// 2022-01-18  William A. Hudson
//
// Testing:  gmNetpgm - Netpbm Grayscale input/output class.
//    10-19  Constructor
//    20-29  .
//    30-39  .
//    40-49  .
//    50-59  .
//    60-98  .
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library

#include "gmNetpgm.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "gmNetpgm constructor" );
    try {
	gmNetpgm	tx;
	CHECK( 0, tx.Ncol );
	CHECK( 0, tx.Nrow );
	CHECK( 0, tx.Npix );
	CHECK( 0, tx.MaxVal );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "gmNetpgm constructor" );
    try {
	gmNetpgm	tx  ( "NoFile.pgm" );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "file not found:  NoFile.pgm",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "12", "gmNetpgm constructor" );
    try {
	gmNetpgm	tx  ( "point.pgm" );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 127, tx.MaxVal );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "13", "gmNetpgm constructor, file '-' is literal" );
    try {
	gmNetpgm	tx  ( "-" );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "file not found:  -",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

