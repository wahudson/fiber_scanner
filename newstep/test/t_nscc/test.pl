#! /usr/bin/perl -w
# 2025-01-01  William A. Hudson

# Testing:  nscc  command
#    10-19  basic options --help
#    20-29  TESTMODE Operation
#    30-39  Default address and command
#    40-49  .
#    50-59  .

# usage:  ./test.pl
# files:
#    ./tmp/	run directory, all files written here
#    ./ref/	reference input/output files
#
# Slow execution!  0.1 second delay per command.
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

$ENV{NSC200_DEV} = "/dev/null";		# serial port not used

#---------------------------------------------------------------------------
# Configure working directory.
#---------------------------------------------------------------------------

chdir( "tmp" ) || die_Error( "cannot chdir ./tmp\n" );


#---------------------------------------------------------------------------
## basic options --help
#---------------------------------------------------------------------------

run_test( "11", "nscc no args - reading /dev/null",
    "nscc",
    1,
    Stderr => q(
	Error:  no error status returned
    ),
    Stdout => q(),
);

run_test( "11", "missing env NSC200_DEV",
    "NSC200_DEV=''  nscc",
    1,
    Stderr => q(
	Error:  missing env NSC200_DEV
    ),
    Stdout => q(),
);

run_test( "12", "nscc help",
    "nscc --help",
    0,
    Stderr => q(),
);

run_test( "13", "unknown option",
    "nscc --foo",
    2,
    Stderr => q(
	Unknown option: foo
	Error:  Type 'nscc --help' for usage.
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
## TESTMODE Operation
#---------------------------------------------------------------------------
# In TESTMODE:
#    3>      = data (cmd and chk) sent to NewStep (file descriptor 3)
#    stdin   = simulated NewStep response, echoed on stdout
#    stdout  = normal stdout
#    stderr  = normal stdderr
# When redirect 3>&1, send data (unit 3) is the first two lines, and response
# (from stdin) is the last line.

run_test( "20", "arbitrary text command, no error",
    "( echo '0TE? 0' | nscc --TESTMODE  fake cmd 3.14 )",
    0,
    Stderr => q(),
    Stdout => q(
	0TE? 0
    ),
);

run_test( "21", "valid command, OK response",
    "( echo '3TE? 0' | nscc --TESTMODE -x  3PA1024 )",
    0,
    Stderr => q(
	+ TESTMODE
	+ cmd=3PA1024=
	+ chk=3TE?=
    ),
    Stdout => q(
	3TE? 0
    ),
);

run_test( "22", "valid command, error response",
    "( echo '3TE? 7' | nscc --TESTMODE  3PA1024 )",
    1,
    Stderr => q(
	Error:  NewStep: (7) Parameter Out of Range
    ),
    Stdout => q(
	3TE? 7
    ),
);

run_test( "23", "valid command, unknown error response",
    "( echo '3TE? 99' | nscc --TESTMODE -x  3PA1024  3>&1 )",
    1,
    Stderr => q(
	+ TESTMODE
	+ cmd=3PA1024=
	+ chk=3TE?=
	Error:  (99) unknown error number
    ),
    Stdout => q(
	3PA1024
	3TE?
	3TE? 99
    ),
);

run_test( "24", "OK response address does not match",
    "( echo '22TE? 7' | nscc --TESTMODE -x  3PA?  3>&1 )",
    1,
    Stderr => q(
	+ TESTMODE
	+ cmd=3PA?=
	+ chk=3TE?=
	Error:  NewStep: (7) Parameter Out of Range
    ),
    Stdout => q(
	3PA?
	3TE?
	22TE? 7
    ),
);

run_test( "25", "no TESTMODE, no response",
    "( echo '3TE? 99' | nscc -x  3PA1024 )",
    1,
    Stderr => q(
	+ open serial port:  /dev/null
	+ cmd=3PA1024=
	+ chk=3TE?=
	Error:  no error status returned
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
## Default address and command
#---------------------------------------------------------------------------

run_test( "31", "no address",
    "( echo 'PA? 1492\n7TE? 0' | nscc --TESTMODE -x  PA?  3>&1 )",
    0,
    Stderr => q(
	+ TESTMODE
	+ cmd=0PA?=
	+ chk=0TE?=
    ),
    Stdout => q(
	0PA?
	0TE?
	PA? 1492
	7TE? 0
    ),
);

run_test( "32", "no command, just check error",
    "( echo '0TE? 0' | nscc --TESTMODE -x  3>&1 )",
    0,
    Stderr => q(
	+ TESTMODE
	+ chk=0TE?=
    ),
    Stdout => q(
	0TE?
	0TE? 0
    ),
);

run_test( "33", "only address, just check error",
    "( echo '7TE? 0' | nscc --TESTMODE -x  7  3>&1 )",
    0,
    Stderr => q(
	+ TESTMODE
	+ chk=7TE?=
    ),
    Stdout => q(
	7TE?
	7TE? 0
    ),
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

