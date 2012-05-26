/*************************************************************************
*****                    Pan-Tilt Tracking Mount                     *****
*****                    C PROGRAMMER'S INTERFACE                    *****
*****                        version 1.09.15                         *****
*****                                                                *****
*****               (C)2010, FLIR Motion Control Systems, Inc.       *****
*****                     All Rights Reserved.                       *****
*****                                                                *****
*****   Licensed users may freely distribute COMPILED code using     *****
*****   this code and data. Distribution of this source data or code *****
*****   without prior written consent from Directed Perception, Inc. *****
*****   is a violation of U.S. and international copyright laws.     *****
*****	      Directed Perception, Inc. reserves the right to make   *****
*****   changes without further notice to any content herein to      *****
*****   improve reliability, function or design. Directed Perception *****
*****   shall not assume any liability arising from the application  *****
*****   or use of this code, data or function.                       *****
*****                                                                *****
**************************************************************************


OVERVIEW
========

This diskette contains Source and compiled code for the Directed Perception 
PTU C Programmer's Interface (CPI). This CPI requires PTU firmware versions
of V1.07.07b and greater. A few advanced functions (as noted in OPCODES.H)
require firmware V1.09.07 or greater.

CONTENTS
========

This PTU-CPI diskette contains the following sections:

   C CODE subdirectory containing:
      PTU.C      : The PTU interface C language source code
      W32seria.C : Example Windows 32 bit serial port interface 
                   (Win 95, Win NT, Win3.X with Win32)
      W16seria.C : Example Windows 16 bit serial port interface
                   (Windows 3.X)
      DOSseria.C : Example DOS 16 bit Serial port interface 
      LINUXser.C : Example LINUX serial port interface
      TEST.C     : Source code for a binary PTU interface test driver
      NETTEST.C  : Source code for networked PTU test driver

   C INCLUDE subdirectory containing:
      OPCODES.H  : PTU binary opcodes required to use the PTU interface
                   defined by PTU.C
      PTU.H      : Required to use the PTU interface defined by PTU.C
      W32seria.H : Required to use the Windows 32 bit serial port interface
                   defined by W32seria.C
      W16seria.H : Required to use the Windows 16 bit serial port interface
                   defined by W16seria.C
      DOSseria.H : Required to use the DOS 16 bit serial port interface
                   defined by DOSseria.C
      LINUXser.H : Required to use the LINUX serial port interface
                   defined by LINUXser.C

   Subdirectories containing projects (makefiles) to compile the example
   binary PTU interface test driver:
      WIN32 : Contains Microsoft Visual C++ Version 4.0 project for
              32 bit Windows 95/NT/3.X-Win32 PTU binary test program
      WIN16 : Contains Microsoft Visual C++ Version 1.52 project for
              16 bit Windows 3.X PTU binary test program
      DOS   : Contains Microsoft Visual C++ Version 1.52 project for
              16 bit DOS PTU binary test program 
      LINUX : Contains LINUX GNU makefile to compile an executable
              LINUX PTU binary test program


HOW TO PROCEED
==============

The PTU commands and syntax are defined in PTU.H .  Take a look at
this file first to get up to speed on the available commands. Also,
refer to the PTU User's Manual to familiarize yourself with the PTU,
its control, and its commands.

If you're using MSVC on a PC, check out the Win32, Win16 or DOS
subdirectories and the file CODE\TEST.C for examples. Just open the 
projects, compile the project, and execute the PTU binary test program.

If you're using GNU on a LINUX machine, check out the Linux subdirectory
and the readme file in that directory. We strongly recommend you verify
proper function of your serial ports before compiling and executing 
the test program. The readme describes how to verify and configure your 
LINUX serial ports under RedHat Linux.

For other compilers, you'll need to define a new makefile to recompile 
the code. If your target operating system is other than Windows/DOS/LINUX,
you'll need to tie in your existing code for performing RS-232 serial 
port I/O. To do this, take a look at *SERIA.C.  You will need to modify
these routines to suit your particular serial interface, then run the 
TEST.C program to verify that the C interface code is performing 
correctly using your serial code. 

IMPORTANT: Refrain from using binary opcodes directly as defined in 
OPCODES.H . Directed Perception reserves the right to modify these 
codes as required to improve the product, so your direct use of these 
opcodes could lead to upgrade problems inherent in your code. 
As a result, Directed Perception explicitly supports the opcodes at
the function level specified by the interface defined in PTU.H . 


QUESTIONS OR BUGS?
==================

If you:
   * have any questions
   * find any bugs
   * have suggestions for improvements or extensions
   * want to share your serial interface code for a machine or
     compiler not currently supported please contact technical support at:

     FLIR Motion Control Systems 890C Cowan Rd Burlingame, CA 94010
     (650) 692-3900, FAX: (650) 692-3930
     email:   support@dperception.com
     website: http://www.flir.com/mcs

