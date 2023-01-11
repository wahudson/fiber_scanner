# 2023-01-05  William A. Hudson
#
# Compile and run this test.
# Use OBJS, but not build them.  Outputs in ./

SHELL      = /bin/sh
OJ         = ../../obj
IC         = ../../src
LB         = ../../librgpio

		# all include files for test program dependency
INCS       = \
	../src/utLib1.h \
	$(LB)/lib/librgpio.a \
	$(IC)/extShift.h \
	$(IC)/uspi_mcp4822x.h

		# objects not including main()
OBJS       = \
	../obj/utLib1.o \
	$(OJ)/extShift.o \
	$(OJ)/uspi_mcp4822x.o

LIBS       = $(LB)/lib/librgpio.a  -lcap

		# compiler flags
CXXFLAGS   = -Wall -std=c++11  -I ../src -I $(IC) -I $(LB)/src


test:	test.exe
	./test.exe

clean:
	rm -f  test.exe

test.exe:	test.cpp  $(OBJS)  $(INCS)
	g++ $(CXXFLAGS) -o $@  test.cpp  $(OBJS)  $(LIBS)

