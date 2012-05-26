/*
 * dp_ptu_api_defs.h
 *
 *  Created on: Oct 18, 2010
 *      Author: mrinal
 */

/* WARNING: This file should only be included from a .cpp file and not
 * from a header file.
 */

#ifndef DP_PTU_API_DEFS_H_
#define DP_PTU_API_DEFS_H_

/* return status codes */
#define PTU_OK                                          0
#define PTU_ILLEGAL_COMMAND_ARGUMENT    1
#define PTU_ILLEGAL_COMMAND                         2
#define PTU_ILLEGAL_POSITION_ARGUMENT   3
#define PTU_ILLEGAL_SPEED_ARGUMENT              4
#define PTU_ACCEL_TABLE_EXCEEDED                5
#define PTU_DEFAULTS_EEPROM_FAULT               6
#define PTU_SAVED_DEFAULTS_CORRUPTED    7
#define PTU_LIMIT_HIT                           8
#define PTU_CABLE_DISCONNECTED                  9
#define PTU_ILLEGAL_UNIT_ID                     10
#define PTU_ILLEGAL_POWER_MODE                  11
#define PTU_RESET_FAILED                        12
#define PTU_NOT_RESPONDING                          13
#define PTU_FIRMWARE_VERSION_TOO_LOW    14

/********************* function call constants ***********************/

#define PAN                         1
#define TILT                2

#define POSITION                    1
#define SPEED                       2
#define ACCELERATION        3
#define BASE                        4
#define UPPER_SPEED_LIMIT       5
#define LOWER_SPEED_LIMIT       6
#define MINIMUM_POSITION        7
#define MAXIMUM_POSITION    8
#define HOLD_POWER_LEVEL        9
#define MOVE_POWER_LEVEL        10
#define RESOLUTION                  11
#define ISM_DRIFT           12

/* specifies changes relative to current position */
/* (Had to add conditional compilation since WIN32 already defines these values */
#ifndef RELATIVE
#define RELATIVE        1
#endif
#ifndef ABSOLUTE
#define ABSOLUTE        2
#endif


#define QUERY           NULL

/* power modes */
#define PTU_HI_POWER    1
#define PTU_REG_POWER   2
#define PTU_LOW_POWER   3
#define PTU_OFF_POWER   4

/* PTU mode types */
#define COMMAND_EXECUTION_MODE               1
#define ASCII_VERBOSE_MODE                   2
#define ASCII_ECHO_MODE                      3
#define POSITION_LIMITS_MODE                 4
#define DEFAULTS                             5
#define SPEED_CONTROL_MODE                   6 /* v1.9.7 and higher */

#define EXECUTE_IMMEDIATELY                  1  /* default */
#define EXECUTE_UPON_IMMEDIATE_OR_AWAIT      2

#define VERBOSE                         1  /* default */
#define TERSE                           0

#define ON_MODE                         1  /* default */
#define OFF_MODE                        0

#define SAVE_CURRENT_SETTINGS           0
#define RESTORE_SAVED_SETTINGS          1
#define RESTORE_FACTORY_SETTINGS        2

#define QUERY_MODE                      3

#define ALL             3

#endif /* DP_PTU_API_DEFS_H_ */
