// 2023-01-31  William A. Hudson

#ifndef dNcTriangle_P
#define dNcTriangle_P

#include <iostream>

//--------------------------------------------------------------------------
// Triangle Wave generation class for raster scan.
//--------------------------------------------------------------------------
// Normalized fixed point Q2.30 {-1.0 to +1.0}

class dNcTriangle {
  private:
				// signed Q2.30 fixed point values
    int32_t		y_Qd30;		// current value, point on wave
    int32_t		dy_Qd30;	// current slope (step size)

    int32_t		dyUp_Qd30;	// slope up   (> 0)
    int32_t		dyDn_Qd30;	// slope down (< 0)

    int32_t		yMin_Qd30;	// normalized min -1.0
    int32_t		yMax_Qd30;	// normalized max +1.0

  public:
    dNcTriangle(		// constructor
	float		dy_up,
	float		dy_down
    );

    int32_t		get_y_Qd30()	{ return  y_Qd30; }
    int32_t		get_dy_Qd30()	{ return  dy_Qd30; }

    int32_t		get_yMin_Qd30()	{ return  yMin_Qd30; }
    int32_t		get_yMax_Qd30()	{ return  yMax_Qd30; }

    int32_t		get_dyUp_Qd30()	{ return  dyUp_Qd30; }
    int32_t		get_dyDn_Qd30()	{ return  dyDn_Qd30; }

    void		set_step_size( double dy_up, double dy_down );
    void		set_slope_points( int n_up, int n_down );

    void		init_point( float y, int direction );

    int32_t		next_sample_Qd30();	// advance the wave

    bool		is_rising()	{ return  ( (dy_Qd30 > 0) ? 1 : 0 ); }

    bool		is_atmax();
    bool		is_atmin();
    bool		is_atzero();

    int32_t		float2Qd30( double f );
    double		Qd30_2float( int32_t v );
};

#endif

