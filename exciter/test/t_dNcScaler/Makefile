# 2017-05-19  William A. Hudson
#
# Compile and run this test.
# Use OBJS, but not build them.  Outputs in ./

SHELL      = /bin/sh
OJ         = ../../obj
IC         = ../../src

		# all include files for test program dependency
INCS       = \
	../src/utLib1.h \
	$(IC)/dNcScaler.h

		# objects not including main()
OBJS       = \
	../obj/utLib1.o \
	$(OJ)/dNcScaler.o

LIBS       = -lcap

		# compiler flags
CXXFLAGS   = -Wall -std=c++11  -I ../src


test:	test.exe
	./test.exe

clean:
	rm -f  test.exe

test.exe:	test.cpp  $(OBJS)  $(INCS)
	g++ $(CXXFLAGS) -I $(IC) -o $@  test.cpp  $(OBJS)  $(LIBS)

