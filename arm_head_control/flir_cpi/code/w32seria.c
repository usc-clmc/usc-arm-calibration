/*************************************************************************
*****    MACHINE-DEPENDENT SERIAL SUPPORT INCLUDE FILE WSERIAL.C     *****
*****                    (Windows 95/NT/3.1win32)                    *****
*****                                                                *****
*****               (C)1997..9, Directed Perception, Inc.            *****
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
   3/15/00:            SerialBytesIn return when charCnt==0 regardless of timeout.
   7/28/99: v1.08.11.  SerialBytesIn timeout now in elapsed seconds.
   8/10/98: v1.08.10.  ReadSerialLine initialized charsRead to 0 for 
					   compilers that do not do this automatically.
   1/ 7/98: v1.08.09.  Additional error processing added to SerialBytesIn
						and ReadSerialLine.
   9/27/97: v1.08.08.  Win32. Removed writestring in openserial.
		               Set 0 read timeout in setserial. Peek works
					   better.
  11/17/96: v1.08.05d. Updated for 32-bit architecture
  1/25/96:  v1.07.08d. Fixed strmp in openserial routine
  1/7/95:   v1.07.05d. Changed for Windows Borland C/C++.
  10/12/94: v1.07.03d. Pre-release working DOS Borland C/C++ version.
		       XON/XOFF removed from PTU firmware to allow for
		       binary mode. 

**************************************************************************/

#include <windows.h>
#include "..\INCLUDE\W32SERIA.H"

//#include <commdlg.h>
#include <stdio.h>
//#include <stdlib.h>
//#include <errno.h>
//#include <string.h>
//#include <assert.h>
#include <time.h>
#include <mmsystem.h>


//***************************************************************
//*****                LOCAL STATIC STATE                   *****
//***************************************************************
static int err;

static unsigned char peeked_char, peeked_char_avail = FALSE;

extern portstream_fd SetSerial(char *, int, int, int, int);

#define NO_PARITY       0x00
#define EVEN_PARITY     0x18
#define ODD_PARITY      0x08

static int serBaudRate = 9600;

//********************************************************************
//*****               PORTED ROUTINES                            *****
//********************************************************************

/* PURPOSE: Opens a serial communications port
   INPUT:   The serial commpunications port name string
   OUTPUT:  Returns portstream handle if the serial port is successfully opened; 
            otherwise NULL */
portstream_fd openserial(char *portname)
{	 /* Serial communications parameters */
 	 int        speed    = serBaudRate;
	 int        parity   = NO_PARITY;
	 int        bits     = 8;
	 int        stopbits = 1;
	 portstream_fd pstream;

	 pstream = SetSerial(portname, speed, parity, bits, stopbits);

	 return pstream;
}

char   setbaudrate(int baudrate)
{
	serBaudRate = baudrate;
	return 0;
}


char closeserial(portstream_fd portstream)
{   if (portstream != NULL) {                         
   		// disable event notification
   		SetCommMask( portstream, 0 ) ;
   	    // drop DTR
   		EscapeCommFunction( portstream, CLRDTR ) ;	 
   		// purge any outstanding reads/writes and close device handle
        PurgeComm( portstream, PURGE_TXABORT | PURGE_RXABORT | 
			                   PURGE_TXCLEAR | PURGE_RXCLEAR );
		// close the device   
		err = CloseHandle( portstream ) ;
        portstream = (HANDLE) -1;                
		if (err < 0)
			return -1;
	 }
     return 0;
}


/* returns TRUE if all is OK */
char SerialBytesOut(portstream_fd portstream, unsigned char *buffer,
		            int charCnt)
{   int BytesWritten;
   
	if (portstream == NULL) 
	   return FALSE;
	if ( WriteFile(portstream, (LPSTR) buffer, charCnt, (unsigned long *) &BytesWritten, NULL) != TRUE )
	   { printf("\nWriteFile error of %d\n", GetLastError());
		 return -1;  
	   }
	return TRUE;
}


/* returns TRUE if executed correctly. timeout is in msecs */
char SerialBytesIn (portstream_fd portstream, unsigned char *buffer,
 		            unsigned int charCnt, long timeout)
{  COMSTAT COMstatus;
   UINT NumCharsAvail;
   DWORD ErrCode;
   char tbuf;
   unsigned long BytesRead;
   time_t start_time, end_time;
   int timeout_in_secs;

    if ( timeout >= 0 )
	   { time(&start_time);
	     timeout_in_secs = (timeout) / 1000;
		 if(timeout > 0 && timeout_in_secs <= 0)
			 timeout_in_secs = 1;
	}
	if (portstream == 0) 
	     { printf("\nERROR(SerialBytesIn): portstream not properly opened\n");
	       return(FALSE);
		 }
	else {
		for (; charCnt > 0 ;)
		{	
			err = ClearCommError(portstream, &ErrCode, &COMstatus);
			if (err != TRUE)
			{
				printf("\nERROR(SerialBytesIn): ClearCommError error (%d)\n", 
				GetLastError() );
				return((char) err);
			}
			NumCharsAvail = COMstatus.cbInQue;
			if (peeked_char_avail)
				NumCharsAvail++;
			if ( NumCharsAvail >= charCnt )
			{
				if (peeked_char_avail)
				{ 
					*buffer = peeked_char;
					peeked_char_avail = FALSE;
					buffer++;
					charCnt--;
				}
				err = ReadFile(portstream, (LPSTR) buffer, charCnt,
				&BytesRead, NULL);
				tbuf = buffer[0];
				if(tbuf == 255)
				{
					tbuf++;
					tbuf--;
				}
				if (err == TRUE)
				{
					charCnt -= BytesRead;
					if (charCnt ==0)
						return(TRUE);
				}
				else
				{
					printf("\nERROR(SerialBytesIn): ReadFile error (%d)\n", GetLastError() );
					return((char) err);
				}
			}
			else
			{
				if ( timeout != -1 )
				{
					time(&end_time);
					if ( (end_time - start_time) > timeout_in_secs )
						return TIMEOUT_CHAR_READ;
					//timeout -= 100;
					//if (timeout <= 0) 
					// return TIMEOUT_CHAR_READ;  
				}
				Sleep(0);  /* give up the remaining timeslice */
			}

	// otherwise, keep looping until needed chars are available
		}
	}
	return TRUE;
}

// returns TRUE if BYTE available to peek at; otherwise, FALSE
char PeekByte(portstream_fd portstream, unsigned char *peekedByte) 
{  COMSTAT COMstatus;
   UINT NumCharsAvail;
   DWORD ErrCode;
   unsigned long BytesRead;

	if (peeked_char_avail)
		{ *peekedByte = peeked_char;
		  return TRUE;
        }
	
	err = ClearCommError(portstream, &ErrCode, &COMstatus);
    NumCharsAvail = COMstatus.cbInQue;
	if ( NumCharsAvail > 0 )
	   { if ( !ReadFile(portstream, (LPSTR) &peeked_char, 1, &BytesRead, NULL) )
	        { printf("PeekByte err: readfile error(%d)\n", GetLastError());
	          return FALSE;  }
		 if ( BytesRead != 1 )
	        { printf("PeekByte err: readfile did not read peek char(%d)\n", GetLastError());
	          return FALSE;  }
		 *peekedByte = peeked_char;	
 	     peeked_char_avail = TRUE;
	     return (TRUE);
        }

   return FALSE;
}


int numPendingInputChars(portstream_fd portstream)
{ COMSTAT COMstatus;
  DWORD ErrCode;
  
  ClearCommError(portstream, &ErrCode, &COMstatus);
  return( COMstatus.cbInQue );
}


/* returns TRUE is everything OK */
char FlushInputBuffer(portstream_fd portstream) { 
	// flush receiving queue
	return (char) PurgeComm(portstream, PURGE_RXCLEAR);
}


char SerialStringOut(portstream_fd portstream, unsigned char *buffer) { 
	return SerialBytesOut(portstream, buffer, strlen((char *) buffer));
}

// if string successfully read, returns TRUE; otherwise, the negative error 
// code. The number of characters read is returned in charsRead.
char ReadSerialLine(portstream_fd portstream, unsigned char *StringBuffer,
					long timeout, int *charsRead) {
	if (portstream == NULL) return(FALSE);
	*charsRead = 0;
	for (;;) { 
		err = SerialBytesIn(portstream, StringBuffer, 1, timeout);
		/* putchar(*StringBuffer); */
		if (err != TRUE) return ( (char) err);
		if ( *StringBuffer == '\n' ) 
		   { *StringBuffer = '\0';
			 return(TRUE);	
		   }
		else if (err == TRUE) 
		        { StringBuffer++;
			      (*charsRead)++;
		        }
	}
  }


void do_delay(long timeInMsec) {	
    Sleep((DWORD) timeInMsec);
}


// Whether you define this depends upon your particular machine.
// PCs reverse integer byte order, so this define is required.
// For almost all other machines, you would omit this define.
//
// If your machine has 2 byte signed and unsigned integers, and
// 4 byte signed integers, then you won't have to port the below code...
#define	INT_REVERSED


// 2 byte signed short int
char GetSignedShort(portstream_fd portstream, signed short *SHORTval, 
					long timeout) {
#ifdef INT_REVERSED
	SerialBytesIn( portstream, (((unsigned char *) SHORTval)+1), 1, 
		       timeout);
	SerialBytesIn( portstream, ( (unsigned char *) SHORTval), 1, timeout); 
#else
	SerialBytesIn( portstream, ( (unsigned char *) SHORTval), 1, timeout);
	SerialBytesIn( portstream, (((unsigned char *) SHORTval)++), 1,
		       timeout); 
#endif
	return TRUE;
}

// 2 byte signed short int
char PutSignedShort(portstream_fd portstream, signed short *SHORTval) {
#ifdef INT_REVERSED
	SerialBytesOut( portstream, (((unsigned char *) SHORTval)+1), 1);
	SerialBytesOut( portstream, ( (unsigned char *) SHORTval), 1); 
#else
	SerialBytesOut( portstream, ( (unsigned char *) SHORTval), 1);
	SerialBytesOut( portstream, (((unsigned char *) SHORTval)++), 1); 
#endif
	return TRUE;
}

// 2 byte usigned short int
char GetUnsignedShort(portstream_fd portstream, unsigned short
		      *USHORTval, long timeout) {
#ifdef INT_REVERSED
	SerialBytesIn( portstream, (((unsigned char *) USHORTval)+1), 1,
		       timeout);
	SerialBytesIn( portstream, ( (unsigned char *) USHORTval), 1,
		       timeout); 
#else
	SerialBytesIn( portstream, ( (unsigned char *) USHORTval), 1, timeout);
	SerialBytesIn( portstream, (((unsigned char *) USHORTval)++), 1,
		       timeout); 
#endif
	return TRUE;
}

// 2 byte unsigned short int
char PutUnsignedShort(portstream_fd portstream, unsigned short *USHORTval) {

#ifdef INT_REVERSED
	SerialBytesOut( portstream, (((unsigned char *) USHORTval)+1), 1);
	SerialBytesOut( portstream, ( (unsigned char *) USHORTval), 1); 
#else
	SerialBytesOut( portstream, ( (unsigned char *) USHORTval),    1);
	SerialBytesOut( portstream, (((unsigned char *) USHORTval)++), 1); 
#endif
	return TRUE;
}

// 4 byte signed short int
char GetSignedLong(portstream_fd portstream, signed long *LONGval, long
		   timeout) {   
    long i, incr = 1;

#ifdef INT_REVERSED
	LONGval = (signed long *) (((unsigned char *) LONGval) + 3);
	incr = -1;
#endif
	for (i=0; i<4; i++) { 
		SerialBytesIn( portstream, ((unsigned char *) LONGval), 1,
			       timeout);
		LONGval = (signed long *) (((unsigned char *) LONGval) + incr);
	}
	return TRUE;
}

// 4 byte signed short int
char PutSignedLong(portstream_fd portstream, signed long *LONGval) {

#ifdef INT_REVERSED
	SerialBytesOut( portstream, ((unsigned char *) LONGval)+3, 1);
	SerialBytesOut( portstream, ((unsigned char *) LONGval)+2, 1);
	SerialBytesOut( portstream, ((unsigned char *) LONGval)+1, 1);
	SerialBytesOut( portstream, ((unsigned char *) LONGval),   1);
#else
	SerialBytesOut( portstream, ((unsigned char *) LONGval),4);
#endif
	return TRUE;
}


//*******************************************************
//******               LOCAL CODE                  ******
//*******************************************************

portstream_fd SetSerial(char *portname, int Speed, int Parity, int Bits, int StopBit) 
  { portstream_fd pstream;
	DCB dcb;
	COMMTIMEOUTS timeout_info;

	pstream = 
		CreateFile(portname,
		           GENERIC_READ | GENERIC_WRITE,
				   0,    /* comm devices must be opened w/exclusive-access */
				   NULL, /* no security attrs */
				   OPEN_EXISTING, /* comm devices must use OPEN_EXISTING */
				   FILE_ATTRIBUTE_NORMAL, // | FILE_FLAG_OVERLAPPED,  // overlapped I/O
				   NULL  /* hTemplate must be NULL for comm devices */
				   );
	if (pstream == INVALID_HANDLE_VALUE) {
    	printf("\nCreateFile error for %s (error=%d)\n", portname, GetLastError());
      	return NULL;
		}

	// printf("\nSetting COM port parameters\n");
    // e.g. "COM2:9600,n,8,1"

	if ( !(GetCommState(pstream, &dcb)) ) 
	   { printf("GetCommState error(%d)\n", GetLastError());
	     return NULL;
	   }

	dcb.BaudRate = Speed;
    dcb.ByteSize = (unsigned char) Bits;
	dcb.Parity = NOPARITY;
	if (StopBit == 2)
	     dcb.StopBits = TWOSTOPBITS; 
    else dcb.StopBits = ONESTOPBIT;
	switch (Parity) {
		case NO_PARITY:   dcb.Parity = NOPARITY;    break;
		case EVEN_PARITY: dcb.Parity = EVENPARITY;  break;
		case ODD_PARITY:  dcb.Parity = ODDPARITY;   break;
		default:		  return NULL;     }
	dcb.fOutxCtsFlow      = 
	dcb.fOutxDsrFlow      = 
	dcb.fDsrSensitivity   = 
	dcb.fOutX			  = 
	dcb.fInX			  = FALSE;
	dcb.fDtrControl       = DTR_CONTROL_ENABLE;
	dcb.fRtsControl       = RTS_CONTROL_ENABLE;
	dcb.fTXContinueOnXoff = TRUE;

    if ( ! (SetCommState(pstream, &dcb)) ) 
	   { printf("SetCommState err(%d)\n", GetLastError());
	     return NULL;
	}
	// printf("\nSetCommState OK\n");

    if ( ! (PurgeComm(pstream, PURGE_TXABORT | PURGE_RXABORT |
							   PURGE_TXCLEAR | PURGE_RXCLEAR)) )
	   { printf("PurgeComm err(%d)\n", GetLastError());
	     return NULL; }

	// set timout read info. Readfile returns immediately, even if not enough data is avail
	if ( ! GetCommTimeouts(pstream, &timeout_info) )
	   { printf("GetCommTimeouts err(%d)\n", GetLastError());
	     return NULL; }
	timeout_info.ReadIntervalTimeout = MAXDWORD;
	timeout_info.ReadTotalTimeoutMultiplier =
    timeout_info.ReadTotalTimeoutConstant   = 0;
	if (! SetCommTimeouts(pstream, &timeout_info) )
	   { printf("SetCommTimeouts err(%d)\n", GetLastError());
	     return NULL; }

	// printf("\nPort initialized!\n");
    // SerialStringOut(pstream, "\nSetSerial");

    return (pstream);
}


