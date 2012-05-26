/*
 * arm_pan_tilt_unit.h
 *
 *  Created on: Oct 14, 2010
 *      Author: kalakris
 */

#ifndef ARM_PAN_TILT_UNIT_H_
#define ARM_PAN_TILT_UNIT_H_

#include <arm_head_control/dp_pan_tilt_unit.h>

namespace arm_head_control
{

class ArmPanTiltUnit: public DPPanTiltUnit
{
public:
  ArmPanTiltUnit();
  virtual ~ArmPanTiltUnit();

  void setDeviceAndName(const char* device_file, const char* name);
  void setParameters(bool reset, long pan_acceleration, long tilt_acceleration,
                     long pan_max_speed, long tilt_max_speed,
                     unsigned char pan_hold_power_mode, unsigned char pan_move_power_mode,
                     unsigned char tilt_hold_power_mode, unsigned char tilt_move_power_mode,
                     bool position_control_mode);
  void setDesiredLimits(float pan_min, float pan_max, float tilt_min, float tilt_max);
  bool open();
  bool close();
  bool printErrorCode(char code);

  bool sendPositionsVelocitiesRadians(float pan_pos, float pan_vel, float tilt_pos, float tilt_vel);
  bool sendVelocitiesRadians(float pan_vel, float tilt_vel);
  bool getPositionsRadians(float& pan_pos, float& tilt_pos);

  bool waitForAsciiSuccess(int timeout_ms);
  bool sendAsciiCommand(const char* command);
  bool sendAsciiCommandAndWait(const char* command, int timeout_ms);

  void getResolutions(float& pan_resolution, float& tilt_resolution);

  std::string getName() const;

private:
  short int radiansToUnitsPan(float radians);
  float unitsToRadiansPan(int units);
  short int radiansToUnitsTilt(float radians);
  float unitsToRadiansTilt(int units);

  bool readDeviceInformation();
  bool setParametersOnDevice();
  void triggerJointLimits();
  bool resetParser();

  // these are read back from the device:
  float radians_per_step_pan_;
  float radians_per_step_tilt_;
  float desired_acceleration_pan_;
  float desired_acceleration_tilt_;
  float base_speed_pan_;
  float base_speed_tilt_;
  float max_speed_pan_;
  float max_speed_tilt_;
  float min_speed_pan_;
  float min_speed_tilt_;
  short int int_max_speed_pan_;
  short int int_max_speed_tilt_;
  short int int_min_speed_pan_;
  short int int_min_speed_tilt_;
  float min_position_pan_;
  float max_position_pan_;
  float min_position_tilt_;
  float max_position_tilt_;

  float min_desired_position_pan_;
  float max_desired_position_pan_;
  float min_desired_position_tilt_;
  float max_desired_position_tilt_;

  // these are for sending to the device:
  bool reset_;
  long pan_acceleration_;
  long tilt_acceleration_;
  long pan_max_speed_;
  long tilt_max_speed_;
  unsigned char pan_hold_power_mode_;
  unsigned char pan_move_power_mode_;
  unsigned char tilt_hold_power_mode_;
  unsigned char tilt_move_power_mode_;
  bool position_control_mode_;

  short int prev_commanded_pan_pos_;
  short int prev_commanded_tilt_pos_;
  unsigned short int prev_commanded_pan_vel_;
  unsigned short int prev_commanded_tilt_vel_;
  bool prev_command_valid_;

  std::string device_file_;
  std::string name_;

};

}

#endif /* ARM_PAN_TILT_UNIT_H_ */
