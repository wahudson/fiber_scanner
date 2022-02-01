// 2022-01-19  William A. Hudson
//
// Testing:  gmStats - Grayscale Image Statistics class.
//    10-19  .
//    20-29  .
//    30-39  .
//    40-49  .
//    50-59  .
//    60-98  .
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <stdexcept>	// std::stdexcept
#include <math.h>

#include "utLib1.h"		// unit test library

#include "gmStats.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "gmStats constructor" );
    try {
	gmStats		tx;
	CHECK(  0, tx.Ncol );
	CHECK(  0, tx.Nrow );
	CHECK(  0, tx.Npix );
	CHECK(  0, tx.MaxVal );
	CHECK( -1, tx.Max  );
	CHECK( -1, tx.Min  );
	CHECK( -1, tx.Sum  );
	CHECK( -1, tx.Mean );
	CHECK( -1, tx.CGx  );
	CHECK( -1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "gmStats constructor" );
    try {
	gmStats		tx  ( "NoFile.pgm" );
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

  CASE( "12", "gmStats constructor" );
    try {
	gmStats		tx  ( "point.pgm" );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "14", "gmStats constructor" );
    try {
	FILE*		fp = fopen( "point.pgm", "r" );
	gmStats		tx  ( fp );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Computation
//--------------------------------------------------------------------------

  CASE( "21a", "point image - constructor" );
    try {
	gmStats		tx  ( "point.pgm" );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  -1, tx.Max  );
	CHECK(  -1, tx.Min  );
	CHECK(  -1, tx.Sum  );
	CHECK(  -1, tx.Mean );
	CHECK(  -1, tx.CGx  );
	CHECK(  -1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21b", "point image - get_mean()" );
    try {
	gmStats		tx  ( "point.pgm" );
	float		mean;
	mean = tx.get_mean();
	cout << "Mean= " <<fixed << mean <<endl;
	CHECK(   2, tx.get_mean()  );
	//
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  31, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(  31, tx.Sum  );
	CHECK(   2, tx.Mean );
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21c", "point image get_std_deviation()" );
    try {
	gmStats		tx  ( "point.pgm" );
	float		sd;
	sd = tx.get_std_deviation();
	cout << "Mean= " <<fixed << tx.Mean <<endl;
	cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs(7.732759 - sd) < 0.0001) );
	//
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  31, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(  31, tx.Sum  );
	CHECK(   2, tx.Mean );
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "22", "ibar image" );
    try {
	gmStats		tx  ( "ibar.pgm" );
	float		sd;
	sd = tx.get_std_deviation();
	cout << "Mean= " <<fixed << tx.Mean <<endl;
	cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs( 22.715633 - sd ) < 0.0001) );
	//
	CHECK(   5, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  20, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  80, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK( 360, tx.Sum  );
	CHECK(  18, tx.Mean );
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "23", "flat image" );
    try {
	gmStats		tx  ( "flat.pgm" );
	float		sd;
	sd = tx.get_std_deviation();
	cout << "Mean= " <<fixed << tx.Mean <<endl;
	cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs( 0.000000 - sd ) < 0.0001) );
	//
	CHECK(   5, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  20, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  20, tx.Max  );
	CHECK(  20, tx.Min  );
	CHECK( 400, tx.Sum  );
	CHECK(  20, tx.Mean );
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Corner-case images
//--------------------------------------------------------------------------

//--------------------------------------
  CASE( "30", "empty image" );
    try {
	gmStats		tx  ( "empty.pgm" );
	float		sd = tx.get_std_deviation();
	cout << "Mean= " <<fixed << tx.Mean <<endl;
	cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs( 0.000000 - sd ) < 0.0001) );
	//
	CHECK(   0, tx.Ncol );
	CHECK(   0, tx.Nrow );
	CHECK(   0, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(   0, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(   0, tx.Sum  );
	CHECK(   0, tx.Mean );  // as integer
	CHECK(   0, tx.CGx  );
	CHECK(   0, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "31", "black image" );
    try {
	gmStats		tx  ( "black.pgm" );
	float		sd = tx.get_std_deviation();
	//cout << "Mean= " <<fixed << tx.Mean <<endl;
	//cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs( 0.000000 - sd ) < 0.0001) );
	//
	CHECK(   3, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  12, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(   0, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(   0, tx.Sum  );
	CHECK(   0, tx.Mean );  // as integer
	CHECK(   1, tx.CGx  );
	CHECK(   2, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "32", "white image" );
    try {
	gmStats		tx  ( "white.pgm" );
	float		sd = tx.get_std_deviation();
	//cout << "Mean= " <<fixed << tx.Mean <<endl;
	//cout << "SD=   " << sd <<endl;
	CHECK(   1, (fabs( 0.000000 - sd ) < 0.0001) );
	//
	CHECK(   4, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  12, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK( 255, tx.Max  );
	CHECK( 255, tx.Min  );
	CHECK(3060, tx.Sum  );
	CHECK( 255, tx.Mean );  // as integer
	CHECK(   1, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

