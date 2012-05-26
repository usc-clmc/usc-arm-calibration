/*************************************************************************
*****                    Pan-Tilt Tracking Mount                     *****
*****                LINUX C PROGRAMMER'S INTERFACE                  *****
*****                                                                *****
*****               (C)1999, Directed Perception, Inc.               *****
*****                     All Rights Reserved.                       *****
*************************************************************************/



OVERVIEW
========

The LINUX subdirectory contains Source and compiled code for the Directed 
Perception PTU C Programmer's Interface (CPI). This CPI requires PTU 
firmware versions of V1.07.07b and greater. This LINUX interface was 
developed and tested under RedHat LINUX v5.2 using an x386 computer. 


CONFIGURING AND VERIFYING PROPER OPERATION OF YOUR LINUX SERIAL PORTS
=====================================================================

Before attempting to compile and execute the CPI test code, you should
verify that your serial ports are functioning properly. Under LINUX, the
setserial command can be used to configure your serial ports. One way to
use this configuration command is to ensure that your rc.local contains
a setserial command for each serial port in the command form of:
   setserial /dev/ttyS1 auto_irq skip_test autoconfig
This command is restricted to use by the system administrator (i.e., root).
You can check the settings for a particular serial port by entering
the root account command:
   setserial /dev/ttyS1
Under UNIX, the /dev/ttyS0-3 devices directly correspond to the COM1-4
ports under windows.

   To verify your serial port is functioning properly, we recommend that
you connect the pan-tilt to your LINUX machine's serial port (leave the
pan-tilt power off). Then run kermit with the following commands:
   SET LINE /dev/cua3
   SET SPEED 9600
   SET HANDSHAKE none
   SET FLOW-CONTROL none
   SET PARITY none
   CONNECT
where /dev/cua3 should be replaced with another port device if needed.
Now turn on the pan-tilt, and you should see the pan-tilt feedback
text. If not, then check connections and proper serial port configuration. 
When prompted by the PTU in kermit, enter the string "   pp300 " and
verify that the pan-tilt moves. If so, you have verified the proper
function of your serial port device. If not, you need to check cabling
and the device use and configuration.
   Please note that the process running the PTU CPI test program must
have privilege to access the serial device. The error message 
"Permission Denied" indicates this type of privilege problem.
   More information on serial ports under LINUX may be found at 
http://www.linuxdoc.org/HOWTO/Serial-HOWTO.html. 

BUILDING THE CPI TEST PROGRAM
=============================

A makefile is provided to build the LINUX version of the PTU CPI.
This makefile was developed and tested under RedHat LINUX v5.2.
More information the LINUX serial port settings may be found at
http://www.linuxdoc.org/HOWTO/Serial-Programming-HOWTO.html


QUESTIONS OR BUGS?
==================

If you:
   * have any questions
   * find any bugs
   * have suggestions for improvements or extensions
   * want to share your serial interface code for a machine or
     compiler not currently supported please contact technical support at:

   Directed Perception, Inc.
   1485 Rollins Road, Burlingame, CA   94010
   (650) 342-9399, FAX: (650) 342-9199
   Internet: tech@DPerception.com
   URL:      http://www.DPerception.com/
