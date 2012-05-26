/*
 * arm_pan_tilt_unit.cpp
 *
 *  Created on: Oct 14, 2010
 *      Author: kalakris
 */

#include <cstring>
#include <cstdio>
#include <cmath>
#include <arm_head_control/arm_pan_tilt_unit.h>
#include <arm_head_control/dp_ptu_api_defs.h>
#include <sys/time.h>
#include <unistd.h>

namespace arm_head_control
{

ArmPanTiltUnit::ArmPanTiltUnit()
{
}

ArmPanTiltUnit::~ArmPanTiltUnit()
{
}

void ArmPanTiltUnit::setDeviceAndName(const char* device_file, const char* name)
{
  device_file_ = device_file;
  name_ = name;
}

bool ArmPanTiltUnit::open()
{

  bool successfully_initialized=false;
  int num_tries = 0;

  while (!successfully_initialized)
  {
    open_host_port(device_file_.c_str());
    if (current_host_port == PORT_NOT_OPENED)
    {
      printf("%s: Serial port %s could not be setup.\n", name_.c_str(), device_file_.c_str());
      return false;
    }
    printf("%s: Serial port %s opened.\n", name_.c_str(), device_file_.c_str());

    //Just in case there is an ISM on the line, talk directly to PTU.
    usleep(100000);
    FlushIOBuffer(current_host_port);
    if (sendAsciiCommandAndWait("                                         _0 u0 ee ft ", 5000))
    {
      successfully_initialized = true;
    }
    else
    {
      num_tries++;
      close_host_port(current_host_port);
      if (num_tries == 5)
      {
        printf("%s: Failed to initialize after %d attempts\n", name_.c_str(), num_tries);
        return FALSE;
      }
    }
  }

  if (reset_)
  {
  // set the stepping mode using ASCII commands
    usleep(100000);
    FlushIOBuffer(current_host_port);
    if (sendAsciiCommandAndWait(" WTA ",60000))
      printf("%s: Successfully set tilt axis to micro-stepping mode\n", name_.c_str());
    else
      return false;

    usleep(100000);
    FlushIOBuffer(current_host_port);
    if (sendAsciiCommandAndWait(" WPA ",60000))
      printf("%s: Successfully set pan axis to micro-stepping mode\n", name_.c_str());
    else
      return false;
  }

  // begin exercising the PTU command set
  if (!resetParser())
    return false;

  // set all device parameters:
  if (!setParametersOnDevice())
  {
    printf("%s: Failed to set device parameters\n", name_.c_str());
  }

  printf("%s: Successfully set device parameters\n", name_.c_str());

  if (reset_)
  {
    // reset the pan tilt unit to determine resolutions correctly
    reset_ptu();
    printf("%s: Successfully reset PTU\n", name_.c_str());
  }

  if (!readDeviceInformation())
  {
    return false;
  }

  if (position_control_mode_)
  {
    set_mode(POSITION_LIMITS_MODE, OFF_MODE);
    set_mode(SPEED_CONTROL_MODE, PTU_INDEPENDENT_SPEED_CONTROL_MODE);
    printf("%s: Set to position control mode\n", name_.c_str());
    printf("%s: Zeroing...\n", name_.c_str());
    sendPositionsVelocitiesRadians(0.0, max_speed_pan_, 0.0, max_speed_tilt_);
    await_completion();

    struct timeval start_time, end_time;
    gettimeofday(&start_time, NULL);
    triggerJointLimits();
    gettimeofday(&end_time, NULL);
    useconds_t delay = (end_time.tv_sec - start_time.tv_sec)*1000000 + (end_time.tv_usec - start_time.tv_usec);

    printf("%s: Zeroing...\n", name_.c_str());
    sendPositionsVelocitiesRadians(0.0, max_speed_pan_, 0.0, max_speed_tilt_);
    usleep(delay);
    //await_completion();
    printf("%s: Done.\n", name_.c_str());
  }
  else
  {
    set_mode(SPEED_CONTROL_MODE, PTU_PURE_VELOCITY_SPEED_CONTROL_MODE);
    printf("%s: Set to pure velocity speed control mode\n", name_.c_str());
  }

  prev_command_valid_ = false;
  return true;

}

bool ArmPanTiltUnit::resetParser()
{
  usleep(100000);
  FlushIOBuffer(current_host_port);
  switch (reset_PTU_parser(5000))
  {
    case PTU_OK:
      printf("%s: Successfully reset PTU parser for binary mode\n", name_.c_str());
      return true;
    case PTU_FIRMWARE_VERSION_TOO_LOW:
      printf("\nError(reset_PTU_parser): PTU FIRMWARE VERSION MATCH ERROR\n");
      return false;
    case PTU_NOT_RESPONDING:
      printf("\nError(reset_PTU_parser): PTU_NOT_RESPONDING\n");
      return false;
  }
  return true;
}

void ArmPanTiltUnit::setParameters(bool reset, long pan_acceleration, long tilt_acceleration,
                   long pan_max_speed, long tilt_max_speed,
                   unsigned char pan_hold_power_mode, unsigned char pan_move_power_mode,
                   unsigned char tilt_hold_power_mode, unsigned char tilt_move_power_mode,
                   bool position_control_mode)
{
  reset_ = reset;
  pan_acceleration_ = pan_acceleration;
  tilt_acceleration_ = tilt_acceleration;
  pan_max_speed_ = pan_max_speed;
  tilt_max_speed_ = tilt_max_speed;
  pan_hold_power_mode_ = pan_hold_power_mode;
  pan_move_power_mode_ = pan_move_power_mode;
  tilt_hold_power_mode_ = tilt_hold_power_mode;
  tilt_move_power_mode_ = tilt_move_power_mode;
  position_control_mode_ = position_control_mode;

}

void ArmPanTiltUnit::setDesiredLimits(float pan_min, float pan_max, float tilt_min, float tilt_max)
{
  min_desired_position_pan_ = pan_min;
  max_desired_position_pan_ = pan_max;
  min_desired_position_tilt_ = tilt_min;
  max_desired_position_tilt_ = tilt_max;
}

bool ArmPanTiltUnit::setParametersOnDevice()
{
  set_desired(PAN, ACCELERATION, (short int*)&pan_acceleration_, ABSOLUTE);
  set_desired(TILT, ACCELERATION, (short int*)&tilt_acceleration_, ABSOLUTE);
  set_desired(PAN, UPPER_SPEED_LIMIT, (short int*)&pan_max_speed_, ABSOLUTE);
  set_desired(TILT, UPPER_SPEED_LIMIT, (short int*)&tilt_max_speed_, ABSOLUTE);
  set_desired(PAN, HOLD_POWER_LEVEL, (short int*)&pan_hold_power_mode_, ABSOLUTE);
  set_desired(PAN, MOVE_POWER_LEVEL, (short int*)&pan_move_power_mode_, ABSOLUTE);
  set_desired(TILT, HOLD_POWER_LEVEL, (short int*)&tilt_hold_power_mode_, ABSOLUTE);
  set_desired(TILT, MOVE_POWER_LEVEL, (short int*)&tilt_move_power_mode_, ABSOLUTE);
  return true;
}

bool ArmPanTiltUnit::readDeviceInformation()
{
  // get resolutions:
  float one_by_sixty_arc_second = (1.0/60.0) * (1.0/3600) * (M_PI/180.0);
  radians_per_step_pan_ = get_desired(PAN,RESOLUTION) * one_by_sixty_arc_second;
  radians_per_step_tilt_ = get_desired(TILT,RESOLUTION) * one_by_sixty_arc_second;

  printf("%s: Retrieved resolutions: %f, %f\n", name_.c_str(),
         radians_per_step_pan_, radians_per_step_tilt_);

  desired_acceleration_pan_ = unitsToRadiansPan(get_desired(PAN,ACCELERATION));
  desired_acceleration_tilt_ = unitsToRadiansTilt(get_desired(TILT,ACCELERATION));
  base_speed_pan_ = unitsToRadiansPan(get_desired(PAN,BASE));
  base_speed_tilt_ = unitsToRadiansTilt(get_desired(TILT,BASE));
  int_min_speed_pan_ = get_desired(PAN,LOWER_SPEED_LIMIT);
  int_min_speed_tilt_ = get_desired(TILT,LOWER_SPEED_LIMIT);
  int_max_speed_pan_ = get_desired(PAN,UPPER_SPEED_LIMIT);
  int_max_speed_tilt_ = get_desired(TILT,UPPER_SPEED_LIMIT);
  min_speed_pan_ = unitsToRadiansPan(int_min_speed_pan_);
  min_speed_tilt_ = unitsToRadiansTilt(int_min_speed_tilt_);
  max_speed_pan_ = unitsToRadiansPan(int_max_speed_pan_);
  max_speed_tilt_ = unitsToRadiansTilt(int_max_speed_tilt_);

  printf("%s: Int Pan speed limit %d to %d\n", name_.c_str(),
         int_min_speed_pan_, int_max_speed_pan_);
  printf("%s: Int Tilt speed limit %d to %d\n", name_.c_str(),
         int_min_speed_tilt_, int_max_speed_tilt_);
  printf("%s: Pan speed limit %f to %f, base speed = %f, desired acc = %f\n", name_.c_str(),
         min_speed_pan_, max_speed_pan_, base_speed_pan_, desired_acceleration_pan_);
  printf("%s: Tilt speed limit %f to %f, base speed = %f, desired acc = %f\n", name_.c_str(),
         min_speed_tilt_, max_speed_tilt_, base_speed_tilt_, desired_acceleration_tilt_);

  min_position_pan_ = unitsToRadiansPan(get_desired(PAN,MINIMUM_POSITION));
  max_position_pan_ = unitsToRadiansPan(get_desired(PAN,MAXIMUM_POSITION));
  min_position_tilt_ = unitsToRadiansTilt(get_desired(TILT,MINIMUM_POSITION));
  max_position_tilt_ = unitsToRadiansTilt(get_desired(TILT,MAXIMUM_POSITION));

  printf("%s: Pan position limits %f to %f\n", name_.c_str(),
         min_position_pan_, max_position_pan_);
  printf("%s: Tilt position limits %f to %f\n", name_.c_str(),
         min_position_tilt_, max_position_tilt_);

  return true;
}

void ArmPanTiltUnit::triggerJointLimits()
{
  bool reset_parser = false;
  float desired_pan_position = 0.0;
  float desired_tilt_position = 0.0;
  if (min_position_pan_ > min_desired_position_pan_ ||
      max_position_pan_ < max_desired_position_pan_)
  {
    printf("%s: Pan overrides limits\n", name_.c_str());
    reset_parser = true;
    if (max_position_pan_ < max_desired_position_pan_)
      desired_pan_position = max_desired_position_pan_;
    else
      desired_pan_position = min_desired_position_pan_;
  }
  if (min_position_tilt_ > min_desired_position_tilt_ ||
      max_position_tilt_ < max_desired_position_tilt_)
  {
    printf("%s: Tilt overrides limits\n", name_.c_str());
    reset_parser = true;
    if (max_position_tilt_ < max_desired_position_tilt_)
      desired_tilt_position = max_desired_position_tilt_;
    else
      desired_tilt_position = min_desired_position_tilt_;
  }

  if (reset_parser)
  {
    printf("%s: Triggering joint limits...\n", name_.c_str());
    sendPositionsVelocitiesRadians(desired_pan_position, max_speed_pan_, desired_tilt_position, max_speed_tilt_);
    printf("%s: Awaiting completion...\n", name_.c_str());
    await_completion();
    //printf("%s: Resetting parser...\n", name_.c_str());
    //resetParser();
  }

}

short int ArmPanTiltUnit::radiansToUnitsPan(float radians)
{
  return lrint(radians / radians_per_step_pan_);
}

float ArmPanTiltUnit::unitsToRadiansPan(int units)
{
  return radians_per_step_pan_ * units;
}

short int ArmPanTiltUnit::radiansToUnitsTilt(float radians)
{
  return lrint(radians / radians_per_step_tilt_);
}

float ArmPanTiltUnit::unitsToRadiansTilt(int units)
{
  return radians_per_step_tilt_ * units;
}

bool ArmPanTiltUnit::close()
{
  char ret = close_host_port(current_host_port);
  return printErrorCode(ret);
}

bool ArmPanTiltUnit::printErrorCode(char code)
{
  if (code == 0)
    return true;

  printf("Error code = %d\n", code);
  return false;
}

bool ArmPanTiltUnit::waitForAsciiSuccess(int timeout_ms)
{
  unsigned char buffer[1000];
  int chars;
  char ret = ReadSerialLine(current_host_port, buffer, timeout_ms, &chars);
  if (ret==0)
    return false;
  if (std::strchr((char*)buffer, int('*'))!=NULL)
  {
    return true;
  }
  else
    return false;
}

bool ArmPanTiltUnit::sendAsciiCommand(const char* command)
{
  SerialStringOut(current_host_port, (unsigned char*)command);
  return true;
}

bool ArmPanTiltUnit::sendAsciiCommandAndWait(const char* command, int timeout_ms)
{
  sendAsciiCommand(command);
  return waitForAsciiSuccess(timeout_ms);
}

template<typename T>
void clipValue(T& value, T max)
{
  if (value > max)
  {
    value = max;
  }
  if (value < -max)
  {
    value = -max;
  }
}

bool ArmPanTiltUnit::sendPositionsVelocitiesRadians(float pan_pos, float pan_vel, float tilt_pos, float tilt_vel)
{
  unsigned short int pan_vel_units, tilt_vel_units;
  short int pan_pos_units, tilt_pos_units;
  pan_pos_units = radiansToUnitsPan(pan_pos);
  tilt_pos_units = radiansToUnitsTilt(tilt_pos);
  pan_vel_units = radiansToUnitsPan(fabs(pan_vel));
  tilt_vel_units = radiansToUnitsTilt(fabs(tilt_vel));

  if (pan_vel_units > int_max_speed_pan_)
	  pan_vel_units = int_max_speed_pan_;
  if (tilt_vel_units > int_max_speed_tilt_)
	  tilt_vel_units = int_max_speed_tilt_;

  if (!prev_command_valid_ ||
      prev_commanded_pan_pos_ != pan_pos_units ||
      prev_commanded_tilt_pos_ != tilt_pos_units ||
      prev_commanded_pan_vel_ != pan_vel_units ||
      prev_commanded_tilt_vel_ != tilt_vel_units)
  {
    //char ret = set_PTU_motion(pan_pos_units, tilt_pos_units, pan_vel_units, tilt_vel_units);
    //set_desired_positions_velocities(&pan_pos_units, &pan_vel_units, &tilt_pos_units, &tilt_vel_units);
    set_desired(PAN, POSITION, &pan_pos_units, ABSOLUTE);
    set_desired(PAN, SPEED, (short int*)&pan_vel_units, ABSOLUTE);
    set_desired(TILT, POSITION, &tilt_pos_units, ABSOLUTE);
    set_desired(TILT, SPEED, (short int*)&tilt_vel_units, ABSOLUTE);
    prev_command_valid_ = true;
    prev_commanded_pan_pos_ = pan_pos_units;
    prev_commanded_tilt_pos_ = tilt_pos_units;
    prev_commanded_pan_vel_ = pan_vel_units;
    prev_commanded_tilt_vel_ = tilt_vel_units;
  }

  return true;
  //return printErrorCode(ret);
}

bool ArmPanTiltUnit::sendVelocitiesRadians(float pan_vel, float tilt_vel)
{
  short int pan_vel_units, tilt_vel_units;
  pan_vel_units = radiansToUnitsPan(pan_vel);
  tilt_vel_units = radiansToUnitsTilt(tilt_vel);

  clipValue(pan_vel_units, int_max_speed_pan_);
  clipValue(tilt_vel_units, int_max_speed_tilt_);
//  printf("%s: Sending int velocities %d, %d\n", name_.c_str(), pan_vel_units, tilt_vel_units);
  char ret = execute_set_desired_velocities(&pan_vel_units, &tilt_vel_units);
  return printErrorCode(ret);
}

bool ArmPanTiltUnit::getPositionsRadians(float& pan_pos, float& tilt_pos)
{
  short int pan_pos_units, tilt_pos_units;

//  pan_pos = unitsToRadiansPan(get_current(PAN, POSITION));
//  tilt_pos = unitsToRadiansTilt(get_current(TILT, POSITION));
//  return true;

  char ret = get_current_positions(&pan_pos_units, &tilt_pos_units);
  if (ret)
  {
    pan_pos = unitsToRadiansPan(pan_pos_units);
    tilt_pos = unitsToRadiansTilt(tilt_pos_units);
    return true;
  }
  else
  {
    return false;
  }
}

void ArmPanTiltUnit::getResolutions(float& pan_resolution, float& tilt_resolution)
{
  pan_resolution  = radians_per_step_pan_;
  tilt_resolution = radians_per_step_tilt_;
}

std::string ArmPanTiltUnit::getName() const
{
  return name_;
}

}
