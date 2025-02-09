#! /usr/bin/perl -w
# 2025-01-28  William A. Hudson

# Testing:  nsc  command
#    00-09  multi-line echo command
#    10-19  basic options --help
#    20-29  TESTMODE Operation, send command
#    30-39  query command
#    40-49  move command
#    50-59  stop command, Motor state
#    60-69  state command

# usage:  ./test.pl
# files:
#    ./tmp/	run directory, all files written here
#    ./ref/	reference input/output files
#
# Slow execution!  0.2 second delay per command.
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

#---------------------------------------
# Test multi-line echo command.

run_test( "01", "sh echo OK",
    "( echo '0TP? 42\n0TE? 0' )",
    0,
    Stderr => q(),
    Stdout => q(
	0TP? 42
	0TE? 0
    ),
);

run_test( "02", "/bin/echo OK with -e",
    "( /bin/echo -e '0TP? 42\n0TE? 0' )",
    0,
    Stderr => q(),
    Stdout => q(
	0TP? 42
	0TE? 0
    ),
);

#---------------------------------------------------------------------------
## basic options --help
#---------------------------------------------------------------------------

run_test( "11", "nsc no args - reading /dev/null",
    "nsc",
    1,
    Stderr => q(
	Error:  no error status returned
    ),
    Stdout => q(),
);

run_test( "11", "missing env NSC200_DEV",
    "NSC200_DEV=''  nsc",
    1,
    Stderr => q(
	Error:  missing env NSC200_DEV
    ),
    Stdout => q(),
);

run_test( "12", "nsc help",
    "nsc --help",
    0,
    Stderr => q(),
);

run_test( "13", "unknown option",
    "nsc --foo",
    2,
    Stderr => q(
	Unknown option: foo
	Error:  Type 'nsc --help' for usage.
    ),
    Stdout => q(),
);

#---------------------------------------------------------------------------
## TESTMODE Operation, send command
#---------------------------------------------------------------------------
# In TESTMODE:
#    3>      = data (cmd and chk) sent to NewStep (file descriptor 3)
#    stdin   = simulated NewStep response, echoed on stdout
#    stdout  = normal stdout
#    stderr  = normal stdderr
# When redirect 3>&1, send data (unit 3) is the first two lines, and response
# (from stdin) is the last line.

run_test( "20", "arbitrary text command, no error",
    "( echo '0TE? 0' | nscc --TESTMODE  send fake cmd 3.14 )",
    0,
    Stderr => q(),
    Stdout => q(
	0TE? 0
    ),
);

run_test( "21", "valid command, OK response",
    "( echo '3TE? 0' | nsc --TESTMODE -x -v -a3  send PA1024 )",
    0,
    Stderr => q(
	+ TESTMODE  3> <stdin
	+ cmd=3PA1024=
	+ cmd=3TE?=
	+< 3TE? 0
    ),
    Stdout => q(),
);

run_test( "22", "valid command, error response",
    "( echo '3TE? 7' | nscc --TESTMODE send 3PA1024 )",
    1,
    Stderr => q(
	Error:  NewStep: (7) Parameter Out of Range
    ),
    Stdout => q(
	3TE? 7
    ),
);

#---------------------------------------------------------------------------
## query command
#---------------------------------------------------------------------------

run_test( "30", "valid command, no response",
    "( echo '0TE? 0' | nsc --TESTMODE -x -v  query TP )",
    1,
    Stderr => q(
	+ TESTMODE  3> <stdin
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TE? 0
	Error:  no reply for:  TP?
    ),
    Stdout => q(),
);

run_test( "31a", "query valid, trace execution",
    "( echo '0TP? 42\n0TE? 0' | nsc --TESTMODE -x -v  query TP )",
    0,
    Stderr => q(
	+ TESTMODE  3> <stdin
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 42
	+< 0TE? 0
    ),
    Stdout => q(
	42
    ),
);

run_test( "31b", "query valid",
    "( echo '0TP? 42\n0TE? 0' | nsc --TESTMODE  query TP )",
    0,
    Stderr => q(
	+< 0TP? 42
	+< 0TE? 0
    ),
    Stdout => q(
	42
    ),
);

#---------------------------------------------------------------------------
## move command
#---------------------------------------------------------------------------

run_test( "41", "move, no movement and motor stopped",
    "( < ../ref/41.in  nsc --TESTMODE -v  move 5443 )",
    0,
    Stderr => q(
	+< 0TP? 42
	+< 0TE? 0
	+< 0TE? 0
	+< 0TP? 42
	+< 0TE? 0
	+< 0TS? 81
	+< 0TE? 0
    ),
    Stdout => q(
	42  start position (uStep)
	42
    ),
);

run_test( "42a", "move, movement stopped with motor running",
    "( < ../ref/42.in  nsc --TESTMODE -x -v  move 5443 )",
    1,
    Stderr => q(
	+ TESTMODE  3> <stdin
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 42
	+< 0TE? 0
	+ cmd=0PA 5443=
	+ cmd=0TE?=
	+< 0TE? 0
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 142
	+< 0TE? 0
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 242
	+< 0TE? 0
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 342
	+< 0TE? 0
	+ cmd=0TP?=
	+ cmd=0TE?=
	+< 0TP? 342
	+< 0TE? 0
	+ cmd=0TS?=
	+ cmd=0TE?=
	+< 0TS? 80
	+< 0TE? 0
	Error:  motor not stopped
    ),
    Stdout => q(
	42  start position (uStep)
	142
	242
	342
	342
    ),
);

run_test( "42b", "move, movement stopped with motor running",
    "( < ../ref/42.in  nsc --TESTMODE  move 5443 )",
    1,
    Stderr => q(
	Error:  motor not stopped
    ),
    Stdout => q(
	42  start position (uStep)
	142
	242
	342
	342
    ),
);

#---------------------------------------------------------------------------
## stop command, Motor state
#---------------------------------------------------------------------------

run_test( "51", "stop - and read position",
    "( < ../ref/51.in  nsc --TESTMODE -v  stop )",
    0,
    Stderr => q(
	+< 0TE? 0
	+< 0TS? 81
	+< 0TE? 0
	+< 0TP? 42
	+< 0TE? 0
    ),
    Stdout => q(
	42  position (uStep)
    ),
);

#---------------------------------------
run_test( "55a", "motor state Stopped",
    "( echo '0TS? 81\n0TE? 0' | nsc --TESTMODE -x -v  motor )",
    0,
    Stderr => q(
	+ TESTMODE  3> <stdin
	+ cmd=0TS?=
	+ cmd=0TE?=
	+< 0TS? 81
	+< 0TE? 0
    ),
    Stdout => q(
	Motor:  Stopped
    ),
);

run_test( "55b", "motor state Moving",
    "( echo '0TS? 80\n0TE? 0' | nsc --TESTMODE -v  motor )",
    0,
    Stderr => q(
	+< 0TS? 80
	+< 0TE? 0
    ),
    Stdout => q(
	Motor:  Moving
    ),
);

#---------------------------------------------------------------------------
## state command
#---------------------------------------------------------------------------

run_test( "60", "state - mostly default values",
    "( < ../ref/60.in  nsc --TESTMODE -v  state )",
    0,
    Stderr => q(
	+< 0SL? 42
	+< 0TE?0
	+< 0SR? 116000
	+< 0TE?0
	+< 0AC? 624.00
	+< 0TE?0
	+< 0AU? 1239.00
	+< 0TE?0
	+< 0VA? 156.00
	+< 0TE?0
	+< 0VU? 312.00
	+< 0TE?0
	+< 0TP? 10420
	+< 0TE?0
	+< 0TS? 81
	+< 0TE?0
    ),
    Stdout => q(
	        42  uStep      Left Limit (SL)
	    116000  uStep      Right Limit (SR)
	    624.00  FStep/s/s  Acceleration (AC)
	   1239.00  FStep/s/s  Max Acceleration (AU)
	    156.00  FStep/s    Velocity (VA)
	    312.00  FStep/s    Max Velocity (VU)
	     10420  uStep      Position (TP)
	   Stopped  --         Motor (TS)
    ),
);

#---------------------------------------------------------------------------
# Check that all tests ran.
#---------------------------------------------------------------------------

End_test();		# last test exit

__END__

