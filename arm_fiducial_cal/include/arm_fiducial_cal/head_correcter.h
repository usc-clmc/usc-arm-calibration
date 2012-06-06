/*
 * head_correcter.h
 *
 *  Created on: Jun 6, 2012
 *      Author: arm_user
 */

#ifndef HEAD_CORRECTOR_H_
#define HEAD_CORRECTER_H_

#include <ros/ros.h>
#include <vector>

#include <tf/transform_listener.h>
#include <tf/transform_broadcaster.h>

#include <sensor_msgs/JointState.h>

#include <arm_gp_lib/gp_model.h>

namespace arm_fiducial_cal
{

static const std::string BASE_FRAME = "/BASE";
static const std::string ORIGINAL_HEAD_FRAME = "/BUMBLEBEE_LEFT_REAL";
static const std::string CORRECTED_HEAD_FRAME = "/BUMBLEBEE_LEFT";

class HeadCorrecter
{

public:

  HeadCorrecter(ros::NodeHandle node_handle);
  virtual ~HeadCorrecter() {};

private:

  ros::NodeHandle node_handle_;
  tf::TransformListener tf_listener_;
  tf::TransformBroadcaster tf_broadcaster_;

  arm_gp_lib::GPModel gp_model_;

  std::vector<double> input_;
  std::vector<double> prev_input_;
  std::vector<double> output_;

  bool joint_map_initialized_;
  std::vector<int> joint_map_;

  tf::StampedTransform corrected_head_transform_;

  ros::Subscriber joint_state_sub_;
  void jointStateCB(const sensor_msgs::JointStateConstPtr joint_state);

};

}


#endif /* HEAD_CORRECTER_H_ */
