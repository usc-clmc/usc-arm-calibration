/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		calibrate_extrinsics_3d.cpp

  \author	Peter Pastor
  \date		Sep 17, 2011

 *********************************************************************/

// system includes
#include <map>

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
#include <arm_calibrate_extrinsics/calibrate_extrinsics_3d.h>

namespace arm_calibrate_extrinsics
{

// static const double RVIZ_MARKER_LIFETIME = 0.1;

static const std::string BASE_FRAME = "/BASE";
static const std::string HEAD_FRAME = "/HEAD";
static const std::string BB_FRAME = "/BUMBLEBEE_LEFT";

ExtrinsicsCalibrator3D::ExtrinsicsCalibrator3D(ros::NodeHandle node_handle) :
    node_handle_(node_handle), num_snapshots_for_averaging_(1), snapshot_counter_(0),
    dump_snapshot_(false), do_calibration_(true)
{
  calibrate_extrinsics_server_ = node_handle_.advertiseService("calibrateExtrinsics3D", &ExtrinsicsCalibrator3D::calibrateExtrinsics, this);

  readParams();
  if(move_head_using_SL_)
  {
    look_at_client_.reset(new actionlib::SimpleActionClient<arm_behavior_actions::LookAtAction>("/Behaviors/lookAt", true));
    if(!look_at_client_->waitForServer(ros::Duration(2.0)))
    {
      dashboard_client_.warn("Waiting for /Behaviors/lookAt to come up... is lookAt behavior up and running?");
      ROS_VERIFY(look_at_client_->waitForServer());
    }
  }
  else
  {
    look_at_joint_client_.reset(new actionlib::SimpleActionClient<arm_head_control::LookAtAction>("/HeadInterface/lookAt", true));
    if(!look_at_joint_client_->waitForServer(ros::Duration(2.0)))
    {
      dashboard_client_.warn("Waiting for /HeadInterface/lookAt to come up...");
      dashboard_client_.warn("...is lookAt behavior up and running ? (roslaunch arm_head_control arm_head_control.launch)");
      ROS_VERIFY(look_at_joint_client_->waitForServer());
    }
  }

  rviz_marker_pub_ = node_handle_.advertise<visualization_msgs::MarkerArray> ("visualization_marker_array", 10);
  marker_index_ = 0;
  marker_array_.reset(new visualization_msgs::MarkerArray());
}

bool ExtrinsicsCalibrator3D::calibrateExtrinsics(arm_calibrate_extrinsics::CalibrateExtrinsics::Request& request,
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

    dashboard_client_.info("Waiting for honeybee parameters to settle.");
    ros::Duration(5.0).sleep();
  }

  mutex_.lock();
  dump_snapshot_ = false;
  frames_.clear();
  mutex_.unlock();

  dashboard_client_.info("Calibrating extrinsics in 3d...");
  readParams();
  ros::Duration(1.0).sleep();

  if(!readLookAtConfigurations())
  {
    dashboard_client_.error("Could not read LookAt head configuration.");
    response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
    return true;
  }

  ROS_INFO_COND(move_head_using_SL_, "Using SL to control the head.");
  ROS_INFO_COND(!move_head_using_SL_, "Using arm_head_control to control the head.");
  ROS_INFO_COND(generate_head_configurations_, "Generating head joint configurations.");

  if(look_at_joint_configurations_array_.size() != look_at_configurations_array_.size())
  {
    dashboard_client_.error("Number of look_at_joint_configurations >%i< must match number of look_at_configurations >%i<.",
                            (int)look_at_joint_configurations_array_.size(), (int)look_at_configurations_array_.size());
    response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
    return true;
  }

  for (int i = 0; i < (int)look_at_configurations_array_.size(); ++i)
  {
    ROS_INFO("Moving to head joint configuration number >%i< of >%i<.", i, (int)look_at_configurations_array_.size());

    if(move_head_using_SL_) // use SL (USC)
    {
      arm_behavior_actions::LookAtGoal look_at_goal;
      look_at_goal.lower_pan = look_at_configurations_array_[i][0];
      look_at_goal.lower_tilt = look_at_configurations_array_[i][1];
      look_at_goal.pos.x = look_at_configurations_array_[i][2];
      look_at_goal.pos.y = look_at_configurations_array_[i][3];
      look_at_goal.pos.z = look_at_configurations_array_[i][4];

      actionlib::SimpleClientGoalState goal_state = look_at_client_->sendGoalAndWait(look_at_goal);
      if(goal_state.state_ != actionlib::SimpleClientGoalState::SUCCEEDED)
      {
        dashboard_client_.error("Problems when calling LookAt action.");
        response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
        return true;
      }
    }
    else // move head with arm_head_control (JPL + CMU)
    {
      arm_head_control::LookAtGoal look_at_goal;
      for (int j = 0; j < 4; ++j)
      {
        look_at_goal.ptu_joint_angels[j] = look_at_joint_configurations_array_[i][j];
      }

      actionlib::SimpleClientGoalState goal_state = look_at_joint_client_->sendGoalAndWait(look_at_goal);
      if (goal_state.state_ != actionlib::SimpleClientGoalState::SUCCEEDED)
      {
        dashboard_client_.error("Problems when calling LookAt action.");
        response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::FAILED;
        return true;
      }
    }

    if (!generate_head_configurations_) // skip if we want to generate the head configs
    {
      ros::Duration(head_settling_duration_).sleep();
      snapshot_time_ = ros::Time::now();

      // reset counter and record frames
      snapshot_counter_ = 0;
      averaging_markers_.clear();
      mutex_.lock();
      dump_snapshot_ = true;
      mutex_.unlock();
      bool dump_snapshot_not_done = true;
      while (dump_snapshot_not_done)
      {
        ros::Duration(0.01).sleep();
        mutex_.lock();
        dump_snapshot_not_done = dump_snapshot_;
        mutex_.unlock();
      }
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

  if (do_calibration_)
  {
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
  }

  response.result = arm_calibrate_extrinsics::CalibrateExtrinsics::Response::SUCCEEDED;
  return true;
}

void ExtrinsicsCalibrator3D::run()
{
  const int MESSAGE_QUEUE_SIZE = 50;
  message_filters::Subscriber<ar_target::ARMarkers3d> ar_sub(node_handle_, "/ARSynchronize/ar_target_marker_3d", MESSAGE_QUEUE_SIZE);
  message_filters::Subscriber<sensor_msgs::PointCloud2> point_sub(node_handle_, "/points", MESSAGE_QUEUE_SIZE);
  message_filters::Subscriber<sensor_msgs::Image> left_image_sub(node_handle_, "/left_image", MESSAGE_QUEUE_SIZE);
  message_filters::Subscriber<sensor_msgs::Image> right_image_sub(node_handle_, "/right_image", MESSAGE_QUEUE_SIZE);
  message_filters::Subscriber<sensor_msgs::CameraInfo> left_camera_info_sub(node_handle_, "/left_camera_info", MESSAGE_QUEUE_SIZE);
  message_filters::Subscriber<sensor_msgs::CameraInfo> right_camera_info_sub(node_handle_, "/right_camera_info", MESSAGE_QUEUE_SIZE);

  message_filters::TimeSynchronizer<ar_target::ARMarkers3d, sensor_msgs::PointCloud2, sensor_msgs::Image,
      sensor_msgs::Image, sensor_msgs::CameraInfo, sensor_msgs::CameraInfo> sync(
      ar_sub, point_sub, left_image_sub, right_image_sub, left_camera_info_sub, right_camera_info_sub,
      MESSAGE_QUEUE_SIZE);
  sync.registerCallback(boost::bind(&ExtrinsicsCalibrator3D::callback, this, _1, _2, _3, _4, _5, _6));

  ros::MultiThreadedSpinner mts;
  mts.spin();
}

double ExtrinsicsCalibrator3D::getMean(const std::vector<double>& values)
{
  double mean = 0.0;
  for (int n = 0; n < (int)values.size(); ++n)
  {
    mean += values[n];
  }
  mean /= (double)values.size();
  return mean;
}

geometry_msgs::Point ExtrinsicsCalibrator3D::getMean(const std::vector<geometry_msgs::Point>& values)
{
  geometry_msgs::Point mean;
  for (int n = 0; n < (int)values.size(); ++n)
  {
    mean.x += values[n].x;
    mean.y += values[n].y;
    mean.z += values[n].z;
  }
  mean.x /= (double)values.size();
  mean.y /= (double)values.size();
  mean.z /= (double)values.size();
  return mean;
}

geometry_msgs::Quaternion ExtrinsicsCalibrator3D::getMean(const std::vector<geometry_msgs::Quaternion>& values)
{
  Eigen::Vector4d avg_q(values[0].w, values[0].x, values[0].y, values[0].z);
  for (int i = 1; i < (int)values.size(); ++i)
  {
    Eigen::Vector4d q_new(values[i].w, values[i].x, values[i].y, values[i].z);
    if(avg_q.dot(q_new) > 0)
    {
      avg_q = avg_q + q_new;
    }
    else
    {
      avg_q = avg_q - q_new;
    }
    avg_q.normalize();
  }
  geometry_msgs::Quaternion quaternion;
  quaternion.w = avg_q(0);
  quaternion.x = avg_q(1);
  quaternion.y = avg_q(2);
  quaternion.z = avg_q(3);
  return quaternion;
}

geometry_msgs::Pose ExtrinsicsCalibrator3D::getMean(const std::vector<geometry_msgs::Pose>& values)
{
  geometry_msgs::Pose pose;
  std::vector<geometry_msgs::Point> positions;
  std::vector<geometry_msgs::Quaternion> orientations;
  for(int i=0; i<(int)values.size(); ++i)
  {
    positions.push_back(values[i].position);
    orientations.push_back(values[i].orientation);
  }
  pose.position = getMean(positions);
  pose.orientation = getMean(orientations);
  return pose;
}


void ExtrinsicsCalibrator3D::averageMarkers(const std::vector<std::vector<ar_target::ARMarker3d> >& markers,
                                            std::vector<ar_target::ARMarker3d>& averaged_markers)
{
  ROS_DEBUG("Averaging >%i< markers.", (int)markers.size());

  std::map<int, std::vector<ar_target::ARMarker3d> > marker_map;
  const int MAX_NUMBER_MARKERS = 32;
  for (int i = 0; i < MAX_NUMBER_MARKERS; ++i)
  {
    marker_map.insert(std::pair<int, std::vector<ar_target::ARMarker3d> >(i, std::vector<ar_target::ARMarker3d>()));
  }

  for (int i = 0; i < (int)markers.size(); ++i)
  {
    std::vector<ar_target::ARMarker3d> marker_frame = markers[i];
    for (int j = 0; j < (int)marker_frame.size(); ++j)
    {
      ROS_DEBUG("Getting container for id >%i<.", marker_frame[j].id);
      marker_map.at(marker_frame[j].id).push_back(marker_frame[j]);
    }
  }

  averaged_markers.clear();
  std::map<int, std::vector<ar_target::ARMarker3d> >::iterator it;
  for(it = marker_map.begin(); it != marker_map.end(); ++it)
  {
    if(!it->second.empty())
    {
      ROS_INFO("Got >%i< markers with id >%i<.", (int)it->second.size(), it->first);

      ar_target::ARMarker3d avg_marker;
      avg_marker.id = it->first;

      // error checking
      for (int i = 0; i < (int)it->second.size(); ++i)
      {
        ROS_ASSERT(it->second[i].left_u_corners.size() == 4);
        ROS_ASSERT(it->second[i].left_v_corners.size() == 4);
        ROS_ASSERT(it->second[i].right_u_corners.size() == 4);
        ROS_ASSERT(it->second[i].right_v_corners.size() == 4);
      }

      // average confidence. TODO: fix this
      std::vector<double> avg_conf;
      for (int i = 0; i < (int)it->second.size(); ++i)
      {
        avg_conf.push_back(it->second[i].confidence);
      }
      avg_marker.confidence = getMean(avg_conf);

      // avg corners
      for (int n = 0; n < 4; ++n)
      {
        std::vector<double> avg_left_u_corners;
        std::vector<double> avg_left_v_corners;
        std::vector<double> avg_right_u_corners;
        std::vector<double> avg_right_v_corners;
        for (int i = 0; i < (int)it->second.size(); ++i)
        {
          avg_left_u_corners.push_back(it->second[i].left_u_corners[n]);
          avg_left_v_corners.push_back(it->second[i].left_v_corners[n]);
          avg_right_u_corners.push_back(it->second[i].right_u_corners[n]);
          avg_right_v_corners.push_back(it->second[i].right_v_corners[n]);
        }
        avg_marker.left_u_corners.push_back(getMean(avg_left_u_corners));
        avg_marker.left_v_corners.push_back(getMean(avg_left_v_corners));
        avg_marker.right_u_corners.push_back(getMean(avg_right_u_corners));
        avg_marker.right_v_corners.push_back(getMean(avg_right_v_corners));
      }

      // avg corner positions
      for (int n = 0; n < 4; ++n)
      {
        std::vector<geometry_msgs::Point> avg_corner_points;
        for (int i = 0; i < (int)it->second.size(); ++i)
        {
          avg_corner_points.push_back(it->second[i].corner_positions[n]);
        }
        avg_marker.corner_positions.push_back(getMean(avg_corner_points));
      }

      // avg corner orientations
      for (int n = 0; n < 4; ++n)
      {
        std::vector<geometry_msgs::Quaternion> avg_corner_orientations;
        for (int i = 0; i < (int)it->second.size(); ++i)
        {
          avg_corner_orientations.push_back(it->second[i].corner_orientations[n]);
        }
        avg_marker.corner_orientations.push_back(getMean(avg_corner_orientations));
      }

      // avg center pose
      std::vector<geometry_msgs::Pose> avg_center_pose;
      for (int i = 0; i < (int)it->second.size(); ++i)
      {
        avg_center_pose.push_back(it->second[i].center_pose);
      }
      avg_marker.center_pose = getMean(avg_center_pose);

      averaged_markers.push_back(avg_marker);
    }
  }

  ROS_DEBUG("Averaged >%i< markers.", (int)averaged_markers.size());

}

void ExtrinsicsCalibrator3D::callback(const ar_target::ARMarkers3dConstPtr& markers,
                                      const sensor_msgs::PointCloud2ConstPtr& point_cloud,
                                      const sensor_msgs::ImageConstPtr& left_image,
                                      const sensor_msgs::ImageConstPtr& right_image,
                                      const sensor_msgs::CameraInfoConstPtr& left_camera_info,
                                      const sensor_msgs::CameraInfoConstPtr& right_camera_info)
{
  boost::mutex::scoped_lock(mutex_);

  if(dump_snapshot_)
  {
    // tripple checking
    ROS_ASSERT(markers->header.stamp == point_cloud->header.stamp);
    ROS_ASSERT(markers->header.stamp == left_image->header.stamp);
    ROS_ASSERT(markers->header.stamp == right_image->header.stamp);
    ROS_ASSERT(markers->header.stamp == left_camera_info->header.stamp);
    ROS_ASSERT(markers->header.stamp == right_camera_info->header.stamp);
    if(markers->header.stamp < snapshot_time_)
    {
      ROS_WARN("Old messages received.");
      return;
    }

    averaging_markers_.push_back(markers->markers);
    snapshot_counter_++;

    if(num_snapshots_for_averaging_ <= snapshot_counter_)
    {
      ROS_INFO("Taking averaged snapshot >%i< out of >%i< using >%i< snapshots.", (int)frames_.size()+1,
               (int)look_at_configurations_array_.size(), (int)averaging_markers_.size());

      ARFrame3d frame;

      if(num_snapshots_for_averaging_ <= 1)
      {
        frame.markers = markers->markers;
      }
      else
      {
        averageMarkers(averaging_markers_, frame.markers);
      }

      ros::Time rviz_now = ros::Time::now();
      ROS_DEBUG("Found >%i< markers.", (int)frame.markers.size());
      marker_index_ = 0;
      marker_array_->markers.resize((int)frame.markers.size() * (4+1+1));
      for (int i = 0; i < (int)frame.markers.size(); ++i)
      {
        addRvizMarker3d(frame.markers[i], rviz_now);
      }
      rviz_marker_pub_.publish(marker_array_);

      ROS_DEBUG("Publishing >%i< markers.", (int) marker_array_->markers.size());


      frame.header.stamp = markers->header.stamp;
      frame.left_camera_info = *left_camera_info;
      frame.right_camera_info = *right_camera_info;
      frame.points = *point_cloud;
      frame.left_image = *left_image;
      frame.right_image = *right_image;

      for (int i = 0; i < (int)frame.markers.size(); ++i)
      {
        frame.ids.push_back(frame.markers[i].id);
      }

      if(frame.ids.empty())
      {
        ROS_WARN("No ARMarker found for this head pose.");
      }

      // Get base to head transform
      tf::StampedTransform head_transform_base;
      try
      {
        if (!tf_listener_.waitForTransform(BASE_FRAME, HEAD_FRAME, markers->header.stamp, ros::Duration(0.5)))
        {
          ROS_WARN("Problems obtaining >%s< to >%s< transform. Trying again...", BASE_FRAME.c_str(), HEAD_FRAME.c_str());
          return;
        }
        tf_listener_.lookupTransform(BASE_FRAME, HEAD_FRAME, markers->header.stamp, head_transform_base);
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
        if (!tf_listener_.waitForTransform(HEAD_FRAME, BB_FRAME, markers->header.stamp, ros::Duration(0.5)))
        {
          ROS_WARN("Problems obtaining >%s< to >%s< transform. Trying again...", HEAD_FRAME.c_str(), BB_FRAME.c_str());
          return;
        }
        tf_listener_.lookupTransform(HEAD_FRAME, BB_FRAME, markers->header.stamp, cam_transform_head);
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
      snapshot_counter_ = 0;
    }
  }
}

bool ExtrinsicsCalibrator3D::writeOutImages()
{
  std::string filename;
  for (int i = 0; i < (int)frames_.size(); ++i)
  {
    ROS_ASSERT_MSG(frames_[i].ids.size() == frames_[i].markers.size(), "Number of ids >%i< does not correspond to number of markers >%i<.",
                   (int)frames_[i].ids.size(), (int)frames_[i].markers.size());

    cv_bridge::CvImageConstPtr left_image_ptr = cv_bridge::toCvCopy(frames_[i].left_image);
    cv_bridge::CvImage left_image = *left_image_ptr;
    cv::Mat left_cv_mat_image = left_image.image;
    for (int n = 0; n < (int)frames_[i].ids.size(); ++n)
    {
      ROS_ASSERT(frames_[i].markers[n].left_u_corners.size() == 4);
      ROS_ASSERT(frames_[i].markers[n].left_v_corners.size() == 4);
      for (int c = 0; c < 4; ++c)
      {
        cv::circle(left_image.image,
                 cvPoint((int)frames_[i].markers[n].left_u_corners[c], (int)frames_[i].markers[n].left_v_corners[c]), 5,
                 cvScalar(0, 0, 255, 0),
                 2, 8, 0);
      }
    }
    filename.assign(data_directory_name_ + "left_snapshots_" + boost::lexical_cast<std::string>(i) + ".png");
    ROS_INFO("Writing >%s<.", filename.c_str());
    if(!cv::imwrite(filename, left_cv_mat_image))
    {
      ROS_ERROR("Problems when writing >%s<.", filename.c_str());
    }

    cv_bridge::CvImageConstPtr right_image_ptr = cv_bridge::toCvCopy(frames_[i].right_image);
    cv_bridge::CvImage right_image = *right_image_ptr;
    cv::Mat right_cv_mat_image = right_image.image;
    for (int n = 0; n < (int)frames_[i].ids.size(); ++n)
    {
      ROS_ASSERT(frames_[i].markers[n].right_u_corners.size() == 4);
      ROS_ASSERT(frames_[i].markers[n].right_v_corners.size() == 4);
      for (int c = 0; c < 4; ++c)
      {
        cv::circle(right_image.image,
                 cvPoint((int)frames_[i].markers[n].right_u_corners[c], (int)frames_[i].markers[n].right_v_corners[c]), 5,
                 cvScalar(0, 0, 255, 0),
                 2, 8, 0);
      }
    }
    filename.assign(data_directory_name_ + "right_snapshots_" + boost::lexical_cast<std::string>(i) + ".png");
    ROS_INFO("Writing >%s<.", filename.c_str());
    if(!cv::imwrite(filename, right_cv_mat_image))
    {
      ROS_ERROR("Problems when writing >%s<.", filename.c_str());
    }
  }

  return true;
}

bool ExtrinsicsCalibrator3D::writeOutFile()
{
  boost::mutex::scoped_lock(mutex_);
  return usc_utilities::FileIO<arm_calibrate_extrinsics::ARFrame3d>::writeToBagFileWithTimeStamps(frames_, "/ARFrames3d", bag_file_name_);
}

void ExtrinsicsCalibrator3D::readParams()
{
  ROS_VERIFY(usc_utilities::read(node_handle_, "head_settling_duration", head_settling_duration_));
  std::string package_path = ros::package::getPath(ROS_PACKAGE_NAME);
  usc_utilities::appendTrailingSlash(package_path);
  std::string bag_file_name;
  ROS_VERIFY(usc_utilities::read(node_handle_, "bag_file_name", bag_file_name));
  data_directory_name_.assign(package_path + "data/");
  bag_file_name_.assign(data_directory_name_ + bag_file_name);
  ROS_VERIFY(usc_utilities::read(node_handle_, "confidence_threshold", confidence_threshold_));

  ROS_VERIFY(usc_utilities::read(node_handle_, "num_snapshots_for_averaging", num_snapshots_for_averaging_));

  ROS_VERIFY(usc_utilities::read(node_handle_, "generate_head_configurations", generate_head_configurations_));
  ROS_VERIFY(usc_utilities::read(node_handle_, "move_head_using_SL", move_head_using_SL_));

  ROS_VERIFY(usc_utilities::read(node_handle_, "do_calibration", do_calibration_));
  cal_script_ = ros::package::getPath("arm_fiducial_cal");
  usc_utilities::appendTrailingSlash(cal_script_);
  cal_script_.append("scripts/./calibrate.py");
}

bool ExtrinsicsCalibrator3D::readLookAtConfigurations()
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

  // read look at configurations
  look_at_joint_configurations_array_.clear();
  XmlRpc::XmlRpcValue look_at_joint_configurations;
  if (!node_handle_.getParam("head_look_at_joint_configurations", look_at_joint_configurations))
  {
    ROS_ERROR("Could not read head joint configurations in namespace >%s<.", node_handle_.getNamespace().c_str());
    return false;
  }

  for (int i = 0; i < look_at_joint_configurations.size(); ++i)
  {
    if (!look_at_joint_configurations[i].hasMember("look_at_configuration"))
    {
      ROS_ERROR("Each head configuration must contain a field >look_at_configuration<.");
      return false;
    }
    XmlRpc::XmlRpcValue look_at_configuration = look_at_joint_configurations[i]["look_at_configuration"];
    const int NUM_LOOK_AT_LOCATIONS = 4;
    if (look_at_configuration.size() != NUM_LOOK_AT_LOCATIONS) // lower_pan, lower_tilt, upper_pan, upper_tilt
    {
      ROS_ERROR("Number of look_at_joint_configuration >%i< is wrong. It should be >%i<.",
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
    look_at_joint_configurations_array_.push_back(head_configuration);
  }

  ROS_ASSERT_MSG(look_at_joint_configurations_array_.size() == look_at_configurations_array_.size(),
                 "Number of look_at_joint_configurations >%i< must match number of look_at_configurations >%i<.",
                 (int)look_at_joint_configurations_array_.size(), (int)look_at_configurations_array_.size());

  return true;
}


void ExtrinsicsCalibrator3D::addRvizMarker3d(const ar_target::ARMarker3d& marker, const ros::Time& time_stamp)
{
  const double SPHERE_RADIUS = 0.016;
  ROS_ASSERT(marker.corner_orientations.size() == 4);
  ROS_ASSERT(marker.corner_positions.size() == 4);
  for (int i = 0; i < 4; ++i)
  {
    visualization_msgs::Marker rviz_corner_marker;
    rviz_corner_marker.pose.position = marker.corner_positions[i];
    rviz_corner_marker.pose.orientation = marker.corner_orientations[i];

    // rviz_corner_marker.header.frame_id = left_camera_frame_;
    rviz_corner_marker.header.frame_id = BB_FRAME;
    rviz_corner_marker.header.stamp = time_stamp;
    rviz_corner_marker.id = i;
    rviz_corner_marker.ns.assign("ARMarker3d_" + boost::lexical_cast<std::string>(marker.id) + "_corner_" + boost::lexical_cast<std::string>(i));

    rviz_corner_marker.scale.x = SPHERE_RADIUS;
    rviz_corner_marker.scale.y = SPHERE_RADIUS;
    rviz_corner_marker.scale.z = SPHERE_RADIUS;

    rviz_corner_marker.type = visualization_msgs::Marker::SPHERE;
    rviz_corner_marker.action = visualization_msgs::Marker::MODIFY;

    rviz_corner_marker.color.r = 1.0;
    rviz_corner_marker.color.g = 1.0;
    rviz_corner_marker.color.b = 1.0;
    rviz_corner_marker.color.a = 0.95;

    // rviz_corner_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
    marker_array_->markers[marker_index_] = rviz_corner_marker;
    marker_index_++;
  }

  visualization_msgs::Marker rviz_center_marker;
  rviz_center_marker.pose = marker.center_pose;

  rviz_center_marker.header.frame_id = BB_FRAME;
  rviz_center_marker.header.stamp = time_stamp;
  rviz_center_marker.id = 4;
  rviz_center_marker.ns.assign("ARMarker3d_center_" + boost::lexical_cast<std::string>(marker.id));

  rviz_center_marker.scale.x = 0.101;
  rviz_center_marker.scale.y = 0.101;
  rviz_center_marker.scale.z = 0.001;

  rviz_center_marker.type = visualization_msgs::Marker::CUBE;
  rviz_center_marker.action = visualization_msgs::Marker::MODIFY;

  rviz_center_marker.color.r = 0.0;
  rviz_center_marker.color.g = 1.0;
  rviz_center_marker.color.b = 0.0;
  rviz_center_marker.color.a = 0.5;

  // rviz_center_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
  marker_array_->markers[marker_index_] = rviz_center_marker;
  marker_index_++;

  visualization_msgs::Marker rviz_text_marker;
  rviz_text_marker.pose = marker.center_pose;
  rviz_text_marker.pose.position.y -= 0.02;

  rviz_text_marker.header.frame_id = BB_FRAME;
  rviz_text_marker.header.stamp = time_stamp;
  rviz_text_marker.id = 5;
  rviz_text_marker.ns.assign("ARMarker3d_text_" + boost::lexical_cast<std::string>(marker.id));
  rviz_text_marker.scale.z = 0.04;

  std::stringstream ss;
  ss << std::setprecision(2);
  ss << marker.confidence;
  rviz_text_marker.text.assign("id:" + boost::lexical_cast<std::string>(marker.id+1) + "\n" + ss.str());

  rviz_text_marker.type = visualization_msgs::Marker::TEXT_VIEW_FACING;
  rviz_text_marker.action = visualization_msgs::Marker::MODIFY;

  rviz_text_marker.color.r = 1.0;
  rviz_text_marker.color.g = 0.0;
  rviz_text_marker.color.b = 0.0;
  rviz_text_marker.color.a = 0.7;

  // rviz_text_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
  marker_array_->markers[marker_index_] = rviz_text_marker;
  marker_index_++;
}

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "ExtrinsicsCalibrator3D");
  ros::NodeHandle node_handle("~");
  arm_calibrate_extrinsics::ExtrinsicsCalibrator3D calibrate_extrinsics_3d(node_handle);
  calibrate_extrinsics_3d.run();
  return 0;
}
