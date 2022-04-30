// 2021-11-12  William A. Hudson

// Wave Table class for Numeric Controlled Oscillator.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>
#include <cmath>

using namespace std;

#include "dNcWave.h"


/*
* Constructor.
*    n     = number of entries, need not be a power of 2
*    array = pointer to array with at least n entries
*/
dNcWave::dNcWave(
    int		n,
    int32_t*	array
)
{
    Nsize  = n;
    WavTab = array;
}


//--------------------------------------------------------------------------
// Wave table generation.
//--------------------------------------------------------------------------

/*
* Initialize wave table with a single cycle sine wave.
*    Values are calculated in (float), then rounded away from zero to
*    signed integer (int32_t):
*        WavTab = round( r * sin() + b )
* call:
*    init_sine( r, b )
*    r = amplitude
*    b = offset
*/
void
dNcWave::init_sine(
    float		r,	// amplitude peak
    float		b	// offset
)
{
    const float		pi  = 3.14159265;
    float		rad = (float) 2 * pi / Nsize;	// step size, radians

    for ( uint32_t  i=0;  i<Nsize;  i++ )
    {
	WavTab[i] = round( ( sin( i * rad ) * r ) + b );
    }
}

//--------------------------------------------------------------------------
// Load/Store
//--------------------------------------------------------------------------

/*
* Write wave table to a stream.
* call:
*     write_wave( &std::cout )
*/
void
dNcWave::write_wave(
    std::ostream*	ofs	// output file stream
)
{
    for ( uint32_t  i=0;  i<Nsize;  i++ )
    {
	*ofs << i << "  " << WavTab[ i ] <<endl;
    }
}

