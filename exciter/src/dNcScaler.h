// 2022-03-10  William A. Hudson

#ifndef dNcScaler_P
#define dNcScaler_P

#include <iostream>

//--------------------------------------------------------------------------
// Signal Scaler class for a numerical controlled oscillator.
//--------------------------------------------------------------------------

class dNcScaler {
  private:
    uint32_t		Nbits;		// output number of bits full scale
    uint32_t		MaskFS;		// full scale mask ((1 << Nbits) - 1)
					//     is maximum FS output.

    int32_t		Gain;		// multiplier [-MaskFS to MaskFS]
    int32_t		Offset;		// offset     [0 to MaskFS]

  public:
    dNcScaler( uint32_t nbits );		// constructor

    uint32_t		get_Nbits()	{ return Nbits; }
    uint32_t		get_MaskFS()	{ return MaskFS; }

    void		set_Gain(   int32_t gain );
    void		set_Offset( int32_t offset );

    int32_t		get_Gain()	{ return Gain; }
    int32_t		get_Offset()	{ return Offset; }

    uint32_t		scale( int32_t v );

    uint32_t		Qd30_float(   float y );
    float		float_Qd30( int32_t u );
};

#endif

