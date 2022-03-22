# 2018-08-21  William A. Hudson
#
# Compile and run the main program.

# Outputs in $(BINDIR)/ and Inputs in $(OJ)/

SHELL      = /bin/sh
BINDIR     = ../bin
OJ         = ../obj
IH         = ./

		# the librgpio library
INCDIR     = ../librgpio/src
LIBDIR     = ../librgpio/lib
LIBS       = $(LIBDIR)/librgpio.a

		# all include files for main program dependency
INCS       = \
	$(IH)/Error.h \
	$(IH)/yOpVal.h \
	$(IH)/yOption.h \
	$(IH)/dNcOsc.h \
	$(IH)/dNcScaler.h \
	$(IH)/dNcWave.h

		# objects not including main()
OBJS       = \
	$(OJ)/Error.o \
	$(OJ)/yOpVal.o \
	$(OJ)/yOption.o \
	$(OJ)/dNcOsc.o \
	$(OJ)/dNcScaler.o \
	$(OJ)/dNcWave.o

		# link libraries, order matters
LIBFLAGS   = -lrgpio -lcap

		# compiler flags
	# -std=c++11  needed for std::stoi
CXXFLAGS   = -Wall  -std=c++11  -I $(IH)  -I $(INCDIR)


run:	compile
	$(BINDIR)/sine_mcp4822 --TESTOP

compile:  $(OJ)  $(BINDIR) \
	$(BINDIR)/sine_mcp4822 \
	$(BINDIR)/awave

cap:
	sudo  setcap 'CAP_DAC_OVERRIDE,CAP_SYS_RAWIO=p'  $(BINDIR)/awave

mkdirs:   $(OJ)  $(BINDIR)

clean:
	rm -f  $(OJ)/*.o

clobber:
	rm -f  $(BINDIR)/awave

$(BINDIR):
	mkdir -p  $(BINDIR)

$(OJ):
	mkdir -p  $(OJ)


$(BINDIR)/awave:	 awave.cpp  $(OBJS)  $(INCS)  $(LIBS)
	g++ $(CXXFLAGS) -o $@ -L $(LIBDIR) \
			 awave.cpp  $(OBJS)  $(LIBFLAGS)

$(BINDIR)/sine_mcp4822:	 sine_mcp4822.cpp  $(OBJS)  $(INCS)  $(LIBS)
	g++ $(CXXFLAGS) -o $@ -L $(LIBDIR) \
			 sine_mcp4822.cpp  $(OBJS)  $(LIBFLAGS)


$(OJ)/dNcOsc.o:		dNcOsc.cpp  dNcOsc.h  dNcWave.h
	g++ $(CXXFLAGS) -o $@  -c dNcOsc.cpp

$(OJ)/dNcScaler.o:	dNcScaler.cpp  dNcScaler.h
	g++ $(CXXFLAGS) -o $@  -c dNcScaler.cpp

$(OJ)/dNcWave.o:	dNcWave.cpp  dNcWave.h
	g++ $(CXXFLAGS) -o $@  -c dNcWave.cpp

$(OJ)/Error.o:		Error.cpp  Error.h
	g++ $(CXXFLAGS) -o $@  -c Error.cpp

$(OJ)/yOpVal.o:		yOpVal.cpp  yOpVal.h
	g++ $(CXXFLAGS) -o $@  -c yOpVal.cpp

$(OJ)/yOption.o:	yOption.cpp  yOption.h  Error.h
	g++ $(CXXFLAGS) -o $@  -c yOption.cpp

