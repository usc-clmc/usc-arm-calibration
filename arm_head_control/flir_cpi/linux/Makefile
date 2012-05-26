SHELL = /bin/sh

#############################################################

PTU_HOME = $(abspath ..)

INCD = $(PTU_HOME)/include
SRCD = $(PTU_HOME)/code
OBJD = $(PTU_HOME)/linux/obj

CC = gcc
CFLAGS = -Werror -Wall -g -D_LINUX -D_POSIX_C_SOURCE=200112L -D_BSD_SOURCE -I$(INCD)

OBJS = $(OBJD)/ptu.o $(OBJD)/linuxser.o
TESTPTU_OBJS = $(OBJS) $(OBJD)/test.o
TEST_POS_OBJS = $(OBJS) $(OBJD)/test_pos.o

all: $(OBJD) testptu

$(OBJD):
	mkdir -p $(OBJD)

testptu: $(TESTPTU_OBJS)
	$(CC) $(CFLAGS) $(TESTPTU_OBJS) -o testptu -lm

$(OBJD)/test.o:  $(SRCD)/test.c
	$(CC) $(CFLAGS) -I$(INCD) -c $(SRCD)/test.c -o $(OBJD)/test.o

$(OBJD)/test_pos.o:  $(SRCD)/test_pos.c
	$(CC) $(CFLAGS) -I$(INCD) -c $(SRCD)/test_pos.c -o $(OBJD)/test_pos.o

$(OBJD)/ptu.o:  $(SRCD)/ptu.c $(INCD)/ptu.h
	$(CC) $(CFLAGS) -I$(INCD) -c $(SRCD)/ptu.c -o $(OBJD)/ptu.o

$(OBJD)/linuxser.o:  $(SRCD)/linuxser.c $(INCD)/linuxser.h
	$(CC) $(CFLAGS) -I$(INCD) -c $(SRCD)/linuxser.c -o $(OBJD)/linuxser.o

clean:
	-rm -f $(OBJD)/*.o core testptu
