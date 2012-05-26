# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=Win32 - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Win32 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Win32 - Win32 Release" && "$(CFG)" != "Win32 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "WIN32.MAK" CFG="Win32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Win32 - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Win32 - Win32 Debug" (based on "Win32 (x86) Console Application")
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
# PROP Target_Last_Scanned "Win32 - Win32 Debug"
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Win32 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "."
# PROP Intermediate_Dir ".\TMP\"
# PROP Target_Dir ""
OUTDIR=.\.
INTDIR=.\.\TMP

ALL : "$(OUTDIR)\WIN32.exe"

CLEAN : 
	-@erase ".\TMP\vc40.pdb"
	-@erase ".\WIN32.exe"
	-@erase ".\TMP\TEST.OBJ"
	-@erase ".\TMP\W32SERIA.OBJ"
	-@erase ".\TMP\PTU.OBJ"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

# ADD BASE CPP /nologo /W3 /GX /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /GX /Zi /D "NDEBUG" /D "_WIN32" /D "_CONSOLE" /U "_WIN16" /U "_DOS" /U "_UNIX" /YX /c
CPP_PROJ=/nologo /ML /W3 /GX /Zi /D "NDEBUG" /D "_WIN32" /D "_CONSOLE" /U\
 "_WIN16" /U "_DOS" /U "_UNIX" /Fp"$(INTDIR)/WIN32.pch" /YX /Fo"$(INTDIR)/"\
 /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\.\TMP\ 
CPP_SBRS=
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/WIN32.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/WIN32.pdb" /machine:I386 /out:"$(OUTDIR)/WIN32.exe" 
LINK32_OBJS= \
	"$(INTDIR)/TEST.OBJ" \
	"$(INTDIR)/W32SERIA.OBJ" \
	"$(INTDIR)/PTU.OBJ"

"$(OUTDIR)\WIN32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Win32 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "."
# PROP Intermediate_Dir ".\TMP\"
# PROP Target_Dir ""
OUTDIR=.\.
INTDIR=.\.\TMP

ALL : "$(OUTDIR)\WIN32.exe" "$(OUTDIR)\WIN32.bsc"

CLEAN : 
	-@erase ".\TMP\vc40.pdb"
	-@erase ".\TMP\vc40.idb"
	-@erase ".\WIN32.bsc"
	-@erase ".\TMP\TEST.SBR"
	-@erase ".\TMP\W32SERIA.SBR"
	-@erase ".\TMP\PTU.SBR"
	-@erase ".\WIN32.exe"
	-@erase ".\TMP\TEST.OBJ"
	-@erase ".\TMP\W32SERIA.OBJ"
	-@erase ".\TMP\PTU.OBJ"
	-@erase ".\WIN32.ilk"
	-@erase ".\WIN32.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

"$(INTDIR)" :
    if not exist "$(INTDIR)/$(NULL)" mkdir "$(INTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W3 /Gm /GX /Zi /Od /D "_DEBUG" /D "_WIN32" /D "_CONSOLE" /U "_WIN16" /U "_DOS" /U "_UNIX" /FR /YX /c
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "_DEBUG" /D "_WIN32" /D "_CONSOLE"\
 /U "_WIN16" /U "_DOS" /U "_UNIX" /FR"$(INTDIR)/" /Fp"$(INTDIR)/WIN32.pch" /YX\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\.\TMP\ 
CPP_SBRS=.\.\TMP\ 
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/WIN32.bsc" 
BSC32_SBRS= \
	"$(INTDIR)/TEST.SBR" \
	"$(INTDIR)/W32SERIA.SBR" \
	"$(INTDIR)/PTU.SBR"

"$(OUTDIR)\WIN32.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/WIN32.pdb" /debug /machine:I386 /out:"$(OUTDIR)/WIN32.exe" 
LINK32_OBJS= \
	"$(INTDIR)/TEST.OBJ" \
	"$(INTDIR)/W32SERIA.OBJ" \
	"$(INTDIR)/PTU.OBJ"

"$(OUTDIR)\WIN32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Win32 - Win32 Release"
# Name "Win32 - Win32 Debug"

!IF  "$(CFG)" == "Win32 - Win32 Release"

!ELSEIF  "$(CFG)" == "Win32 - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\PTU.C"

!IF  "$(CFG)" == "Win32 - Win32 Release"

DEP_CPP_PTU_C=\
	".\..\include\ptu.h"\
	".\..\INCLUDE\W32SERIA.H"\
	".\..\include\W16SERIA.H"\
	".\..\include\DOSSERIA.H"\
	".\..\INCLUDE\linuxser.h"\
	".\..\include\opcodes.h"\
	
NODEP_CPP_PTU_C=\
	".\..\CODE\FlushInputBuffer"\
	".\..\CODE\SerialBytesOut"\
	".\..\CODE\firmware_version_OK"\
	

"$(INTDIR)\PTU.OBJ" : $(SOURCE) $(DEP_CPP_PTU_C) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "Win32 - Win32 Debug"

DEP_CPP_PTU_C=\
	".\..\include\ptu.h"\
	".\..\INCLUDE\W32SERIA.H"\
	".\..\include\W16SERIA.H"\
	".\..\include\DOSSERIA.H"\
	".\..\INCLUDE\linuxser.h"\
	".\..\include\opcodes.h"\
	

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

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\TEST.C"
DEP_CPP_TEST_=\
	".\..\include\ptu.h"\
	".\..\INCLUDE\W32SERIA.H"\
	".\..\include\W16SERIA.H"\
	".\..\include\DOSSERIA.H"\
	".\..\INCLUDE\linuxser.h"\
	".\..\include\opcodes.h"\
	
NODEP_CPP_TEST_=\
	".\..\CODE\ptu.h"\
	

!IF  "$(CFG)" == "Win32 - Win32 Release"


"$(INTDIR)\TEST.OBJ" : $(SOURCE) $(DEP_CPP_TEST_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "Win32 - Win32 Debug"


BuildCmds= \
	$(CPP) $(CPP_PROJ) $(SOURCE) \
	

"$(INTDIR)\TEST.OBJ" : $(SOURCE) $(DEP_CPP_TEST_) "$(INTDIR)"
   $(BuildCmds)

"$(INTDIR)\TEST.SBR" : $(SOURCE) $(DEP_CPP_TEST_) "$(INTDIR)"
   $(BuildCmds)

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE="\PTU CPI Development\Cpi10800v0\CODE\W32SERIA.C"

!IF  "$(CFG)" == "Win32 - Win32 Release"

DEP_CPP_W32SE=\
	".\..\INCLUDE\W32SERIA.H"\
	
NODEP_CPP_W32SE=\
	".\..\CODE\cbInQue"\
	".\..\CODE\portstream"\
	".\..\CODE\ClearCommError"\
	

"$(INTDIR)\W32SERIA.OBJ" : $(SOURCE) $(DEP_CPP_W32SE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "Win32 - Win32 Debug"

DEP_CPP_W32SE=\
	".\..\INCLUDE\W32SERIA.H"\
	

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
