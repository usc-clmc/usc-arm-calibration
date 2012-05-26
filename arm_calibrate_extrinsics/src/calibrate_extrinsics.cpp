/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		calibrate_extrinsics

  \author	Peter Pastor
  \date		Sep 17, 2011

 *********************************************************************/

// system includes
#include <usc_utilities/param_server.h>
#include <usc_utilities/assert.h>
#include <usc_utilities/file_io.h>

#include <ros/package.h>

#include <message_filters/subscriber.h>
#include <message_filters/time_synchronizer.h>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/CvBridge.h>

// local includes
#include <arm_calibrate_extrinsics/calibrate_extrinsics.h>

namespace arm_calibrate_extrinsics
{

static const std::string BASE_FRAME = "/BASE";
static const std::string HEAD_FRAME = "/HEAD";
static const std::string BB_FRAME = "/BUMBLEBEE_LEFT";

ExtrinsicsCalibrator::ExtrinsicsCalibrator(ros::NodeHandle node_handle) :
    node_handle_(node_handle), dump_snapshot_(false)
{
  calibrate_extrinsics_server_ = node_handle_.advertiseService("calibrateExtrinsics", &ExtrinsicsCalibrator::calibrateExtrinsics, this);
  look_at_client_.reset(new actionlib::SimpleActionClient<arm_behavior_actions::LookAtAction>("/Behaviors/lookAt", true));
  if(!look_at_client_->waitForServer(ros::Duration(2.0)))
  {
    dashboard_client_.warn("Waiting for /Behaviors/lookAt to come up... is lookAt behavior up and running?");
    ROS_VERIFY(look_at_client_->waitForServer());
  }

}

bool ExtrinsicsCalibrator::calibrateExtrinsics(arm_calibrate_extrinsics::CalibrateExtrinsics::Request& request,
                                               arm_calibrate_extrinsics::CalibrateExtrinsics::Response& response)
{
  bool set_honeybee_to_auto = true;
  if(set_honeybee_to_auto)
  {
    dashboard_client_.info("Setting honeybee parameters to auto.");
    std::string directory = ros::package::getPath("arm_calibrate_extrinsics");
    usc_utilities::appendTrailingSlash(directory);
    directory.append("scripts");
    if (chdir(directory.c_str()) != 0)
    {
      ROS_ERROR("Could not change directory to >%s<", directory.c_str());
      return false;
    }

    std::string system_command = "./set_honeybee_to_auto.sh";
    if (system(system_command.c_str()))
    {
      dashboard_client_.error("Could not set honeybee parameters.");
      return false;
    }
  }

  dashboard_client_.info("Waiting for honeybee parameters to settle.");
  ros::Duration(5.0).sleep();

  mutex_.lock();
  dump_snapshot_ = false;
  frames_.clear();
  mutex_.unlock();

  dashboard_client_.info("Calibrating extrinsics...");
  readParams();
  ros::Duration(1.0).sleep();

  if(!readLookAtConfigurations())
  {
    dashboard_client_.error("Could not read LookAt head configuration.");
    response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
    return true;
  }

  for (int i = 0; i < (int)look_at_configurations_array_.size(); ++i)
  {

    arm_behavior_actions::LookAtGoal look_at_goal;
    look_at_goal.pos.x = look_at_configurations_array_[i][2];
    look_at_goal.pos.y = look_at_configurations_array_[i][3];
    look_at_goal.pos.z = look_at_configurations_array_[i][4];

    look_at_goal.lower_pan = look_at_configurations_array_[i][0];
    look_at_goal.lower_tilt = look_at_configurations_array_[i][1];

    actionlib::SimpleClientGoalState goal_state = look_at_client_->sendGoalAndWait(look_at_goal);
    if(goal_state.state_ != actionlib::SimpleClientGoalState::SUCCEEDED)
    {
      dashboard_client_.error("Problems when calling LookAt action.");
      response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
      return true;
    }

    ros::Duration(head_settling_duration_).sleep();

    snapshot_time_ = ros::Time::now();

    // record frame
    mutex_.lock();
    dump_snapshot_ = true;
    mutex_.unlock();
    bool dump_snapshot_not_done = true;
    while(dump_snapshot_not_done)
    {
      ros::Duration(0.01).sleep();
      mutex_.lock();
      dump_snapshot_not_done = dump_snapshot_;
      mutex_.unlock();
    }

  }


  // write collected frames to file
  if(!writeOutFile())
  {
    dashboard_client_.error("Problems when writing to calibration file >%s<.", bag_file_name_.c_str());
    response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
    return true;
  }

  if(!writeOutImages())
  {
    ROS_WARN("Problems when writing out images.");
  }

  // calling cal script
  if (system(cal_script_.c_str()))
  {
    dashboard_client_.error("Problems when calling calibration script >%s<.", cal_script_.c_str());
    dashboard_client_.warn("To fix this, try executing it from the command line.");
    dashboard_client_.warn(" $ roscd arm_fiducial_cal/scripts");
    dashboard_client_.warn(" $ ./calibrate.py");
    dashboard_client_.error("");
    response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
    return true;
  }

  response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::SUCCEEDED;
  return true;
}

void ExtrinsicsCalibrator::run()
{
  message_filters::Subscriber<ar_target::ARMarkers> left_sub(node_handle_, "/ARLeftMultipleSinglePattern/ar_target_marker", 20);
  message_filters::Subscriber<sensor_msgs::PointCloud2> point_sub(node_handle_, "/points", 20);
  message_filters::Subscriber<sensor_msgs::Image> image_sub(node_handle_, "/image", 20);
  message_filters::Subscriber<sensor_msgs::CameraInfo> camera_info_sub(node_handle_, "/camera_info", 20);

  message_filters::TimeSynchronizer<ar_target::ARMarkers, sensor_msgs::PointCloud2, sensor_msgs::Image,
      sensor_msgs::CameraInfo> sync(left_sub, point_sub, image_sub, camera_info_sub, 20);
  sync.registerCallback(boost::bind(&ExtrinsicsCalibrator::callback, this, _1, _2, _3, _4));

  ros::MultiThreadedSpinner mts;
  mts.spin();
}

void ExtrinsicsCalibrator::callback(const ar_target::ARMarkersConstPtr& left_markers,
                                    const sensor_msgs::PointCloud2ConstPtr& point_cloud,
                                    const sensor_msgs::ImageConstPtr& image,
                                    const sensor_msgs::CameraInfoConstPtr& camera_info)
{
  boost::mutex::scoped_lock(mutex_);

  if(dump_snapshot_)
  {
    if(left_markers->header.stamp < snapshot_time_)
    {
      ROS_WARN("Old messages received.");
      return;
    }

    ROS_INFO("Taking snapshot >%i< out of >%i<.", (int)frames_.size(), (int)look_at_configurations_array_.size());
    ARFrame frame;

    frame.header.stamp = left_markers->header.stamp;
    frame.camera_info = *camera_info;
    frame.points = *point_cloud;
    frame.image = *image;

    for (int i = 0; i < (int)left_markers->markers.size(); ++i)
    {
      if(left_markers->markers[i].confidence > confidence_threshold_)
      {
        ROS_VERIFY_MSG(left_markers->markers[i].u_corners.size() == 4, "Number of U corners received must be 4.");
        ROS_VERIFY_MSG(left_markers->markers[i].v_corners.size() == 4, "Number of V corners received must be 4.");
        frame.u_corner_1.push_back(left_markers->markers[i].u_corners[0]);
        frame.v_corner_1.push_back(left_markers->markers[i].v_corners[0]);
        frame.u_corner_2.push_back(left_markers->markers[i].u_corners[1]);
        frame.v_corner_2.push_back(left_markers->markers[i].v_corners[1]);
        frame.u_corner_3.push_back(left_markers->markers[i].u_corners[2]);
        frame.v_corner_3.push_back(left_markers->markers[i].v_corners[2]);
        frame.u_corner_4.push_back(left_markers->markers[i].u_corners[3]);
        frame.v_corner_4.push_back(left_markers->markers[i].v_corners[3]);
        frame.ids.push_back(left_markers->markers[i].id);
      }
      else
      {
        ROS_INFO("Skipping marker >%i<. Confidence >%f< is too low.", left_markers->markers[i].id, left_markers->markers[i].confidence);
      }
    }

    if(frame.ids.empty())
    {
      ROS_WARN("No ARMarker found for this head pose.");
    }

    // Get base to head transform
    tf::StampedTransform head_transform_base;
    try
    {
      if (!tf_listener_.waitForTransform(BASE_FRAME, HEAD_FRAME, left_markers->header.stamp, ros::Duration(0.5)))
      {
        ROS_WARN("Problems obtaining >%s< to >%s< transform. Trying again...", BASE_FRAME.c_str(), HEAD_FRAME.c_str());
        return;
      }
      tf_listener_.lookupTransform(BASE_FRAME, HEAD_FRAME, left_markers->header.stamp, head_transform_base);
    }
    catch (tf::TransformException& ex)
    {
      ROS_WARN_STREAM("Transform error from " << HEAD_FRAME << " to " << BASE_FRAME << ", quitting callback. Trying again...");
      return;
    }
    geometry_msgs::TransformStamped head_transform_base_stamped;
    tf::transformStampedTFToMsg(head_transform_base, head_transform_base_stamped);
    frame.head_transform_base = head_transform_base_stamped.transform;

    tf::StampedTransform cam_transform_head;
    try
    {
      if (!tf_listener_.waitForTransform(HEAD_FRAME, BB_FRAME, left_markers->header.stamp, ros::Duration(0.5)))
      {
        ROS_WARN("Problems obtaining >%s< to >%s< transform. Trying again...", HEAD_FRAME.c_str(), BB_FRAME.c_str());
        return;
      }
      tf_listener_.lookupTransform(HEAD_FRAME, BB_FRAME, left_markers->header.stamp, cam_transform_head);
    }
    catch (tf::TransformException& ex)
    {
      ROS_WARN_STREAM("Transform error from " << BB_FRAME << " to " << HEAD_FRAME << ", quitting callback. Trying again...");
      return;
    }
    geometry_msgs::TransformStamped cam_transform_head_stamped;
    tf::transformStampedTFToMsg(cam_transform_head, cam_transform_head_stamped);
    frame.cam_transform_head = cam_transform_head_stamped.transform;

    frames_.push_back(frame);
    dump_snapshot_ = false;
  }

}

bool ExtrinsicsCalibrator::writeOutImages()
{

  for (int i = 0; i < (int)frames_.size(); ++i)
  {
    cv_bridge::CvImageConstPtr image_ptr = cv_bridge::toCvCopy(frames_[i].image);
    cv_bridge::CvImage curr_image = *image_ptr;
    cv::Mat cv_mat_image = curr_image.image;
    for (int n = 0; n < (int)frames_[i].ids.size(); ++n)
    {
      cv::circle(curr_image.image,
               cvPoint((int)frames_[i].u_corner_1[n], (int)frames_[i].v_corner_1[n]), 5,
               cvScalar(0, 0, 255, 0),
               2, 8, 0);
      cv::circle(curr_image.image, // the dest image
               cvPoint((int)frames_[i].u_corner_2[n], (int)frames_[i].v_corner_2[n]), 5, // center point and radius
               cvScalar(0, 0, 255, 0), // the color; red
               2, 8, 0);
      cv::circle(curr_image.image, // the dest image
               cvPoint((int)frames_[i].u_corner_3[n], (int)frames_[i].v_corner_3[n]), 5, // center point and radius
               cvScalar(0, 0, 255, 0), // the color; red
               2, 8, 0);
      cv::circle(curr_image.image, // the dest image
               cvPoint((int)frames_[i].u_corner_4[n], (int)frames_[i].v_corner_4[n]), 5, // center point and radius
               cvScalar(0, 0, 255, 0), // the color; red
               2, 8, 0);
    }

    std::string filename = data_directory_name_ + "snapshots_" + boost::lexical_cast<std::string>(i) + ".png";
    ROS_INFO("Writing >%s<.", filename.c_str());
    if(!cv::imwrite(filename, cv_mat_image))
    {
      ROS_ERROR("Problems when writing >%s<.", filename.c_str());
    }
  }

  return true;
}

bool ExtrinsicsCalibrator::writeOutFile()
{
  boost::mutex::scoped_lock(mutex_);
  return usc_utilities::FileIO<arm_calibrate_extrinsics::ARFrame>::writeToBagFileWithTimeStamps(frames_, "/ARFrames", bag_file_name_);
}

void ExtrinsicsCalibrator::readParams()
{
  ROS_VERIFY(usc_utilities::read(node_handle_, "head_settling_duration", head_settling_duration_));
  std::string package_path = ros::package::getPath(ROS_PACKAGE_NAME);
  usc_utilities::appendTrailingSlash(package_path);
  std::string bag_file_name;
  ROS_VERIFY(usc_utilities::read(node_handle_, "bag_file_name", bag_file_name));
  data_directory_name_.assign(package_path + "data/");
  bag_file_name_.assign(data_directory_name_ + bag_file_name);
  ROS_VERIFY(usc_utilities::read(node_handle_, "confidence_threshold", confidence_threshold_));

  cal_script_ = ros::package::getPath("arm_fiducial_cal");
  usc_utilities::appendTrailingSlash(cal_script_);
  cal_script_.append("scripts/./calibrate.py");
}

bool ExtrinsicsCalibrator::readLookAtConfigurations()
{

  // read look at configurations
  look_at_configurations_array_.clear();
  XmlRpc::XmlRpcValue look_at_configurations;
  if (!node_handle_.getParam("head_look_at_configurations", look_at_configurations))
  {
    ROS_ERROR("Could not read head configurations in namespace >%s<.", node_handle_.getNamespace().c_str());
    return false;
  }

  for (int i = 0; i < look_at_configurations.size(); ++i)
  {
    if (!look_at_configurations[i].hasMember("look_at_configuration"))
    {
      ROS_ERROR("Each head configuration must contain a field >look_at_configuration<.");
      return false;
    }
    XmlRpc::XmlRpcValue look_at_configuration = look_at_configurations[i]["look_at_configuration"];
    const int NUM_LOOK_AT_LOCATIONS = 5;
    if (look_at_configuration.size() != NUM_LOOK_AT_LOCATIONS) // lower_pan, lower_tilt, target_x, target_y, target_z

    {
      ROS_ERROR("Number of look_at_configuration >%i< is wrong. It should be >%i<.",
                look_at_configuration.size(), NUM_LOOK_AT_LOCATIONS);
      return false;
    }

    std::vector<double> head_configuration;
    for (int j = 0; j < NUM_LOOK_AT_LOCATIONS; ++j)
    {
      if (look_at_configuration[j].getType() != XmlRpc::XmlRpcValue::TypeDouble
          && look_at_configuration[j].getType() != XmlRpc::XmlRpcValue::TypeInt)
      {
        ROS_ERROR("Joint configuration values must either be of type integer or double.");
        return false;
      }
      head_configuration.push_back(static_cast<double>(look_at_configuration[j]));
    }
    look_at_configurations_array_.push_back(head_configuration);
  }

//  // read look at configurations
//  lower_ptu_configurations_array_.clear();
//  XmlRpc::XmlRpcValue lower_ptu_configurations;
//  if (!node_handle_.getParam("lower_ptu_configurations", lower_ptu_configurations))
//  {
//    ROS_ERROR("Could not read head configurations in namespace >%s<.", node_handle_.getNamespace().c_str());
//    return false;
//  }
//
//  for (int i = 0; i < lower_ptu_configurations.size(); ++i)
//  {
//    if (!lower_ptu_configurations[i].hasMember("ptu_configuration"))
//    {
//      ROS_ERROR("Each head configuration must contain a field >ptu_configuration<.");
//      return false;
//    }
//    XmlRpc::XmlRpcValue ptu_configuration = lower_ptu_configurations[i]["ptu_configuration"];
//    const int NUM_PTU_CONFIGURATIONS = 2;
//    if (ptu_configuration.size() != NUM_PTU_CONFIGURATIONS) // lower pan, lower tilt
//
//    {
//      ROS_ERROR("Number of ptu_configuration >%i< is wrong. It should be >%i<.",
//                ptu_configuration.size(), NUM_PTU_CONFIGURATIONS);
//      return false;
//    }
//
//    std::vector<double> head_configuration;
//    for (int j = 0; j < NUM_PTU_CONFIGURATIONS; ++j)
//    {
//      if (ptu_configuration[j].getType() != XmlRpc::XmlRpcValue::TypeDouble
//          && ptu_configuration[j].getType() != XmlRpc::XmlRpcValue::TypeInt)
//      {
//        ROS_ERROR("Joint configuration values must either be of type integer or double.");
//        return false;
//      }
//      head_configuration.push_back(static_cast<double>(ptu_configuration[j]));
//    }
//    lower_ptu_configurations_array_.push_back(head_configuration);
//  }

  return true;
}

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "ExtrinsicsCalibrator");
  ros::NodeHandle node_handle("~");
  arm_calibrate_extrinsics::ExtrinsicsCalibrator calibrate_extrinsics(node_handle);
  calibrate_extrinsics.run();
  return 0;
}
