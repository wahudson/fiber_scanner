// 2022-01-16  William A. Hudson

// gmNetpgm - Netpbm Grayscale input/output class.
//    Provides an object interface.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>      // std::ostringstream
#include <string>
#include <stdexcept>
#include <netpbm/pgm.h>

using namespace std;

#include "gmNetpgm.h"


/*
* Constructor.
*/
gmNetpgm::gmNetpgm()
{
    Img    = NULL;
    Ncol   = 0;
    Nrow   = 0;
    Npix   = 0;
    MaxVal = 0;

    pm_init( "gmNetpgm", 0 );
    //#!! Can pm_init() be called more than once?
}

gmNetpgm::gmNetpgm( FILE* fp )
{
    read( fp );
}

gmNetpgm::gmNetpgm( const char* in_file )
{
    read( in_file );
}

/*
* Destructor.
*   Free memory allocated by pgm_allocarray() or pgm_readpgm().
*   #!! Maybe.  Depends on how images are shared.
*/
gmNetpgm::~gmNetpgm()
{
    if ( Img ) {
	pgm_freearray( Img, Nrow );
    }

    Img = NULL;
}

//--------------------------------------------------------------------------
// Read
//--------------------------------------------------------------------------

/*
* Read .pgm image from file stream.
* call:
*    read( fp )
*    read( in_file )
*/
void
gmNetpgm::read( FILE* fp )
{
    Img = pgm_readpgm(
	fp,
	&Ncol,
	&Nrow,
	&MaxVal             // maximum gray value
    );

    Npix = Ncol * Nrow;
}

/*
* Read .pgm image from file name.
*/
void
gmNetpgm::read( const char* in_file )
{
    FILE*		fp;

    fp = fopen( in_file, "r" );

    if ( fp == NULL ) {
	std::ostringstream	css;
	css << "file not found:  " << in_file;
	throw std::runtime_error ( css.str() );
    }
    //#!! apply errorno

    this->read( fp );

    fclose( fp );
    //#!! check errorno
}

