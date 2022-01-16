# 2022-01-07  William A. Hudson
#
# Compile and run the main program.

# Outputs in $(BINDIR)/ and $(OJ)/

SHELL      = /bin/sh
BINDIR     = ../bin
OJ         = ../obj

		# the Netpbm library
NETPBM_ROOT = /opt/netpbm-sf-10.73.37
INCDIR     = $(NETPBM_ROOT)/usr/include
LIBDIR     = $(NETPBM_ROOT)/usr/lib
LIBS       = $(LIBDIR)/libnetpbm.a

		# common include dependencies
INCS       = \
	Error.h \
	yOpVal.h \
	yOption.h \
	$(LIBS)

		# objects not including main()
OBJS       = \
	$(OJ)/Error.o \
	$(OJ)/yOpVal.o \
	$(OJ)/yOption.o

		# link libraries, order matters
LIBFLAGS   = -lnetpbm

		# compiler flags
	# -std=c++11  needed for std::stoi
CXXFLAGS   = -Wall  -std=c++11  -I $(INCDIR)


run:	compile
	$(BINDIR)/pgm_box --TESTOP

compile:  $(OJ)  $(BINDIR)  $(BINDIR)/pgm_stats  $(BINDIR)/pgm_box

mkdirs:   $(OJ)  $(BINDIR)

clean:
	rm -f  $(OJ)/*

clobber:
	rm -f  $(OJ)/*
	rm -f  $(BINDIR)/pgm_stats
	rm -f  $(BINDIR)/pgm_box

$(BINDIR):
	mkdir -p  $(BINDIR)

$(OJ):
	mkdir -p  $(OJ)


$(BINDIR)/pgm_stats:	        $(OJ)/pgm_stats.o  $(OBJS)  $(LIBS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgm_stats.o  $(OBJS)  $(LIBS)

$(BINDIR)/pgm_box:	        $(OJ)/pgm_box.o  $(OBJS)  $(LIBS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgm_box.o  $(OBJS)  $(LIBS)


$(OJ)/pgm_stats.o:	pgm_stats.cpp  $(INCS)  $(YINCS)
	g++ $(CXXFLAGS) -o $@  -c pgm_stats.cpp

$(OJ)/pgm_box.o:	pgm_box.cpp  $(INCS)  $(YINCS)
	g++ $(CXXFLAGS) -o $@  -c pgm_box.cpp


$(OJ)/Error.o:		Error.cpp  Error.h
	g++ $(CXXFLAGS) -o $@  -c Error.cpp

$(OJ)/yOpVal.o:		yOpVal.cpp  yOpVal.h
	g++ $(CXXFLAGS) -o $@  -c yOpVal.cpp

$(OJ)/yOption.o:	yOption.cpp  yOption.h  Error.h
	g++ $(CXXFLAGS) -o $@  -c yOption.cpp

