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
    "    Compute image stats - min, max, mean, standard deviation\n"
    "usage:  " << ProgName << " [options..]  FILE.pgm ..\n"
    "  options:\n"
//  "    --geo=WxH+X+Y       region to analyze\n"
    "    --help              show this usage\n"
    "    -v, --verbose       verbose output, show if fake memory\n"
    "    --debug             debug output\n"
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

    char*		in_file;
    while ( ( in_file = Opx.next_arg() ) )
    {
	cout << "==> " << in_file << " <==" << endl;

	FILE		*fp;
	gray**		img;		// pointer to image array img[row][col]
	int		Ncol;
	int		Nrow;
	unsigned	MaxVal;

	fp = fopen( in_file, "r" );

	if ( fp == NULL ) {
	    Error::msg( "file not found:  " ) << in_file <<endl;
	    continue;
	}

	pm_init( Opx.ProgName, 0 );

	img = pgm_readpgm(
	    fp,
	    &Ncol,
	    &Nrow,
	    &MaxVal		// maximum gray value
	);

	cout << "Ncol   = " << Ncol   <<endl;
	cout << "Nrow   = " << Nrow   <<endl;
	cout << "MaxVal = " << MaxVal <<endl;
	cout << "im[0,0]= " << **img <<endl;

	int		pixv;
	int		max = 0;
	int		min = MaxVal;
	long int	sum = 0;

	for ( int j=0;  j<Nrow;  j++ )
	{
	    for ( int i=0;  i<Ncol;  i++ )
	    {
		pixv = img[j][i];

		sum += pixv;

		if ( pixv > max ) { max = pixv; }
		if ( pixv < min ) { min = pixv; }

//		cout << "im[" << i << "," << j << "]= " << img[i][j] <<endl;
	    }
	}

	int		Npix;
	int		mean;
	float		sd   = 0;
	float		cgx  = 0;
	float		cgy  = 0;

	Npix = Ncol * Nrow;

	mean = sum / Npix;

	cout << "Npix   = " << Npix   <<endl;
	cout << "max    = " << max    <<endl;
	cout << "min    = " << min    <<endl;
	cout << "sum    = " << sum    <<endl;
	cout << "mean   = " << mean   <<endl;

	// Standard Deviation (SD)
	for ( int j=0;  j<Nrow;  j++ )
	{
	    for ( int i=0;  i<Ncol;  i++ )
	    {
		pixv = img[j][i];

		sd += (pixv - mean) * (pixv - mean);

		cgx += i * pixv;
		cgy += j * pixv;
	    }
	}

	cout << "sd_sum = " << sd     <<endl;
	sd = sqrt( sd / Npix );

	long int	CGx = lroundf( cgx / sum );
	long int	CGy = lroundf( cgy / sum );

	cout << "SD     = " << sd     <<endl;
	cout << "CG     = " << CGx << ", " << CGy <<endl;

    }

  }
  catch ( std::exception& e ) {
    Error::msg( "exception caught:  " ) << e.what() <<endl;
  }
  catch (...) {
    Error::msg( "unexpected exception\n" );
  }

  return ( Error::has_err() ? 1 : 0 );

}

