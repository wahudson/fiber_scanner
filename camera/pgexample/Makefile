# 2022-01-06  William A. Hudson
#
# Compile a example program.

BINDIR     = .
OJ         = .

NETPBM_ROOT = /opt/netpbm-sf-10.73.37

INCD       = $(NETPBM_ROOT)/usr/include

LIBDIR     = $(NETPBM_ROOT)/usr/lib
LIBS       = $(LIBDIR)/libnetpbm.a

		# link libraries, order matters
LIBFLAGS   = -lnetpbm

CXXFLAGS   = -Wall

run	: compile
	$(BINDIR)/pgexample

compile	: $(BINDIR)/pgexample

clobber:
	rm $(BINDIR)/pgexample $(OJ)/pgexample.o

$(BINDIR)/pgexample:  $(OJ)/pgexample.o
	# g++ -o $@ -L $(LIBDIR)  $(OJ)/pgexample.o  $(LIBFLAGS)
	g++ -o $@ -L $(LIBDIR)  $(OJ)/pgexample.o  $(LIBS)

$(OJ)/pgexample.o:		pgexample.c
	g++ $(CXXFLAGS) -I $(INCD) -o $@  -c pgexample.c


