/*************************************************************************
*****    MACHINE-DEPENDENT SERIAL SUPPORT INCLUDE FILE WSERIAL.C     *****
*****                            (Windows 3.X)                       *****
*****                                                                *****
*****               (C)1995..99, Directed Perception, Inc.           *****
*****                     All Rights Reserved.                       *****
*****                                                                *****
*****   Licensed users may freely distribute compiled code including *****
*****   this code and data. Source data and code may NOT be          *****
*****   distributed without the prior written consent from           *****
*****   Directed Perception, Inc.                                    *****
*****	        Directed Perception, Inc. reserves the right to make *****
*****   changes without further notice to any content herein to      *****
*****   improve reliability, function or design. Directed Perception *****
*****   shall not assume any liability arising from the application  *****
*****   or use of this code, data or function.                       *****
*****                                                                *****
**************************************************************************

CHANGE HISTORY:                
    11/11/99: v1.08.04   Fixed improper printf of nonexistent error status in OpenSerial. 
    					 Fixed FlushInputBuffer to ensure returns boolean return result.
     8/10/98: v1.08.03.  ReadSerialLine initialized charsRead to 0 for 
				 	     compilers that do not do this automatically.
     7/15/98: v1.08.02   Fixed SerialBytesOut to return TRUE/FALSE for DOS/Win16
     1/25/96: v1.07.08d. Fixed strmp in openserial routine
	 1/ 7/95: v1.07.05d. Changed for Windows Borland C/C++.
	10/12/94: v1.07.03d. Pre-release working DOS Borland C/C++ version.
					     XON/XOFF removed from PTU firmware to allow for binary mode.



**************************************************************************/

#include <windows.h>

#include "..\INCLUDE\W16seria.h"
//#include "commdlg.h"
#include "stdio.h"
//#include "stdlib.h"
// #include <dos.h>
//#include "errno.h"
#include "string.h"
//#include "assert.h"


//***************************************************************
//*****                LOCAL STATIC STATE                   *****
//***************************************************************
static int err;

static unsigned char peeked_char, peeked_char_avail = FALSE;

extern char SetSerial(char *,int,int,int,int, int *);

#define COM1            1
#define COM2            2
#define COM3		3
#define COM4	       	4

#define NO_PARITY       0x00
#define EVEN_PARITY     0x18
#define ODD_PARITY      0x08

//********************************************************************
//*****               PORTED ROUTINES                            *****
//********************************************************************

/* portname format recognizes strings including "COM1" to "COM4" */
portstream_fd openserial(char *portname)
{	 /* Serial communications parameters */
         int status;
	 portstream_fd portstream;
	 int        port;
	 int        speed    = 9600;
	 int        parity   = NO_PARITY;
	 int        bits     = 8;
	 int        stopbits = 1;

     /* portname format recognizes strings including "COM1" to "COM4" */
	 if ( (strlen(portname) == 4)            &&
	      /* ensure this is a COM port started string */
	      (tolower(portname[0]) == 'c')      &&
	      (tolower(portname[1]) == 'o')      &&
	      (tolower(portname[2]) == 'm')      &&
	      /* ensure that the port number is from 1-4 */
	      (portname[3] >= '1')               &&
	      (portname[3] <= '4')              )
	    /* then a legal portname has been specified (i.e., COM1-4) */
	    { port = portname[3] - '0';
	    }
	 else /* illegal COM port number has been specified */
	    { printf("\n\nERROR in openserial: ILLEGAL COM PORTNAME '%s'\n", portname);
	      return(PORT_NOT_OPENED);
	    }
	                      
         printf("\n\nLEGAL COM PORTNAME SPECIFIED\n");	                      
	 status = SetSerial(portname, speed, parity, bits, stopbits, &portstream);
	 if ( status != 0)
	      { printf("\nSetSerial returned error code %d\n", status);
	        return(PORT_NOT_OPENED); }
	 else { return(portstream); }       
}


char   closeserial(portstream_fd portstream)
{
	if (portstream>=0) {
		FlushComm(portstream,0); // flush transmission queue
		FlushComm(portstream,1); // flush receiving queue
		err = CloseComm(portstream);
		if (err < 0)
			return -1;
		}
	return 0;
}

char   SerialBytesOut(portstream_fd portstream, unsigned char *buffer, int charCnt)
{
	if (portstream>=0) {
		err = WriteComm(portstream, buffer, charCnt);
		if (err < 0)
			return FALSE;
		}
	return TRUE;
}


char SerialBytesIn (portstream_fd portstream, unsigned char *buffer, 
                    unsigned int charCnt, long timeout)
{  COMSTAT COMstatus;
	UINT NumCharsAvail;

	if (portstream>=0) {
		for (;;)
			{	err = GetCommError(portstream, &COMstatus);
				NumCharsAvail = COMstatus.cbInQue;
				if (peeked_char_avail)
					NumCharsAvail++;
				if ( NumCharsAvail >= charCnt )
					{ if (peeked_char_avail)
						  { *buffer = peeked_char;
							 peeked_char_avail = FALSE;
							 buffer++;
							 charCnt--;
						  }
					  err = ReadComm(portstream, buffer, charCnt);
					  return err;
					}
				else if ( timeout == 0 )
						  return TIMEOUT_CHAR_READ;
					  else timeout -= 100;
				// otherwise, keep looping until needed chars are available
			}}
	return 0;
}

// returns TRUE if BYTE available to peek at; otherwise, FALSE
char	  PeekByte(portstream_fd portstream, unsigned char *peekedByte)
{  if (peeked_char_avail)
		{ *peekedByte = peeked_char;
		  return TRUE;	}
	if ( SerialBytesIn (portstream, &peeked_char, 1, -1) == 1 )
		{ peeked_char_avail = TRUE;
		  *peekedByte = peeked_char;
		  return TRUE;	}
	else { // no char is available to peek at
			 return FALSE;
			 }
}


char	 FlushInputBuffer(portstream_fd portstream)
{  return (char) (FlushComm(portstream,1) == 0); // flush receiving queue
}


char   SerialStringOut(portstream_fd portstream, unsigned char *buffer)
{ return SerialBytesOut(portstream, buffer, strlen((char *) buffer));
}

// if string successfully read, returns TRUE; otherwise, the negative error code.
// the number of characters read is returned in charsRead.
char ReadSerialLine(portstream_fd portstream,
				    unsigned char *StringBuffer, long timeout, int *charsRead)
	{ *charsRead = 0;
	  for (;;)
			{ err = SerialBytesIn(portstream, StringBuffer, 1, timeout);
			  if (err < 0) return err;
			  if ( *StringBuffer == '\n' )
				  { *StringBuffer = '\0';
					 return(TRUE);	}
			  else if (err == 1)
						 { StringBuffer++;
							(*charsRead)++;
						 }
		  }
  }


char   do_delay(long timeInMsec)
	{	DWORD start_time;

		start_time = GetCurrentTime();
		for (;;) {
			if ( ( GetCurrentTime() - start_time ) >= (DWORD) timeInMsec )
				return(TRUE);
			}
	}



// Whether you define this depends upon your particular machine.
// PCs reverse integer byte order, so this define is required.
// For almost all other machines, you would omit this define.
//
// If your machine has 2 byte signed and unsigned integers, and
// 4 byte signed integers, then you won't have to port the below code...
#define	INT_REVERSED


// 2 byte signed short int
char	  GetSignedShort(portstream_fd portstream, signed short *SHORTval, long timeout)
	{
#ifdef INT_REVERSED
		  { SerialBytesIn( portstream, (((unsigned char *) SHORTval)+1), 1, timeout);
			 SerialBytesIn( portstream, ( (unsigned char *) SHORTval), 1, timeout); }
#else
		  { SerialBytesIn( portstream, ( (unsigned char *) SHORTval),    1, timeout);
			 SerialBytesIn( portstream, (((unsigned char *) SHORTval)++), 1, timeout); }
#endif
			return TRUE;
	}

// 2 byte signed short int
char	  PutSignedShort(portstream_fd portstream, signed short *SHORTval)
	{
#ifdef INT_REVERSED
		  { SerialBytesOut( portstream, (((unsigned char *) SHORTval)+1), 1);
			 SerialBytesOut( portstream, ( (unsigned char *) SHORTval), 1); }
#else
		  { SerialBytesOut( portstream, ( (unsigned char *) SHORTval),    1);
			 SerialBytesOut( portstream, (((unsigned char *) SHORTval)++), 1); }
#endif
			return TRUE;
	}

// 2 byte usigned short int
char   GetUnsignedShort(portstream_fd portstream, unsigned short *USHORTval, long timeout)
	{
#ifdef INT_REVERSED
		  { SerialBytesIn( portstream, (((unsigned char *) USHORTval)+1), 1, timeout);
			 SerialBytesIn( portstream, ( (unsigned char *) USHORTval), 1, timeout); }
#else
		  { SerialBytesIn( portstream, ( (unsigned char *) USHORTval),    1, timeout);
			 SerialBytesIn( portstream, (((unsigned char *) USHORTval)++), 1, timeout); }
#endif
			return TRUE;
	}

// 2 byte unsigned short int
char	  PutUnsignedShort(portstream_fd portstream, unsigned short *USHORTval)
	{

#ifdef INT_REVERSED
		  { SerialBytesOut( portstream, (((unsigned char *) USHORTval)+1), 1);
			 SerialBytesOut( portstream, ( (unsigned char *) USHORTval), 1); }
#else
		  { SerialBytesOut( portstream, ( (unsigned char *) USHORTval),    1);
			 SerialBytesOut( portstream, (((unsigned char *) USHORTval)++), 1); }
#endif
			return TRUE;
	}

// 4 byte signed short int
char   GetSignedLong(portstream_fd portstream, signed long *LONGval, long timeout)
 	{   long i, incr = 1;

#ifdef INT_REVERSED
		 LONGval = (signed long *) (((unsigned char *) LONGval) + 3);
		 incr = -1;
#endif
		 for (i=0; i<4; i++)
		  { SerialBytesIn( portstream, ((unsigned char *) LONGval), 1, timeout);
			 LONGval = (signed long *) (((unsigned char *) LONGval) + incr);
		  }
		 return TRUE;
	}

// 4 byte signed short int
char   PutSignedLong(portstream_fd portstream, signed long *LONGval)
	{
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

/*****/
#define OPEN_COM_ERR				-1
#define BUILD_COM_DCB_ERR		-2
#define SET_COMM_STATE_ERR		-3
#define UNKNOWN_COMM_PORT		-4
#define UNKNOWN_PARITY			-5
                                         
/* Call to initialize the Win16 serial port interface. 
   Returns 0 for success; otherwise the error code.  */                                         
char    SetSerial(char *Portname, int Speed, int Parity, int Bits, int StopBit,
				  portstream_fd *portstream)
{   char szText[80], PARITYtxt[20];
	DCB dcb;

	 switch (Parity) {
		case NO_PARITY:   sprintf(PARITYtxt,"n");
				  break;
		case EVEN_PARITY: sprintf(PARITYtxt,"e");
				  break;
		case ODD_PARITY:  sprintf(PARITYtxt,"o");
				  break;
		default:          return UNKNOWN_PARITY;
		}
	*portstream = OpenComm(Portname, 1024, 1024);
	if (*portstream < 0)
		{ printf("\nOpenComm error opening %s (error=%d)\n", Portname, *portstream);
		  return OPEN_COM_ERR;
		}
	// e.g. "COM1:9600,n,8,1"
	sprintf(szText, "%s:%d,%s,%d,%d", Portname, Speed, PARITYtxt, Bits, StopBit);
	err = BuildCommDCB(szText, &dcb);
	if (err < 0)
	   { printf("\nOpenComm error building the DCB (error=%d)\n", err);
	     return BUILD_COM_DCB_ERR;
	   }
	err = SetCommState(&dcb);
	if (err < 0)
	   { printf("\nOpenComm error setting the DCB (error=%d)\n", err);
	     return SET_COMM_STATE_ERR;   
	   }
	FlushComm(*portstream,0); // flush transmission queue
	FlushComm(*portstream,1); // flush receiving queue

	return (0);
}


