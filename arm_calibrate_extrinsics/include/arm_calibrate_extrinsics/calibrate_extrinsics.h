/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		calibrate_extrinsics.h

  \author	Peter Pastor
  \date		Sep 17, 2011

 *********************************************************************/

#ifndef CALIBRATE_EXTRINSICS_H_
#define CALIBRATE_EXTRINSICS_H_

// system includes
#include <vector>
#include <string>
#include <ros/ros.h>

#include <boost/shared_ptr.hpp>
#include <boost/thread/mutex.hpp>

#include <ar_target/ARMarkers.h>
#include <sensor_msgs/PointCloud2.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/CameraInfo.h>

#include <actionlib/client/simple_action_client.h>
#include <arm_behavior_actions/LookAtAction.h>
#include <arm_dashboard_client/dashboard_client.h>

#include <tf/transform_listener.h>

// local includes
#include <arm_calibrate_extrinsics/CalibrateExtrinsics.h>
#include <arm_calibrate_extrinsics/ARFrame.h>

namespace arm_calibrate_extrinsics
{

class ExtrinsicsCalibrator
{

public:

  /*! Constructor
   */
  ExtrinsicsCalibrator(ros::NodeHandle node_handle);
  virtual ~ExtrinsicsCalibrator() {};

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

  std::vector<std::vector<double> > look_at_configurations_array_;
//  std::vector<std::vector<double> > lower_ptu_configurations_array_;
  bool readLookAtConfigurations();

  void readParams();
  double head_settling_duration_;

  std::string bag_file_name_;
  std::string data_directory_name_;

  double confidence_threshold_;

  boost::mutex mutex_;
  bool dump_snapshot_;
  std::vector<arm_calibrate_extrinsics::ARFrame> frames_;

  void callback(const ar_target::ARMarkersConstPtr& left_markers,
                const sensor_msgs::PointCloud2ConstPtr& point_cloud,
                const sensor_msgs::ImageConstPtr& image,
                const sensor_msgs::CameraInfoConstPtr& camera_info);

  bool writeOutFile();
  bool writeOutImages();

  ros::Time snapshot_time_;

  std::string cal_script_;

};

}

#endif /* CALIBRATE_EXTRINSICS_H_ */
