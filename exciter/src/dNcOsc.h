// 2018-08-24  William A. Hudson

#ifndef dNcOsc_P
#define dNcOsc_P

#include <iostream>

#include "dNcWave.h"

//--------------------------------------------------------------------------
// Numerical Controled Oscillator class.
//--------------------------------------------------------------------------

class dNcOsc {
  private:
    dNcWave*		WTab;		// Pointer to wave table object.

				// Qm.k fixed point values, k= Kbits
    uint32_t		Stride;		// Stride stepping thru wave table.
    uint32_t		AccPhase;	// Accumulated phase index into WTab.
    uint32_t		MaxPhase;	// Maximum Accumulated phase.

    const uint		Kbits = 12;	// Number of bits in fractional part.
    const uint32_t	Kmask = (1 << Kbits) - 1;

  public:
    dNcOsc(				// constructor
	dNcWave*	wx,
	uint32_t	stride_int,
	uint32_t	stride_frac
    );

    uint32_t		get_MaxPhase_qmk() { return  MaxPhase; }

    uint32_t		get_stride_qmk()   { return Stride; }	// Qm.k
    float		get_stride_float() { return qmk2float( Stride ); }

    uint32_t		get_phase_qmk()    { return AccPhase; }	// Qm.k
    float		get_phase_float()  { return qmk2float( AccPhase ); }

    void		set_stride( float  v );
    void		set_phase(  float  v );

    float		qmk2float( uint32_t u );
    uint32_t		float2qmk( double f );

    uint32_t		next_sample();
    uint32_t		next_index();

    uint32_t		get_index()  { return (AccPhase >> Kbits); }

    bool		is_new_cycle()	{ return (AccPhase < Stride); }

    uint32_t		phase2mag( uint32_t phase ) { return (phase >> Kbits); }
    uint32_t		phase2frac( uint32_t phase ) { return (phase & Kmask); }

    uint32_t		to_phase( uint32_t mag, uint32_t frac );

    float		get_nout();
};


#endif

