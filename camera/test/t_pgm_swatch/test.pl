#! /usr/bin/perl -w
# 2022-02-02  William A. Hudson

# Testing:  pgm_swatch  command
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

# pgm_swatch no args - reads stdin

run_test( "12", "pgm_swatch help",
    "pgm_swatch --help",
    0,
    Stderr => q(),
);

run_test( "13", "unknown option",
    "pgm_swatch --foo",
    1,
    Stderr => q(
	Error:  unknown option:  --foo
    ),
    Stdout => q(),
);

run_test( "14", "file not found",
    "pgm_swatch Not.pgm",
    1,
    Stderr => q(
	Error:  file not found:  Not.pgm
    ),
    Stdout => q(),
);

run_test( "15", "no --geo option",
    "pgm_swatch ../blob.pgm",
    1,
    Stderr => q(
	Error:  zero width image:  --geo=0x0+0+0
    ),
    Stdout => q(),
);

run_test( "16", "no --geo option",
    "pgm_swatch -v ../blob.pgm",
    1,
    Stderr => q(
	Ncol   = 10
	Nrow   = 7
	Npix   = 70
	MaxVal = 255
	Error:  zero width image:  --geo=0x0+0+0
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
## Images
#---------------------------------------------------------------------------

run_test( "20", "blob image",
    "pgm_swatch -v --geo=5x3+4+2  ../blob.pgm",
    0,
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

