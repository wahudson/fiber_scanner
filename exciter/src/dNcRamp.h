// 2022-05-03  William A. Hudson

#ifndef dNcRamp_P
#define dNcRamp_P

#include "dNcScaler.h"

//--------------------------------------------------------------------------
// Gain Ramp class for a numerical controlled oscillator.
//--------------------------------------------------------------------------

class dNcRamp : public dNcScaler {
  private:
				// configuration
    int32_t		HiGain_Qd12;	// High-level gain in hold state
    int32_t		GainStep_Qd12;	// step size

    int32_t		RampDuration;	// ramp number of steps
    int32_t		HoldDuration;	// hold state number of steps

				// state machine
    int			RampState;	// [3..0] up, hold, down, done
    int			HoldCnt;	// current count down remaining
    int32_t		Gain_Qd12;	// current ramp gain

  public:
    dNcRamp( uint32_t nbits_fs );	// constructor

    void		reset_init();	// reset to initial constructor state

				// debug accessors
    int32_t		get_HiGain_Qd12()    { return  HiGain_Qd12; }
    int32_t		get_GainStep_Qd12()  { return  GainStep_Qd12; }
    int32_t		get_RampDuration()   { return  RampDuration; }
    int32_t		get_HoldDuration()   { return  HoldDuration; }
    int			get_RampState()      { return  RampState; }
    int			get_HoldCnt()        { return  HoldCnt; }
    int32_t		get_Gain_Qd12()      { return  Gain_Qd12; }

				// configuration
    void		restart_ramp();			// start over
    void		set_HiGain(       int32_t gain  );
    void		set_RampDuration( int32_t count );
    void		set_HoldDuration( int32_t count );

    int			ramp_step();	// evolve one step, 0=done

				// debug/test (private)
    void		TESTset_Gain_Qd12( int32_t v )  { Gain_Qd12 = v; }
};

#endif

