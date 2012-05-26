/*************************************************************************
*****        MACHINE-DEPENDENT DOS SERIAL SUPPORT INCLUDE FILE       *****
*****                           (DSERIAL.H)                          ****/
#define SERIAL_CODE_VERSION   "DOS v1.08.03"
/****                                                                *****
*****             (C)1995,1997, Directed Perception, Inc.            *****
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
     8/10/98:   v1.08.03   ReadSerialLine initialized charsRead to 0 for 
				 	       compilers that do not do this automatically.
     7/15/98:   v1.08.02   Fixed SerialBytesOut to return TRUE/FALSE for DOS/Win16
     7/10/97:   v1.08.00.  Unified with Win and MSVC 1.52. IRQs generalized.
	 4/11/95:  	v1.07.07b. Fixed bug in getccb and GetSerialChar where
	  							  unsigned char declarations were missing.
	 1/7/95:    v1.07.05d. Re-ported for DOS Borland C/C++.
	 1/7/95:	v1.07.05d. Changed for Windows Borland C/C++.
	10/12/94:	v1.07.03d. Pre-release working DOS Borland C/C++ version.
					XON/XOFF removed from PTU firmware to allow for binary mode.


**************************************************************************/

/*************  These are the standard PC IRQ serial port assignments   */
/*************  IRQs 2-7 may be used.                                   */
#define COM1IRQ         4   /*  Port IRQ for COM1  */
#define COM2IRQ         3   /*  Port IRQ for COM2  */
#define COM3IRQ         4   /*  Port IRQ for COM3  */
#define COM4IRQ         3   /*  Port IRQ for COM4  */  


                                 
/************************** PORTED FUNCTIONAL INTERFACES *****************/
                                          
typedef int portstream_fd;     
#define PORT_NOT_OPENED			0
   
#define TRUE  1
#define FALSE 0                                         
                                         
                                         
/* function definition that need are machine/compiler dependent */
extern portstream_fd	openserial(char *);
extern char   closeserial(portstream_fd);

extern char   SerialBytesOut(portstream_fd, unsigned char *, int);

#define AWAIT_CHARSTREAM		-1
#define TIMEOUT_CHAR_READ		-1
extern char   SerialBytesIn (portstream_fd, unsigned char *, unsigned int, long);

extern char	  PeekByte(portstream_fd, unsigned char *);
extern char	  FlushInputBuffer(portstream_fd);
extern char   do_delay(long); /* in milliseconds */

extern char   SerialStringOut(portstream_fd, unsigned char*); /* Output a string to the serial port */
extern char   ReadSerialLine(portstream_fd, unsigned char*, long, int*);

extern char	  GetSignedShort(portstream_fd, signed short*, long); 	 // 2 byte signed short int
extern char	  PutSignedShort(portstream_fd, signed short*);
extern char   GetUnsignedShort(portstream_fd, unsigned short*, long); // 2 byte unsigned short int
extern char	  PutUnsignedShort(portstream_fd, unsigned short*);
extern char   GetSignedLong(portstream_fd, signed long*, long);		 // 4 byte signed long
extern char   PutSignedLong(portstream_fd, signed long*);
                                             
                                             
                                             
                                          
/************************** INTERNAL DECLARATIONS *****************/

typedef signed char SERIAL_BUFFER;


#define NOERROR         0       /* No error               */
#define BUFOVFL         1       /* Buffer overflowed      */

#define ESC             0x1B    /* ASCII Escape character */
#define ASCII           0x007F  /* Mask ASCII characters  */
#define SBUFSIZ         0x4000  /* Serial buffer size     */

extern int            SError;

/* configurations */

#define COM1            0
#define COM2            1          
#define COM3            2
#define COM4            3          

/*
    The 8250 UART has 10 registers accessible through 7 port addresses.
    Here are their addresses relative to the COM portbase. Note
    that the baud rate registers, (DLL) and (DLH) are active only when
    the Divisor-Latch Access-Bit (DLAB) is on. The (DLAB) is bit 7 of
    the (LCR).

	o TXR Output data to the serial port.
	o RXR Input data from the serial port.
	o LCR Initialize the serial port.
	o IER Controls interrupt generation.
	o IIR Identifies interrupts.
	o MCR Send control signals to the modem.
	o LSR Monitor the status of the serial port.
	o MSR Receive status of the modem.
	o DLL Low byte of baud rate divisor.
	o DHH High byte of baud rate divisor.
*/
#define TXR             0       /*  Transmit register (WRITE) */
#define RXR             0       /*  Receive register  (READ)  */
#define IER             1       /*  Interrupt Enable          */
#define IIR             2       /*  Interrupt ID              */
#define LCR             3       /*  Line control              */
#define MCR             4       /*  Modem control             */
#define LSR             5       /*  Line Status               */
#define MSR             6       /*  Modem Status              */
#define DLL             0       /*  Divisor Latch Low         */
#define DLH             1       /*  Divisor latch High        */


/*-------------------------------------------------------------------*
  Bit values held in the Line Control Register (LCR).
	bit		meaning
	---		-------
	0-1		00=5 bits, 01=6 bits, 10=7 bits, 11=8 bits.
	2		Stop bits.
	3		0=parity off, 1=parity on.
	4		0=parity odd, 1=parity even.
	5		Sticky parity.
	6		Set break.
	7		Toggle port addresses.
 *-------------------------------------------------------------------*/
#define NO_PARITY       0x00
#define EVEN_PARITY     0x18
#define ODD_PARITY      0x08



/*-------------------------------------------------------------------*
  Bit values held in the Line Status Register (LSR).
	bit		meaning
	---		-------
	0		Data ready.
	1		Overrun error - Data register overwritten.
	2		Parity error - bad transmission.
	3		Framing error - No stop bit was found.
	4		Break detect - End to transmission requested.
	5		Transmitter holding register is empty.
	6		Transmitter shift register is empty.
	7               Time out - off line.
 *-------------------------------------------------------------------*/
#define RCVRDY          0x01
#define OVRERR          0x02
#define PRTYERR         0x04
#define FRMERR          0x08
#define BRKERR          0x10
#define XMTRDY          0x20
#define XMTRSR          0x40
#define TIMEOUT		0x80

/*-------------------------------------------------------------------*
  Bit values held in the Modem Output Control Register (MCR).
	bit     	meaning
	---		-------
	0		Data Terminal Ready. Computer ready to go.
	1		Request To Send. Computer wants to send data.
	2		auxillary output #1.
	3		auxillary output #2.(Note: This bit must be
			set to allow the communications card to send
			interrupts to the system)
	4		UART ouput looped back as input.
	5-7		not used.
 *------------------------------------------------------------------*/
#define DTR             0x01
#define RTS             0x02
#define MC_INT	    	0x08


/*------------------------------------------------------------------*
  Bit values held in the Modem Input Status Register (MSR).
	bit		meaning
	---		-------
	0		delta Clear To Send.
	1		delta Data Set Ready.
	2		delta Ring Indicator.
	3		delta Data Carrier Detect.
	4		Clear To Send.
	5		Data Set Ready.
	6		Ring Indicator.
	7		Data Carrier Detect.
 *------------------------------------------------------------------*/
#define CTS             0x10
#define DSR             0x20


/*------------------------------------------------------------------*
  Bit values held in the Interrupt Enable Register (IER).
	bit		meaning
	---		-------
	0		Interrupt when data received.
	1		Interrupt when transmitter holding reg. empty.
	2		Interrupt when data reception error.
	3		Interrupt when change in modem status register.
	4-7		Not used.
 *------------------------------------------------------------------*/
#define RX_INT          0x01


/*------------------------------------------------------------------*
  Bit values held in the Interrupt Identification Register (IIR).
	bit		meaning
	---		-------
	0		Interrupt pending
	1-2     Interrupt ID code
			00=Change in modem status register,
			01=Transmitter holding register empty,
			10=Data received,
			11=reception error, or break encountered.
	3-7		Not used.
 *------------------------------------------------------------------*/
#define RX_ID           0x04
#define RX_MASK         0x07


/*
    These are the port addresses of the 8259 Programmable Interrupt
    Controller (PIC).
*/
#define IMR             0x21   /* Interrupt Mask Register port */
#define ICR             0x20   /* Interrupt Control Port       */


/*
    An end of interrupt needs to be sent to the Control Port of
    the 8259 when a hardware interrupt ends.
*/
#define EOI             0x20   /* End Of Interrupt */


