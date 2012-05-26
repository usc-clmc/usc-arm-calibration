# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=NETwin32 - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to NETwin32 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "NETwin32 - Win32 Release" && "$(CFG)" !=\
 "NETwin32 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "NETwin32.mak" CFG="NETwin32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "NETwin32 - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "NETwin32 - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "NETwin32 - Win32 Debug"
RSC=rc.exe
CPP=cl.exe

!IF  "$(CFG)" == "NETwin32 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "$(OUTDIR)\NETwin32.exe"

CLEAN : 
	-@erase ".\Release\NETwin32.exe"
	-@erase ".\Release\PTU.OBJ"
	-@erase ".\Release\W32SERIA.OBJ"
	-@erase ".\Release\NETTEST.OBJ"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /GX /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /ML /W3 /GX /D "WIN32" /D "NDEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/NETwin32.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/NETwin32.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/NETwin32.pdb" /machine:I386 /out:"$(OUTDIR)/NETwin32.exe" 
LINK32_OBJS= \
	"$(INTDIR)/PTU.OBJ" \
	"$(INTDIR)/W32SERIA.OBJ" \
	"$(INTDIR)/NETTEST.OBJ"

"$(OUTDIR)\NETwin32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "NETwin32 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\NETwin32.exe" "$(OUTDIR)\NETwin32.bsc"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\Debug\NETwin32.bsc"
	-@erase ".\Debug\NETTEST.SBR"
	-@erase ".\Debug\PTU.SBR"
	-@erase ".\Debug\W32SERIA.SBR"
	-@erase ".\Debug\NETwin32.exe"
	-@erase ".\Debug\W32SERIA.OBJ"
	-@erase ".\Debug\NETTEST.OBJ"
	-@erase ".\Debug\PTU.OBJ"
	-@erase ".\Debug\NETwin32.ilk"
	-@erase ".\Debug\NETwin32.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /FR /YX /c
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /FR"$(INTDIR)/" /Fp"$(INTDIR)/NETwin32.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/"\
 /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\Debug/
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/NETwin32.bsc" 
BSC32_SBRS= \
	"$(INTDIR)/NETTEST.SBR" \
	"$(INTDIR)/PTU.SBR" \
	"$(INTDIR)/W32SERIA.SBR"

"$(OUTDIR)\NETwin32.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/NETwin32.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/NETwin32.exe" 
LINK32_OBJS= \
	"$(INTDIR)/W32SERIA.OBJ" \
	"$(INTDIR)/NETTEST.OBJ" \
	"$(INTDIR)/PTU.OBJ"

"$(OUTDIR)\NETwin32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "NETwin32 - Win32 Release"
# Name "NETwin32 - Win32 Debug"

!IF  "$(CFG)" == "NETwin32 - Win32 Release"

!ELSEIF  "$(CFG)" == "NETwin32 - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\NETTEST.C"
DEP_CPP_NETTE=\
	".\..\..\include\ptu.h"\
	".\..\..\include\W32SERIA.H"\
	".\..\..\include\W16SERIA.H"\
	".\..\..\include\DOSSERIA.H"\
	".\..\..\INCLUDE\linuxser.h"\
	".\..\..\include\opcodes.h"\
	
NODEP_CPP_NETTE=\
	".\..\..\CODE\ptu.h"\
	

!IF  "$(CFG)" == "NETwin32 - Win32 Release"


"$(INTDIR)\NETTEST.OBJ" : $(SOURCE) $(DEP_CPP_NETTE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "NETwin32 - Win32 Debug"


BuildCmds= \
	$(CPP) $(CPP_PROJ) $(SOURCE) \
	

"$(INTDIR)\NETTEST.OBJ" : $(SOURCE) $(DEP_CPP_NETTE) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\NETTEST.SBR" : $(SOURCE) $(DEP_CPP_NETTE) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\PTU.C"
DEP_CPP_PTU_C=\
	".\..\..\include\ptu.h"\
	".\..\..\include\W32SERIA.H"\
	".\..\..\include\W16SERIA.H"\
	".\..\..\include\DOSSERIA.H"\
	".\..\..\INCLUDE\linuxser.h"\
	".\..\..\include\opcodes.h"\
	

!IF  "$(CFG)" == "NETwin32 - Win32 Release"


"$(INTDIR)\PTU.OBJ" : $(SOURCE) $(DEP_CPP_PTU_C) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "NETwin32 - Win32 Debug"


BuildCmds= \
	$(CPP) $(CPP_PROJ) $(SOURCE) \
	

"$(INTDIR)\PTU.OBJ" : $(SOURCE) $(DEP_CPP_PTU_C) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\PTU.SBR" : $(SOURCE) $(DEP_CPP_PTU_C) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\W32SERIA.C"

!IF  "$(CFG)" == "NETwin32 - Win32 Release"

DEP_CPP_W32SE=\
	".\..\..\include\W32SERIA.H"\
	

"$(INTDIR)\W32SERIA.OBJ" : $(SOURCE) $(DEP_CPP_W32SE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "NETwin32 - Win32 Debug"

DEP_CPP_W32SE=\
	".\..\..\include\W32SERIA.H"\
	
NODEP_CPP_W32SE=\
	".\..\..\CODE\SetSerial"\
	

BuildCmds= \
	$(CPP) $(CPP_PROJ) $(SOURCE) \
	

"$(INTDIR)\W32SERIA.OBJ" : $(SOURCE) $(DEP_CPP_W32SE) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\W32SERIA.SBR" : $(SOURCE) $(DEP_CPP_W32SE) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
