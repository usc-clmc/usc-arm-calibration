# Microsoft Visual C++ generated build script - Do not modify

PROJ = NETWIN16
DEBUG = 1
PROGTYPE = 3
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = /d_DEBUG /d_WIN16 
R_RCDEFINES = /dNDEBUG /d_WIN16 
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = D:\PTUCPI~1\CPI108~1\WIN16\NETWIN16\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC = NETTEST.C   
FIRSTCPP =             
RC = rc
CFLAGS_D_WTTY = /nologo /G2 /Mq /W3 /Zi /AM /Od /D "_DEBUG" /D "_WIN16" /U "_WIN32" /I "..\..\INCLUDE" /FR /Fd"NETWIN16.PDB"
CFLAGS_R_WTTY = /nologo /Gs /G2 /Mq /W3 /AM /Ox /D "NDEBUG" /FR 
LFLAGS_D_WTTY = /NOLOGO /PACKC:57344 /ALIGN:16 /ONERROR:NOEXE /CO 
LFLAGS_R_WTTY = /NOLOGO /NOD /PACKC:57344 /ALIGN:16 /ONERROR:NOEXE 
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
SBRS = NETTEST.SBR \
		PTU.SBR \
		W16SERIA.SBR


NETTEST_DEP = d:\ptucpi~1\cpi108~1\include\ptu.h \
	d:\ptucpi~1\cpi108~1\include\w32seria.h \
	d:\ptucpi~1\cpi108~1\include\w16seria.h \
	d:\ptucpi~1\cpi108~1\include\dosseria.h \
	d:\ptucpi~1\cpi108~1\include\linuxser.h \
	d:\ptucpi~1\cpi108~1\include/opcodes.h \
	d:\ptucpi~1\cpi108~1\include\opcodes.h


PTU_DEP = d:\ptucpi~1\cpi108~1\include/ptu.h \
	d:\ptucpi~1\cpi108~1\include\w32seria.h \
	d:\ptucpi~1\cpi108~1\include\w16seria.h \
	d:\ptucpi~1\cpi108~1\include\dosseria.h \
	d:\ptucpi~1\cpi108~1\include/\linuxser.h \
	d:\ptucpi~1\cpi108~1\include/opcodes.h \
	d:\ptucpi~1\cpi108~1\include\opcodes.h \
	d:\ptucpi~1\cpi108~1\include\ptu.h \
	d:\ptucpi~1\cpi108~1\include\linuxser.h


W16SERIA_DEP = d:\ptucpi~1\cpi108~1\include\w16seria.h


all:	$(PROJ).EXE $(PROJ).BSC

NETTEST.OBJ:	..\..\CODE\NETTEST.C $(NETTEST_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ..\..\CODE\NETTEST.C

PTU.OBJ:	..\..\CODE\PTU.C $(PTU_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\..\CODE\PTU.C

W16SERIA.OBJ:	..\..\CODE\W16SERIA.C $(W16SERIA_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\..\CODE\W16SERIA.C


$(PROJ).EXE::	NETTEST.OBJ PTU.OBJ W16SERIA.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
NETTEST.OBJ +
PTU.OBJ +
W16SERIA.OBJ +
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
