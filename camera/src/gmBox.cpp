// 2022-01-20  William A. Hudson

// gmBox - Grayscale Image Bounding Box class.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>      // std::ostringstream
#include <string>
#include <stdexcept>
#include <math.h>
#include <netpbm/pgm.h>

using namespace std;

#include "gmBox.h"


/*
* Constructor.
//#!!
gmBox::gmBox( FILE* fp )
    : gmStats( fp )
{
    init();
}
*/

/*
* Constructor.
*/
gmBox::gmBox( const char* in_file )
    : gmStats( in_file )
{
    init();
}

/*
* Initialization.  (private)
*/
void
gmBox::init()
{
    Ycnt  = new int[Nrow];
    Ymax  = new int[Nrow];
    Ymin  = new int[Nrow];
    Ymean = new int[Nrow];
    //#!! array elements are uninitialized

    Xcnt  = new int[Ncol];
    Xmax  = new int[Ncol];
    Xmin  = new int[Ncol];
    Xmean = new int[Ncol];

    YmaxMean = -1;
    YminMean = -1;
    YhalfMax = -1;

    XmaxMean = -1;
    XminMean = -1;
    XhalfMax = -1;

    Ytop     = -1;
    Ybot     = -1;
    Xleft    = -1;
    Xright   = -1;

    PixBase  = 0;
}


/*
* Destructor.
*/
gmBox::~gmBox()
{
    delete( Ycnt  );
    delete( Ymax  );
    delete( Ymin  );
    delete( Ymean );

    delete( Xcnt  );
    delete( Xmax  );
    delete( Xmin  );
    delete( Xmean );
}


//--------------------------------------------------------------------------
// Computation
//--------------------------------------------------------------------------

/*
* Compute the Row Means.
*    Will re-compute on each call.  Dependent values are NOT invalidated.
*    Does not depend on gmStats.
* call:
*    find_Yrow_means( thresh )
*    thresh  = count only pixel values >= this value
* return:
*    Ythreshold = thresh;
*    Ycnt[], Ymax[], Ymin[], Ymean[]
*    YmaxMean, YminMean
*    YhalfMax = (YmaxMean + YminMean) / 2;  input to find_Yedges()
*/
void
gmBox::find_Yrow_means( unsigned thresh )
{
    if ( thresh > MaxVal ) {
	std::ostringstream      css;
	css << "gmBox::find_Yrow_means() MaxVal exceeded by threshold= "
	    << thresh;
	throw std::runtime_error ( css.str() );
    }

    Ythreshold = thresh;

    YmaxMean = 0;
    YminMean = MaxVal;

    for ( int j=0;  j<Nrow;  j++ )	// each row (Y)
    {
	int		pixv;
	int		cnt  = 0;
	int64_t		sum  = 0;
	int		max  = 0;
	int		min  = MaxVal;
	int		mean = 0;

	for ( int i=0;  i<Ncol;  i++ )	// each column (X)
	{
	    pixv = Img[j][i];

	    if ( pixv >= Ythreshold ) {
		cnt++;
		sum += pixv;
		if ( pixv > max ) { max = pixv; }
		if ( pixv < min ) { min = pixv; }
	    }
	}

	if ( min > max ) { min = max; }

	if ( cnt ) {
	    mean = sum / cnt;		// integer division #!! float?
	}

	Ycnt[j]  = cnt;
	Ymax[j]  = max;
	Ymin[j]  = min;
	Ymean[j] = mean;

	if ( mean > YmaxMean ) { YmaxMean = mean; }
	if ( mean < YminMean ) { YminMean = mean; }
    }

    YhalfMax = (YmaxMean + YminMean) / 2;	// half maximum, i.e. average

    return;
}

/*
* Compute the Column Means.
*    Will re-compute on each call.  Dependent values are NOT invalidated.
*    Does not depend on gmStats.
* call:
*    find_Xcol_means( thresh )
*    thresh  = count only pixel values >= this value
* return:
*    Xthreshold = thresh;
*    Xcnt[], Xmax[], Xmin[], Xmean[]
*    XmaxMean, XminMean
*    XhalfMax = (XmaxMean + XminMean) / 2;  input to find_Xedges()
*/
void
gmBox::find_Xcol_means( unsigned thresh )
{
    if ( thresh > MaxVal ) {
	std::ostringstream      css;
	css << "gmBox::find_Xcol_means() MaxVal exceeded by threshold= "
	    << thresh;
	throw std::runtime_error ( css.str() );
    }

    Xthreshold = thresh;

    XmaxMean = 0;
    XminMean = MaxVal;

    for ( int i=0;  i<Ncol;  i++ )	// each column (X)
    {
	int		pixv;
	int		cnt  = 0;
	int64_t		sum  = 0;
	int		max  = 0;
	int		min  = MaxVal;
	int		mean = 0;

	for ( int j=0;  j<Nrow;  j++ )	// each row (Y)
	{
	    pixv = Img[j][i];

	    if ( pixv >= Xthreshold ) {
		cnt++;
		sum += pixv;
		if ( pixv > max ) { max = pixv; }
		if ( pixv < min ) { min = pixv; }
	    }
	}

	if ( min > max ) { min = max; }

	if ( cnt ) {
	    mean = sum / cnt;		// integer division #!! float?
	}

	Xcnt[i]  = cnt;
	Xmax[i]  = max;
	Xmin[i]  = min;
	Xmean[i] = mean;

	if ( mean > XmaxMean ) { XmaxMean = mean; }
	if ( mean < XminMean ) { XminMean = mean; }
    }

    XhalfMax = (XmaxMean + XminMean) / 2;	// half maximum, i.e. average

    return;
}

/*
* Find the Y column edges.
*    Will re-compute on each call.
* call:
*    find_Yedges()
*    YhalfMax  = input threshold for finding edges, default from
*		find_Yrow_means()
*    Ymean[]   = means computed by find_Yrow_means()
* return:
*    Ytop, Ybot  = edges of blob, -1 if not found
*/
void
gmBox::find_Yedges()
{
    Ytop = -1;		// edges not found
    Ybot = -1;

    for ( int j=0;  j<Nrow;  j++ )
    {
	if ( Ymean[j] >= YhalfMax ) { Ytop = j;  break; }
    }

    for ( int j=(Nrow - 1);  j>=0;  j-- )
    {
	if ( Ymean[j] >= YhalfMax ) { Ybot = j;  break; }
    }
}

/*
* Find the X row edges.
*    Will re-compute on each call.
* call:
*    find_Xedges()
*    XhalfMax  = input threshold for finding edges, default from
*		find_Xcol_means()
*    Xmean[]   = means computed by find_Xcol_means()
* return:
*    Xtop, Xbot  = edges of blob, -1 if not found
*/
void
gmBox::find_Xedges()
{
    Xleft  = -1;	// edges not found
    Xright = -1;

    for ( int i=0;  i<Ncol;  i++ )
    {
	if ( Xmean[i] >= XhalfMax ) { Xleft = i;  break; }
    }

    for ( int i=(Ncol - 1);  i>=0;  i-- )
    {
	if ( Xmean[i] >= XhalfMax ) { Xright = i;  break; }
    }
}

//--------------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------------

/*
* Output table of Yrow means.
* call:
*    out_Yrow_means( std::cout )
*/
void
gmBox::out_Yrow_means( std::ostream* ost )
{
    *ost << "    Jy"
	<< "    Ycnt"
	<< "   Ymean"
	<< "    Ymax"
	<< "    Ymin"
	<<endl;

    for ( int j=0;  j<Nrow;  j++ )		// each row (Y)
    {
	*ost << "  " <<setw(4) << j
	    << "  " <<setw(6) << Ycnt[j]
	    << "  " <<setw(6) << Ymean[j]
	    << "  " <<setw(6) << Ymax[j]
	    << "  " <<setw(6) << Ymin[j]
	    <<endl;
    }
}

/*
* Output table of Xcol means.
* call:
*    out_Xcol_means( std::cout )
*/
void
gmBox::out_Xcol_means( std::ostream* ost )
{
    *ost << "    Ix"
	<< "    Xcnt"
	<< "   Xmean"
	<< "    Xmax"
	<< "    Xmin"
	<<endl;

    for ( int i=0;  i<Ncol;  i++ )		// each column (X)
    {
	*ost << "  " <<setw(4) << i
	    << "  " <<setw(6) << Xcnt[i]
	    << "  " <<setw(6) << Xmean[i]
	    << "  " <<setw(6) << Xmax[i]
	    << "  " <<setw(6) << Xmin[i]
	    <<endl;
    }
}

