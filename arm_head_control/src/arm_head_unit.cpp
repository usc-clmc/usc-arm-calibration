/*
 * arm_head_unit.cpp
 *
 *  Created on: Oct 14, 2010
 *      Author: kalakris
 */

#include <cstdio>
#include <boost/bind.hpp>
#include <arm_head_control/arm_head_unit.h>
#include <arm_head_control/arm_head_unit_params.h>

#ifdef __XENO__
#include <native/task.h>
#endif

namespace arm_head_control
{

ArmHeadUnit::ArmHeadUnit(bool reset, bool position_control_mode):
    position_control_mode_(position_control_mode)
{
  joints_.resize(NUM_DOF);

  lower_pan_tilt_unit_.setDeviceAndName(LOWER_PTU_DEVICE,"LowerPTU");
  upper_pan_tilt_unit_.setDeviceAndName(UPPER_PTU_DEVICE, "UpperPTU");

  lower_pan_tilt_unit_.setParameters(reset,
                                     LOWER_PAN_ACCELERATION,
                                     LOWER_TILT_ACCELERATION,
                                     LOWER_PAN_MAX_SPEED,
                                     LOWER_TILT_MAX_SPEED,
                                     LOWER_PAN_HOLD_POWER_MODE,
                                     LOWER_PAN_MOVE_POWER_MODE,
                                     LOWER_TILT_HOLD_POWER_MODE,
                                     LOWER_TILT_MOVE_POWER_MODE,
                                     position_control_mode_);
  lower_pan_tilt_unit_.setDesiredLimits(LOWER_PAN_MIN_ANGLE,
                                        LOWER_PAN_MAX_ANGLE,
                                        LOWER_TILT_MIN_ANGLE,
                                        LOWER_TILT_MAX_ANGLE);
  upper_pan_tilt_unit_.setParameters(reset,
                                     UPPER_PAN_ACCELERATION,
                                     UPPER_TILT_ACCELERATION,
                                     UPPER_PAN_MAX_SPEED,
                                     UPPER_TILT_MAX_SPEED,
                                     UPPER_PAN_HOLD_POWER_MODE,
                                     UPPER_PAN_MOVE_POWER_MODE,
                                     UPPER_TILT_HOLD_POWER_MODE,
                                     UPPER_TILT_MOVE_POWER_MODE,
                                     position_control_mode_);
  upper_pan_tilt_unit_.setDesiredLimits(UPPER_PAN_MIN_ANGLE,
                                        UPPER_PAN_MAX_ANGLE,
                                        UPPER_TILT_MIN_ANGLE,
                                        UPPER_TILT_MAX_ANGLE);
  control_exit_ = false;
  //gets initialized only within the control thread
  lower_ptu_initialized_ = false;
  upper_ptu_initialized_ = false;

  // initialize debug file
  //debug_file_ = fopen("/tmp/head_check.txt", "w");

  // sl_rt_mutex_init(&mutex_);
}

ArmHeadUnit::~ArmHeadUnit()
{
  // sl_rt_mutex_destroy(&mutex_);
}

void ArmHeadUnit::startControlThreads()
{
  lower_pan_tilt_thread_.reset(new boost::thread(boost::bind(&ArmHeadUnit::controlThread, this, 0, &lower_pan_tilt_unit_, &lower_ptu_initialized_)));
  usleep(100000);
  upper_pan_tilt_thread_.reset(new boost::thread(boost::bind(&ArmHeadUnit::controlThread, this, 2, &upper_pan_tilt_unit_, &upper_ptu_initialized_)));
}

void ArmHeadUnit::stopControlThreads()
{
  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  control_exit_ = true;
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();

  lower_pan_tilt_thread_->join();
  upper_pan_tilt_thread_->join();
}

void ArmHeadUnit::controlThread(int start_index, ArmPanTiltUnit* pan_tilt_unit, bool* initialized)
{
#ifdef __NOT_USING_XENO__
  std::string task_name = "head_control_" + pan_tilt_unit->getName();
  rt_task_shadow(NULL, task_name.c_str(), 0, 0);

  // immediately go into secondary mode:
  rt_task_set_mode(T_PRIMARY,0,NULL);
#endif

  // initialize the device:
  if (!pan_tilt_unit->open())
  {
    printf("Failed to initialize PTU.");
    return;
  }

  // create all the necessary vectors before the loop:
  std::vector<Joint> joints(2);
  bool control_exit = control_exit_;

  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  *initialized = true;
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();

  while (!control_exit)
  {
    // first transfer variables:
    // sl_rt_mutex_lock(&mutex_);
    mutex_.lock();

    for (int i=0; i<2; ++i)
    {
      joints[i].commanded_position_ = joints_[start_index+i].commanded_position_;
      joints[i].commanded_velocity_ = joints_[start_index+i].commanded_velocity_;
      joints_[start_index+i].sensed_position_ = joints[i].sensed_position_;
      joints_[start_index+i].prev_sensed_position_ = joints[i].prev_sensed_position_;
      joints_[start_index+i].update_time_ = joints[i].update_time_;
      joints_[start_index+i].prev_update_time_ = joints[i].prev_update_time_;
    }
    control_exit = control_exit_;
    // sl_rt_mutex_unlock(&mutex_);
    mutex_.unlock();

#ifdef __NOT_USING_XENO__
    // go into secondary mode:
    rt_task_set_mode(T_PRIMARY,0,NULL);
#endif

    // velocity control mode:
    if (position_control_mode_)
    {
      // position control mode:
      pan_tilt_unit->sendPositionsVelocitiesRadians(joints[0].commanded_position_,
                                                    joints[0].commanded_velocity_,
                                                    joints[1].commanded_position_,
                                                    joints[1].commanded_velocity_);
    }
    else
    {
      pan_tilt_unit->sendVelocitiesRadians(joints[0].commanded_velocity_,
                                           joints[1].commanded_velocity_);
    }

    joints[0].prev_sensed_position_ = joints[0].sensed_position_;
    joints[1].prev_sensed_position_ = joints[1].sensed_position_;
    joints[0].prev_update_time_ = joints[0].update_time_;
    joints[1].prev_update_time_ = joints[1].update_time_;

    pan_tilt_unit->getPositionsRadians(joints[0].sensed_position_,
                                       joints[1].sensed_position_);
    //fprintf(debug_file_, "%d: %f, %d: %f\n ", start_index+1, joints[0].sensed_position_, start_index+2, joints[1].sensed_position_);
    //fflush(debug_file_);

    // joints[0].update_time_ = rt_timer_read();
    joints[0].update_time_ = ros::Time::now();
    joints[1].update_time_ = joints[0].update_time_;
  }


}

bool ArmHeadUnit::isInitialized()
{
  bool lower_ret=false, upper_ret=false;
  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  lower_ret = lower_ptu_initialized_;
  upper_ret = upper_ptu_initialized_;
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();
  return lower_ret && upper_ret;
}

void ArmHeadUnit::setPositionsVelocities(float* positions, float* velocities)
{
  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  for (int i=0; i<NUM_DOF; ++i)
  {
    joints_[i].commanded_position_ = positions[i];
    joints_[i].commanded_velocity_ = velocities[i];
  }
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();
}

void ArmHeadUnit::setVelocities(float* velocities)
{
  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  for (int i=0; i<NUM_DOF; ++i)
    joints_[i].commanded_velocity_ = velocities[i];
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();
}

void ArmHeadUnit::getPositionsVelocities(float* positions, float* velocities)
{
  // RTIME cur_time;
  ros::Time cur_time;
  // sl_rt_mutex_lock(&mutex_);
  mutex_.lock();
  // cur_time = rt_timer_read();
  cur_time = ros::Time::now();
  for (int i=0; i<NUM_DOF; ++i)
  {
    double deltat = (double)(joints_[i].update_time_.toNSec() - joints_[i].prev_update_time_.toNSec())/1000000000.0;
    velocities[i] = (joints_[i].sensed_position_ - joints_[i].prev_sensed_position_) / deltat;

    double cur_delta_t = (double)(cur_time.toNSec() - joints_[i].update_time_.toNSec())/1000000000.0;
    positions[i] = joints_[i].sensed_position_ + cur_delta_t * velocities[i];
  }
  // sl_rt_mutex_unlock(&mutex_);
  mutex_.unlock();
}

void ArmHeadUnit::getResolutions(float* resolutions)
{
  lower_pan_tilt_unit_.getResolutions(resolutions[0], resolutions[1]);
  upper_pan_tilt_unit_.getResolutions(resolutions[2], resolutions[3]);
}

}
