#define PQ_VERSION  "PQ_DATE 11-9-99"
/******************************************************************
 Filename:  post-query.c
 Called by: preprice.htm (this is a form processing CGI)
 Output:    1) A response HTML (STDOUT) with the result of their form post
            2) Tab delimited form output into /web/d/www.dperception.com/cgi/db/accesses.fmp.tdr
	       for importing into applications like FileMaker Pro v4
	    3) If the form email is OK, autoemails the pricing to the inquirer 
	       (figures out domestic versus international) 
 History:
  2/ 6/98:   Made changes for country name, and separate phone and fax area codes
 11/ 9/99:   Added traceability to the form with an HTML comment. Changed CountryCode
             to Country. (Worked that way anyhow. Note that SoughtKeyword didn't distinguish
	     between CountryCode and Country).

 ******************************************************************/


#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <time.h>

#include "ptu.h"


#define MAX_ENTRIES 10000

/*****************
**********/

typedef struct {
    char *name;
    char *val;
} entry;

char *makeword(char *line, char stop);
char *fmakeword(FILE *f, char stop, int *len);
char x2c(char *what);
void unescape_url(char *url);
void plustospace(char *str);

/***** FORM DATA STRUCTURE *****/
typedef struct {
  /* automatically generated user information */
  char dateStr[10];
  char timeStr[10];
  char HTTPuser[50];
  char RemoteHost[50];
  char RemoteAddr[50];
  /* user entered data */
  char emailAddr[50];
  char FirstName[50];
  char LastName[50];
  char Country[50];
  char PhoneAreaCode[10];
  char PhoneNumber[20];
  char FaxAreaCode[10];
  char FaxNumber[20];
  char UserType[50];
  char urgency[50];
  char originator[50];
  char ActionRequired[50];
  char comments[1000];
} UserData;


/***    ***/
ReplaceReservedCharacters(char buffer[], int bufSize)
{ int i;

  for (i=0; i<bufSize; i++)
    { if (buffer[i] == 13) 
	 buffer[i] = '\011';
      if ( (buffer[i] == '\t')  || (buffer[i] == 10) )
	buffer[i] = ' ';
      buffer[i] &= 127;
    }
}

/* returns -1 if no match; otherwise the index */
int SoughtKeyword(/* IN */
		  char *indexStr, entry entries[], int numEntries,
		  /* OUT */
		  char *outKeywordValue)
{ int i;
  for (i=0; i<=numEntries; i++)
    { if ( strcmp(indexStr,entries[i].name) == 0) 
	 { /* outKeywordValue = entries[i].val; */
	   sprintf(outKeywordValue, "%s", entries[i].val);
           return(i);
	 }
    }
  outKeywordValue = "";
  return(-1);
}

#define TRUE      -1
#define FALSE      0
int DomesticBuyer(char *emailAddr, char *Country)
{ /* If they have declared outside of US or CANADA, then not a domestic buyer.
     Could be a domestic checking internation pricing, but then there are
     international customers with COM domains asking for pricing... Which
     harm is greater? */
  if ( (strcmp( Country, "USA")    == 0) ||
       (strcmp( Country, "CANADA") == 0)    )
     return ( TRUE );
  /* they may have just left USA, or trying to get US pricing, so now check email domain to see */
  return (  ( strrchr(emailAddr, ".com") != NULL )  ||
	    ( strrchr(emailAddr, ".gov") != NULL )  ||
	    ( strrchr(emailAddr, ".edu") != NULL )  ||
	    ( strrchr(emailAddr, ".mil") != NULL )  ||
	    ( strrchr(emailAddr, ".org") != NULL )  ||
	    ( strrchr(emailAddr, ".ca" ) != NULL )     );
}



main(int argc, char *argv[]) {
    entry entries[MAX_ENTRIES];
    register int x,m=0;
    int cl;
    int index;
    UserData UserData;    

    FILE *fd_filemakerProDB;
    char *cstr;
    time_t timeVal;
    char tmpStr[200];
    unsigned int status;
    
    int COMportNum;
#ifdef _UNIX
      char COMportName[100] = "/dev/cua";
#else
      char COMportName[100] = "COM";
#endif
    char tmpChar;
    portstream_fd COMstream;
	  
	/* begin the html return data with a header */
	printf("Content-type: text/html%c%c",10,10);


	/* initialize the serial port */       
	COMstream = open_host_port(COMportName);
	if ( COMstream == PORT_NOT_OPENED )
		{ printf("\nSerial Port %s RS232 port initialization error (%d).\n", COMportName);
		  goto abnormal_exit;  }
	printf("\nSerial port %s initialized\n", COMportName);
	
	
	
    if(strcmp(getenv("REQUEST_METHOD"),"POST")) {
        printf("This script should be referenced with a METHOD of POST.\n");
        printf("If you don't understand this, see this ");
        printf("<A HREF=\"http://www.ncsa.uiuc.edu/SDG/Software/Mosaic/Docs/fill-out-forms/overview.html\">forms overview</A>.%c",10);
        exit(1);
    }
    if(strcmp(getenv("CONTENT_TYPE"),"application/x-www-form-urlencoded")) {
        printf("This script can only be used to decode form results. \n");
        exit(1);
    }

    /* read the form data into the internal record storage locations */
    cl = atoi(getenv("CONTENT_LENGTH"));
    for(x=0;cl && (!feof(stdin));x++) {
        m=x;
        entries[x].val = fmakeword(stdin,'&',&cl);
        plustospace(entries[x].val);
        unescape_url(entries[x].val);
        entries[x].name = makeword(entries[x].val,'=');
    }

    /***** now fill out the UserData record *****/
    time(&timeVal);
    strftime(UserData.dateStr, 20, "%D", localtime(&timeVal));
    strftime(UserData.timeStr, 20, "%R", localtime(&timeVal));
 
    if ( getenv("HTTP_FROM") != NULL )
       sprintf(UserData.HTTPuser,   "%s", getenv("HTTP_FROM") );
    if ( getenv("REMOTE_HOST") != NULL )
       sprintf(UserData.RemoteHost, "%s", getenv("REMOTE_HOST"));
    if ( getenv("REMOTE_ADDR") != NULL )
       sprintf(UserData.RemoteAddr, "%s", getenv("REMOTE_ADDR"));

    /* entered form data */
    SoughtKeyword("emailAddr", entries, m, tmpStr);
    sscanf(tmpStr, "%s", UserData.emailAddr); 
    SoughtKeyword("FirstName", entries, m, UserData.FirstName);
    SoughtKeyword("LastName", entries, m, UserData.LastName);
    SoughtKeyword("Country", entries, m, UserData.Country);
    SoughtKeyword("PhoneAreaCode", entries, m, UserData.PhoneAreaCode);
    SoughtKeyword("PhoneNumber", entries, m, UserData.PhoneNumber);
    SoughtKeyword("FaxAreaCode", entries, m, UserData.FaxAreaCode);
    SoughtKeyword("FaxNumber", entries, m, UserData.FaxNumber);
    SoughtKeyword("UserType", entries, m, UserData.UserType);
    SoughtKeyword("urgency", entries, m, UserData.urgency);
    SoughtKeyword("originator", entries, m, UserData.originator);
    SoughtKeyword("ActionRequired", entries, m, UserData.ActionRequired);
    SoughtKeyword("comments", entries, m, UserData.comments);
    ReplaceReservedCharacters( UserData.comments, strlen(UserData.comments) );



    /***** now send back an html query to verify the data entered */
    printf("<!-- %s -->\n\n", PQ_VERSION);
    printf("<HTML><HEAD><TITLE>\nPricing and Availability\n</TITLE></HEAD>\n<BODY BGCOLOR=\"white\">\n ");

    printf("<CENTER><FONT SIZE=\"+3\" color=\"blue\"><B><I>Directed Perception, Inc.</I></B> </FONT><FONT SIZE=\"-1\" color=\"blue\"><br>Manufacturers of innovative devices and software for the intelligent control of sensors and sensor processing. </FONT><BR></center>\n");
    printf("<CENTER><IMG SRC=\"http://www.dperception.com/art/mount.jpg\" ALT=\"[ Directed Perception, Inc., 1485 Rollins Road, Burlingame, CA 94010, (650) 342-9399, FAX: (650) 342-9199, Internet: info@DPerception.com, URL: http://www.DPerception.com/ ]\" HEIGHT=80 WIDTH=729></CENTER>");

    printf("<br><IMG IMAGE ALIGN=left BORDER=0 VSPACE=6 WIDTH=119 HEIGHT=124 SRC=\"http://www.dperception.com/art/woman_ph.gif\"><br>");

    /***** now write the info into the log file! */
    if ( (fd_filemakerProDB = 
	  fopen("/web/d/www.dperception.com/cgi/db/accesses.fmp.tdr"
		, "a"))
	 == NULL)
       { system("Mail -s filemakerProDBErr pkahn@dperception.com < ../db/FileOpenErr.text");
       /* printf("FILE OPEN FAILED!!"); */
       }
    else { /* block until the file is available */
           flockfile(fd_filemakerProDB);
      
	   fprintf(fd_filemakerProDB, 
		   "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
		   UserData.dateStr, UserData.timeStr,
		   UserData.RemoteHost, UserData.RemoteAddr,
		   UserData.emailAddr,
		   UserData.FirstName, UserData.LastName,
		   UserData.Country, 
                   UserData.PhoneAreaCode, UserData.PhoneNumber, 
                   UserData.FaxAreaCode, UserData.FaxNumber,
		   UserData.UserType, UserData.urgency,
		   UserData.originator,
		   UserData.ActionRequired,
		   UserData.comments,
		   UserData.HTTPuser);
	   /* let others into the file */
	   funlockfile(fd_filemakerProDB);
 	   fclose(fd_filemakerProDB);
	 }


    /***** now send email to dp-info@dperception.com  */
    if ( (fd_filemakerProDB = 
	  fopen("/web/d/www.dperception.com/cgi/db/inquirer.mail", "w"))
	 == NULL)
       { system("Mail -s filemakerProDBErr pkahn@dperception.com < ../db/FileOpenErr.text");
	 /* printf("FILE OPEN FAILED!!"); */
       }
    else { /* block until the file is available */
           flockfile(fd_filemakerProDB);
	   /* assemble the inquirer information */
	   fprintf(fd_filemakerProDB, 
		   "\n\n\n\n_______________________________________________________\n\n%s%s\n+%s (%s) %s, FAX: (%s) %s\nemail: %s\n\n%s, %s, %s\n\n%s\n",
		   UserData.FirstName, UserData.LastName,
		   UserData.Country, 
                   UserData.PhoneAreaCode, UserData.PhoneNumber, 
                   UserData.FaxAreaCode,   UserData.FaxNumber,
		   UserData.emailAddr,
		   UserData.UserType, UserData.urgency,
		   UserData.ActionRequired,
		   UserData.comments);
	   funlockfile(fd_filemakerProDB);
	   fclose(fd_filemakerProDB);
	 }
    if ( (fd_filemakerProDB = 
	  fopen("/web/d/www.dperception.com/cgi/db/tmp.mail"
		, "w"))
	 == NULL)
       { system("Mail -s filemakerProDBErr pkahn@dperception.com < ../db/FileOpenErr.text");
	 /* printf("FILE OPEN FAILED!!"); */
       }
    else { /* block until the file is available */
            flockfile(fd_filemakerProDB);
	   /* assemble the mailing information */
	   fprintf(fd_filemakerProDB, 
		   "From: DP-info@DPerception.com\n");
	   fprintf(fd_filemakerProDB, 
		   "Reply-to: DP-info@DPerception.com\n");	   
	   fprintf(fd_filemakerProDB, 
		   "Errors-to: DP-info@DPerception.com\n");
	   /* fprintf(fd_filemakerProDB, 
		      "Cc: pkahn@DPerception.com\n");   */
	   fprintf(fd_filemakerProDB, 
		   "Subject: Pricing info you requested from Directed Perception\n");
	   fprintf(fd_filemakerProDB, 
		   "To: %s\n\n", UserData.emailAddr);
	   fclose(fd_filemakerProDB);
	   /* now merge with the appropriate text */
	   if ( DomesticBuyer(UserData.emailAddr, UserData.Country) )
              system("cat /web/d/www.dperception.com/cgi/db/tmp.mail /web/d/www.dperception.com/cgi/db/USprices /web/d/www.dperception.com/cgi/db/inquirer.mail > /web/d/www.dperception.com/cgi/db/outbound-mail");
	   else
              system("cat /web/d/www.dperception.com/cgi/db/tmp.mail /web/d/www.dperception.com/cgi/db/INTERNprices /web/d/www.dperception.com/cgi/db/inquirer.mail > /web/d/www.dperception.com/cgi/db/outbound-mail");
	   status = system("/usr/lib/sendmail -t -oexm < /web/d/www.dperception.com/cgi/db/outbound-mail");
	   status = status >> 8; 
	   /* printf("<p>Status is %d<p>", status);  */

	   /* let others into the file */
	   funlockfile(fd_filemakerProDB); 
	   /* clean out the temporary files */
	   system("rm -f /web/d/www.dperception.com/cgi/db/tmp.mail /web/d/www.dperception.com/cgi/db/outbound-mail /web/d/www.dperception.com/cgi/db/inquirer.mail");  

	 }


    /***** if email addr worked OK, let them know the info is awaiting them,
           otherwise, ask them to email their request or contact the company */
    if (status == 0)
       { /* then the email address worked fine: thanks and notify them */
	 printf("<font size=+1><p>Directed Perception product pricing has been emailed to you at <b><font color=\"red\">%s</font></b>.<p>", UserData.emailAddr );
	 printf("If this email bounces, we will try to contact you by phone or FAX to answer your questions.<p>");
	 printf("Since it can take over 3 days for email to bounce, if you do not soon receive the pricing info by email, please <A HREF=\"http://www.dperception.com/dp_about.htm#DPcontacts\"><blink>contact us!</blink></A><p>");
	 printf("Thank you for the opportunity to answer your questions!");
       }
    else
      { /* then the email address is invalid, so let them know their choices:
	   correct it, email us, or call us */

	printf("<font size=+1>The mailer returned an error for email address <b>%s</b>.<p>",
	       UserData.emailAddr);
	printf("To obtain pricing information, please:");
	printf("<ul><li>Press the <blink>BACK</blink> button to correct your email address");
	printf("<li><A HREF=\"mailto:dp-info@dperception.com\">EMAIL US</A>  and tell us how we should send you pricing/availability information (e.g., mail, phone, FAX)");
	printf("<li><A HREF=\"http://www.dperception.com/dp_about.htm#DPcontacts\">CALL or MAIL US</A></ul>");
	printf("<br><p><font size=+1>We are very eager to quickly provide you with the pricing and availability information you seek.<font size=+0>");
      }
    
    /* wrap up the html feedback */
    printf("%s%s%s",
	   "<br clear=all><hr>",
	   "<A HREF=\"http://www.dperception.com\"><IMG IMAGE ALIGN=middle HSPACE=6 VSPACE=4 WIDTH=32 HEIGHT=30 BORDER=1 SRC=\"http://www.dperception.com/art/dp_icon.gif\"><b>DP</b>'s Home Page</A>",
	   "<br clear=all><hr><font size=-1><i>Currently surfing: http://www.DPerception.com/</I><P></BODY></HTML>");

 exit:

}






