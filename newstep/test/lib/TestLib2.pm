#! /usr/bin/perl -w
# 2018-04-30  William A. Hudson

# TestLib2 library for testing code.
#
# usage:
#    Copy this module to your test suite.  A private copy ensures
#    stability, as evolution may not be backward compatible.
#---------------------------------------------------------------------------

package TestLib2;

require Exporter;
@ISA       = qw( Exporter );
@EXPORT    = qw(
    Error
    die_Error
    here_text
    End_test
    run_test
);
@EXPORT_OK = qw(
);

use strict;

our $VERSION = '1.01';          #!! <=== Update me

#---------------------------------------------------------------------------
## Error handling (public)
#---------------------------------------------------------------------------

my $Error_cnt = 0;	# error count (global, private)

# Error message reporting.
#    Will cause the test program to fail.
# call:
#    $self->Error( @text )      Print error message, increment error count.
#    $self->Error()             Get error count.
#    @text  = error message text, same as warn().
# return:
#    ()  = Error count, false if no errors were recorded.
# Note:
#    Explicit STDERR is used here, intended for test program errors.
#    Do not use warn(), which may be trapped in the test program and
#    never reach stderr.
#
sub Error
{
    if ( @_ ) {
	print( STDERR  "Error:  ", @_ );
	$Error_cnt ++;
    }
    return( $Error_cnt );
}


# Die with an Error message.
#    Will cause the test program to fail.
# call:
#    $self->die_Error( @text )
#
sub die_Error
{
    Error( @_ );
    $! = 1;		# exit code value for die()
    die( "    Stop.\n" );
}


#---------------------------------------------------------------------------
## Utility Functions (public)
#---------------------------------------------------------------------------

# Format "here-text", similar to the shell "here-file".
#    - Any first blank line is removed.
#    - Any leading <TAB> character is removed from each line.
#    - Any trailing white-space is removed from the last line only.
#    This allows check result text to be indented with tabs for better
#    readability in the test program.  Is used in the main test functions.
# call:
#    here_text( "text" )
#        text = literal text, include new-lines
# return:
#    ()  = formatted text
# example:
#    here_text( q(	# this line is removed
#	first line
#	second line
#    ))			# this trailing white-space is removed
#
sub here_text
{
    my( $text ) = @_;

    if ( $text =~ m/^\n/ )
    {
	$text =~ s/^\n// ;	# remove first blank line
	$text =~ s/^\t//gm ;	# remove leading tab from each line
	$text =~ s/[ \t]+$// ;	# remove trailing spaces of last line
    }

    return( $text );
}


#---------------------------------------------------------------------------
## End of Test (public)
#---------------------------------------------------------------------------

our $Success  = 0;	# (global, private)

# End block executes on Way out, regardless of how program terminates.
#
END {
    if ( Error() ) {
	Error( "system errors!!\n" );
    }

    if ( $Success ) {
	print( "99  OK\n" );
    } else {
	print( "99  NOT OK - failed to run all tests - End_test() not reached\n" );
    }
}


# End a test program.
#    Call only once at the end of all tests.
#    Exits the program, any following code is not executed.
# call:
#    End_test();
#
sub End_test
{
    $Success = 1;	# we made it

    exit( Error() ? 1 : 0 );
}


#---------------------------------------------------------------------------
## Program Test (public)
#---------------------------------------------------------------------------

# Common arguments:
#   $index         = Test identification number, e.g. "10", "12b".
#                       Must match expression  m/^[0-9]\w+$/
#   $x_comment     = Comment string, no new-line.


# Run a shell command, checking exit, stdout, stderr results.
#    The command is executed with stdout and stderr re-directed.  If the
#    command has shell meta-characters, then enclose it in parenthesis () to
#    make a sub-process.  e.g.  "( xycmd  2> err | yzcmd )"
# Optional arguments 'Stderr', 'Stdout' provide in-line result text.
#    They are pre-processed thru here_text() to allow nice formatting in the
#    test case file.
# call:
#    run_test( $index, "comment",
#        "command",     # Command string, will be executed with redirection.
#        "exit",        # Exit code from the command.
#                   # optional tuples:
#        Stderr => '',  # stderr text, default is file "$index.check.stderr"
#        Stdout => '',  # stdout text, default is file "$index.check.stdout"
#    );
#
sub run_test
{
    my( $index, $x_comment, $x_command, $x_exit, %opt ) = @_;

    my $x_stderr = delete( $opt{Stderr} );
    my $x_stdout = delete( $opt{Stdout} );

    $x_stderr = here_text( $x_stderr )  if ( defined( $x_stderr ) );
    $x_stdout = here_text( $x_stdout )  if ( defined( $x_stdout ) );

    if ( keys( %opt ) ) {
	foreach my $key ( keys( %opt ) )
	{
	    die_Error( "run_test( $index ) unknown argument:  '$key'\n" );
	}
    }

    my $stderr = (defined( $x_stderr )) ? "$index.stderr" : "$index.check.stderr";
    my $stdout = (defined( $x_stdout )) ? "$index.stdout" : "$index.check.stdout";

    my $y_exit;
    my $y_stderr  = undef;
    my $y_stdout  = undef;

    my $ok_stderr = 0;
    my $ok_stdout = 0;
    my @fail_text = ();

    if ( defined( $x_stderr ) ) {
	my $cmd = "$x_command  2>&1  > $stdout";
	open( my $fh, "-|", $cmd ) ||	# pipe to us
	    push( @fail_text, "Failure:  cannot launch command\n" );
	my @stderr = <$fh>;		# slurp whole file
	$y_stderr  = join( '', @stderr );
	close( $fh );
	$y_exit    = $? >> 8;
	if ( $! ) {
	    push( @fail_text, "Failure:  close() error:  $!\n" );
	}
	$ok_stderr = ( $x_stderr eq $y_stderr );
    }
    else {
	my $cmd = "$x_command  > $stdout  2> $stderr";
	my $rc  = system( $cmd );
	$y_exit = $rc >> 8;
	$y_stderr = read_file( $stderr );
	if ( defined( $y_stderr ) ) {
	    $ok_stderr = ! cmp_file( "../ref/$stderr", "./$stderr" );
	}
	else {
	    push( @fail_text, "Failure:  no stderr file:  $stderr\n" );
	}
    }

    if ( defined( $x_stdout ) ) {
	$y_stdout = read_file( $stdout );
	if ( defined( $y_stdout ) ) {
	    $ok_stdout = ( $x_stdout eq $y_stdout );
	}
	else {
	    push( @fail_text, "Failure:  no stdout file:  $stdout\n" );
	}
    }
    else {
	$ok_stdout = ! cmp_file( "../ref/$stdout", "./$stdout" );
    }

    my $ok = (  ( $y_exit == $x_exit ) &&
		( ! @fail_text )       &&
		$ok_stderr             &&
		$ok_stdout
    );

    if ( $ok ) {
	print( "$index  OK\n" );
    }
    else {
	print( "\n$index  NOT OK\n" );
	print( "# $x_comment\n" );
	print( "+ $x_command\n" );

	if ( $y_exit == $x_exit ) {
	    print( "+ exit= $y_exit\n" );
	} else {
	    print( "< exit= $x_exit\n" );
	    print( "> exit= $y_exit\n" );
	}

	if ( @fail_text ) {
	    print( @fail_text );
	}

	if ( defined( $x_stderr ) ) {
	    if ( $ok_stderr ) {
		print( "+ stderr=\n$y_stderr=\n" );
	    }
	    elsif ( defined( $y_stderr ) ) {
		print( "< stderr=\n$x_stderr=\n" );
		print( "> stderr=\n$y_stderr=\n" );
	    }
	}
	else {
	    if ( ! $ok_stderr ) {
		diff_file( "../ref/$stderr", "./$stderr" );
	    }
	}

	if ( defined( $x_stdout ) ) {
	    if ( $ok_stdout ) {
		print( "+ stdout=\n$y_stdout=\n" );
	    }
	    elsif ( defined( $y_stdout ) ) {
		print( "< stdout=\n$x_stdout=\n" );
		print( "> stdout=\n$y_stdout=\n" );
	    }
	}
	else {
	    if ( ! $ok_stdout ) {
		diff_file( "../ref/$stdout", "./$stdout" );
	    }
	}

	print( "\n" );
    }

    1;
}


#---------------------------------------------------------------------------
## Private functions
#---------------------------------------------------------------------------

sub read_file
{
    my( $file ) = @_;

    unless ( -r $file ) {
	return( undef );
    }

    open( my $fh, "<", $file ) || do {
	Error( "cannot open file:  $file\n" );
	return( undef );
    };

    my $text = join( '', <$fh> );

    close( $fh ) || do {
	Error( "closing file:  $file\n" );
	return( undef );
    };

    return( $text );
}


sub cmp_file
{
    my( $afile, $bfile ) = @_;

    unless ( (-r $afile) && (-r $bfile) ) {
	return( 1 );
    }

    my $rc = system( "cmp --quiet  $afile $bfile" );

    return( $rc >> 8 );
}


sub diff_file
{
    my( $afile, $bfile ) = @_;

    print( "+ diff  $afile  $bfile\n" );

    my $rc = system( "diff $afile $bfile" );

    return( $rc >> 8 );
}


1;
__END__

