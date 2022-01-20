// 2022-01-16  William A. Hudson

#ifndef gmStats_P
#define gmStats_P

#include "gmNetpgm.h"

//--------------------------------------------------------------------------
// gmStats - Grayscale Image Statistics class.
//--------------------------------------------------------------------------

class gmStats : public gmNetpgm {
  private:
    float		StdDev;		// standard deviation

  public:
    int			Max;		// maximum pixel value in image
    int			Min;		// minimum pixel value in image
    int64_t		Sum;		// sum of all pixel values
    float		Mean;		// mean value of all pixels

    int			CGx;		// center of gravity
    int			CGy;

    gmStats();				// constructor
    gmStats( const char* in_file );	// constructor

				// computing accessors
    int			get_mean();
    float		get_std_deviation();
};

#endif

