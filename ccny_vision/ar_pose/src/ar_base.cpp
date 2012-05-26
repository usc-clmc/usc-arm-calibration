/*
 * ar_base.cpp
 *
 *  Created on: Sep 1, 2011
 *      Author: pastor_local
 */

// system includes
#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>

#include <ros/package.h>
#include <ros/console.h>

#include <angles/angles.h>

// local includes
#include <ar_pose/ar_base.h>

namespace ar_pose
{

ARBase::ARBase(ros::NodeHandle node_handle) :
    node_handle_(node_handle), it_(node_handle_), get_camera_info_(false)
{
  ROS_INFO("Starting AR...");
  ROS_VERIFY(readParams());
}

ARBase::~ARBase()
{
  // cvReleaseImage(&capture); //Don't know why but crash when release the image
  arVideoCapStop();
  arVideoClose();
};

void ARBase::publishMarker(const tf::Transform& transform, const ros::Time& time_stamp)
{
  if (publish_visual_markers_)
  {
    const double MARKER_THIKNESS_SCALE = 0.1;
    tf::Vector3 marker_origin(0, 0, (MARKER_THIKNESS_SCALE/(double)2.0) * marker_width_ * AR_TO_ROS);
    tf::Transform m(tf::Quaternion::getIdentity(), marker_origin);
    tf::Transform marker_pose = transform * m; // marker pose in the camera frame

    visualization_msgs::Marker rviz_marker;
    tf::poseTFToMsg(marker_pose, rviz_marker.pose);

    // rviz_marker_.header.frame_id = image_msg->header.frame_id;
    rviz_marker.header.frame_id = camera_frame_;
    rviz_marker.header.stamp = time_stamp;
    rviz_marker.id = 1;
    rviz_marker.ns.assign(node_handle_.getNamespace());
    rviz_marker.scale.x = 1.0 * marker_width_ * AR_TO_ROS;
    rviz_marker.scale.y = 1.0 * marker_width_ * AR_TO_ROS;
    rviz_marker.scale.z = MARKER_THIKNESS_SCALE * marker_width_ * AR_TO_ROS;
    rviz_marker.type = visualization_msgs::Marker::CUBE;
    rviz_marker.action = visualization_msgs::Marker::ADD;
    rviz_marker.color.r = (float)marker_red_;
    rviz_marker.color.g = (float)marker_green_;
    rviz_marker.color.b = (float)marker_blue_;
    rviz_marker.color.a = 1.0;
    rviz_marker.lifetime = ros::Duration();

    rviz_marker_pub_.publish(rviz_marker);
    ROS_DEBUG ("Published visual marker.");
  }
}

bool ARBase::readParams()
{
  // get parameters
  ROS_VERIFY(usc_utilities::read(node_handle_, "camera_image_topic", camera_image_topic_));
  ROS_INFO ("\tCamera image topic: %s", camera_image_topic_.c_str());

  ROS_VERIFY(usc_utilities::read(node_handle_, "camera_info_topic", camera_info_topic_));
  ROS_INFO ("\tCamera image topic: %s", camera_info_topic_.c_str());

  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_red", marker_red_));
  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_green", marker_green_));
  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_blue", marker_blue_));

  ROS_VERIFY(usc_utilities::read(node_handle_, "publish_tf", publish_tf_));
  ROS_INFO ("\tPublish transforms: %d", publish_tf_);

  ROS_VERIFY(usc_utilities::read(node_handle_, "publish_visual_markers", publish_visual_markers_));
  ROS_INFO ("\tPublish visual markers: %d", publish_visual_markers_);

  ROS_VERIFY(usc_utilities::read(node_handle_, "threshold", threshold_));
  ROS_INFO ("\tThreshold: %d", threshold_);

  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_width", marker_width_));
  ROS_INFO ("\tMarker Width: %.1f", marker_width_);

  ROS_VERIFY(usc_utilities::read(node_handle_, "reverse_transform", reverse_transform_));
  ROS_INFO("\tReverse Transform: %d", reverse_transform_);

  ROS_VERIFY(usc_utilities::read(node_handle_, "camera_frame", camera_frame_));
  ROS_INFO ("\tCamera frame: %s", camera_frame_.c_str());

  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_frame", marker_frame_));
  ROS_INFO ("\tMarker frame: %s", marker_frame_.c_str());

  // If mode=0, we use arGetTransMat instead of arGetTransMatCont
  // The arGetTransMatCont function uses information from the previous image
  // frame to reduce the jittering of the marker
  ROS_VERIFY(usc_utilities::read(node_handle_, "use_history", use_history_));
  ROS_INFO("\tUse history: %d", use_history_);

  std::string local_path;
  std::string package_path = ros::package::getPath(ROS_PACKAGE_NAME);
  ROS_VERIFY(usc_utilities::read(node_handle_, "marker_pattern", local_path));
  sprintf(pattern_filename_, "%s/%s", package_path.c_str(), local_path.c_str());
  ROS_INFO ("\tMarker Pattern Filename: %s", pattern_filename_);
  return true;
}

}
