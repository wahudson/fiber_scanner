# 2017-05-20  William A. Hudson
#
# Compile unit test library.

# Outputs in $(OJ)/

SHELL      = /bin/sh
OJ         = ../obj
#LIB        = ../lib

		# all include files for main program dependency
INCS       = \
        utLib1.h

		# objects not including main()
OBJS       = \
	$(OJ)/utLib1.o

		# compiler flags
CXXFLAGS   = -Wall  -std=c++11


compile:  $(OJ)  $(OBJS)

mkdirs:   $(OJ)

$(OJ):
	mkdir -p  $(OJ)

clean: 
	rm -f  $(OJ)/*

clobber:
	rm -f  $(OJ)/*


$(OJ)/utLib1.o:	utLib1.cpp  utLib1.h
	g++ $(CXXFLAGS) -o $@  -c utLib1.cpp

