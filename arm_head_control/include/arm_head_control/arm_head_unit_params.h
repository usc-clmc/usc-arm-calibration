/*
 * arm_head_unit_params.h
 *
 *  Created on: Oct 15, 2010
 *      Author: kalakris
 */

#ifndef ARM_HEAD_UNIT_PARAMS_H_

#include <arm_head_control/dp_ptu_api_defs.h>


namespace arm_head_control
{
// settings for ARM computer mandy
  static const char* LOWER_PTU_DEVICE = "/dev/ttyUSB_LowerPanTilt";
  static const char* UPPER_PTU_DEVICE = "/dev/ttyUSB_UpperPanTilt";

// settings for Mrinal's laptop
//  static const char* LOWER_PTU_DEVICE = "/dev/ttyUSB2";
//  static const char* UPPER_PTU_DEVICE = "/dev/ttyUSB5";

//  static const long LOWER_PAN_ACCELERATION = 2000;
//  static const long LOWER_TILT_ACCELERATION = 2000;
//  static const long UPPER_PAN_ACCELERATION = 2681;
//  static const long UPPER_TILT_ACCELERATION = 2681;

  // max speed settings
//  static const long LOWER_PAN_ACCELERATION = 200000;
//  static const long LOWER_TILT_ACCELERATION = 200000;
//  static const long UPPER_PAN_ACCELERATION = 268112;
//  static const long UPPER_TILT_ACCELERATION = 268112;
//
//  static const long LOWER_PAN_MAX_SPEED = 32623;
//  static const long LOWER_TILT_MAX_SPEED = 32623;
//  static const long UPPER_PAN_MAX_SPEED = 32623;
//  static const long UPPER_TILT_MAX_SPEED = 32623;
// end max speed settings

  // slower settings
//  static const long LOWER_PAN_ACCELERATION = 8000;
//  static const long LOWER_TILT_ACCELERATION = 8000;
//  static const long UPPER_PAN_ACCELERATION = 8000;
//  static const long UPPER_TILT_ACCELERATION = 8000;
//  static const long LOWER_PAN_MAX_SPEED = 16008;
//  static const long LOWER_TILT_MAX_SPEED = 16008;
//  static const long UPPER_PAN_MAX_SPEED = 16008;
//  static const long UPPER_TILT_MAX_SPEED = 16008;

  // tweaked settings
  static const long LOWER_PAN_ACCELERATION = 8100;
  static const long LOWER_TILT_ACCELERATION = 8000;
  static const long UPPER_PAN_ACCELERATION = 50000;
  static const long UPPER_TILT_ACCELERATION = 50000;
  static const long LOWER_PAN_MAX_SPEED = 4002;
  static const long LOWER_TILT_MAX_SPEED = 4002;
  static const long UPPER_PAN_MAX_SPEED = 12000;
  static const long UPPER_TILT_MAX_SPEED = 12000;


  static const unsigned char LOWER_PAN_HOLD_POWER_MODE = PTU_LOW_POWER;
  static const unsigned char LOWER_TILT_HOLD_POWER_MODE = PTU_LOW_POWER;
  static const unsigned char LOWER_PAN_MOVE_POWER_MODE = PTU_REG_POWER;
  static const unsigned char LOWER_TILT_MOVE_POWER_MODE = PTU_HI_POWER;

  static const unsigned char UPPER_PAN_HOLD_POWER_MODE = PTU_LOW_POWER;
  static const unsigned char UPPER_TILT_HOLD_POWER_MODE = PTU_LOW_POWER;
  static const unsigned char UPPER_PAN_MOVE_POWER_MODE = PTU_REG_POWER;
  static const unsigned char UPPER_TILT_MOVE_POWER_MODE = PTU_REG_POWER;

  static const double LOWER_PAN_MIN_ANGLE = -2.90;
  static const double LOWER_PAN_MAX_ANGLE = 2.90;
  static const double LOWER_TILT_MIN_ANGLE = -1.22;
  static const double LOWER_TILT_MAX_ANGLE = 1.22;

  static const double UPPER_PAN_MIN_ANGLE = -1.55;
  static const double UPPER_PAN_MAX_ANGLE = 1.55;
  static const double UPPER_TILT_MIN_ANGLE = -1.30;
  static const double UPPER_TILT_MAX_ANGLE = 0.0;

// old values for phase 1 head
//  static const double UPPER_PAN_MIN_ANGLE = -2.75;
//  static const double UPPER_PAN_MAX_ANGLE = 2.75;
//  static const double UPPER_TILT_MIN_ANGLE = -1.30;
//  static const double UPPER_TILT_MAX_ANGLE = 0.52;
}


#endif /* ARM_HEAD_UNIT_PARAMS_H_ */
