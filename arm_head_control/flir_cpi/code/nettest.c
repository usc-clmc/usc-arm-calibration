/*************************************************************************
*****         NETWORKED PTU BINARY TEST DRIVER CODE FILE             ****/
#define NET_TEST_CODE_VERSION       "v1.09.14"
/****            (C)1995-1999, Directed Perception, Inc.             *****
*****                     All Rights Reserved.                       *****
*****                                                                *****
*****   Licensed users may freely distribute compiled code including *****
*****   this code and data. Source data and code may NOT be          *****
*****   distributed without the prior written consent from           *****
*****   Directed Perception, Inc.                                    *****
*****      Directed Perception, Inc. reserves the right to make      *****
*****   changes without further notice to any content herein to      *****
*****   improve reliability, function or design. Directed Perception *****
*****   shall not assume any liability arising from the application  *****
*****   or use of this code, data or function.                       *****
*****                                                                *****
**************************************************************************

CHANGE HISTORY:                    
    7/27/99:    v1.09.10.  Created network test file. This test program is
                           used to test and verify control of a network of
                           DP pan-tilts connected via their RS485 networks.
                           The pan-tilts must be cabled and powered for this
                           test program to work. The pan-tilt unit ID numbers
                           should be listed in the below variable PTU_units_list,
                           and the total number of pan-tilts on the network added
                           as NUMBER_OF_NETWORKED_PTUs. 

***** ENTER YOUR LIST OF NETWORKED PAN-TILT UNITS HERE!! ****/
#define NUMBER_OF_NETWORKED_PTUs	2
unsigned char PTU_units_list[NUMBER_OF_NETWORKED_PTUs] = {1, 2};
#define NUMBER_OF_COMMANDS        100


/*************************************************************************/

//#include <windows.h>

// #include <dos.h>
//#include <conio.h>
#include <stdio.h>      
#include <ctype.h>
//#include <string.h>
#include <stdlib.h>
//#include <time.h>
// #include <dir.h>
#ifdef _UNIX
#include "ptu.h"
#else
#include "..\include\ptu.h"
#endif


/********** MAIN PROGRAM *********/

int main()
	{ int COMportNum;
      char COMportName[256]="COM5", tmpChar;
      portstream_fd COMstream;
#ifdef _UNIX
      char COMportPrefix[10] = "/dev/cua";
#else
      char COMportPrefix[10] = "COM";
#endif

	  int UID_index;
	  unsigned char UID;
      int command_count;
      signed short int ppos, tpos;
	  unsigned short int uval;
	  int status;
	  
	 /* parse the input arguments */

     printf("\n\n\n****** PAN-TILT BINARY NETWORKING TEST PROGRAM, %s\n", NET_TEST_CODE_VERSION); 
	 printf("****** Serial Port Interface Driver, %s\n", SERIAL_CODE_VERSION);
	 printf("****** (c)1999, Directed Perception, Inc. All Rights Reserved.\n");
	 COMportName[0] = ' ';
	 while (COMportName[0] == ' ') {
		 printf("\nEnter the %s port number the PTU is attached to: ", COMportPrefix);
		 scanf("%d", &COMportNum);
		 printf("You selected %s%d. Is this OK? (enter 'y' or 'n'): ", COMportPrefix, COMportNum);
		 tmpChar = 'f';
		 while ( (tmpChar != 'y') && (tmpChar != 'n') )
			   tmpChar = ((char) tolower(getchar()));
		 if ( tmpChar == 'y' )
		    sprintf(COMportName, "%s%d", COMportPrefix, COMportNum);
	 }
	 /* initialize the serial port */
	 COMstream = open_host_port(COMportName);
	 if ( COMstream == PORT_NOT_OPENED )
		 { printf("\nSerial Port setup error.\n");
		   goto abnormal_exit;  }
	 printf("\nSerial port %s initialized\n", COMportName);

     
	 /* now initialize the parse state of all the networked PTUs */
	 printf("\n\n\nBEGINNING: INITIALIZING NETWORKED PTU PARSE STATES\n\n");

     for (UID_index=0; UID_index < NUMBER_OF_NETWORKED_PTUs; UID_index++)
	 { UID = PTU_units_list[UID_index];
	   if (select_unit(UID))
	      { printf("\n\n<<< selected UID=%d...  ", UID);
	        if ( (status=reset_PTU_parser(5000)) != PTU_OK )
			   { printf("\nError: reset_PTU_parser returned %d\n", status);
				 goto abnormal_exit;  }
			uval = 2500;
			set_desired(PAN,  SPEED, (PTU_PARM_PTR *) &uval, ABSOLUTE);
			set_desired(TILT, SPEED, (PTU_PARM_PTR *) &uval, ABSOLUTE);
			printf(">>>\n\n"); 
			}	 
	 }
	 printf("\n\nENDED: INITIALIZING NETWORKED PTU PARSE STATES\n\n\n");


	 /* now command each of the networked PTUs in sequence to test network functionality */
	 printf("\n\n\nBEGINNING: EXERCISING NETWORKED PTUS\n\n");
     for (command_count=0, ppos=3000, tpos=600; 
		  command_count<5;
		  command_count++, ppos=-ppos, tpos=-tpos) {
		 printf("\n***\n");
		 for (UID_index=0; 
			  UID_index < NUMBER_OF_NETWORKED_PTUs; 
			  UID_index++) {
		   UID = PTU_units_list[UID_index];
		   if (select_unit(UID))
			  { printf("\nselected UID=%d...  ", UID);
				set_desired(PAN,  POSITION, (PTU_PARM_PTR *) &ppos, ABSOLUTE);
				set_desired(TILT, POSITION, (PTU_PARM_PTR *) &tpos, ABSOLUTE);
				await_completion();
				printf(" %d ", command_count);
				} } }
	 for (UID_index=0, ppos=0, tpos=0; 
		  UID_index < NUMBER_OF_NETWORKED_PTUs; 
		  UID_index++, ppos=-ppos, tpos=-tpos)
		 { UID = PTU_units_list[UID_index];
		   if (select_unit(UID))
		      { set_desired(PAN,  POSITION, (PTU_PARM_PTR *) &ppos, ABSOLUTE);
		        set_desired(TILT, POSITION, (PTU_PARM_PTR *) &tpos, ABSOLUTE);
		        await_completion(); 
		   }}
	 printf("\n\nENDED: EXERCISING NETWORKED PTUS\n\n\n");

	 /* now command each of the networked PTUs to test network functionality */
	 printf("\n\n\nBEGINNING: EXERCISING NETWORKED PTUS\n\n");
     for (UID_index=0; UID_index < NUMBER_OF_NETWORKED_PTUs; UID_index++)
	 { UID = PTU_units_list[UID_index];
	   if (select_unit(UID))
	      { printf("\n\n<<< selected UID=%d...  ", UID);
            for (command_count=0, ppos=3000, tpos=1000; 
				 command_count<NUMBER_OF_COMMANDS; 
				 command_count++, ppos=-ppos, tpos=-tpos)
			{  set_desired(PAN,  POSITION, (PTU_PARM_PTR *) &ppos, ABSOLUTE);
			   set_desired(TILT, POSITION, (PTU_PARM_PTR *) &tpos, ABSOLUTE);
			   await_completion();
			   printf(" %d ", command_count);
			}
		    ppos=0; tpos=0;
			set_desired(PAN,  POSITION, (PTU_PARM_PTR *) &ppos, ABSOLUTE);
			set_desired(TILT, POSITION, (PTU_PARM_PTR *) &tpos, ABSOLUTE);
			await_completion();
			printf("\n>>>\n\n");
	   }}
	 printf("\n\nENDED: EXERCISING NETWORKED PTUS\n\n\n");

	/* rehome the PTU */
    set_mode(DEFAULTS, RESTORE_SAVED_SETTINGS);
	await_completion();


	goto exit;

  abnormal_exit:
	printf("\nABNORMAL EXIT: test failed\n\n");

  exit:
	/* FlushInputBuffer(); */
	close_host_port(COMstream);
	printf("(Enter any key to exit): "); getchar();

	return(TRUE);

}


