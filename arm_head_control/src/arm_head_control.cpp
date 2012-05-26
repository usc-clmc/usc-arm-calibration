/*
 * arm_head_control.cpp
 *
 *  Created on: May 24, 2012
 *      Author: arm_user
 */

#include <usc_utilities/param_server.h>
#include <usc_utilities/assert.h>
#include <arm_head_control/arm_head_control.h>
#include <kdl_parser/kdl_parser.hpp>

namespace arm_head_control
{

ArmHeadControl::ArmHeadControl(ros::NodeHandle node_handle,
                               const std::string action_name)
: node_handle_(node_handle),
  action_server_(node_handle, action_name, boost::bind(&ArmHeadControl::execute, this, _1), false)
{

  bool do_head_reset = true;
  ROS_VERIFY(usc_utilities::read(node_handle_, "do_head_reset", do_head_reset));
  head_unit_.reset(new arm_head_control::ArmHeadUnit(do_head_reset, true));
  head_unit_->startControlThreads();
  while(!head_unit_->isInitialized())
  {
    ros::Duration(0.1).sleep();
  }

  ROS_VERIFY(initialize());

  double frequency = 300.0; // hz
  double update_timer_period = (double)1.0 / frequency;
  loop_timer_ = node_handle_.createTimer(ros::Duration(update_timer_period), &ArmHeadControl::loop, this);

  ROS_INFO("Head is initialized.");
  action_server_.start();
}

ArmHeadControl::~ArmHeadControl()
{
  if(head_unit_)
  {
    if(head_unit_->isInitialized())
    {
      head_unit_->stopControlThreads();
    }
  }
}

bool ArmHeadControl::initialize()
{
  joint_angels_.resize(4, 0.0);
  joint_velocities_.resize(4, 0.0);

  urdf_.reset(new urdf::Model());
  if (!urdf_->initParam("/robot_description"))
  {
    ROS_ERROR("Couldn't load URDF from /robot_description");
    return false;
  }

  KDL::Tree kdl_tree;
  if (!kdl_parser::treeFromUrdfModel(*urdf_, kdl_tree))
  {
    ROS_ERROR("Couldn't create KDL tree from URDF");
    return false;
  }

  tf_pub_.reset(new robot_state_publisher::RobotStatePublisher(kdl_tree));

  joint_positions_.insert(std::pair<std::string, double>("LPAN=", 0.0));
  joint_positions_.insert(std::pair<std::string, double>("LTILT", 0.0));
  joint_positions_.insert(std::pair<std::string, double>("LTILT_TOP", 0.0));
  joint_positions_.insert(std::pair<std::string, double>("LTILT_FRONT", 0.0));
  joint_positions_.insert(std::pair<std::string, double>("UPAN", 0.0));
  joint_positions_.insert(std::pair<std::string, double>("UTILT", 0.0));

  return true;
}

void ArmHeadControl::loop(const ros::TimerEvent& timer_event)
{

  float current_positions[4];
  float current_velocities[4];
  mutex_.lock();
  head_unit_->getPositionsVelocities(current_positions, current_velocities);
  receiving_time_stamp_ = ros::Time::now();
  for (int i = 0; i < 4; ++i)
  {
    joint_angels_[i] = current_positions[i];
    joint_velocities_[i] = current_velocities[i];
  }
  joint_positions_["LPAN"] = joint_angels_[0];
  joint_positions_["LTILT"] = -joint_angels_[1];
  joint_positions_["UPAN"] = -joint_angels_[2];
  joint_positions_["UTILT"] = -joint_angels_[3];

  joint_positions_["LTILT_TOP"] = -joint_positions_["LTILT"];
  joint_positions_["LTILT_FRONT"] = joint_positions_["LTILT"];
  mutex_.unlock();

  tf_pub_->publishFixedTransforms();
  tf_pub_->publishTransforms(joint_positions_, receiving_time_stamp_);

}

void ArmHeadControl::execute(const arm_head_control::LookAtGoalConstPtr& goal)
{
  ROS_INFO("Received joint angels >%.2f %.2f %.2f %.2f<",
           goal->ptu_joint_angels[0], goal->ptu_joint_angels[1], goal->ptu_joint_angels[2], goal->ptu_joint_angels[3]);

  float signs[4] = {1.0, -1.0, -1.0, -1.0};
  float positions[4];
  for(int i=0; i<4; ++i)
  {
    positions[i] = goal->ptu_joint_angels[i] * signs[i];
  }
  float velocities[4];
  velocities[0] = 0.45; // 0.45
  velocities[1] = 0.23; // 0.23
  velocities[2] = 1.2;  // 2.7
  velocities[3] = 0.45;  // 0.7

  mutex_.lock();
  head_unit_->setPositionsVelocities(positions, velocities);
  mutex_.unlock();

  bool target_reached = false;
  double min_abs_vel = 1e-6;
  bool first_time = true;
  while(!target_reached)
  {
    if(first_time)
    {
      first_time = false;
      ros::Duration(1.0).sleep();
    }
    else
    {
      ros::Duration(0.1).sleep();
    }

    double distance = 0.0;

    mutex_.lock();
    for (int i = 0; i < 4; ++i)
    {
      distance += fabs(joint_angels_[i] - positions[i]);
    }
    if(fabs(joint_velocities_[0]) < min_abs_vel &&
        fabs(joint_velocities_[1]) < min_abs_vel &&
        fabs(joint_velocities_[2]) < min_abs_vel &&
        fabs(joint_velocities_[3]) < min_abs_vel &&
        distance < 1e-2)
    {
      target_reached = true;
    }
    mutex_.unlock();
}

  succeed("LookAt action succeeded.");
}

void ArmHeadControl::succeed(const std::string& info)
{
  arm_head_control::LookAtResult result;
  result.info.assign(info);
  result.result = arm_head_control::LookAtResult::SUCCEEDED;
  action_server_.setSucceeded(result);
}

void ArmHeadControl::fail(const std::string& info)
{
  arm_head_control::LookAtResult result;
  result.info.assign(info);
  result.result = arm_head_control::LookAtResult::FAILED;
  action_server_.setSucceeded(result);
}


bool ArmHeadControl:: lookAtJointAngles(const std::vector<double> joint_angels)
{

  return true;
  // return moveTo(joint_angles, time, wait_for_success);
}

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "");
  ros::NodeHandle node_handle("~");
  std::string action_name = "lookAt";
  arm_head_control::ArmHeadControl head_control(node_handle, action_name);
  ros::spin();
}
