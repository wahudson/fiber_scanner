// 2022-02-11  William A. Hudson
//
// Find the width (FWHM) of a spot (circular) image.
//
// Measure Xwidth and Ywidth thru CG of image at given Zlevel.
//--------------------------------------------------------------------------

#include <iostream>     // std::cerr
#include <iomanip>
#include <string>
#include <stdlib.h>

#include <stdio.h>
#include <netpbm/pgm.h>

using namespace std;

#include "Error.h"
#include "yOption.h"
#include "yOpVal.h"

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
    yOpVal		sub;
    yOpVal		level;

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
	else if ( is( "--sub="       )) { sub.set(     this->val() ); }
	else if ( is( "--level="     )) { level.set(   this->val() ); }

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

    if ( get_argc() > 1 ) {
	Error::msg( "require only one file argument" ) <<endl;
    }
}


/*
* Show option flags.
*/
void
yOptLong::print_option_flags()
{
    cout << "--geo         = " << geo          << endl;
    cout << "--sub         = " << sub.Val      << endl;
    cout << "--level       = " << level.Val    << endl;
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
    "    Width (FWHM) of a spot (circular) image\n"
    "usage:  " << ProgName << " [options..]  [FILE.pgm]\n"
    "    FILE.pgm            input file, '-' or default is stdin\n"
    "  options:\n"
//  "    --geo=WxH+X+Y       region to analyze\n"
    "    --sub=V             subract value from each pixel\n"
    "    --level=V           pixel value at which to compute width\n"
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

    if ( ! in_file ) {
	in_file = "-";
    }

    do		// single file
    {
	gmStats		gmx  ( in_file );	// constructor

	cout << "Ncol   = " << gmx.Ncol   <<endl;
	cout << "Nrow   = " << gmx.Nrow   <<endl;
	cout << "Npix   = " << gmx.Npix   <<endl;
	cout << "MaxVal = " << gmx.MaxVal <<endl;

	// Subtract black level --sub
	if ( Opx.sub.Given ) {
	    int		black = Opx.sub.Val;
	    int		cnt   = 0;
	    int		Nzero = 0;
	    int		pixv;

	    if ( Opx.sub.Val > gmx.MaxVal ) {
		Error::msg( "subtract greater than MaxVal:  --sub=" )
		    << Opx.sub.Val <<endl;
		continue;
	    }

	    for ( int j=0;  j<gmx.Nrow;  j++ )		// each row (Y)
	    {
		for ( int i=0;  i<gmx.Ncol;  i++ )	// each column (X)
		{
		    pixv = gmx.Img[j][i];

		    if ( pixv > 0 ) {
			cnt++;
			pixv -= black;
			if ( pixv < 0 ) { pixv = 0; }
			gmx.Img[j][i] = pixv;
		    }
		    if ( pixv == 0 ) { Nzero++; }
		}
	    }
	    cout << "Nsub   = " << cnt    <<endl;	// not already zero
	    cout << "Nzero  = " << Nzero  <<endl;	// now zero
	}

	gmx.get_mean();

	cout << "Max    = " << gmx.Max    <<endl;
	cout << "Min    = " << gmx.Min    <<endl;
	cout << "Mean   = " << gmx.Mean   <<endl;
	cout << "SD     = " << gmx.get_std_deviation() <<endl;
	cout << "CGxy   = (" << gmx.CGx << "," << gmx.CGy << ")" <<endl;

	gray_t		z_level;

	z_level = ( Opx.level.Given ) ? Opx.level.Val : gmx.Max / 2;

	// Find the Y column edges
	int		Ya = -1;
	int		Yb = -1;
	{
	    int		i = gmx.CGx;

	    for ( int j=0;  j<gmx.Nrow;  j++ )
	    {
		if ( gmx.Img[j][i] >= z_level ) { Ya = j;  break; }
	    }

	    for ( int j=(gmx.Nrow - 1);  j>=0;  j-- )
	    {
		if ( gmx.Img[j][i] >= z_level ) { Yb = j;  break; }
	    }
	}

	// Find the X row edges
	int		Xa = -1;
	int		Xb = -1;
	{
	    int		j = gmx.CGy;

	    for ( int i=0;  i<gmx.Ncol;  i++ )
	    {
		if ( gmx.Img[j][i] >= z_level ) { Xa = i;  break; }
	    }

	    for ( int i=(gmx.Ncol - 1);  i>=0;  i-- )
	    {
		if ( gmx.Img[j][i] >= z_level ) { Xb = i;  break; }
	    }
	}

	cout << "Zlevel = " << z_level <<endl;

	cout << "Ya     = " <<setw(4) << Ya      <<endl;
	cout << "Yb     = " <<setw(4) << Yb      <<endl;
	cout << "Ywidth = " <<setw(4) << Yb - Ya <<endl;

	cout << "Xa     = " <<setw(4) << Xa      <<endl;
	cout << "Xb     = " <<setw(4) << Xb      <<endl;
	cout << "Xwidth = " <<setw(4) << Xb - Xa <<endl;

	// structure output so it does not all run together

    } while ( 0 );

  }
  catch ( std::exception& e ) {
    Error::msg( e.what() ) <<endl;
  }
  catch (...) {
    Error::msg( "unexpected exception\n" );
  }

  return ( Error::has_err() ? 1 : 0 );
}

