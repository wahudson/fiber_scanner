// 2022-01-09  William A. Hudson
//
// Find bounding box of an elliptical image.
// Assume background is zero, so the only non-zero pixels are the ellipse
// pattern.
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
#include "yOpVal.h"


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
    bool		table    = 0;

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
	else if ( is( "--table"      )) { table      = 1; }

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
    cout << "--sub         = " << sub.Val      << endl;
    cout << "--table       = " << table        << endl;
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
    "    Bounding box of an elliptical image\n"
    "usage:  " << ProgName << " [options..]  FILE.pgm ..\n"
    "  options:\n"
//  "    --geo=WxH+X+Y       region to analyze\n"
    "    --sub=V             subract value from each pixel\n"
    "    --table             output row mean table\n"
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
	int		Npix;
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

	Npix = Ncol * Nrow;

	cout << "Ncol   = " << Ncol   <<endl;
	cout << "Nrow   = " << Nrow   <<endl;
	cout << "Npix   = " << Npix   <<endl;
	cout << "MaxVal = " << MaxVal <<endl;

    // Subtract black level --sub
	if ( Opx.sub.Given ) {
	    int		black = Opx.sub.Val;
	    int		cnt   = 0;
	    int		Nzero = 0;
	    int		pixv;

	    if ( Opx.sub.Val > MaxVal ) {
		Error::msg( "subtract greater than MaxVal:  --sub=" )
		    << Opx.sub.Val <<endl;
		continue;
	    }

	    for ( int j=0;  j<Nrow;  j++ )		// each row (Y)
	    {
		for ( int i=0;  i<Ncol;  i++ )	// each column (X)
		{
		    pixv = img[j][i];

		    if ( pixv > 0 ) {
			cnt++;
			pixv -= black;
			if ( pixv < 0 ) { pixv = 0; }
			img[j][i] = pixv;
		    }
		    if ( pixv == 0 ) { Nzero++; }
		}
	    }
	    cout << "Nsub   = " << cnt    <<endl;	// not already zero
	    cout << "Nzero  = " << Nzero  <<endl;	// now zero
	}

	int		pixv;
	int		cnt = 0;
	long int	sum = 0;
	int		mean;
	int		max = 0;
	int		min = MaxVal;

	const int	MAXLINE = 4096;
	int		Ymean[MAXLINE];

	if ( (Ncol > MAXLINE) || (Nrow > MAXLINE) ) {
	    Error::msg( "Image exceeds MAXLINE= " ) << MAXLINE <<endl;
	}

	if ( Opx.table ) {
	    cout <<endl << "Row Means along Y" <<endl;
	    cout << "    Jy"
		 << "       cnt"
		 << "      mean"
		 << "       max"
		 << "       min"
		 <<endl;
	}

	for ( int j=0;  j<Nrow;  j++ )		// each row (Y)
	{
	    cnt = 0;
	    sum = 0;
	    max = 0;
	    min = MaxVal;

	    for ( int i=0;  i<Ncol;  i++ )	// each column (X)
	    {
		pixv = img[j][i];

		if ( pixv > 0 ) {	// threshold #!!
		    cnt++;
		    sum += pixv;
		    if ( pixv > max ) { max = pixv; }
		    if ( pixv < min ) { min = pixv; }
		}
	    }

	    if ( min > max ) { min = max; }

	    if ( cnt ) {
		mean = sum / cnt;
	    }
	    else {
		mean = 0;
	    }

	    Ymean[j] = mean;

	    if ( Opx.table ) {
		cout << "  " <<setw(4) << j
		     << "  " <<setw(8) << cnt
		     << "  " <<setw(8) << mean
		     << "  " <<setw(8) << max
		     << "  " <<setw(8) << min
		     <<endl;
	    }
	}

	// Bounding Box Y
	{
	    int		max = 0;
	    int		min = MaxVal;
	    int		mean;

	    for ( int j=0;  j<Nrow;  j++ )		// each row (Y)
	    {
		mean = Ymean[j];
		if ( mean > max ) { max = mean; }
		if ( mean < min ) { min = mean; }
	    }

	    int		halfmax;
	    int		Ytop = 0;
	    int		Ybot = 0;

	    halfmax = (max + min) / 2;		// half maximum, i.e. average

	    cout << "  Bounding Box Y:" <<endl;
	    cout << "Mmax=    " << max     <<endl;
	    cout << "Mmin=    " << min     <<endl;
	    cout << "halfmax= " << halfmax <<endl;

	    for ( int j=0;  j<Nrow;  j++ )
	    {
		if ( Ymean[j] >= halfmax ) { Ytop = j;  break; }
	    }

	    for ( int j=Nrow;  j>=0;  j-- )
	    {
		if ( Ymean[j] >= halfmax ) { Ybot = j;  break; }
	    }

	    int		Yfwhm = Ybot - Ytop;

	    cout << "  Edge Boundaries:" <<endl;
	    cout << "Ytop   = " << Ytop    <<endl;
	    cout << "Ybot   = " << Ybot    <<endl;
	    cout << "Yfwhm  = " << Yfwhm   <<endl;
	}

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

