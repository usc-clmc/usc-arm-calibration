/*
 * ar_base.h
 *
 *  Created on: Sep 1, 2011
 *      Author: pastor_local
 */

#ifndef AR_BASE_H_
#define AR_BASE_H_

// system includes
#include <string.h>
#include <stdarg.h>

#include <AR/param.h>
#include <AR/ar.h>
#include <AR/video.h>

#include <ros/ros.h>
#include <ros/console.h>

#include <geometry_msgs/TransformStamped.h>
#include <geometry_msgs/Pose.h>
#include <sensor_msgs/CameraInfo.h>
#include <visualization_msgs/Marker.h>

#include <tf/transform_broadcaster.h>
#include <image_transport/image_transport.h>
#include <resource_retriever/retriever.h>

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <cv_bridge/CvBridge.h>

// local includes
#include <ar_target/ARMarker.h>

const double AR_TO_ROS = 0.001;

namespace ar_target
{

class ARBase
{

public:

  ARBase(ros::NodeHandle node_handle);
  virtual ~ARBase();

protected:

  void publishMarker(const tf::Transform& transform, const ros::Time& time_stamp);

  ros::NodeHandle node_handle_;
  ros::Subscriber camera_info_subcriber_;
  tf::TransformBroadcaster tf_broadcaster_;
  ros::Publisher ar_marker_publisher_;

  image_transport::ImageTransport it_;
  image_transport::Subscriber cam_sub_;
  sensor_msgs::CvBridge bridge_;
  sensor_msgs::CameraInfo cam_info_;

  std::string camera_info_topic_;
  std::string camera_image_topic_;

  std::string camera_frame_;
  std::string marker_frame_;

  bool publish_tf_;
  bool publish_visual_markers_;
  bool use_history_;
  int threshold_;
  double marker_width_; // Size of the AR Marker in mm

  ARParam cam_param_; // Camera Calibration Parameters
  int patt_id_; // AR Marker Pattern
  char pattern_filename_[FILENAME_MAX];
  bool reverse_transform_; // Reverse direction of transform marker -> cam

  double marker_center_[2]; // Physical Center of the Marker
  double marker_trans_[3][4]; // Marker Transform

  double marker_red_;
  double marker_green_;
  double marker_blue_;

  // for visualisation in rviz
  ros::Publisher rviz_marker_pub_;

  int cont_f_;
  bool get_camera_info_;
  CvSize size_;
  IplImage *capture_;

private:

  bool readParams();

};

}

#endif /* AR_BASE_H_ */
