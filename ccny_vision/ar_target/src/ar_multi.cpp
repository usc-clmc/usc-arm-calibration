/*
 *  Multi Marker Pose Estimation using ARToolkit
 *  Copyright (C) 2010, CCNY Robotics Lab
 *  Ivan Dryanovski <ivan.dryanovski@gmail.com>
 *  William Morris <morris@ee.ccny.cuny.edu>
 *  Gautier Dumonteil <gautier.dumonteil@gmail.com>
 *  http://robotics.ccny.cuny.edu
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// system includes
#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>

#include <angles/angles.h>

// local includes
#include <ar_target/ar_multi.h>
#include <ar_target/object.h>

namespace ar_target
{

ARMultiPublisher::ARMultiPublisher(ros::NodeHandle node_handle) :
  ARBase(node_handle)
{
  ROS_VERIFY(usc_utilities::read(node_handle_, "error_threshold", error_threshold_));

  // subscribe
  ROS_INFO ("ARMultiPublisher subscribing to info topic >%s<.", camera_info_topic_.c_str());
  camera_info_subcriber_ = node_handle_.subscribe(camera_info_topic_, 1, &ARMultiPublisher::camInfoCallback, this);

  // advertise
  ar_marker_publisher_ = node_handle_.advertise<ar_target::ARMarkers> ("ar_target_marker", 0);
  if (publish_visual_markers_)
  {
    rviz_marker_pub_ = node_handle_.advertise<visualization_msgs::Marker> ("visualization_marker", 0);
  }
}

void ARMultiPublisher::camInfoCallback(const sensor_msgs::CameraInfoConstPtr& cam_info)
{
  if (!get_camera_info_)
  {
    cam_info_ = (*cam_info);

    cam_param_.xsize = cam_info_.width;
    cam_param_.ysize = cam_info_.height;

    cam_param_.mat[0][0] = cam_info_.P[0];
    cam_param_.mat[1][0] = cam_info_.P[4];
    cam_param_.mat[2][0] = cam_info_.P[8];
    cam_param_.mat[0][1] = cam_info_.P[1];
    cam_param_.mat[1][1] = cam_info_.P[5];
    cam_param_.mat[2][1] = cam_info_.P[9];
    cam_param_.mat[0][2] = cam_info_.P[2];
    cam_param_.mat[1][2] = cam_info_.P[6];
    cam_param_.mat[2][2] = cam_info_.P[10];
    cam_param_.mat[0][3] = cam_info_.P[3];
    cam_param_.mat[1][3] = cam_info_.P[7];
    cam_param_.mat[2][3] = cam_info_.P[11];

    cam_param_.dist_factor[0] = cam_info_.K[2]; // x0 = cX from openCV calibration
    cam_param_.dist_factor[1] = cam_info_.K[5]; // y0 = cY from openCV calibration
    // cam_param_.dist_factor[2] = -100 * cam_info_.D[0]; // f = -100*k1 from CV. Note, we had to do mm^2 to m^2, hence 10^8->10^2
    cam_param_.dist_factor[2] = 0.0; // f = -100*k1 from CV. Note, we had to do mm^2 to m^2, hence 10^8->10^2
    cam_param_.dist_factor[3] = 1.0; // scale factor, should probably be >1, but who cares...

    arInit();

    ROS_INFO("ARMultiPublisher subscribing to image topic >%s<.", camera_image_topic_.c_str());
    cam_sub_ = it_.subscribe(camera_image_topic_, 1, &ARMultiPublisher::getTransformationCallback, this);
    get_camera_info_ = true;
  }
}

void ARMultiPublisher::arInit()
{
  arInitCparam(&cam_param_);
  ROS_INFO("Camera parameters for ARMultiPublisher are:");
  arParamDisp(&cam_param_);

  if ((multi_marker_config_ = arMultiReadConfigFile(pattern_filename_)) == NULL)
  {
    ROS_ASSERT_MSG(false, "Could not load configurations for ARMultiPublisher.");
  }
  // load in the object data - trained markers and associated bitmap files
  // if ((object = ar_object::read_ObjData(pattern_filename_, &objectnum)) == NULL)
  // ROS_BREAK ();

  num_total_markers_ = multi_marker_config_->marker_num;
  ROS_INFO("Read >%i< objects from file.", num_total_markers_);

  size_ = cvSize(cam_param_.xsize, cam_param_.ysize);
  capture_ = cvCreateImage(size_, IPL_DEPTH_8U, 4);
}

void ARMultiPublisher::publishMarker(const int index,
                                     const tf::Transform& transform,
                                     const ros::Time& time_stamp)
{
  const double MARKER_THIKNESS_SCALE = 0.1;
  const double WIDTH = multi_marker_config_->marker[index].width;
  tf::Vector3 marker_origin(0, 0, (MARKER_THIKNESS_SCALE / (double)2.0) * WIDTH * AR_TO_ROS);
  tf::Transform quaternion(tf::Quaternion::getIdentity(), marker_origin);
  tf::Transform marker_pose = transform * quaternion; // marker pose in the camera frame

  visualization_msgs::Marker rviz_marker;
  tf::poseTFToMsg(marker_pose, rviz_marker.pose);
  rviz_marker.header.frame_id = camera_frame_;
  rviz_marker.header.stamp = time_stamp;
  rviz_marker.id = marker_info_[index].id;

  rviz_marker.scale.x = 1.0 * WIDTH * AR_TO_ROS;
  rviz_marker.scale.y = 1.0 * WIDTH * AR_TO_ROS;
  rviz_marker.scale.z = MARKER_THIKNESS_SCALE * WIDTH * AR_TO_ROS;
  // rviz_marker_.ns.assign(node_handle_.getNamespace());
  rviz_marker.ns.assign(marker_frame_);
  rviz_marker.type = visualization_msgs::Marker::CUBE;
  rviz_marker.action = visualization_msgs::Marker::ADD;
  if(marker_info_[marker_indizes_[index]].cf > 0.9)
  {
    rviz_marker.color.r = marker_red_;
    rviz_marker.color.g = marker_green_;
    rviz_marker.color.b = marker_blue_;
    rviz_marker.color.a = 1.0;
  }
  else
  {
    rviz_marker.color.r = 1.0f;
    rviz_marker.color.g = 0.0f;
    rviz_marker.color.b = 0.0f;
    rviz_marker.color.a = 1.0;
  }
  rviz_marker.lifetime = ros::Duration(0.1);

  rviz_marker_pub_.publish(rviz_marker);
  ROS_DEBUG ("Published visual marker");
}

void ARMultiPublisher::publishErrorMarker(const double error,
                                          const ros::Time& time_stamp)
{
  tf::Transform base_transform;
  base_transform.setRotation(tf::Quaternion::getIdentity());
  base_transform.setOrigin(tf::Vector3(0.0, 0.0, 2.2));

  visualization_msgs::Marker rviz_marker;
  tf::poseTFToMsg(base_transform, rviz_marker.pose);

  rviz_marker.header.frame_id = "/BASE";
  rviz_marker.header.stamp = time_stamp;
  rviz_marker.id = 666;
  if(error < error_threshold_)
  {
    rviz_marker.color.r = 1.0f;
    rviz_marker.color.b = 1.0f;
    rviz_marker.color.g = 1.0f;
    rviz_marker.color.a = 1.0f;
  }
  else
  {
    rviz_marker.color.r = 1.0f;
    rviz_marker.color.b = 0.0f;
    rviz_marker.color.g = 0.0f;
    rviz_marker.color.a = 1.0f;
  }

  std::stringstream ss;
  ss.width(3);
  ss << error;
  std::string text;
  text.assign("error: " + ss.str() + "\n");

  std::stringstream ss2;
  ss2 << num_detected_marker_;
  std::stringstream ss3;
  ss3 << num_total_markers_;

  std::string text2;
  text2.assign("detected: " + ss2.str() + " / " + ss3.str());

  rviz_marker.text.assign(text);
  rviz_marker.text.append(text2);

  rviz_marker.scale.z = 0.1;
  rviz_marker.ns.assign(node_handle_.getNamespace());
  rviz_marker.type = visualization_msgs::Marker::TEXT_VIEW_FACING;
  rviz_marker.lifetime = ros::Duration(0.1);

  rviz_marker_pub_.publish(rviz_marker);
  ROS_DEBUG ("Published visual marker");
}

void ARMultiPublisher::getTransform(const int marker_index,
                                    tf::Transform& transform)
{
  tf::Matrix3x3 matrix(multi_marker_config_->marker[marker_index].trans[0][0], multi_marker_config_->marker[marker_index].trans[0][1], multi_marker_config_->marker[marker_index].trans[0][2],
                     multi_marker_config_->marker[marker_index].trans[1][0], multi_marker_config_->marker[marker_index].trans[1][1], multi_marker_config_->marker[marker_index].trans[1][2],
                     multi_marker_config_->marker[marker_index].trans[2][0], multi_marker_config_->marker[marker_index].trans[2][1], multi_marker_config_->marker[marker_index].trans[2][2]);

  // ROS_INFO("%f %f %f %f", multi_marker_config_->marker[marker_index].trans[0][0], multi_marker_config_->marker[marker_index].trans[0][1], multi_marker_config_->marker[marker_index].trans[0][2], multi_marker_config_->marker[marker_index].trans[0][3]);
  // ROS_INFO("%f %f %f %f", multi_marker_config_->marker[marker_index].trans[1][0], multi_marker_config_->marker[marker_index].trans[1][1], multi_marker_config_->marker[marker_index].trans[1][2], multi_marker_config_->marker[marker_index].trans[1][3]);
  // ROS_INFO("%f %f %f %f", multi_marker_config_->marker[marker_index].trans[2][0], multi_marker_config_->marker[marker_index].trans[2][1], multi_marker_config_->marker[marker_index].trans[2][2], multi_marker_config_->marker[marker_index].trans[2][3]);

  tf::Vector3 origin(multi_marker_config_->marker[marker_index].trans[0][3] * AR_TO_ROS,
                   multi_marker_config_->marker[marker_index].trans[1][3] * AR_TO_ROS,
                   multi_marker_config_->marker[marker_index].trans[2][3] * AR_TO_ROS);
  tf::Quaternion quaternion;
  matrix.getRotation(quaternion);
  if (fabs(quaternion.length() - 1.0) > 10e3)
  {
    ROS_ERROR("Invalid quaternion (X=%f Y=%f Z=%f W=%f).", quaternion.getX(), quaternion.getY(), quaternion.getZ(), quaternion.getW());
    return;
  }
  transform.setRotation(quaternion);
  transform.setOrigin(origin);
}

void ARMultiPublisher::getTransformationCallback(const sensor_msgs::ImageConstPtr & image_msg)
{
  // Get the image from ROSTOPIC
  // NOTE: the dataPtr format is BGR because the ARToolKit library was
  // build with V4L, dataPtr format change according to the
  // ARToolKit configure option (see config.h).
  try
  {
    capture_ = bridge_.imgMsgToCv(image_msg, "bgr8");
  }
  catch (sensor_msgs::CvBridgeException & e)
  {
    ROS_ERROR ("Could not convert from >%s< to 'bgr8'.", image_msg->encoding.c_str ());
  }
  // cvConvertImage(capture,capture,CV_CVTIMG_FLIP);
  ARUint8* data_ptr = (ARUint8 *)capture_->imageData;

  // detect the markers in the video frame
  if (arDetectMarker(data_ptr, threshold_, &marker_info_, &num_detected_marker_) < 0)
  {
    argCleanup();
    ROS_BREAK ();
  }
  ROS_DEBUG("Detected >%i< of >%i< markers.", num_detected_marker_, num_total_markers_);

  double error = 0.0;
  if ((error = arMultiGetTransMat(marker_info_, num_detected_marker_, multi_marker_config_)) < 0)
  {
    // ROS_ERROR("Could not get transformation. This should never happen.");
    ROS_WARN("Could not get transformation.");
    return;
  }
  ROS_DEBUG("Error is >%f<.", error);

  for (int i = 0; i < num_detected_marker_; i++)
  {
    ROS_DEBUG("multi_marker_config_->prevF: %i", multi_marker_config_->prevF);
    ROS_DEBUG("%s: (%i) pos: %f %f id: %i cf: %f", marker_frame_.c_str(), i, marker_info_[i].pos[0], marker_info_[i].pos[1], marker_info_[i].id, marker_info_[i].cf);
  }

  // choose those with the highest confidence
  std::vector<double> cfs(num_total_markers_, 0.0);
  marker_indizes_.clear();
  for (int i = 0; i < num_total_markers_; ++i)
  {
    marker_indizes_.push_back(-1);
  }
  for (int i = 0; i < num_total_markers_; ++i)
  {
    for (int j = 0; j < num_detected_marker_; j++)
    {
      if (!(marker_info_[j].id < 0))
      {
        if (marker_info_[j].cf > cfs[marker_info_[j].id])
        {
          cfs[marker_info_[j].id] = marker_info_[j].cf;
          marker_indizes_[marker_info_[j].id] = j;
        }
      }
    }
  }

  double ar_quat[4], ar_pos[3];
  arUtilMat2QuatPos(multi_marker_config_->trans, ar_quat, ar_pos);
  tf::Quaternion rotation(-ar_quat[0], -ar_quat[1], -ar_quat[2], ar_quat[3]);
  tf::Vector3 origin(ar_pos[0] * AR_TO_ROS, ar_pos[1] * AR_TO_ROS, ar_pos[2] * AR_TO_ROS);
  tf::Transform transform(rotation, origin);
  if (multi_marker_config_->prevF && publish_tf_)
  {
    if(error < error_threshold_)
    {
      ROS_DEBUG("%f %f %f | %f %f %f %f | %f", origin.getX(), origin.getY(), origin.getZ(), rotation.getX(), rotation.getY(), rotation.getZ(), rotation.getW(), image_msg->header.stamp.toSec());
      tf::StampedTransform cam_to_marker(transform, image_msg->header.stamp, camera_frame_, marker_frame_);
      tf_broadcaster_.sendTransform(cam_to_marker);
    }
    publishErrorMarker(error, image_msg->header.stamp);
  }

  if(publish_visual_markers_)
  {
    for (int i = 0; i < num_total_markers_; i++)
    {
      if (marker_indizes_[i] >= 0)
      {
          tf::Transform marker_transform;
          getTransform(i, marker_transform);
          tf::Transform marker = transform * marker_transform;
          publishMarker(i, marker, image_msg->header.stamp);
          last_transform_ = marker;
      }
      // else
      // {
      //     publishMarker(i, last_transform_, image_msg->header.stamp);
      // }
    }
  }


}

}

int main(int argc,
         char **argv)
{
  if (argc < 2)
  {
    printf("ERROR: No node name provided. %i\n", argc);
    for (int i = 0; i < argc; i++)
    {
      printf("argv[%i] = %s\n", i, argv[i]);
    }
    return -1;
  }
  printf("Initializing node named: >%s<.\n", argv[1]);
  ros::init(argc, argv, argv[1]);
  ros::NodeHandle node_handle("~");
  ar_target::ARMultiPublisher ar_multi(node_handle);
  ros::spin();
  return 0;
}
