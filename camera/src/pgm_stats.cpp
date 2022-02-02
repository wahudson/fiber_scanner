// 2022-01-07  William A. Hudson
//
// Program to compute image stats - min, max, mean, standard deviation
//--------------------------------------------------------------------------

#include <iostream>     // std::cerr
#include <iomanip>
#include <string>
#include <stdlib.h>

#include <stdio.h>
#include <netpbm/pgm.h>
#include <math.h>

using namespace std;

#include "Error.h"
#include "yOption.h"

#include "gmStats.h"

//--------------------------------------------------------------------------
// Option Handling
//--------------------------------------------------------------------------

class yOptLong : public yOption {

//  public:	// inherited
//    char*		ProgName;
//    int		get_argc();
//    char*		next_arg();
//    bool		next();
//    bool		is( const char* opt );
//    char*		val();
//    char*		current_option();

  public:	// option values

    const char*		geo;

    bool		verbose;
    bool		debug;
    bool		TESTOP;

  public:	// data values

  public:
    yOptLong( int argc,  char* argv[] );	// constructor

    void		parse_options();
    void		print_option_flags();
    void		print_usage();

};


/*
* Constructor.  Init options with default values.
*    Pass in the main() argc and argv parameters.
* call:
*    yOptLong	Opx  ( argc, argv );
*    yOptLong	Opx = yOptLong::yOptLong( argc, argv );
*/
yOptLong::yOptLong( int argc,  char* argv[] )
    : yOption( argc, argv )
{
    geo         = "WxH+X+Y";	//#!!

    verbose     = 0;
    debug       = 0;
    TESTOP      = 0;
}


/*
* Parse options.
*/
void
yOptLong::parse_options()
{
    while ( this->next() )
    {
	if      ( is( "--geo="       )) { geo        = this->val(); }

	else if ( is( "--verbose"    )) { verbose    = 1; }
	else if ( is( "-v"           )) { verbose    = 1; }
	else if ( is( "--debug"      )) { debug      = 1; }
	else if ( is( "--TESTOP"     )) { TESTOP     = 1; }
	else if ( is( "--help"       )) { this->print_usage();  exit( 0 ); }
	else if ( is( "-"            )) {                break; }
	else if ( is( "--"           )) { this->next();  break; }
	else {
	    Error::msg( "unknown option:  " ) << this->current_option() <<endl;
	}
    }

}


/*
* Show option flags.
*/
void
yOptLong::print_option_flags()
{
    cout << "--geo         = " << geo          << endl;
    cout << "--verbose     = " << verbose      << endl;
    cout << "--debug       = " << debug        << endl;

    char*	arg;
    while ( ( arg = next_arg() ) )
    {
	cout << "arg:          = " << arg          << endl;
    }
}


/*
* Show usage.
*/
void
yOptLong::print_usage()
{
    cout <<
    "    Compute image stats - min, max, mean, standard deviation, CG\n"
    "usage:  " << ProgName << " [options..]  [FILE.pgm ..]\n"
    "    FILE.pgm            input file, '-' or default is stdin\n"
    "  options:\n"
//  "    --geo=WxH+X+Y       region to analyze\n"
    "    --help              show this usage\n"
//  "    -v, --verbose       verbose output\n"
//  "    --debug             debug output\n"
    "  (options with GNU= only)\n"
    ;

// Hidden options:
//       --TESTOP       test mode show all options
}


//--------------------------------------------------------------------------
// Main program
//--------------------------------------------------------------------------

int
main( int	argc,
      char	*argv[]
) {

  try {
    yOptLong		Opx  ( argc, argv );	// constructor

    Opx.parse_options();

    if ( Opx.TESTOP ) {
	Opx.print_option_flags();
	return ( Error::has_err() ? 1 : 0 );
    }

    if ( Error::has_err() )  return 1;

    const char*		in_file;

    in_file = Opx.next_arg();

    do
    {
	if ( in_file ) {
	    cout << "==> " << in_file << " <==" << endl;
	}
	else {
	    in_file = "-";
	}

	gmStats		gmx  ( in_file );	// constructor
	float		std_dev;

	cout << "Ncol   = " << gmx.Ncol   <<endl;
	cout << "Nrow   = " << gmx.Nrow   <<endl;
	cout << "Npix   = " << gmx.Npix   <<endl;
	cout << "MaxVal = " << gmx.MaxVal <<endl;

	gmx.get_mean();

	cout << "Max    = " << gmx.Max    <<endl;
	cout << "Min    = " << gmx.Min    <<endl;
	cout << "Sum    = " << gmx.Sum    <<endl;
	cout << "Mean   = " << gmx.Mean   <<endl;

	std_dev = gmx.get_std_deviation();

	cout << "SD     = " << std_dev    <<endl;
	cout << "CGxy   = " << gmx.CGx << ", " << gmx.CGy <<endl;

    } while ( ( in_file = Opx.next_arg() ) );

  }
  catch ( std::exception& e ) {
    Error::msg( e.what() ) <<endl;
  }
  catch (...) {
    Error::msg( "unexpected exception\n" );
  }

  return ( Error::has_err() ? 1 : 0 );

}

