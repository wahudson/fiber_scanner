#! /usr/bin/perl -w
# 2022-02-12  William A. Hudson

# Testing:  pgm_width  command
#    10-19  basic options --help
#    20-29  Images
#    30-39  .
#    40-49  .
#    50-59  .

# usage:  ./test.pl
# files:
#    ./tmp/	run directory, all files written here
#    ./ref/	reference input/output files
#
#---------------------------------------------------------------------------

use lib "../lib";
use lib "../..";

use TestLib2 ( '1.01',
    'Error',
    'die_Error',
#   'here_text',
    'End_test',
    'run_test',
);

use strict;

print( "PATH=$ENV{PATH}\n" );


#---------------------------------------------------------------------------
# Configure working directory.
#---------------------------------------------------------------------------

chdir( "tmp" ) || die_Error( "cannot chdir ./tmp\n" );


#---------------------------------------------------------------------------
## basic options --help
#---------------------------------------------------------------------------

# pgm_width no args - reads stdin

run_test( "12", "pgm_width help",
    "pgm_width --help",
    0,
    Stderr => q(),
);

run_test( "13", "unknown option",
    "pgm_width --foo",
    1,
    Stderr => q(
	Error:  unknown option:  --foo
    ),
    Stdout => q(),
);

run_test( "14", "file not found",
    "pgm_width Not.pgm",
    1,
    Stderr => q(
	Error:  file not found:  Not.pgm
    ),
    Stdout => q(),
);

#---------------------------------------
run_test( "15a", "good --xy option",
    "pgm_width --xy=2,3 --TESTOP  not.pgm",
    0,
    Stderr => q(),
    Stdout => q(
	--geo         = WxH+X+Y
	--sub         = 0
	--level       = 0
	--xy          = 2,3
	--verbose     = 0
	--debug       = 0
	Px            = 2
	Py            = 3
	arg:          = not.pgm
    ),
);

run_test( "15b", "bad --xy option",
    "pgm_width --xy=3  not.pgm",
    1,
    Stderr => q(
	Error:  bad --xy=X,Y value:  3
    ),
    Stdout => q(),
);

run_test( "15c", "bad --xy option",
    "pgm_width --xy=0,-1  not.pgm",
    1,
    Stderr => q(
	Error:  bad --xy=X,Y value:  0,-1
    ),
    Stdout => q(),
);

run_test( "15d", "bad --xy option",
    "pgm_width --xy=-2,2  not.pgm",
    1,
    Stderr => q(
	Error:  bad --xy=X,Y value:  -2,2
    ),
    Stdout => q(),
);


#---------------------------------------------------------------------------
## Images
#---------------------------------------------------------------------------

run_test( "20", "blob image",
    "pgm_width  ../blob.pgm",
    0,
    Stderr => q(),
);

run_test( "21", "spot image, default",
    "pgm_width  ../spot.pgm",
    0,
    Stderr => q(),
);

run_test( "22", "spot image, spec as default",
    "pgm_width --xy=5,6 --level=49 ../spot.pgm",
    0,
    Stderr => q(),
);

run_test( "23", "spot image",
    "pgm_width --xy=3,4 --level=20 ../spot.pgm",
    0,
    Stderr => q(),
    Stdout => q(
	Ncol   = 12
	Nrow   = 13
	Npix   = 156
	MaxVal = 255
	Max    = 98
	Min    = 0
	Mean   = 9.54487
	SD     = 18.4051
	CGxy   = (5,6)
	Pxy    = (3,4)  	--xy
	Zlevel = 20		--level
	Ya     =    4
	Yb     =    8
	Ywidth =    4
	Xa     =    3
	Xb     =    7
	Xwidth =    4
    ),
    # tabs in output
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

