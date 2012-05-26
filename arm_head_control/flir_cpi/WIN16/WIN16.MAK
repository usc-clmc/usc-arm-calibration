# Microsoft Visual C++ generated build script - Do not modify

PROJ = WIN16
DEBUG = 1
PROGTYPE = 3
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = /d_DEBUG 
R_RCDEFINES = /dNDEBUG 
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = D:\PTUCPI~1\CPI108~1\WIN16\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = PTU.C       
FIRSTCPP =             
RC = rc
CFLAGS_D_WTTY = /nologo /G2 /Mq /W3 /Zi /AM /Od /D "_DEBUG" /D "_WIN16" /U "_WIN32" /FR /Fd"WIN16.PDB"
CFLAGS_R_WTTY = /nologo /Gs /G2 /Mq /W3 /AM /Ox /D "NDEBUG" /FR 
LFLAGS_D_WTTY = /NOLOGO /ONERROR:NOEXE /NOD /PACKC:57344 /CO /ALIGN:16
LFLAGS_R_WTTY = /NOLOGO /ONERROR:NOEXE /NOD /PACKC:57344 /ALIGN:16
LIBS_D_WTTY = oldnames libw mlibcewq
LIBS_R_WTTY = oldnames libw mlibcewq
RCFLAGS = /nologo 
RESFLAGS = /nologo 
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_WTTY)
LFLAGS = $(LFLAGS_D_WTTY)
LIBS = $(LIBS_D_WTTY)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
DEFFILE=D:\PROGRAMS\MSVC\BIN\CL.DEF
!else
CFLAGS = $(CFLAGS_R_WTTY)
LFLAGS = $(LFLAGS_R_WTTY)
LIBS = $(LIBS_R_WTTY)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
DEFFILE=D:\PROGRAMS\MSVC\BIN\CL.DEF
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = PTU.SBR \
		W16SERIA.SBR \
		TEST.SBR


PTU_DEP = d:\ptucpi~1\cpi108~1\include\ptu.h \
	d:\ptucpi~1\cpi108~1\include\opcodes.h


W16SERIA_DEP = d:\ptucpi~1\cpi108~1\include\w16seria.h


TEST_DEP = d:\ptucpi~1\cpi108~1\include\ptu.h \
	d:\ptucpi~1\cpi108~1\include\opcodes.h


all:	$(PROJ).EXE $(PROJ).BSC

PTU.OBJ:	..\CODE\PTU.C $(PTU_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ..\CODE\PTU.C

W16SERIA.OBJ:	..\CODE\W16SERIA.C $(W16SERIA_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\CODE\W16SERIA.C

TEST.OBJ:	..\CODE\TEST.C $(TEST_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\CODE\TEST.C


$(PROJ).EXE::	PTU.OBJ W16SERIA.OBJ TEST.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
PTU.OBJ +
W16SERIA.OBJ +
TEST.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
d:\programs\msvc\lib\+
d:\programs\msvc\mfc\lib\+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF
	$(RC) $(RESFLAGS) $@


run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
