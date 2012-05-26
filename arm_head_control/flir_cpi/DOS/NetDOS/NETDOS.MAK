# Microsoft Visual C++ generated build script - Do not modify

PROJ = NETDOS
DEBUG = 1
PROGTYPE = 6
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = -d_DEBUG
R_RCDEFINES = -dNDEBUG
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = D:\PTUCPI~1\CPI108~1\DOS\NETDOS\
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
CFLAGS_D_DEXE = /nologo /G2 /W3 /Zi /AM /Od /D "_DEBUG" /D "_DOS" /U "_WIN16" /U "_WIN32" /FR /Fd"DOS.PDB"
CFLAGS_R_DEXE = /nologo /Gs /G2 /W3 /AM /Ox /D "NDEBUG" /D "_DOS" /U "_WIN16" /U "_WIN32" /FR 
LFLAGS_D_DEXE = /NOLOGO /NOI /FARCALL /STACK:5120 /ONERROR:NOEXE /CO 
LFLAGS_R_DEXE = /NOLOGO /NOI /STACK:5120 /ONERROR:NOEXE 
LIBS_D_DEXE = oldnames mlibce 
LIBS_R_DEXE = oldnames mlibce 
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_DEXE)
LFLAGS = $(LFLAGS_D_DEXE)
LIBS = $(LIBS_D_DEXE)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_DEXE)
LFLAGS = $(LFLAGS_R_DEXE)
LIBS = $(LIBS_R_DEXE)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = NETTEST.SBR \
		PTU.SBR \
		DOSSERIA.SBR


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


DOSSERIA_DEP = d:\ptucpi~1\cpi108~1\include\dosseria.h


all:	$(PROJ).EXE $(PROJ).BSC

NETTEST.OBJ:	..\..\CODE\NETTEST.C $(NETTEST_DEP)
	$(CC) $(CFLAGS) $(CCREATEPCHFLAG) /c ..\..\CODE\NETTEST.C

PTU.OBJ:	..\..\CODE\PTU.C $(PTU_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\..\CODE\PTU.C

DOSSERIA.OBJ:	..\..\CODE\DOSSERIA.C $(DOSSERIA_DEP)
	$(CC) $(CFLAGS) $(CUSEPCHFLAG) /c ..\..\CODE\DOSSERIA.C

$(PROJ).EXE::	NETTEST.OBJ PTU.OBJ DOSSERIA.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
NETTEST.OBJ +
PTU.OBJ +
DOSSERIA.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
d:\programs\msvc\lib\+
d:\programs\msvc\mfc\lib\+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
