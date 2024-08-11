#! /usr/bin/perl -w
# 2024-08-09  William A. Hudson

# Testing:  numbin - Linearize cosine scan data with a bin map.
#    10-19  .
#    20-29  .
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
## numbin basic options --help
#---------------------------------------------------------------------------

#!! numbin  with no args waits on stdin

run_test( "11", "numbin -n",
    "numbin -n",
    0,
    Stderr => q(
	Nxi      =       40
	Nxi2     =       20
	Nxb      =       20
	bx2      =  0.05000
    ),
    Stdout => q(),
);

run_test( "12", "numbin help",
    "numbin --help",
    0,
    Stderr => q(),
);

run_test( "13", "numbin bad --xxx",
    "numbin --xxx",
    2,
    Stderr => q(
	Unknown option: xxx
	Error:  Type 'numbin --help' for usage.
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
# Map generation
#---------------------------------------------------------------------------

run_test( "20", "numbin -n --map",
    "numbin -n --map --nxi=20 --nxb=10",
    0,
    Stderr => q(
	Nxi      =       20
	Nxi2     =       10
	Nxb      =       10
	bx2      =  0.10000
    ),
);

run_test( "20b", "numbin odd Nxi, Error",
    "numbin -n --map --nxi=21 --nxb=10",
    1,
    Stderr => q(
	Error:  Require --nxi divisible by 2:  21
	Nxi      =       21
	Nxi2     =       10
	Nxb      =       10
	bx2      =  0.10000
	Use of uninitialized value in printf at /home/wah/pro/fiber_scanner/niDAQ/test/t_numbin/../bin/numbin line 158.
    ),
);

run_test( "21", "numbin -n --map",
    "( numbin -n --map --nxi=40 --nxb=10 2>&1 )",
    0,
    Stderr => q(),
);

run_test( "22", "numbin -n --map",
    "( numbin -n --map --nxi=40 --nxb=9 2>&1 )",
    0,
    Stderr => q(),
);

run_test( "23", "numbin odd Nxi, Error",
    "( numbin -n --map --nxi=41 --nxb=10 2>&1 )",
    1,
    Stderr => q(),
);

run_test( "24", "numbin odd Nxi, Error",
    "( numbin -n --map --nxi=41 --nxb=9 2>&1 )",
    1,
    Stderr => q(),
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

