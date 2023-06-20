// 2023-02-01  William A. Hudson

// Triangle Wave generation class for raster scan.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>
#include <cmath>

using namespace std;

#include "dNcTriangle.h"


/*
* Constructor.
*/
dNcTriangle::dNcTriangle(
    float	dy_up,
    float	dy_down
)
{
    yMax_Qd30 = 0x40000000;	// +1.0  Normalized
    yMin_Qd30 = -yMax_Qd30;	// -1.0

    dyUp_Qd30 = 0x00200000;	// default slopes
    dyDn_Qd30 = -dyUp_Qd30;

    y_Qd30  = 0;		// initial point
    dy_Qd30 = dyUp_Qd30;	// initial slope
}

//--------------------------------------------------------------------------
// Triangle Configuration
//--------------------------------------------------------------------------

/*
* Set slope step sizes for normalized (+1.0, -1.0) triangle wave.
*    Values are given in (float), then converted to Q2.30 fixed point.
* call:
*    set_step_size( +0.01, -0.4 )
*/
void
dNcTriangle::set_step_size(
    double		dy_up,		// slope up   (+1.0 > dy_up   > 0.0)
    double		dy_down		// slope down (-1.0 < dy_down < 0.0)
)
{
    if ( dy_up <= 0.0 ) {
	std::ostringstream      css;
	css << "dNcTriangle::set_step_size():  require positive dy_up= ";
	css << dy_up;
	throw std::range_error ( css.str() );
    }

    if ( dy_down >= 0.0 ) {
	std::ostringstream      css;
	css << "dNcTriangle::set_step_size():  require negative dy_down= ";
	css << dy_down;
	throw std::range_error ( css.str() );
    }

    dyUp_Qd30 = float2Qd30( dy_up   );
    dyDn_Qd30 = float2Qd30( dy_down );
}


/*
* Set slope step sizes for normalized (+1.0, -1.0) triangle wave.
*    Values are numbers of points on each slope, then converted to Q2.30
*    fixed point.
* call:
*    set_slope_points( 100, 50 )
*/
void
dNcTriangle::set_slope_points(
    int			n_up,		// n steps up
    int			n_down		// n steps down
)
{
//    dyUp_Qd30 =  (yMax_Qd30 - yMin_Qd30) / n_up;
//    dyDn_Qd30 = -(yMax_Qd30 - yMin_Qd30) / n_down;

    dyUp_Qd30 =   (yMax_Qd30 / n_up)   - (yMin_Qd30 / n_up);
    dyDn_Qd30 = -((yMax_Qd30 / n_down) - (yMin_Qd30 / n_down));
	// avoid overflow, integer math
}


/*
* Initialize point on triangle wave.
* call:
*    init_point( v, dir )
*        v = value (double), -1.0 <= v <= +1.0
*        dir = direction of slope {+1, -1}
*/
void
dNcTriangle::init_point(
    float		v,
    int			direction
)
{
    y_Qd30  = float2Qd30( v );

    if ( direction >= 0 ) {
	dy_Qd30 = dyUp_Qd30;
    }
    else {
	dy_Qd30 = dyDn_Qd30;
    }

}

//--------------------------------------------------------------------------
// Triangle Generation
//--------------------------------------------------------------------------

/*
* Set slope step sizes for normalized (+1.0, -1.0) triangle wave.
* call:
*    next_sample_Qd30()
*/
int32_t
dNcTriangle::next_sample_Qd30()
{
    y_Qd30 += dy_Qd30;

    if ( y_Qd30 >= yMax_Qd30 ) {
	// y_Qd30  = yMax_Qd30;
	y_Qd30  = yMax_Qd30 - y_Qd30 + yMax_Qd30;	// avoid overflow
	dy_Qd30 = dyDn_Qd30;
    }

    if ( y_Qd30 <= yMin_Qd30 ) {
	// y_Qd30  = yMin_Qd30;
	y_Qd30  = yMin_Qd30 - y_Qd30 + yMin_Qd30;	// avoid overflow
	dy_Qd30 = dyUp_Qd30;
    }

    return  y_Qd30;
}

//--------------------------------------------------------------------------
// Conversion functions
//--------------------------------------------------------------------------

/*
* Convert float to Qd30 format.
*    Precision may be lost.  May overflow.
* call:
*    float2Qd30( f )
*    f = float (double)
* return:
*    ()  = Qd30 fixed point (integer)
*/
int32_t
dNcTriangle::float2Qd30(
    double              f
)
{
    int32_t		fix;

    if ( (f > +1.0) || (f < -1.0) ) {
	std::ostringstream      css;
	css << "dNcTriangle::float2Qd30():  range [-1.0:+1.0] exceeded:  ";
	css << f;
	throw std::range_error ( css.str() );
    }

    fix = 0x40000000 * f;	// compute in (double), truncate to int32_t

    return  fix;
}

/*
* Convert Qd30 format to float.
*    Precision may be lost.  May overflow.
* call:
*    Qd30_2float( v )
*    v = q2.30 fixed point integer
* return:
*    ()  = float (double)
*/
double
dNcTriangle::Qd30_2float(
    int32_t		fix
)
{
    double		f;

    f = (double) fix / (double) 0x40000000;

    return  f;
}

