// 2022-01-17  William A. Hudson

#ifndef gmBox_P
#define gmBox_P

#include "gmStats.h"

//--------------------------------------------------------------------------
// gmBox - Grayscale Image Bounding Box class.
//--------------------------------------------------------------------------

class gmBox : public gmStats {
  public:
				// input parameters
    int			Ythreshold = 0;	// consider only pixels above this
    int			Xthreshold = 0;

				// find_Yrow_means()  Yarray[Nrow]
    int			*Ycnt;
    int			*Ymax;
    int			*Ymin;
    int			*Ymean;

    int			YmaxMean;	// maximum mean
    int			YminMean;	// minimum mean
    int			YhalfMax;	// half maximum mean for edge

				// find_Xcol_means()  Xarray[Ncol]
    int			*Xcnt;
    int			*Xmax;
    int			*Xmin;
    int			*Xmean;

    int			XmaxMean;
    int			XminMean;
    int			XhalfMax;

				// find_edges()
    int			Ytop;		// top edge
    int			Ybot;		// bottom edge
    int			Xleft;		// left edge
    int			Xright;		// right edge

				// img_add_offset()
    int			PixBase;	// amount of pixel offset

  private:
    void		init();

  public:
    gmBox( FILE* fp );			// constructor
    gmBox( const char* in_file );	// constructor
    ~gmBox();				// destructor

				// computing accessors
    void		find_Yrow_means( unsigned thresh );
    void		find_Yedges();
    void		img_add_offset();

    void		out_Yrow_means( std::ostream* ost );
};

#endif

