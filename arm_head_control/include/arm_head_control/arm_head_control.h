/*
 * arm_head_control.h
 *
 *  Created on: May 24, 2012
 *      Author: arm_user
 */

#ifndef ARM_HEAD_CONTROL_H_
#define ARM_HEAD_CONTROL_H_

#include <map>
#include <vector>
#include <ros/ros.h>
#include <boost/shared_ptr.hpp>
#include <boost/thread/mutex.hpp>

#include <actionlib/server/simple_action_server.h>
#include <arm_head_control/LookAtAction.h>

#include <urdf/model.h>
#include <kdl/tree.hpp>
#include <robot_state_publisher/robot_state_publisher.h>

#include <sensor_msgs/JointState.h>
#include <arm_head_control/arm_head_unit.h>

namespace arm_head_control
{

class ArmHeadControl
{
  typedef actionlib::SimpleActionServer<arm_head_control::LookAtAction> ActionServer;
  typedef ActionServer::GoalHandle GoalHandle;

public:

  ArmHeadControl(ros::NodeHandle node_handle,
                 const std::string action_name);
  virtual ~ArmHeadControl();

  void execute(const arm_head_control::LookAtGoalConstPtr& goal);

private:
  ros::NodeHandle node_handle_;
  ActionServer action_server_;

  bool initialize();

  ros::Timer loop_timer_;
  void loop(const ros::TimerEvent& timer_event);

  boost::mutex mutex_;
  ros::Time receiving_time_stamp_;

  void fail(const std::string& info);
  void succeed(const std::string& info);

  ros::Publisher joint_state_pub_;
  sensor_msgs::JointState joint_state_msg_;

  boost::shared_ptr<arm_head_control::ArmHeadUnit> head_unit_;

  boost::shared_ptr<urdf::Model> urdf_;
  std::map<std::string, double> joint_positions_;
  std::vector<double> joint_angels_;
  std::vector<double> joint_velocities_;

  boost::shared_ptr<robot_state_publisher::RobotStatePublisher> tf_pub_;
  bool initialize(boost::shared_ptr<urdf::Model> urdf);

  void publish(const std::map<std::string, double>& joint_positions,
               const ros::Time& ros_servo_time);

  bool lookAtJointAngles(const std::vector<double> joint_angels);

};

}



#endif /* ARM_HEAD_CONTROL_H_ */
