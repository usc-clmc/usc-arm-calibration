/*
 * arm_head_unit.h
 *
 *  Created on: Oct 14, 2010
 *      Author: kalakris
 */

#ifndef ARM_HEAD_UNIT_H_
#define ARM_HEAD_UNIT_H_

#include <arm_head_control/arm_pan_tilt_unit.h>
#include <boost/thread/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <boost/shared_ptr.hpp>
#include <sys/time.h>
#include <vector>

// #include "SL_rt_mutex.h"
#include <ros/ros.h>

namespace arm_head_control
{

const int NUM_DOF=4;

struct Joint
{
  float commanded_position_;
  float commanded_velocity_;
  float sensed_position_;
  float sensed_velocity_;
  // RTIME update_time_;
  ros::Time update_time_;
  // RTIME prev_update_time_;
  ros::Time prev_update_time_;
  float prev_sensed_position_;
};

class ArmHeadUnit
{
public:
  ArmHeadUnit(bool reset, bool position_control_mode);
  virtual ~ArmHeadUnit();

  void setPositionsVelocities(float* positions, float* velocities);
  void setVelocities(float* velocities);
  void getPositionsVelocities(float* positions, float* velocities);

  void startControlThreads();
  void stopControlThreads();

  bool isInitialized();

  void getResolutions(float* resolutions);

  /**
   * Two of these threads are started, one for each PTU unit. Each runs
   * synchronously, reading and updating the position and velocity
   * variables protected by the mutex
   */
  void controlThread(int start_index, ArmPanTiltUnit* pan_tilt_unit, bool* initialized);

private:
  ArmPanTiltUnit lower_pan_tilt_unit_;
  ArmPanTiltUnit upper_pan_tilt_unit_;

  std::vector<Joint> joints_;

  bool control_exit_;
  bool lower_ptu_initialized_;
  bool upper_ptu_initialized_;

  // sl_rt_mutex mutex_;
  boost::mutex mutex_;
  boost::shared_ptr<boost::thread> lower_pan_tilt_thread_;
  boost::shared_ptr<boost::thread> upper_pan_tilt_thread_;

  const bool position_control_mode_;

  FILE* debug_file_;
};

}

#endif /* ARM_HEAD_UNIT_H_ */
