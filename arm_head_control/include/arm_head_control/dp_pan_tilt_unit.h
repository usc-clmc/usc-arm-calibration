/*
 * dp_pan_tilt_unit.h
 *
 *  Created on: Oct 11, 2010
 *      Author: mrinal
 */

#ifndef DP_PAN_TILT_UNIT_H_
#define DP_PAN_TILT_UNIT_H_

#include <string>

extern "C" {
#include <arm_head_control/opcodes.h>
#include <arm_head_control/linuxser.h>
}
namespace arm_head_control
{

/**
 * This class is simply a wrapper of the Directed Perception C API.
 * It is required because of the global static variables in the original
 * version, which prevent communicating with two devices in the same program.
 */
class DPPanTiltUnit
{
public:
  DPPanTiltUnit();
  virtual ~DPPanTiltUnit();

  /********************************************************************
   *****                                                          *****
   *****          For all of these commands, a non-zero return status *****
   *****          indicates an error, and it returns that error code. *****
   *****                                                                                                                  *****
   ********************************************************************/


  /* open_host_port(<portname>) ==> <portstream> */
  portstream_fd open_host_port(const char *);

  /* Set's the baud rate of the port prior to opening only */
  char set_baud_rate(int baudrate);

  /* close_host_port(<portstream>) ==> <status> */
  char close_host_port(portstream_fd);



  typedef short int PTU_PARM_PTR;

  /* reset_PTU_parser(<timeout_in_msec>) ==> [PTU_OK|PTU_NOT_RESPONDING] */
  char reset_PTU_parser(long);

  /* set_desired([PAN|TILT],
                                          [POSITION|SPEED|ACCELERATION|BASE|UPPER_SPEED_LIMIT|LOWER_SPEED_LIMIT],
                                          [<position>|<speed>|<acceleration>],
                                          [RELATIVE|ABSOLUTE]) ==> <status>
          set_desired([PAN|TILT],
                                          HOLD_POWER_LEVEL,
                                          <power mode>,
                                          NULL) ==> <status>
          set_desired([PAN|TILT],
                                          [HOLD_POWER_LEVEL,MOVE_POWER_LEVEL],
                                          [PTU_REG_POWER|PTU_LOW_POWER|PTU_OFF_POWER],
                                          ABSOLUTE) ==> <status>                              */
  char set_desired(char, char, PTU_PARM_PTR *, char);


  /* get_current([PAN|TILT],
                                          [POSITION|SPEED|ACCELERATION|BASE|UPPER_SPEED_LIMIT|LOWER_SPEED_LIMIT|
                                           HOLD_POWER_LEVEL|MOVE_POWER_LEVEL|RESOLUTION]) ==> <value> */
  long get_current(char, char);


  /* get_desired([PAN|TILT],
                                          [POSITION|SPEED|ACCELERATION|BASE|UPPER_SPEED_LIMIT|LOWER_SPEED_LIMIT|
                                           HOLD_POWER_LEVEL|MOVE_POWER_LEVEL|RESOLUTION]) ==> <value> */
  long get_desired(char, char);


  /* set_mode(COMMAND_EXECUTION_MODE,
                                  [EXECUTE_IMMEDIATELY|EXECUTE_UPON_IMMEDIATE_OR_AWAIT]) ==> <status>
     set_mode(ASCII_VERBOSE_MODE, [VERBOSE|TERSE|QUERY_MODE]) ==> <status>
     set_mode(ASCII_ECHO_MODE, [ON_MODE|OFF_MODE|QUERY_MODE]) ==> <status>
     set_mode(POSITION_LIMITS_MODE, [ON_MODE|OFF_MODE|QUERY_MODE]) ==> <status>
     set_mode(DEFAULTS,[SAVE_CURRENT_SETTINGS|RESTORE_SAVED_SETTINGS|
                   RESTORE_FACTORY_SETTINGS]) ==> <status> */
  char set_mode(char,char);


  /* halt([ALL|PAN|TILT]) ==> <status>    */
  char halt(char);


  /* await_completion() ==> <status> */
  char await_completion(void);


  /* reset_PTU() ==> <status> */
  char reset_ptu(void);
  char reset_ptu_pan(void);
  char reset_ptu_tilt(void);


  /* firmware_version() ==> <version ID string> */
  char* firmware_version(void);


  /*** multiple unit support ***/
  typedef unsigned short int UID_fd;

  /* in general, should not be used or required... */
  char select_host_port(portstream_fd);

  /* select_unit(<portstream>, <unit ID>) ==> <status> */
  char select_unit(UID_fd);

  char set_unit_id(UID_fd);   // This call should be made only
                                     // when one unit is on the current
                                     // host serial port

  /*** sets all pan-tilt dynamic motion parameters within a single command ***/
  char set_PTU_motion(short int, short int, unsigned short int, unsigned short int);
  char get_PTU_motion(short int *, short int *, unsigned short int *, unsigned short int *);


  /*** sample textual commands ***/
  char config_CHA(void);
  char talkto_CHA(void);
  char talkto_PTUcontroller(void);




  /*** asynchronous event status handling functions ***/

  typedef unsigned char (*event_handler_fn_ptr_type) (unsigned char);

//  unsigned char default_async_event_handler(unsigned char);
  /* Call this function to set the function handler for asynchronous events.
     Defaults to a null function. Example call:
               if ( set_async_event_handler( (unsigned char (*) (unsigned char)) default_async_event_handler ) )
                        printf("ASYNCH handler installed properly!");
                   else printf("ERROR: ASYNCH handler not installed properly!");
  */
  unsigned char set_async_event_handler( void (*) (unsigned char) );


  /* OEM support for TTL controls */
  unsigned char set_TTL_outputs(unsigned char);
  unsigned char get_TTL_values(void);

  /* advanced calls for doubling pan and tilt position query rates by overlapping comms */
  char set_desired_abs_positions(signed short int*, signed short int*);
  char get_current_positions(signed short int*, signed short int*);
  char set_desired_positions_velocities(short int* pan_pos, unsigned short int* pan_vel,
                                        short int* tilt_pos, unsigned short int* tilt_vel);

  /* OEM support for trigger controls */
  unsigned char TriggerOn(signed short int, signed short int, signed short int);
  unsigned char TriggerOff(void);
  signed short int TriggersPending(void);

  /* ISM controls */
  /* use only in pure velocity mode */
  /* <SET_DESIRED_VELOCITIES opcode><pvel signed 2B int><tvel signed 2B int><checksum: xor of int bytes> ==> <status byte> */
  unsigned char ptu_set_desired_velocities(signed short int, signed short int);
  unsigned char execute_set_desired_velocities(signed short int*, signed short int*);

  unsigned char set_desired_velocities_get_positions(signed short int pan_vel, signed short int tilt_vel,
                                                     short int* pan_pos, short int* tilt_pos);

  /* a way to set the pan tilt's positions while in ISM mode */
  /* this will command the ISM to slew to this pan tilt position and to begin stabilizing that angle */
  char set_ISM_desired_abs_positions(signed short int *Ppos, signed short int *Tpos);

  /* a way to get the pan and tilt's positions while in ISM mode */
  /* this will command the ISM to return the latest known positios of the pan-tilt head in pan tilt coordinates. */
  char get_ISM_desired_abs_positions(signed short int *Ppos, signed short int *Tpos);

  unsigned char GetSerialChar(char await_char);
  char SerialOut(unsigned char outchar);
  unsigned char SerialIn();
  char getSignedShortCheckAsync(signed short *val);

protected:
  unsigned char get_binary_command_return_status();
  char firmware_version_OK(void);
  char set_pure_velocities(signed short int *pan_speed, signed short int *tilt_speed);
  unsigned char checksum_on_2_2B(unsigned char *val1, unsigned char *val2);



  // these are what were previously static variables in the c file:
  char err;
  portstream_fd current_host_port;
  char speed_control_mode;
  unsigned char version_ID_string[256];
  char CHA_comm_active;
  event_handler_fn_ptr_type async_event_handler_fn_ptr;
};

}

#endif /* DP_PAN_TILT_UNIT_H_ */
