/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		calibrate_extrinsics_3d.h

  \author	Peter Pastor
  \date		Sep 17, 2011

 *********************************************************************/

#ifndef CALIBRATE_EXTRINSICS_3D_H_
#define CALIBRATE_EXTRINSICS_3D_H_

// system includes
#include <vector>
#include <string>
#include <ros/ros.h>

#include <boost/shared_ptr.hpp>
#include <boost/thread/mutex.hpp>

#include <ar_target/ARMarker3d.h>
#include <ar_target/ARMarkers3d.h>
#include <sensor_msgs/PointCloud2.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/CameraInfo.h>

#include <sensor_msgs/JointState.h>

#include <visualization_msgs/MarkerArray.h>

#include <actionlib/client/simple_action_client.h>
#include <arm_behavior_actions/LookAtAction.h>

// for JPL + CMU
#include <arm_head_control/LookAtAction.h>

#include <arm_dashboard_client/dashboard_client.h>

#include <tf/transform_listener.h>

// local includes
#include <arm_calibrate_extrinsics/CalibrateExtrinsics.h>
#include <arm_calibrate_extrinsics/ARFrame3d.h>

namespace arm_calibrate_extrinsics
{

class ExtrinsicsCalibrator3D
{

public:

  /*! Constructor
   */
  ExtrinsicsCalibrator3D(ros::NodeHandle node_handle);
  virtual ~ExtrinsicsCalibrator3D() {};

  /*!
   * @param request
   * @param response
   * @return
   */
  bool calibrateExtrinsics(arm_calibrate_extrinsics::CalibrateExtrinsics::Request& request,
                           arm_calibrate_extrinsics::CalibrateExtrinsics::Response& response);

  void run();

private:

  ros::NodeHandle node_handle_;
  tf::TransformListener tf_listener_;

  ros::ServiceServer calibrate_extrinsics_server_;

  arm_dashboard_client::DashboardClient dashboard_client_;
  boost::shared_ptr<actionlib::SimpleActionClient<arm_behavior_actions::LookAtAction> > look_at_client_;
  boost::shared_ptr<actionlib::SimpleActionClient<arm_head_control::LookAtAction> > look_at_joint_client_;

  std::vector<std::vector<double> > look_at_configurations_array_;
  std::vector<std::vector<double> > look_at_joint_configurations_array_;
  bool readLookAtConfigurations();

  void readParams();
  double head_settling_duration_;

  std::string bag_file_name_;
  std::string data_directory_name_;

  double confidence_threshold_;

  boost::mutex mutex_;

  int num_snapshots_for_averaging_;
  int snapshot_counter_;
  std::vector<std::vector<ar_target::ARMarker3d> > averaging_markers_;
  double getMean(const std::vector<double>& values);
  geometry_msgs::Point getMean(const std::vector<geometry_msgs::Point>& values);
  geometry_msgs::Quaternion getMean(const std::vector<geometry_msgs::Quaternion>& values);
  geometry_msgs::Pose getMean(const std::vector<geometry_msgs::Pose>& values);

  void averageMarkers(const std::vector<std::vector<ar_target::ARMarker3d> >& markers,
                      std::vector<ar_target::ARMarker3d>& averaged_markers);

  int marker_index_;
  boost::shared_ptr<visualization_msgs::MarkerArray> marker_array_;
  ros::Publisher rviz_marker_pub_;
  void addRvizMarker3d(const ar_target::ARMarker3d& marker, const ros::Time& time_stamp);

  bool dump_snapshot_;
  std::vector<arm_calibrate_extrinsics::ARFrame3d> frames_;

  void callback(const ar_target::ARMarkers3dConstPtr& markers,
                const sensor_msgs::PointCloud2ConstPtr& point_cloud,
                const sensor_msgs::ImageConstPtr& left_image,
                const sensor_msgs::ImageConstPtr& right_image,
                const sensor_msgs::CameraInfoConstPtr& left_camera_info,
                const sensor_msgs::CameraInfoConstPtr& right_camera_info);

  bool writeOutFile();
  bool writeOutImages();

  ros::Time snapshot_time_;

  bool generate_head_configurations_;
  bool move_head_using_SL_;

  std::string cal_script_;
  bool do_calibration_;

  std::string learn_gp_script_;

  sensor_msgs::JointState joint_state_msg_;

};

}

#endif /* CALIBRATE_EXTRINSICS_3D_H_ */
