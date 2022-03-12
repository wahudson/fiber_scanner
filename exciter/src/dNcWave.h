// 2021-11-12  William A. Hudson

#ifndef dNcWave_P
#define dNcWave_P

#include <iostream>

//--------------------------------------------------------------------------
// Wave Table class for a numerical controlled oscillator.
//--------------------------------------------------------------------------

class dNcWave {
  private:
    size_t		Nsize;		// Number of entries used in table

  public:
    int32_t*		WavTab;		// Wave table array

  public:
    dNcWave( int n, int32_t* array );		// constructor

//    void		load_wave( std::istream*   ifs );
    void		write_wave( std::ostream*  ofs );

    void		init_sine(
			    float	r,	// amplitude
			    float	b	// offset
    );

    void		init_sine_float(
			    float	r,	// amplitude
			    float	b	// offset
    );

    uint32_t		get_size()	{ return Nsize; }
    int32_t*		get_array()	{ return WavTab; }
};


#endif

