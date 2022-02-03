// 2022-02-01  William A. Hudson
//
// Extract a swatch of pixels into a table.
//--------------------------------------------------------------------------

#include <iostream>     // std::cerr
#include <iomanip>
#include <string>
#include <stdlib.h>

#include <netpbm/pgm.h>

using namespace std;

#include "Error.h"
#include "yOption.h"
#include "yOpVal.h"

#include "gmGeoSpec.h"
#include "gmNetpgm.h"


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
    geo         = "0x0+0+0";	//#!!  "WxH+X+Y"

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
    "    Extract a swatch of pixels in table format.\n"
    "usage:  " << ProgName << " [options..]  [FILE.pgm]\n"
    "    FILE.pgm            input file, '-' or default is stdin\n"
    "  required:\n"
    "    --geo=WxH+X+Y       region to extract\n"
    "  options:\n"
    "    --help              show this usage\n"
    "    -v, --verbose       verbose output\n"
//  "    --debug             debug output\n"
    "  (options with GNU= only)\n"
    "    Array indexes (x,y) with (0,0) at upper left, +X (column) to right,\n"
    "    and +Y (row) down.\n"
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

    gmNetpgm	gmx  ( in_file );	// constructor

    if ( Opx.verbose ) {
	cerr << "Ncol   = " << gmx.Ncol   <<endl;
	cerr << "Nrow   = " << gmx.Nrow   <<endl;
	cerr << "Npix   = " << gmx.Npix   <<endl;
	cerr << "MaxVal = " << gmx.MaxVal <<endl;
    }

    gmGeoSpec	gx  ( Opx.geo );

    if ( gx.GeoX >= gmx.Ncol ) {
	Error::msg( "--geo X exceeds image Ncol:  " ) << gx.GeoX <<endl;
    }

    if ( gx.GeoY >= gmx.Nrow ) {
	Error::msg( "--geo Y exceeds image Nrow:  " ) << gx.GeoY <<endl;
    }

    if ( (gx.GeoW + gx.GeoX) >= gmx.Ncol ) {
	Error::msg( "--geo W exceeds image Ncol:  " ) << gx.GeoW <<endl;
    }

    if ( (gx.GeoH + gx.GeoY) >= gmx.Nrow ) {
	Error::msg( "--geo H exceeds image Nrow:  " ) << gx.GeoH <<endl;
    }

    if ( (gx.GeoW <= 0) || (gx.GeoH <= 0) ) {
	Error::msg( "zero width image:  --geo=" ) << gx.GeoSpec <<endl;
    }

    if ( Error::has_err() )  return 1;

    int		x_max = gx.GeoX + gx.GeoW - 1;
    int		y_max = gx.GeoY + gx.GeoH - 1;

    if ( Opx.verbose ) {
	cerr << "extract region (" << gx.GeoX << "," << gx.GeoY
			  << ") (" << x_max   << "," << y_max   << ")" <<endl;
	// (x,y) to (x_max, y_max) array notation
	// Matrix notation uses (y,x) i.e. (row,col)
    }

    // Output heading
    cout << "  Jy ";
    for ( int i=gx.GeoX;  i<=x_max;  i++ )	// each column (X)
    {
//	cout << " c" << i;			// decorated index
//	cout << " c" <<left <<setw(2) << i;	// decorated index
	cout << " " <<setw(3) << i;		// bare index
    }
    cout <<right <<endl;

    // Output swatch table
    for ( int j=gx.GeoY;  j<=y_max;  j++ )	// each row (Y)
    {
	cout <<setw(4) << j << " ";

	for ( int i=gx.GeoX;  i<=x_max;  i++ )	// each column (X)
	{
	    cout << " " <<setw(3) << gmx.Img[j][i];
	}
	cout <<endl;
    }

  }
  catch ( std::exception& e ) {
    Error::msg( e.what() ) <<endl;
  }
  catch (...) {
    Error::msg( "unexpected exception\n" );
  }

  return ( Error::has_err() ? 1 : 0 );

}

