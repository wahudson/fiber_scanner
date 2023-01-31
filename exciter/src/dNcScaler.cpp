// 2022-03-10  William A. Hudson

// Signal Scaler class for Numeric Controlled Oscillator.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>
#include <cmath>

using namespace std;

#include "dNcScaler.h"


/*
* Constructor.
*    n = number of bits full scale for output
*/
dNcScaler::dNcScaler(
    uint32_t		n
)
{
    if ( n > 16 ) {
	std::ostringstream	css;
	css << "dNcScaler:  constructor requires Nbits<=16:  " << n;
	throw std::range_error ( css.str() );
    }

    Nbits  = n;
    MaskFS = (1 << Nbits) - 1;
    Gain   = 1;
    Offset = 0;
}

//--------------------------------------------------------------------------
// Accessors
//--------------------------------------------------------------------------

/*
* Set Gain scale factor.
*    Gain is a Q14.0 value with range [-MaskFS to MaskFS].
*    Wave table entries Q2.30 are multiplied by (Gain / MaskFS).
*    Negative gain is allowed.
*    Small sanity check?
* call:
*/
void
dNcScaler::set_Gain(
    int32_t		gain	// gain < MaxBits
)
{
    int32_t		limit;

    limit = (Nbits > 14) ? (1 << 14) - 1 : MaskFS;

    if ( (gain > limit) || (gain < -limit) ) {
	std::ostringstream	css;
	css << "dNcScaler::set_Gain() too large:  " << gain;
	throw std::range_error ( css.str() );
    }

    Gain = gain;
}


/*
* Set Offset value, must be positive.
* call:
*/
void
dNcScaler::set_Offset(
    int32_t		offset
)
{
    if ( (offset < 0 ) || (offset > (int) MaskFS) ) {
	std::ostringstream	css;
	css << "dNcScaler::set_Offset() too large:  " << offset;
	throw std::range_error ( css.str() );
    }

    Offset = offset;
}


//--------------------------------------------------------------------------
// Scale value
//--------------------------------------------------------------------------

/*
* Scale a Q2.30 wave table entry for an Nbits DAC.
*    Input value is signed Q2.30 fixed point:  -1.9999 <= i <= +1.9999
*        bit[31] is sign (twos complement)
*        bit[30] is the +-1
*        bit[29:0] is the fractional value (30 bits)
*    Generally use  -1.0 <= i <= +1.0
*    Note the lower 14 bits are discarded, which could be used for flags,
*    preserving 16 bits of precision.
*    Result is saturated to avoid glitches from wrap-around.
* call:
*    scale_Qd30( i )
*      i = signed Q2.30 fixed point,  -2 < i < +2
* return:
*    ()  = ((i * Gain) + Offset) unsigned Nbits integer, clamped (saturated)
*          in range [0 .. MaskFS], where MaskFS = 2^Nbits - 1
*/
uint32_t
dNcScaler::scale_Qd30(
    int32_t		value
)
{
    register int32_t	x;

    // value		// Q2.30  input value
    x = value >> 14;	// Q2.16  discard low bits
    x = x * Gain;	// Q16.16, Gain is Q14.0 signed
    x = x >> 16;	// Q16.0
    x = x + Offset;	// Q17.0,  Offset is Q16.0, positive (>0)

    if ( x & ~MaskFS ) {	// overflow or negative
	if ( x < 0 ) {
	    x = 0;
	}
	else {
	    x = MaskFS;
	}
    }

    x = x & MaskFS;	// Q16.0

    return  x;
}


//--------------------------------------------------------------------------
// Conversion
//--------------------------------------------------------------------------

//#!! Possibly use double float, and int64_t?

/*
* Convert float into Q2.30 integer format.
*    Require ( -2.0 < y < 2.0 ) to avoid overflow.
* call:
*/
uint32_t
dNcScaler::Qd30_float(
    float		y
)
{
    uint32_t		u;

    u = y * ((float) 0x40000000);

    return  u;
}

/*
* Convert a Q2.30 integer into a float.
*    Precision is lost, as float has only a 24-bit mantissa.
* call:
*/
float
dNcScaler::float_Qd30(
    int32_t		u
)
{
    float		y;

    y = ((float) u) / ((float) 0x40000000);

    return  y;
}

