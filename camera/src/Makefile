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
	gmBox.h \
	gmGeoSpec.h \
	gmNetpgm.h \
	gmStats.h \
	$(LIBS)

		# objects not including main()  #!! maybe split out gm*.o
OBJS       = \
	$(OJ)/gmBox.o \
	$(OJ)/gmGeoSpec.o \
	$(OJ)/gmNetpgm.o \
	$(OJ)/gmStats.o \
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

compile:  $(OJ)  $(BINDIR)  ../lib/libgmlocal.a \
	$(BINDIR)/pgm_stats \
	$(BINDIR)/pgm_box \
	$(BINDIR)/pgm_swatch

mkdirs:   $(OJ)  $(BINDIR)

clean:
	rm -f  $(OJ)/*

clobber:
	rm -f  $(OJ)/*
	rm -f  ../lib/libgmlocal.a
	rm -f  $(BINDIR)/pgm_stats
	rm -f  $(BINDIR)/pgm_box
	rm -f  $(BINDIR)/pgm_swatch

$(BINDIR):
	mkdir -p  $(BINDIR)

$(OJ):
	mkdir -p  $(OJ)


../lib/libgmlocal.a:   $(OBJS)
	rm -f    ../lib/libgmlocal.a
	ar -rcs  ../lib/libgmlocal.a  $(OBJS)


$(BINDIR)/pgm_stats:	        $(OJ)/pgm_stats.o  $(OBJS)  $(LIBS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgm_stats.o  $(OBJS)  $(LIBS)

$(BINDIR)/pgm_box:	        $(OJ)/pgm_box.o  $(OBJS)  $(LIBS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgm_box.o  $(OBJS)  $(LIBS)

$(BINDIR)/pgm_swatch:	        $(OJ)/pgm_swatch.o  $(OBJS)  $(LIBS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgm_swatch.o  $(OBJS)  $(LIBS)


$(OJ)/pgm_stats.o:	pgm_stats.cpp  $(INCS)
	g++ $(CXXFLAGS) -o $@  -c pgm_stats.cpp

$(OJ)/pgm_box.o:	pgm_box.cpp  $(INCS)
	g++ $(CXXFLAGS) -o $@  -c pgm_box.cpp

$(OJ)/pgm_swatch.o:	pgm_swatch.cpp  $(INCS)
	g++ $(CXXFLAGS) -o $@  -c pgm_swatch.cpp


$(OJ)/gmBox.o:	gmBox.cpp  gmBox.h
	g++ $(CXXFLAGS) -o $@  -c gmBox.cpp

$(OJ)/gmGeoSpec.o:	gmGeoSpec.cpp  gmGeoSpec.h
	g++ $(CXXFLAGS) -o $@  -c gmGeoSpec.cpp

$(OJ)/gmNetpgm.o:	gmNetpgm.cpp  gmNetpgm.h
	g++ $(CXXFLAGS) -o $@  -c gmNetpgm.cpp

$(OJ)/gmStats.o:	gmStats.cpp  gmStats.h
	g++ $(CXXFLAGS) -o $@  -c gmStats.cpp

$(OJ)/Error.o:		Error.cpp  Error.h
	g++ $(CXXFLAGS) -o $@  -c Error.cpp

$(OJ)/yOpVal.o:		yOpVal.cpp  yOpVal.h
	g++ $(CXXFLAGS) -o $@  -c yOpVal.cpp

$(OJ)/yOption.o:	yOption.cpp  yOption.h  Error.h
	g++ $(CXXFLAGS) -o $@  -c yOption.cpp

