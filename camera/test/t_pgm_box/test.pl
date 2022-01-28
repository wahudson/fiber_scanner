#! /usr/bin/perl -w
# 2022-01-26  William A. Hudson

# Testing:  pgm_box  command
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

run_test( "11", "pgm_box no args",
    "pgm_box",
    0,
    Stderr => q(),
    Stdout => q(),
);

run_test( "12", "pgm_box help",
    "pgm_box --help",
    0,
    Stderr => q(),
);

run_test( "13", "unknown option",
    "pgm_box --foo",
    1,
    Stderr => q(
	Error:  unknown option:  --foo
    ),
    Stdout => q(),
);

run_test( "14", "file not found",
    "pgm_box Not.pgm",
    1,
    Stderr => q(
	Error:  exception caught:  file not found:  Not.pgm
    ),
    Stdout => q(
	==> Not.pgm <==
    ),
);

#---------------------------------------------------------------------------
## Images
#---------------------------------------------------------------------------

run_test( "20", "single point",
    "pgm_box ../point.pgm",
    0,
    Stderr => q(),
);

run_test( "21", "blob image",
    "pgm_box --table ../blob.pgm",
    0,
    Stderr => q(),
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

