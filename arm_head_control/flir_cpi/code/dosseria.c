/*************************************************************************
*****    MACHINE-DEPENDENT SERIAL SUPPORT INCLUDE FILE DSERIAL.C     *****
*****                            (DOS)                               *****
*****                                                                *****
*****             (C)1995/1997, Directed Perception, Inc.            *****
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
     7/15/98:   v1.08.02   Fixed SerialBytesOut to return TRUE/FALSE for DOS/Win16
     7/10/97:   v1.08.00.  Unified with Win and MSVC 1.52. IRQs generalized.
	 4/11/95:  	v1.07.07b. Fixed bug in getccb and GetSerialChar where
	  							  unsigned char declarations were missing.
	 1/7/95:    v1.07.05d. Re-ported for DOS Borland C/C++.
	 1/7/95:	v1.07.05d. Changed for Windows Borland C/C++.
	10/12/94:	v1.07.03d. Pre-release working DOS Borland C/C++ version.
					XON/XOFF removed from PTU firmware to allow for binary mode.



**************************************************************************/

#include "..\INCLUDE\DOSseria.h"
#include <conio.h>     
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include "errno.h"
#include <string.h>
#include "assert.h"


//***************************************************************
//*****                LOCAL STATIC STATE                   *****
//***************************************************************
static int err;
static unsigned char peeked_char;
static char peeked_char_avail = FALSE;
static int SError;

/*********************/

int            portbase        = 0;   
          
/* placeholders for the previous interrupt routines */           
void     (interrupt *oldvect1)();
void     (interrupt *oldvect2)();

extern void   interrupt com_int(void);

static   char  ccbuf[SBUFSIZ];
unsigned int   startbuf        = 0;
unsigned int   endbuf          = 0;


/*********************/
extern char   SetSerial(int, int, int, int, int, portstream_fd *);
extern int    SetPort(portstream_fd *, int);
extern int    SetSpeed(portstream_fd, int);
extern int    SetOthers(portstream_fd, int, int, int);
extern void   comm_on(portstream_fd, int);
extern void   i_enable(portstream_fd, int);
extern void   i_disable(portstream_fd);
extern int    DSerialOut(unsigned char);
extern unsigned char   DGetSerialChar(void);
extern int    getccb(void);


//********************************************************************
//*****               PORTED ROUTINES                            *****
//********************************************************************
                                           
void delay(int msec)
{ time_t otime;
  double delay_in_secs;                     
                       
  delay_in_secs = msec/1000;                       
  time(&otime);
  for (;;) // loop until delay is exceeded
     { if ( difftime(time(NULL),otime) > delay_in_secs )
          return;
     }
}    
               
static int com_irq	= 0;
               
portstream_fd openserial(char *portname)
{	 /* Serial communications parameters */
	 portstream_fd portstream;
	 int        port;
	 int        speed    = 9600;
	 int        parity   = NO_PARITY;
     int        bits     = 8;
	 int        stopbits = 1; 
	 int        com_irq;

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
	    { port = portname[3] - '0' - 1;   /* port number is x-1 where x is from COMx */
	    }
	 else /* illegal COM port number has been specified */
	    return(PORT_NOT_OPENED);
	                     
	 if (SetSerial(port, speed, parity, bits, stopbits, &portstream) != 0)
		  return(-1);

	 /* determine the computer IRQ from the COM port number */
	 switch (port) {
	    case COM1: com_irq = COM1IRQ;
	    		   break;
	    case COM2: com_irq = COM2IRQ;
	    		   break;
	    case COM3: com_irq = COM3IRQ;
	    		   break;
	    case COM4: com_irq = COM4IRQ;
	    		   break;
        } 
     /* only accept COM IRQs 2-7 */
     if ( (com_irq < 2) || (com_irq > 7) )
        return(-1);
        
	 endbuf = startbuf = 0;
	 oldvect1 = _dos_getvect(0x0B);
	 oldvect2 = _dos_getvect(0x0C);
	 _dos_setvect(0x0B, com_int);
	 _dos_setvect(0x0C, com_int);
	 comm_on(portstream, com_irq);

     portbase = portstream;
	 return(portstream);
}


char   closeserial(portstream_fd portstream)
{
	if (portstream>=0)
		 { i_disable(portstream);
			outp(portstream + MCR, 0);

			_dos_setvect(0x0B, oldvect1);
			_dos_setvect(0x0C, oldvect2);

			FlushInputBuffer(portstream);
		}
	return 0;
}


char   SerialBytesOut(portstream_fd portstream,
							 unsigned char *buffer,
							 int charCnt)
{  int i;

	if (portstream != 0)
		for (i=0; i<charCnt; i++)
		    {	DSerialOut(*buffer++);	}
	return TRUE;
}

char SerialBytesIn (portstream_fd portstream,
				    unsigned char *buffer,
					unsigned int charCnt,
					long timeout)
{  unsigned int i;
   unsigned int NumCharsAvail;

	if (portstream>=0) {
		for (;;)
			{  NumCharsAvail = endbuf - startbuf;
				if (peeked_char_avail)
					NumCharsAvail++;
				if ( NumCharsAvail >= charCnt )
					{ if (peeked_char_avail)
						  { *buffer = peeked_char;
							 peeked_char_avail = FALSE;
							 buffer++;
							 charCnt--;
						  }
					  for (i=0; i<charCnt; i++)
							{	*buffer++ = DGetSerialChar();	}
					  return TRUE;
					}
				else if ( ( timeout == 0 ) /* || ( timeout < -1 ) */ )
						  return TIMEOUT_CHAR_READ;
					  else timeout -= 10;
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


/* flush the incoming character buffer */
char FlushInputBuffer(portstream_fd portstream)
{ if ( portstream != 0 )
	  {  while (getccb() != -1);
		  return(TRUE);		}
	else return(FALSE);

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
	{	delay((unsigned) timeInMsec);
		return(TRUE);
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

/* Handle communications interrupts and put them in ccbuf */
void   interrupt far com_int(void)
{
	 _disable();
	 if (( _inp(portbase + IIR) & RX_MASK) == RX_ID)
	 {
		  if (((endbuf + 1) & SBUFSIZ - 1) == startbuf)
				SError = BUFOVFL;

		  ccbuf[endbuf++] = _inp(portbase + RXR);
		  endbuf &= SBUFSIZ - 1;
	 }

	 /* Signal end of hardware interrupt */
	 _outp(ICR, EOI);
	 _enable();
}


/*****/
char    SetSerial(int Port, int Speed, int Parity, int Bits, int StopBit,
						portstream_fd *portstream)
{   
	 SError = NOERROR;
	 if (SetPort(portstream,Port))                      return (-1);      
	 if (SetSpeed(*portstream, Speed))                  return (-1);
	 if (SetOthers(*portstream, Parity, Bits, StopBit)) return (-1);

	FlushInputBuffer(*portstream);
	
	return (0);
}


/********************************************/
/* Set the port number to use */
int    SetPort(portstream_fd *portstream, int Port)
{
    int                Offset, far *RS232_Addr;
    switch (Port)
    { /* Sort out the base address */
      case COM1 : Offset = 0x0000;
                  break;
      case COM2 : Offset = 0x0002;
                  break;
      case COM3 : Offset = 0x0004;
                  break;
      case COM4 : Offset = 0x0006;
                  break;
      default   : return (-1);
    }

    RS232_Addr = MK_FP(0x0040, Offset);  /* Find out where the port is. */
    if (! *RS232_Addr) return (-1);/* If NULL then port not used. */
	*portstream = *RS232_Addr;
	 
	return (0);
}



/* This routine sets the speed; will accept funny baud rates. */
/* Setting the speed requires that the DLAB be set on.        */
int    SetSpeed(portstream_fd portstream, int Speed)
{
	 char		c;
    int		divisor;

	 if (Speed == 0)            /* Avoid divide by zero */
        return (-1);
	 else
		  divisor = (int) (115200L/Speed);

	 if (portstream == 0)
        return (-1);

     _disable();
	 c = _inp(portstream + LCR);
	 _outp(portstream + LCR, (c | 0x80)); /* Set DLAB */
	 _outp(portstream + DLL, (divisor & 0x00FF));
	 _outp(portstream + DLH, ((divisor >> 8) & 0x00FF));
	 _outp(portstream + LCR, c);          /* Reset DLAB */
     _enable();

    return (0);
}


/* Set other communications parameters */
int    SetOthers(portstream_fd portstream, int Parity, int Bits, int StopBit)
{
	 int                setting;

	 if (portstream == 0)					return (-1);
	 if (Bits < 5 || Bits > 8)				return (-1);
	 if (StopBit != 1 && StopBit != 2)		return (-1);
	 if (Parity != NO_PARITY && Parity != ODD_PARITY && Parity != EVEN_PARITY)
		return (-1);

	 setting  = Bits-5;
	 setting |= ((StopBit == 1) ? 0x00 : 0x04);
	 setting |= Parity;

	 _disable();
	 _outp(portstream + LCR, setting);
	 _enable();

	 return (0);
}


/* Tell modem that we're ready to go */
void   comm_on(portstream_fd portstream, int com_irq)
{    int                c;
     
	 i_enable(portstream, com_irq);
	 c = _inp(portstream + MCR) | DTR | RTS;
	 _outp(portstream + MCR, c);
}
                            


/*  The (IMR) tells the (PIC) to service an interrupt only if it
    is not masked (FALSE).     */ 
int IMR_irq_mask(int IRQ_number)  
{  return (0xFF & (1 << IRQ_number));  
}                          

/* Turn on communications interrupts */
void   i_enable(portstream_fd portstream, int pnum)
{
	 int                c;

    _disable();
    c = _inp(portstream + MCR) | MC_INT;
    _outp(portstream + MCR, c);
    _outp(portstream + IER, RX_INT);
    c = _inp(IMR) & IMR_irq_mask(com_irq);
    _outp(IMR, c);
    _enable();
}

/* Turn off communications interrupts */
void   i_disable(portstream_fd portstream)
{
    int                c;

    _disable();
    c = _inp(IMR) | (~ IMR_irq_mask(com_irq)) ;
    _outp(IMR, c);
	_outp(portstream + IER, 0);
	c = _inp(portstream + MCR) & ~MC_INT;
    _outp(portstream + MCR, c);
    _enable();
}


/* Output a character to the serial port */
int    DSerialOut(unsigned char x)
{
	 long int           timeout = 0x0000FFFFL;

	 _outp(portbase + MCR,  MC_INT | DTR | RTS);
	 timeout = 0x0000FFFFL;

	 /* Wait for transmitter to clear */
	 while ((_inp(portbase + LSR) & XMTRDY) == 0)
		  if (!(--timeout))
				return (-1);

	 _disable();
	 _outp(portbase + TXR, x);
	 _enable();

	 return (0);
}


unsigned char DGetSerialChar(void)
	{ int c;
	  while ((c = getccb()) == -1);
	  return((unsigned char) c);
	}


/* This routine returns the current value in the buffer */
int    getccb(void)
{
	 int                res;

	 if (endbuf == startbuf)
		  return (-1);

	 res = (int) ((unsigned char) ccbuf[startbuf++]);
	 startbuf %= SBUFSIZ;
	 return (res);
}


