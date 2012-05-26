/*************************************************************************
*****     MACHINE-DEPENDENT SERIAL SUPPORT INCLUDE FILE (LINUX)      ****/
/****                                                                *****
*****              (C)2008, Directed Perception, Inc.                *****
*****                     All Rights Reserved.                       *****
*****                                                                *****
*****   Licensed users may freely distribute compiled code including *****
*****   this code and data. Source data and code may NOT be          *****
*****   distributed without the prior written consent from           *****
*****   Directed Perception, Inc.                                    *****
*****	      Directed Perception, Inc. reserves the right to make     *****
*****   changes without further notice to any content herein to      *****
*****   improve reliability, function or design. Directed Perception *****
*****   shall not assume any liability arising from the application  *****
*****   or use of this code, data or function.                       *****
*****                                                                *****
**************************************************************************/

#ifndef LINUXSER_H
#define LINUXSER_H

#define SERIAL_CODE_VERSION   "LINUX v2.0"

typedef int portstream_fd;
#define PORT_NOT_OPENED	-1

#undef TRUE
#undef FALSE
#define TRUE 	1
#define FALSE	0

// function definitions that need are machine dependent
extern portstream_fd openserial(const char *portname);
extern char   setbaudrate(int baudrate);
extern char   closeserial(portstream_fd);

extern char   SerialBytesOut(portstream_fd, unsigned char *, int);

#define AWAIT_CHARSTREAM		-1
#define TIMEOUT_CHAR_READ		-1
extern char   SerialBytesIn (portstream_fd, unsigned char *, unsigned int, long);

extern char   PeekByte(portstream_fd, unsigned char *);
extern char   FlushInputBuffer(portstream_fd);
extern char   FlushOutputBuffer(portstream_fd);
extern char   FlushIOBuffer(portstream_fd);
extern void   do_delay(long); /* in milliseconds */

extern char   SerialStringOut(portstream_fd, unsigned char*); /* Output a string to the serial port */
extern char   ReadSerialLine(portstream_fd, unsigned char*, long, int*);

extern char   GetSignedShort(portstream_fd, signed short*, long);     // 2 byte signed short int
extern char   PutSignedShort(portstream_fd, signed short*);
extern char   GetUnsignedShort(portstream_fd, unsigned short*, long); // 2 byte unsigned short int
extern char   PutUnsignedShort(portstream_fd, unsigned short*);
extern char   GetSignedLong(portstream_fd, signed long*, long);	      // 4 byte signed long
extern char   PutSignedLong(portstream_fd, signed long*);

#endif /* LINUXSER_H */

