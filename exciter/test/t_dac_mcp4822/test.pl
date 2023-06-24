#! /usr/bin/perl -w
# 2023-01-21  William A. Hudson

# Testing:  dac_mcp4822  main program.
#    10-19  basic options --help
#    20-29  -a -b Arg values
#    30-39  --shutdown
#    40-49  --csv
#    50-59  --raw

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
## dac_mcp4822 basic options --help
#---------------------------------------------------------------------------

run_test( "10", "no args",
    "dac_mcp4822",
    1,
    Stderr => q(
	Error:  require argv or --csv or --raw or --shutdown
    ),
    Stdout => q(),
);

run_test( "11", "only argv",
    "dac_mcp4822  0",
    1,
    Stderr => q(
	Error:  argv requires -a or -b
    ),
    Stdout => q(),
);

run_test( "12", "help",
    "dac_mcp4822 --help",
    0,
    Stderr => q(),
);

run_test( "13", "bad option --baad",
    "dac_mcp4822 --baad",
    1,
    Stderr => q(
	Error:  unknown option:  --baad
	Error:  require argv or --csv or --raw or --shutdown
    ),
    Stdout => q(),
);

run_test( "14", "bad gain",
    "dac_mcp4822  --gain1x --gain2x -a 0,0",
    1,
    Stderr => q(
	Error:  require only one of:  --gain1x, --gain2x
    ),
    Stdout => q(),
);

run_test( "19", "dac_mcp4822 --TESTOP",
    "dac_mcp4822 --TESTOP -a 0,0",
    0,
    Stderr => q(),
    Stdout => q(
	--csv         = 0
	--raw         = 0
	-a            = 1
	-b            = 0
	--gain1x      = 0
	--gain2x      = 0
	--shutdown    = 0
	--warm        = 5000000
	--verbose     = 0
	--debug       = 0
	arg:          = 0,0
    ),
);

#---------------------------------------------------------------------------
# -a -b Arg values
#---------------------------------------------------------------------------

#---------------------------------------
run_test( "20a", "good --gain2x",
    "dac_mcp4822 -v --gain2x -a -b 0,0",
    0,
    Stderr => q(
	Using Fake memory
    ),
    Stdout => q(
	+ 0x10000000
	+ 0x90000000
    ),
);

run_test( "20b", "good --gain1x",
    "dac_mcp4822 -v --gain1x -a -b 0,0",
    0,
    Stderr => q(
	Using Fake memory
    ),
    Stdout => q(
	+ 0x30000000
	+ 0xb0000000
    ),
);

#---------------------------------------
run_test( "21a", "good -a",
    "dac_mcp4822 -v -a 0,0  4095,0xffff",
    0,
    Stderr => q(
	Using Fake memory
    ),
    Stdout => q(
	+ 0x30000000
	+ 0x3fffffff
    ),
);

run_test( "21b", "good -b",
    "dac_mcp4822 -v -b 0,0  4095,0xffff",
    0,
    Stderr => q(
	Using Fake memory
    ),
    Stdout => q(
	+ 0xb0000000
	+ 0xbfffffff
    ),
);

run_test( "21c", "good -a -b",
    "dac_mcp4822 -v -a -b 0,0  4095,0xffff",
    0,
    Stderr => q(
	Using Fake memory
    ),
    Stdout => q(
	+ 0x30000000
	+ 0xb0000000
	+ 0x3fffffff
	+ 0xbfffffff
    ),
);

#---------------------------------------
run_test( "23", "bad vdac value",
    "dac_mcp4822 -a 4096,0x0000",
    1,
    Stderr => q(
	Using Fake memory
	Error:  DAC value too large:  4096
    ),
    Stdout => q(),
);

run_test( "24", "bad ExData value",
    "dac_mcp4822 -a 0,0x10000",
    1,
    Stderr => q(
	Using Fake memory
	Error:  ext shift too large:  0x10000
    ),
    Stdout => q(),
);

#---------------------------------------
run_test( "25", "bad argv",
    "dac_mcp4822 -a 4096",
    1,
    Stderr => q(
	Using Fake memory
	Error:  expected ',' in arg:  4096
    ),
    Stdout => q(),
);

run_test( "26", "bad argv",
    "dac_mcp4822 -a 4096,0xffz",
    1,
    Stderr => q(
	Using Fake memory
	Error:  extra chars in arg:  4096,0xffz
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
# --shutdown
#---------------------------------------------------------------------------

run_test( "30", "good --shutdown",
    "dac_mcp4822 -v --shutdown",
    0,
    Stderr => q(
	Using Fake memory
	shutdown A
	shutdown B
    ),
    Stdout => q(
	+ 0x28000000
	+ 0xa8000000
    ),
);

run_test( "31", "good --shutdown",
    "dac_mcp4822 -v -a --shutdown",
    0,
    Stderr => q(
	Using Fake memory
	shutdown A
    ),
    Stdout => q(
	+ 0x28000000
    ),
);

run_test( "32", "--shutdown output vdac, repeat ExData",
    "dac_mcp4822 -v -a --shutdown  0x111,0xabba",
    0,
    Stderr => q(
	Using Fake memory
	shutdown A
    ),
    Stdout => q(
	+ 0x3111abba
	+ 0x2800abba
    ),
);


#---------------------------------------------------------------------------
# --csv
#---------------------------------------------------------------------------

run_test( "40", "good --csv",
    "echo 'a,0x555,0xcccc' | dac_mcp4822 --TESTMODE -v --csv",
    0,
    Stderr => q(),
    Stdout => q(
	+ 0x2555cccc
    ),
);

run_test( "41", "bad --csv",
    "echo 'c,0x555,0xcccc' | dac_mcp4822 --TESTMODE -v --csv",
    1,
    Stderr => q(
	Error:  bad channel letter:  c
    ),
    Stdout => q(),
);

run_test( "42", "bad --csv",
    "echo 'a 0x555,0xcccc' | dac_mcp4822 --TESTMODE -v --csv",
    1,
    Stderr => q(
	Error:  bad input:  a 0x555,0xcccc
    ),
    Stdout => q(),
);

run_test( "43", "bad --csv",
    "echo 'a,0x555 0xcccc' | dac_mcp4822 --TESTMODE -v --csv",
    1,
    Stderr => q(
	Error:  bad input:  a,0x555 0xcccc
    ),
    Stdout => q(),
);

#!!
run_test( "44", "--csv extra chars not detected",
    "echo 'a,0x555,0xccccZYX' | dac_mcp4822 --TESTMODE -v --csv",
    0,
    Stderr => q(),
    Stdout => q(
	+ 0x2555cccc
    ),
);

run_test( "45", "good --csv",
    "dac_mcp4822 --TESTMODE -v --csv < ../ref/in.csv",
    0,
    Stderr => q(),
    Stdout => q(
	+ 0x2000aaaa
	+ 0xa000bbbb
	+ 0xa7ff00bb
	+ 0x27ff00aa
    ),
);

#---------------------------------------------------------------------------
# --raw
#---------------------------------------------------------------------------

run_test( "50", "good --raw",
    "echo '0x3abbfeed' | dac_mcp4822 --TESTMODE -v --raw",
    0,
    Stderr => q(),
    Stdout => q(
	+ 0x3abbfeed
    ),
);

run_test( "51", "bad --raw",
    "echo 'x3abbfeed' | dac_mcp4822 --TESTMODE -v --raw",
    1,
    Stderr => q(
	Error:  bad input:  x3abbfeed
    ),
    Stdout => q(),
);


#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

