/*************************************************************************
*****     MACHINE-DEPENDENT SERIAL SUPPORT INCLUDE FILE SERIAL.H     ****/
#define SERIAL_CODE_VERSION   "Win16 v1.08.04"
/****                                                                *****
*****          (C)1995..1999, Directed Perception, Inc.               *****
*****                     All Rights Reserved.                       *****
*****                                                                *****
*****   Licensed users may freely distribute compiled code including *****
*****   this code and data. Source data and code may NOT be          *****
*****   distributed without the prior written consent from           *****
*****   Directed Perception, Inc.                                    *****
*****	      Directed Perception, Inc. reserves the right to make   *****
*****   changes without further notice to any content herein to      *****
*****   improve reliability, function or design. Directed Perception *****
*****   shall not assume any liability arising from the application  *****
*****   or use of this code, data or function.                       *****
*****                                                                *****
**************************************************************************

CHANGE HISTORY:
    11/11/99: v1.08.04   Fixed improper printf of nonexistent error status in OpenSerial. 
     8/10/98: v1.08.03.  ReadSerialLine initialized charsRead to 0 for 
				 	     compilers that do not do this automatically.
     7/15/98: v1.08.02   Fixed SerialBytesOut to return TRUE/FALSE for DOS/Win16
     1/25/96: v1.07.08d. Fixed strmp in openserial routine
	 1/ 7/95: v1.07.05d. Changed for Windows Borland C/C++.
	10/12/94: v1.07.03d. Pre-release working DOS Borland C/C++ version.
					     XON/XOFF removed from PTU firmware to allow for binary mode.


**************************************************************************/

#include <windows.h>                          
#include <ctype.h>                          
                          
                          
typedef int portstream_fd;        
#define PORT_NOT_OPENED			0

/* function definition that need are machine/compiler dependent */
extern portstream_fd	openserial(char *);
extern char   closeserial(portstream_fd);

extern char   SerialBytesOut(portstream_fd, unsigned char *, int);

#define AWAIT_CHARSTREAM		-1
#define TIMEOUT_CHAR_READ		-1
extern char   SerialBytesIn (portstream_fd, unsigned char *, unsigned int, long);

extern char   PeekByte(portstream_fd, unsigned char *);
extern char   FlushInputBuffer(portstream_fd);
extern char   do_delay(long); /* in milliseconds */

extern char   SerialStringOut(portstream_fd, unsigned char*); /* Output a string to the serial port */
extern char   ReadSerialLine(portstream_fd, unsigned char*, long, int*);

extern char   GetSignedShort(portstream_fd, signed short*, long); 	 // 2 byte signed short int
extern char   PutSignedShort(portstream_fd, signed short*);
extern char   GetUnsignedShort(portstream_fd, unsigned short*, long); // 2 byte unsigned short int
extern char   PutUnsignedShort(portstream_fd, unsigned short*);
extern char   GetSignedLong(portstream_fd, signed long*, long);		 // 4 byte signed long
extern char   PutSignedLong(portstream_fd, signed long*);

