/*
 * arm_head_c_api.cpp
 *
 *  Created on: Oct 18, 2010
 *      Author: kalakris
 */

#include <unistd.h>
#include <arm_head_control/arm_head_c_api.h>
#include <arm_head_control/arm_head_unit.h>

#ifdef __NOT_USING_XENO__
#include <native/task.h>
#endif

using namespace arm_head_control;

static ArmHeadUnit* arm_head_unit;

int arm_head_initialize(int reset, int position_control)
{
  arm_head_unit = new ArmHeadUnit(reset==1, position_control==1);
  arm_head_unit->startControlThreads();
  return 1;
}

int arm_head_wait_for_initialized()
{
  while (!arm_head_unit->isInitialized())
  {
#ifdef __NOT_USING_XENO__
    rt_task_sleep(100000000);
#else
    usleep(100000);
#endif
  }
  return 1;
}

int arm_head_is_initialized()
{
  if (arm_head_unit->isInitialized())
    return 1;
  else
    return 0;
}

int arm_head_set_positions_velocities(float* commanded_positions, float* commanded_velocities)
{
  arm_head_unit->setPositionsVelocities(commanded_positions, commanded_velocities);
  return 1;
}

int arm_head_set_velocities(float* commanded_velocities)
{
  arm_head_unit->setVelocities(commanded_velocities);
  return 1;
}

int arm_head_get_positions_velocities(float* sensed_positions, float* sensed_velocities)
{
  arm_head_unit->getPositionsVelocities(sensed_positions, sensed_velocities);
  return 1;
}

int arm_head_destroy()
{
  delete arm_head_unit;
  return 1;
}

int arm_head_get_resolutions(float* resolutions)
{
  arm_head_unit->getResolutions(resolutions);
  return 1;
}
