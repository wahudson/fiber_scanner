// 2022-05-03  William A. Hudson

// Gain Ramp class for Numeric Controlled Oscillator.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>
#include <cmath>

using namespace std;

#include "dNcRamp.h"


/*
* Constructor.
*    n = number of bits full scale for output
*/
dNcRamp::dNcRamp(
    uint32_t		nbits_fs
    ) : dNcScaler( nbits_fs )
{
    reset_init();
    set_Gain( Gain_Qd12 >> 12 );
}

/*
* Reset to initial constructor state.
*    The current applied dNcScaler::Gain is not changed.
*/
void
dNcRamp::reset_init()
{
    HiGain_Qd12    = 1 << 12;		// gain 1
    GainStep_Qd12  = HiGain_Qd12;	// step size
    RampDuration   = 1;			// ramp number of steps
    HoldDuration   = 100;		// hold state number of steps

    restart_ramp();			// set state machine
}

//--------------------------------------------------------------------------
// Configuration
//--------------------------------------------------------------------------
/*
* Can be set while running - will continue in the same state with new
*     configuration.
* The set_() functions do not update the active Gain used by
*     dNcScaler::scale(), only ramp_step() does that.
*#!! Is an apply_config() needed to update active Gain?
*/

/*
* Restart the ramp pattern, configuration is unchanged.
*    Essentially reset the state machine.
* call:
*    restart_ramp()
*/
void
dNcRamp::restart_ramp()
{
    RampState    = 3;			// ramp up
    HoldCnt      = HoldDuration;	// current count down remaining
    Gain_Qd12    = 0;			// current ramp gain
}

/*
* Set the Gain high level of ramp.
*    The current GainStep_Qd12 is also updated based on RampDuration,
*    regardless of RampState.
*    Gain is limited by the dNcScaler::scale() fixed-point computation.
*    #!! Only positive gain is allowed as an initial simplification.
* call:
*    set_HiGain( gain )
*    gain  = value in the hold state, 0 <= gain <= MaskFS
*	#!! allow negative?
*/
void
dNcRamp::set_HiGain(
    int32_t		gain
)
{
    int32_t		limit = MaskFS;		// uint32_t

    if ( gain < 0 ) {
	std::ostringstream	css;
	css << "dNcRamp::set_HiGain() must be positive:  " << gain;
	throw std::range_error ( css.str() );
    }

    if ( (gain > limit) || (gain < -limit) ) {
	std::ostringstream	css;
	css << "dNcRamp::set_HiGain() too large:  " << gain;
	throw std::range_error ( css.str() );
    }

    HiGain_Qd12 = gain << 12;

    if ( Gain_Qd12 > HiGain_Qd12 ) {	// keep current gain in range
	 Gain_Qd12 = HiGain_Qd12;
    }

    set_RampDuration( RampDuration );	// recompute GainStep_Qd12
}

/*
* Set the ramp rate GainStep_Qd12 as a given number of cycles.
*    Depends on HiGain_Qd12.
*    The given RampDuration is saved for use by set_HiGain().
* call:
*    set_RampDuration( N )
*    N  = number of ramp_step() cycles for ramp duration, >= 1
* return:
*    GainStep_Qd12 = HiGain_Qd12 / count,  =1 as a minimum limit
*/
void
dNcRamp::set_RampDuration(
    int32_t		count
)
{
    int32_t		gainstep;

    if ( count <= 0 ) {
	std::ostringstream	css;
	css << "dNcRamp::set_RampDuration() must be positive:  " << count;
	throw std::range_error ( css.str() );
    }

    gainstep = HiGain_Qd12 / count;	// integer divide

    if ( gainstep <= 0 ) {
	gainstep = 1;	// minimum step

	// Decide no-throw for now.
//	std::ostringstream	css;
//	css << "dNcRamp::set_RampDuration() too large:  " << count
//	    << ",  HiGain_Qd12= " << HiGain_Qd12;
//	throw std::range_error ( css.str() );
    }

    // Extra sanity check.
    if ( (gainstep * (count + 1)) < HiGain_Qd12 ) {
	std::ostringstream	css;
	css << "dNcRamp::set_RampDuration() internal small gainstep= "
	    << gainstep;
	throw std::range_error ( css.str() );
    }

    RampDuration  = count;
    GainStep_Qd12 = gainstep;
}

/*
* Set the hold duration as the number of cycles.
*    The hold period is where the gain is held constant at HiGain.
*    The current HoldCnt is also updated, regardless of RampState.
* call:
*    set_HoldDuration( N )
*    N  = number of ramp_step() cycles for hold duration, >= 1
*/
void
dNcRamp::set_HoldDuration(
    int32_t		count
)
{
    if ( count <= 0 ) {
	std::ostringstream	css;
	css << "dNcRamp::set_HoldDuration() must be positive:  " << count;
	throw std::range_error ( css.str() );
    }

    HoldDuration = count;
    HoldCnt      = count;
}

//--------------------------------------------------------------------------
// Ramp Step
//--------------------------------------------------------------------------

/*
* Evolve one ramp step.
*    Typically call once per waveform cycle near a zero crossing.
*    Creates a Gain profile:  ramp up from zero to HiGain_Qd12, hold, then
*        ramp down to zero.
*    Ramp duration is controlled by the GainStep_Qd12 increment.
*    Hold duration is the counted number of cycles in HoldCnt.
*    Require:  Currently only for positive Gain.
*        (GainStep_Qd12 > 0)
*        (HiGain_Qd12   > 0)
* call:
*    ramp_step()
* return:
*    ()  = ramp state [3..0] - up, hold, down, done
*/
int
dNcRamp::ramp_step()
{
    switch ( RampState )
    {

    case 3:	// ramp up
	Gain_Qd12 += GainStep_Qd12;
	if ( Gain_Qd12 >= HiGain_Qd12 ) {
	    Gain_Qd12 = HiGain_Qd12;	// clamp final
	    RampState = 2;
	}
	set_Gain( Gain_Qd12 >> 12 );
	break;

    case 2:	// hold
	HoldCnt--;
	if ( HoldCnt <= 0 ) {
	    RampState = 1;
	}
	break;

    case 1:	// ramp down
	Gain_Qd12 -= GainStep_Qd12;
	if ( Gain_Qd12 <= 0 ) {
	    Gain_Qd12 = 0;		// clamp zero
	    RampState = 0;
	}
	set_Gain( Gain_Qd12 >> 12 );
	break;

    case 0:	// done
	return  0;
    }

    return  RampState;
}

