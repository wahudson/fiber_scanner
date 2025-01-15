#! /usr/bin/perl -w
# 2025-01-10  William A. Hudson
#
# NewStep NSC200 Controller interface object.
#    Intended to aid a cockpit command.
#---------------------------------------------------------------------------

package NscLib;

use strict;

# Object data:
# {
#    DevFile      => "/dev/ttyUSB0",	# serial port device file
#    AddrNum      => 0,		# controller address {0..255}
#    TraceEx      => 0,		# trace execution flag, on STDERR
#    TraceReply   => 0,		# trace reply     flag, on STDERR
#    TESTMODE     => 0,		# test mode communication flag
# }

# Required Environment:
#    NSC200_DEV		Serial port device file.  e.g. /dev/ttyUSB0

# Errors reported on STDERR.
# Trace execution reported on STDERR.
# Normal output on STDOUT.

#---------------------------------------------------------------------------
## Constructor
#---------------------------------------------------------------------------
# Intend only one object exist at a time.

# Construct a new 'NSC200 Controller' object and set its attributes.
#    Required parameters must have a defined value.
#    Optional parameters have default values, and may explicitly be set
#    to undef (e.g. Key => undef).
# call:
#    Package->new( key=> value, ..	# class method call only
#			    # required:
#			    # optional:
#        Error_sub    => sub {},	# Reference to error subroutine
#    )
# The Error_sub should print error message with appropriate prefix, e.g.:
#        Error_sub    => sub { warn( "Error:  ", @_ ) },
# return:
#    () = new object, undef on error
#
sub new
{
    my( $package, %arg ) = @_;

    my $self = {
		# required args
	AddrNum      => delete( $arg{AddrNum} ),	# controller address
		# optional args, default values
	Error_sub    => sub { warn( "Error:  ", @_ ) },
	DevFile      => $ENV{NSC200_DEV},	# serial port device file
	TESTMODE     => 0,			# test mode communication
	TraceEx      => 0,			# trace execution
	TraceReply   => 0,			# trace response
		# initialize
	Error_cnt    => 0,
	FHout        => undef,	# file handle out
	FHin         => undef,	# file handle in
    };

    bless( $self, $package );

    # optional args, allow undef values
    foreach my $key (
	'Error_sub',	# before any calls to $self->Error()
	'TESTMODE',
	'TraceEx',
	'TraceReply',
	'DevFile',
    ) {
	if (                exists( $arg{$key} ) ) {
	    $self->{$key} = delete( $arg{$key} );
	}
    }

    # required args, must be defined values
    foreach my $key (
	'AddrNum',
    ) {
	unless ( defined( $self->{$key} ) ) {
	    $self->Error( "$package->new() required argument:  '$key'\n" );
	}
    }

    # unexpected args
    foreach my $key ( keys( %arg ) )
    {
	$self->Error( "$package->new() unexpected argument:  '$key'\n" );
    }

# Range check
    unless ( ($self->{AddrNum} >= 0) && ($self->{AddrNum} <= 255) ) {
	$self->Error( "$package->new() require AddrNum in {0..255}:  ",
	    "$self->{AddrNum}\n"
	);
    }

    if ( $self->Error() ) {
	return( undef );
    }

# Check device file

    unless ( $self->{DevFile} ) {
	$self->Error( "missing env NSC200_DEV\n" );
	return( undef );
    }

# Open device file

    if ( $self->{TESTMODE} ) {
	print( STDERR  "+ TESTMODE  3> <stdin\n" )  if ( $self->{TraceEx} );
	$self->{FHin} = \*STDIN;

	open( $self->{FHout}, '>&=3' ) || do {
	    $self->Error( "cannot write file descriptor:  3>\n" );
	    return( undef );
	};
    }
    else {
	print( STDERR  "+ open serial port:  $self->{DevFile}\n" )
		if ( $self->{TraceEx} );

	open( $self->{FHin},  '<', $self->{DevFile} ) || do {
	    $self->Error( "cannot read serial port:  $self->{DevFile}\n" );
	    return( undef );
	};
	open( $self->{FHout}, '>', $self->{DevFile} ) || do {
	    $self->Error( "cannot write serial port:  $self->{DevFile}\n" );
	    return( undef );
	};
    }

    return( $self );
}


# Destructor.
#    Automatically called when object goes out-of-scope.
sub DESTROY
{
    my( $self ) = @_;

    if ( $self->{TESTMODE} ) {
	close( $self->{FHout} );	# close anonymous unit 3
    }
}


# Show object attributes.
#
sub show_debug
{
    my( $self ) = @_;
    print( "AddrNum   = $self->{AddrNum}\n" );
    print( "TESTMODE  = $self->{TESTMODE}\n" );
    print( "TraceEx   = $self->{TraceEx}\n" );
    print( "TraceReply= $self->{TraceReply}\n" );
    print( "Error_cnt = $self->{Error_cnt}\n" );
}


#---------------------------------------------------------------------------
## Object Methods
#---------------------------------------------------------------------------

# Send command to NewStep controller, No error query.
# call:
#    $self->send_raw( @cmd )
#    @cmd    = command without controller address,  e.g. "SL"
# return:
#    () :  1= success, 0= error
#
sub send_raw
{
    my( $self, @cmd ) = @_;

    unless ( $cmd[0] =~ m/^[A-Z][A-Z]/ ) {
	$self->Error( "send_raw():  require 2-letter command:  $cmd[0]\n" );
	return( 0 );
    }

    my $cmd = $self->{AddrNum} . join( ' ', @cmd );

    print( STDERR  "+ cmd=", $cmd, "=\n" )  if ( $self->{TraceEx} );

    print( {$self->{FHout}}  $cmd, "\n" );	# Send command

    Time::HiRes::sleep( 1 )  unless ( $self->{TESTMODE} );
    # delay seconds before sending next command

    return( 1 );
}


# Send query command to NewStep controller.
#    It is followed by an error query (TE?) to check for unrecognized command.
# call:
#    $self->query( $cmd )
#    $cmd    = command without controller address,  e.g. "SL?"
# return:
#    () = query result text, without the command
# A query command may be invalid and return nothing.  A following error
# query then returns "(6) Invalid command".
#
sub query_chk
{
    my( $self, $cmd ) = @_;

    my $retval = undef;

    unless ( $cmd =~ m/^[A-Z][A-Z]\?$/ ) {
	$self->Error( "query_chk():  require 'XX?' command format:  $cmd\n" );
	return( undef );
    }

    $self->send_raw( $cmd );		# Send query
    $self->send_raw( "TE?" );		# Send error query

    my $fh = $self->{FHin};
    while ( <$fh> ) {			# Read each response line

	print( STDERR  "+< ", $_ )  if ( $self->{TraceReply} );
	chomp( $_ );

	my $rcmd = undef;
	my $rval = undef;

	if ( m/^\d+([A-Z][A-Z]\?)\s*(\S+)$/ ) {		# e.g. "99XX? 42"
	    $rcmd = $1;
	    $rval = $2;
	}
	else {
	    $self->Error( "query_chk():  unexpected reply format:  '$_'\n" );
	    next;
	}

	if ( $rcmd eq $cmd ) {		# desired query
	    $retval = $rval;
	}
	elsif ( $rcmd eq 'TE?' ) {	# error query
	    if ( $rval ) {
		$self->Error( $self->decode_err( $rval ), "\n" );
	    }
	    last;
	}
	else {
	    $self->Error( "query_chk():  unexpected reply:  '$_'\n" );
	}
    }
    # may be EOF

    return( $retval );
}


# Decode NewStep error number (TE?).
# call:
#    $self->decode_err( $erno )
#    $erno = error number
# return:
#    () = $text of error message, null '' if no error
#
sub decode_err
{
    my( $self, $erno ) = @_;

    return( '' )  unless ( $erno );

    my %Msg = (
	'0' => "No errors",
	'1' => "Driver fault (open load)",
	'2' => "Driver Fault (thermal shut down)",
	'3' => "Driver fault (short)",
	'6' => "Invalid command",
	'7' => "Parameter Out of Range",
	'8' => "No Motor connected",
	'10' => "Brown-out",
	'38' => "Command parameter missing",
	'24' => "Positive hardware limit detected",
	'25' => "Negative hardware limit detected",
	'26' => "Positive software limit detected",
	'27' => "Negative software limit detected",
	'210' => "Max velocity exceeded",
	'211' => "Max acceleration exceeded",
	'213' => "Motor not enabled",
	'214' => "Switch to invalid axis",
	'220' => "Homing aborted",
	'226' => "Parameter change not allowed during motion",
    );

    my $msg = $Msg{$erno};

    if ( defined( $msg ) ) {
	return( "NewStep: ($erno) $msg" );
    }
    else {
	return( "unknown error number:  $erno" );
    }
}


# Query error status of NewStep controller.
#    Send TE? and return decoded error text.
# call:
#    $self->check_err()
# return:
#    () :  1= success, 0= error
#
sub check_err
{
    my( $self ) = @_;

    my $cmd = "TE?";

    $self->send_raw( $cmd );		# Send error query

    my $erno = '';
    my $fh   = $self->{FHin};
    while ( <$fh> ) {			# Read each response line
	print( STDERR  "+< ", $_ )  if ( $self->{TraceReply} );
	chomp( $_ );

	if ( m/^\d*TE\?\s*(\d*)/ ) {	# e.g. "0TE? 99"
	    $erno = $1;

	    unless ( length( $erno ) ) {
		$self->Error( "missing error number in return:  '$_'\n" );
		last;
	    } # unlikely response

	    last;
	}
	# less strict pattern for unexpected reply variation
	#!! ignore reply address
    }
    # may be EOF

    unless ( length( $erno ) ) {
	$self->Error( "no error status returned\n" );
	return( 0 );
    }

    my %Msg = (
	'0' => "No errors",
	'1' => "Driver fault (open load)",
	'2' => "Driver Fault (thermal shut down)",
	'3' => "Driver fault (short)",
	'6' => "Invalid command",
	'7' => "Parameter Out of Range",
	'8' => "No Motor connected",
	'10' => "Brown-out",
	'38' => "Command parameter missing",
	'24' => "Positive hardware limit detected",
	'25' => "Negative hardware limit detected",
	'26' => "Positive software limit detected",
	'27' => "Negative software limit detected",
	'210' => "Max velocity exceeded",
	'211' => "Max acceleration exceeded",
	'213' => "Motor not enabled",
	'214' => "Switch to invalid axis",
	'220' => "Homing aborted",
	'226' => "Parameter change not allowed during motion",
    );

    if ( $erno ) {
	my $msg = $Msg{$erno};
	if ( defined( $msg ) ) {
	    $self->Error( "NewStep: ($erno) $msg\n" );
	}
	else {
	    $self->Error( "($erno) unknown error number\n" );
	}
    }

    return( 1 );
}


#---------------------------------------------------------------------------
## Hardware Status (PH)
#---------------------------------------------------------------------------

# Query Hardware Status (PH?).
# call:
#    $self->query_status()
# return:
#    () = Hardware status, decimal integer value
#
sub query_status
{
    my( $self ) = @_;

    my $cmd = "PH?";

    $self->send_raw( $cmd );		# Send query

    my $retnum = undef;
    my $fh     = $self->{FHin};
    while ( <$fh> ) {			# Read each response line
	print( STDERR  "+< ", $_ )  if ( $self->{TraceReply} );
	chomp( $_ );

	if ( m/^\d*PH\?\s*(\d+)$/ ) {	# e.g. "0PH? 1572098"
	    $retnum = $1;
	    last;
	}
    }
    # may be EOF

    unless ( defined( $retnum ) ) {
	$self->Error( "query_status():  reply not found:  $cmd\n" );
    }

    return( $retnum );
}

# Decode Hardware Status (PH?).
# call:
#    $self->decode_status( $stat_num )
# return:
#    () = @Text of Hardware status
#
sub decode_status
{
    my( $self, $nx ) = @_;

    my @text = (
	statx( $nx,  0, "Green LED on" ),
	statx( $nx,  1, "Red LED on" ),
	statx( $nx,  8, "Negative travel limit reached" ),
	statx( $nx,  9, "Positive travel limit reached" ),
	statx( $nx, 11, "Device reset button not pressed" ),
	statx( $nx, 12, "Button A not pressed" ),
	statx( $nx, 13, "Button B not pressed" ),
	statx( $nx, 14, "Jog knob switch not pressed" ),
	statx( $nx, 15, "Low voltage not detected" ),
	statx( $nx, 16, "Encoder A signal high" ),
	statx( $nx, 17, "Encoder B signal high" ),
	statx( $nx, 18, "Driver line 1 no fault" ),
	statx( $nx, 19, "Driver enabled" ),
	statx( $nx, 20, "Driver line 2 no fault" ),
    );

    return( @text );
}

# Format status bit. (private)
sub statx
{
    my( $word, $nbit, $text ) = @_;

    my $bit = ($word >> $nbit) & 0x1;

    return( "    $bit  [$nbit]  $text\n" );
}


# Show Hardware Status (PH?).
# call:
#    $self->show_status()
#
sub show_status
{
    my( $self ) = @_;

    my $stat_num = $self->query_status();

    if ( defined( $stat_num ) ) {
	printf( "Hardware Status (PH?):  0x%08x\n", $stat_num );
	print( $self->decode_status( $stat_num ) )
    }
    else {
	$self->Error( "show_status():  query failed\n" );
    }
}


#---------------------------------------------------------------------------
## Hardware Configuration (SH)
#---------------------------------------------------------------------------

# Query Hardware Configuration (SH?).
# call:
#    $self->query_hardware()
# return:
#    () = Hardware configuration, integer value
#
sub query_hardware
{
    my( $self ) = @_;

    my $cmd = "SH?";

    $self->send_raw( $cmd );		# Send query

    my $retnum = undef;
    my $fh   = $self->{FHin};
    while ( <$fh> ) {			# Read each response line
	print( STDERR  "+< ", $_ )  if ( $self->{TraceReply} );
	chomp( $_ );

	if ( m/^\d*SH\?\s*(\d+)$/ ) {	# e.g. "0SH? 255"
	    $retnum = $1;
	    last;
	}
    }
    # may be EOF

    unless ( defined( $retnum ) ) {
	$self->Error( "query_hardware():  reply not found:  $cmd\n" );
    }

    return( $retnum );
}

# Decode Hardware Configuration (SH?).
# call:
#    $self->decode_hardware( $hw_code )
# return:
#    () = @Text of Hardware configuration
#
sub decode_hardware
{
    my( $self, $hw_code ) = @_;

    my %Hw_text = (	# index by value bit position {0..7}
	'0' => "disable hardware limit checking",
	'1' => "reserved",
	'2' => "enable knob relative move",
	'3' => "disable local position/velocity buttons",
	'4' => "knob positive direction, 0= CW, 1= CCW",
	'5' => "disable local switchbox scan",
	'6' => "disable home search",
	'7' => "disable software travel limit checking",
    );

    my @text;
    for ( my $ii=0;  $ii<=7;  $ii++ )
    {
	push( @text,
	    sprintf("   %d  [%d] %s\n", ($hw_code & 0x1), $ii, $Hw_text{ $ii })
	);
	$hw_code = $hw_code >> 1;
    }

    return( @text );
}


# Show Hardware Configuration (SH?).
# call:
#    $self->show_HwConfig()
#
sub show_HwConfig
{
    my( $self ) = @_;

    my $hw_code = $self->query_hardware();

    if ( defined( $hw_code ) ) {
	print( "Hardware Configuration (SH)\n" );
	print( $self->decode_hardware( $hw_code ) )
    }
    else {
	$self->Error( "show_HwConfig():  query failed\n" );
    }
}


#---------------------------------------------------------------------------
## Error Handling
#---------------------------------------------------------------------------

# Error message reporting - on STDERR.
# call:
#    $self->Error( @text )	Print error message, increment error count.
#    $self->Error()		Get error count.
# return:
#    ()  = Error count, false if no errors were recorded.
#
sub Error
{
    my $self = shift();

    if ( @_ ) {
	$self->{Error_cnt} ++;
	&{$self->{Error_sub}}( @_ );
    }
    return( $self->{Error_cnt} );
}


1;
__END__

