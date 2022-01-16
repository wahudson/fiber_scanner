// 2016-05-02  William A. Hudson

// Option parsing base class.
//
// Functions next(), is(), and val() are the heart of the parsing loop and
// are based on pre-increment.
// Functions get_argc(), next_arg() help with non-option arguments.
//
// This was an initial idea for option parsing assistance, and can probably
// be improved.
//--------------------------------------------------------------------------

#include <iostream>
#include <libgen.h>

using namespace std;

#include "yOption.h"
#include "Error.h"


/*
* Constructor.
*/
yOption::yOption()
{
}

/*
* Constructor.
*    Pass in the main() argc and argv parameters.
* call:
*    yOption	Opx  ( argc, argv );
*    yOption	Opx = yOption::yOption( argc, argv );
*/
yOption::yOption( int argc,  char* argv[] )
{

    // Want GNU basename(), POSIX modifies argv[0], but not critical.
    ProgName = basename( *argv );	// possibly modify argv[0]

//    cout << "ProgName= " << ProgName << endl;

    Argc = argc;
    Argv = argv;
    Vp   = NULL;
}


/*
* Copy Constructor.
*    Pass in an existing option object.
* call:
*    yOption	Opx  ( &MainOpx );
*/
yOption::yOption( yOption  *opx )
{
    Argc     = opx->Argc;
    Argv     = opx->Argv;
    Vp       = NULL;
    ProgName = opx->ProgName;
}


/*
* Get current argument count.
* call:
*    self.get_argc()
* return:
*    () = number of arguments remaining
*/
int
yOption::get_argc()
{
    return( Argc );
}


/*
* Get next argument after all options.
*    Call only after parse_options().
*    Return null when at end of arguments.
#    Note:  In C main(), argv[argc] is a NULL pointer.
* call:
*    self.next_arg()
* return:
*    () =  pointer to arg, NULL at end of arguments
*/
char*
yOption::next_arg()
{
    char*	arg = *Argv;

    if ( Argc > 0 ) {
	Argc--;
	Argv++;
    }
    return( arg );
}


/*
* Advance to the next argument option.
*    Return false when at end of options, leaving pointer at first non-option.
* call:
*    self.next()
* return:
*    () :  true= it is an option, false= end of options
*/
bool
yOption::next()
{
    if ( Argc > 0 ) {
	Argc--;
	Argv++;
    }
    return( (Argc > 0) && (**Argv == '-') );
}


/*
* True if current option matches this option.
*    Sets value pointer Vp to the associated option value, if any.
*    Only gnu '=' options with value are supported.
* call:
*    self.is( '--libdef=' )	option with value
*    self.is( '--map' )		flag option
* return:
*    () : true= is current option, false= not
* Possibly use Vp as arg pointer, and leave where it lands.
*/
bool
yOption::is( const char* opt )
{
    char* ap = *Argv;

    while ( *opt && *ap ) {		// not at end of string
	if ( *(opt++) != *(ap++) ) {	    // char do not match
	    return 0;
	}
    }

    Vp = ap;
    return ( (*opt == '\0') && ((*ap == '\0') || (*(ap - 1) == '=')) );

    // True if opt at end and (arg pointer at end or previous char is '=').
}


/*
* Get option value from the last successful options::is() match.
*/
char*
yOption::val()
{
    if ( ! Vp ) {
	Error::msg( "internal:  option has no value\n" );
    }
    return( Vp );
}


/*
* Get current argument option being inspected.
*/
char*
yOption::current_option()
{
    return *Argv;
}

