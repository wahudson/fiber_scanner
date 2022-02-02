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

#include "gmBox.h"


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
    "usage:  " << ProgName << " [options..]  [FILE.pgm]\n"
    "    FILE.pgm            input file, '-' or default is stdin\n"
    "  options:\n"
//  "    --geo=WxH+X+Y       region to analyze\n"
    "    --sub=V             subract value from each pixel\n"
    "    --table             output row/column mean tables\n"
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
	gmBox		gmx  ( in_file );	// constructor

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

	gmx.find_Yrow_means( 2 );		//#!! threshold
	gmx.find_Xcol_means( 2 );

	if ( Opx.table ) {
	    gmx.out_Yrow_means( &cout );
	    cout <<endl;
	    gmx.out_Xcol_means( &cout );
	    cout <<endl;
	}

	gmx.find_Yedges();
	gmx.find_Xedges();

	cout << "  Bounding Box Y:" <<endl;
	cout << "YmaxMean = " << gmx.YmaxMean  <<endl;
	cout << "YminMean = " << gmx.YminMean  <<endl;
	cout << "YhalfMax = " << gmx.YhalfMax  <<endl;
	cout << "Ytop     = " << gmx.Ytop      <<endl;
	cout << "Ybot     = " << gmx.Ybot      <<endl;
	cout << "Yfwhm    = " << gmx.Ybot - gmx.Ytop <<endl;

	cout << "  Bounding Box X:" <<endl;
	cout << "XmaxMean = " << gmx.XmaxMean  <<endl;
	cout << "XminMean = " << gmx.XminMean  <<endl;
	cout << "XhalfMax = " << gmx.XhalfMax  <<endl;
	cout << "Xleft    = " << gmx.Xleft     <<endl;
	cout << "Xright   = " << gmx.Xright     <<endl;
	cout << "Xfwhm    = " << gmx.Xright - gmx.Xleft <<endl;

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

