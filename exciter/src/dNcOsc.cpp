// 2018-08-24  William A. Hudson

// Numeric Controlled Oscillator class.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>

using namespace std;

#include "dNcWave.h"
#include "dNcOsc.h"


/*
* Constructor.
*    The wave table must be initialized.
* call:
*    dNcOsc	nox  ( &wx, stride_int, stride_frac );	// constructor
*    &wx         = pointer to an initialized wave table
*    stride_int  = stride integer part
*    stride_frac = stride fractional part
* Note:
*    The maximum wave table size is limited by MaxPhase to
*    (1 << (32 - Kbits)) entries.  Is a trade-off with Stride fractional
*    resolution, Kbits, to fit in a 32-bit integer.
*/
dNcOsc::dNcOsc(
    dNcWave		*wx,
    uint32_t		stride_int,
    uint32_t		stride_frac
)
{
    if ( ! wx ) {
	std::ostringstream	css;
	css << "dNcOsc:  constructor requires dNcWave object";
	throw std::logic_error ( css.str() );
    }

    if ( stride_int >= wx->get_size() ) {
	std::ostringstream	css;
	css << "dNcOsc:  constructor:  stride_int exceeds wave table size";
	throw std::logic_error ( css.str() );
    }

    // cout << "dNcOsc:  constructor get_size()= " << wx->get_size() << endl;
    // cout << "dNcOsc:  constructor Kmask= " << Kmask << endl;

    WTab       = wx;
    MaxPhase   = to_phase( wx->get_size() - 1, Kmask );
    AccPhase   = 0;
    Stride     = to_phase( stride_int, stride_frac );

    if ( Stride >= MaxPhase ) {		// sanity check relied-on condition
	std::ostringstream	css;
	css << "dNcOsc:  constructor Stride exceeds MaxPhase:  ";
	css << Stride;
	throw std::range_error ( css.str() );
    }
}

//--------------------------------------------------------------------------
// Initialization
//--------------------------------------------------------------------------

/*
* Set the stride (phase increment).
*/
void
dNcOsc::set_stride(
    float		v
)
{
    uint32_t		stride;

    stride = float2qmk( v );

    if ( stride >= MaxPhase ) {
	std::ostringstream	css;
	css << "dNcOsc::set_stride():  stride exceeds MaxPhase:  ";
	css << v;
	throw std::range_error ( css.str() );
    }

    Stride   = stride;
}


/*
* Set the accumulated phase index AccPhase.
*/
void
dNcOsc::set_phase(
    float		v
)
{
    uint32_t		phase;

    phase = float2qmk( v );

    if ( phase >= MaxPhase ) {
	std::ostringstream	css;
	css << "dNcOsc::set_phase():  phase exceeds MaxPhase:  ";
	css << v;
	throw std::range_error ( css.str() );
    }

    AccPhase = phase;
}

//--------------------------------------------------------------------------
// Oscillator
//--------------------------------------------------------------------------

/*
* Return next oscillator output index.
*    Increments the accumulated phase with Stride.
*    Rollover at MaxPhase.
*/
uint32_t
dNcOsc::next_index()
{
    uint32_t		index;	// index into wave table

    AccPhase += Stride;

    if ( AccPhase > MaxPhase ) {
	AccPhase -= MaxPhase;
    }

    index = (AccPhase >> Kbits);

    return  index;
}


/*
* Return next oscillator output sample.
*    Increments the accumulated phase with Stride.
*    Rollover at Nsize end of table.
*/
uint32_t
dNcOsc::next_sample()
{
    uint32_t		out;	// output sample
    uint32_t		index;	// index into wave table

    AccPhase += Stride;

    if ( AccPhase > MaxPhase ) {
	AccPhase -= MaxPhase;
    }

//    cout << "0x" <<hex << AccPhase <<endl;
//    cout <<dec;

    index = (AccPhase >> Kbits);

    if ( index >= WTab->get_size() ) {
	std::ostringstream	css;
	css << "dNcOsc::next():  index exceeded Nsize:  " << index;
	throw std::range_error ( css.str() );
    }
//#!! use Kmask?  range check?

    out = WTab->WavTab[ index ];

    return  out;
}

//--------------------------------------------------------------------------
// Conversion functions
//--------------------------------------------------------------------------

/*
* Convert float to Qm.k format, where k= Kbits.
*    Precision may be lost.
* call:
*    float2qmk( f )
*    f = positive float (double) (f >= 0).
* return:
*    ()  = phase, in Qm.k format, where k=Kbits, m=(32 - Kbits)
*/
uint32_t
dNcOsc::float2qmk(
    double 		f
)
{
    uint32_t		phase;

    phase = (Kmask + 1) * f;

    return  phase;
//#!! check positive, overflow
}


/*
* Convert Qm.k to float, where k= Kbits.
*    Precision may be lost.
* call:
*    qmk2float( u )
*    u = unsigned Qm.k
* return:
*    ()  = float
*/
float
dNcOsc::qmk2float(
    uint32_t 		u	// Qm.k
)
{
    float		y;

    y = (u & Kmask);		// fractional part as integer, convert to float
    y = y / (Kmask + 1);

    y = y + (u >> Kbits);	// add integer part converted to float

    return  y;
}


/*
* Convert integers to fixed-point phase.
* call:
*    to_phase( mag, frac )
*    mag  = unsigned integer part,    less than (32 - Kbits) bits
*    frac = unsigned fractional part, less than (Kbits) bits
* return:
*    ()  = phase, in Qm.k format, where k=Kbits, m=(32 - Kbits)
* exceptions:
*    std::range_error  if either mag or frac is out of range.
*/
uint32_t
dNcOsc::to_phase(
    uint32_t		mag,
    uint32_t		frac
)
{
    uint32_t		phase;

    if ( frac > Kmask ) {
	std::ostringstream	css;
	css << "dNcOsc::to_phase():  fraction exceeds Kbits (4095):  ";
	css << frac;
	throw std::range_error ( css.str() );
    }

    if ( mag >= ( (uint32_t) 1 << (32 - Kbits) ) ) {
	std::ostringstream	css;
	css << "dNcOsc::to_phase():  integer exceeds 2^20 (1048575):  ";
	css << mag;
	throw std::range_error ( css.str() );
    }

    phase = (mag << Kbits) + frac;

    return  phase;
}


/*
* Get average number of output samples per cycle.
* call:
*    get_nout()
* return:
*    ()  = average number of samples per cycle (float)
*/
float
dNcOsc::get_nout()
{
    float		nout;

    nout = (float) WTab->get_size() / ((float) Stride / (Kmask + 1));

    return  nout;
}


