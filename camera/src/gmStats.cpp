// 2022-01-16  William A. Hudson

// gmStats - Grayscale Image Statistics class.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>      // std::ostringstream
#include <string>
#include <stdexcept>
#include <math.h>
#include <netpbm/pgm.h>

using namespace std;

#include "gmStats.h"


/*
* Constructor.
*/
gmStats::gmStats()
{
    StdDev = -1.0;
    Max    = -1;
    Min    = -1;
    Sum    = -1;
    Mean   = -1.0;
    CGx    = -1;
    CGy    = -1;
}

/*
* Constructor.
*/
gmStats::gmStats( const char* in_file )
    : gmNetpgm( in_file )
{
    StdDev = -1.0;
    Max    = -1;
    Min    = -1;
    Sum    = -1;
    Mean   = -1.0;
    CGx    = -1;
    CGy    = -1;
}

//--------------------------------------------------------------------------
// Computation
//--------------------------------------------------------------------------

/*
* Compute all attributes, but not Standard Deviation.
* call:
*    get_mean()
*/
int
gmStats::get_mean()
{
    if ( Mean >= 0 ) {
	return  Mean;
    }

    if ( Img == NULL ) {
	std::ostringstream      css;
	css << "gmStats::get_mean() image not loaded";
	throw std::runtime_error ( css.str() );
    }

    int			pixv;
    int64_t		cgx;	// avoid integer overflow in very large sum
    int64_t		cgy;

    Max    = 0;
    Min    = MaxVal;
    Sum    = 0;
    Mean   = 0;
    cgx    = 0;
    cgy    = 0;

    for ( int j=0;  j<Nrow;  j++ )
    {
	for ( int i=0;  i<Ncol;  i++ )
	{
	    pixv = Img[j][i];

	    Sum += pixv;

	    if ( pixv > Max ) { Max = pixv; }
	    if ( pixv < Min ) { Min = pixv; }

	    cgx += i * pixv;
	    cgy += j * pixv;
	}
    }

    Mean = (float) Sum / Npix;

    CGx = cgx / Sum;		// integer division
    CGy = cgy / Sum;

    return  Mean;
}


/*
* Compute Standard Deviation.
* call:
*    get_std_deviation()
*/
float
gmStats::get_std_deviation()
{
    if ( StdDev >= 0 ) {
	return  StdDev;
    }

    if ( Mean < 0 ) {		// not computed
	get_mean();
    }

    int64_t		sd = 0;		// sum of deviation squared

    for ( int j=0;  j<Nrow;  j++ )
    {
	for ( int i=0;  i<Ncol;  i++ )
	{
	    register int	dv;	// deviation
	    dv = Img[j][i];
	    dv -= Mean;
	    sd += dv * dv;
	}
    }

    StdDev = sqrt( (float) sd / Npix );

    return  StdDev;
}

