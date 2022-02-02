# 2022-01-18  William A. Hudson
#
# Compile and run this test.
# Use OBJS, but not build them.  Outputs in ./

SHELL      = /bin/sh
OJ         = ../../obj
IC         = ../../src
LB         = ../../lib

		# all include files for test program dependency
INCS       = \
	../src/utLib1.h \
	$(IC)/gmGeoSpec.h

		# objects not including main()
OBJS       = ../obj/utLib1.o

LIBS       = $(LB)/libgmlocal.a  ../netpbm/usr/lib/libnetpbm.a

		# compiler flags
CXXFLAGS   = -Wall -std=c++11  -I ../src


test:	test.exe
	./test.exe

clean:
	rm -f  test.exe

test.exe:	test.cpp  $(OBJS)  $(INCS)  $(LIBS)
	g++ $(CXXFLAGS) -I $(IC) -o $@  test.cpp  $(OBJS)  $(LIBS)

