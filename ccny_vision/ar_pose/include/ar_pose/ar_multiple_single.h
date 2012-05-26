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

#ifndef AR_POSE_AR_MULTIPLE_SINGLE_H
#define AR_POSE_AR_MULTIPLE_SINGLE_H

#include <string.h>
#include <stdarg.h>

#include <AR/gsub.h>
#include <AR/video.h>
#include <AR/param.h>
#include <AR/ar.h>
#include <AR/arMulti.h>

#include <ros/ros.h>
#include <ros/package.h>
#include <ros/console.h>

#include <tf/transform_broadcaster.h>
#include <geometry_msgs/TransformStamped.h>
#include <tf/transform_broadcaster.h>
#include <image_transport/image_transport.h>
#include <sensor_msgs/CameraInfo.h>
#include <visualization_msgs/Marker.h>
#include <resource_retriever/retriever.h>

#include <opencv/cv.h>
#include <cv_bridge/CvBridge.h>

// local includes
#include <ar_pose/ARMarkers.h>
#include <ar_pose/ARMarker.h>
#include <ar_pose/object.h>
#include <ar_pose/ar_base.h>

namespace ar_pose
{
class ARMultipleSinglePublisher : public ARBase
{

public:
  ARMultipleSinglePublisher(ros::NodeHandle& node_handle);
  virtual ~ARMultipleSinglePublisher() {};

private:
  void arInit();
  void getTransformationCallback(const sensor_msgs::ImageConstPtr& image_msg);
  void camInfoCallback(const sensor_msgs::CameraInfoConstPtr& cam_info);

  void addMarker(const int index, const tf::Transform& transform);

  void publishMarker(const int index,
                     const tf::Transform& transform,
                     const ros::Time& time_stamp);

  void publishCube(const tf::Transform& transform,
                   const ros::Time& time_stamp);

  ros::Publisher ar_marker_pub_;
  ARMarkers ar_markers_;

  ARMarkerInfo* marker_info_;
  int num_detected_marker_;

  // parameters
  ARParam cam_param_; // Camera Calibration Parameters
  ar_object::ObjectData_T * object_;
  int objectnum_;
};

}

#endif
