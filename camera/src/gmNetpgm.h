// 2022-01-16  William A. Hudson

#ifndef gmNetpgm_P
#define gmNetpgm_P

typedef unsigned int	gray_t;		// match Netpbm type gray

//--------------------------------------------------------------------------
// gmNetpgm - Netpbm Grayscale input/output class.
//--------------------------------------------------------------------------

class gmNetpgm {
  private:

  public:

    gray_t**		Img;		// pointer to image array Img[row][col]
    int			Ncol;		// number of columns (X)
    int			Nrow;		// number of rows (Y)
    int			Npix;		// total number of pixels
    gray_t		MaxVal;		// maximum pixle value allowed in file

    gmNetpgm();			// constructor
    gmNetpgm( FILE* fp );
    gmNetpgm( const char* in_file );

    ~gmNetpgm();		// destructor

    void		read( FILE* fp );
    void		read( const char* file );

    void		write( const char* file );
};

#endif

