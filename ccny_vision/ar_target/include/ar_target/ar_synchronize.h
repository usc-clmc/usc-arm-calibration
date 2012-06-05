/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		ar_synchronize.h

  \author	Peter Pastor
  \date		Sep 4, 2011

 *********************************************************************/

#ifndef AR_SYNCHRONIZE_H_
#define AR_SYNCHRONIZE_H_

// system includes
#include <ros/ros.h>
#include <vector>
#include <string>

#include <tf/transform_broadcaster.h>
#include <geometry_msgs/TransformStamped.h>
#include <message_filters/subscriber.h>
#include <message_filters/time_synchronizer.h>

#include <image_geometry/stereo_camera_model.h>
#include <image_geometry/pinhole_camera_model.h>

#include <stereo_msgs/DisparityImage.h>
#include <sensor_msgs/PointCloud2.h>

#include <visualization_msgs/MarkerArray.h>

// local includes
#include <ar_target/ARMarker3d.h>
#include <ar_target/ARMarkers3d.h>

namespace ar_target
{

class ARSynchronize
{

public:
  ARSynchronize(ros::NodeHandle);
  virtual ~ARSynchronize() {};

  void run();

private:

  ros::NodeHandle node_handle_;

  bool got_camera_info_;
  std::string left_camera_frame_;
  ros::Subscriber camera_info_subcriber_;
  void camInfoCallback(const sensor_msgs::CameraInfoConstPtr& left_cam_info,
                       const sensor_msgs::CameraInfoConstPtr& right_cam_info);

  void markerCallback(const ar_target::ARMarkersConstPtr& left_markers,
                      const ar_target::ARMarkersConstPtr& right_markers);


  image_geometry::PinholeCameraModel left_cam_;
  image_geometry::PinholeCameraModel right_cam_;

  cv::Mat_<double> Q_;
  void process();

  bool computeDisparity(const std::vector<double>& left,
                        const std::vector<double>& right,
                        std::vector<float>& disparity);

  void projectDisparityTo3d(const cv::Point2d& left_uv_rect,
                            float disparity,
                            cv::Point3d& xyz) const;

//  void publishMarker(const int corner_id,
//                     const int marker_id,
//                     const Eigen::Vector3d point_xyz,
//                     const ros::Time& time_stamp);
//  void publishMarker(const int corner_id,
//                     const int marker_id,
//                     const cv::Point3d& point_xyz,
//                     const ros::Time& time_stamp);

  int marker_index_;
  boost::shared_ptr<visualization_msgs::MarkerArray> marker_array_;
  void addRvizMarker3d(const ar_target::ARMarker3d& marker,
                       const ros::Time& time_stamp);

  // for visualisation in rviz
  ros::Publisher rviz_marker_pub_;
  ros::Publisher marker_pub_;

  int num_markers_;
  double confidence_threshold_;

  std::vector<tf::Transform> marker_static_transforms_;
  std::vector<tf::Transform> marker_transforms_;
  std::vector<double> marker_confidences_;
  bool readTransforms();

  void processMarkerTransforms(const ros::Time& time_stamp);
  tf::TransformBroadcaster tf_broadcaster_;

  void publishTransform(const tf::Transform& transform, const ros::Time& time_stamp);

};

}


#endif /* AR_SYNCHRONIZE_H_ */
