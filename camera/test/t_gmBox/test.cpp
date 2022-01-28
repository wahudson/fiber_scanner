// 2022-01-21  William A. Hudson
//
// Testing:  gmBox - Grayscale Image Bounding Box class.
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

#include "gmBox.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "11", "gmBox constructor" );
    try {
	gmBox		tx  ( "NoFile.pgm" );
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

  CASE( "12", "gmBox constructor" );
    try {
	gmBox		tx  ( "point.pgm" );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## gmStats Computation
//--------------------------------------------------------------------------

  CASE( "21a", "point image - constructor" );
    try {
	gmBox		tx  ( "point.pgm" );
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
	gmBox		tx  ( "point.pgm" );
	float		mean = tx.get_mean();
	cout << "Mean= " <<fixed << mean <<endl;
	CHECK(   2, tx.get_mean() );  // as integer
	//
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  31, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(  31, tx.Sum  );
	CHECK(   2, tx.Mean );  // as integer
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21c", "point image get_std_deviation()" );
    try {
	gmBox		tx  ( "point.pgm" );
	float		sd = tx.get_std_deviation();
	cout << "SD= " << sd <<endl;
	CHECK(   1, (fabs(7.73276 - sd) < 0.0001) );
	//
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(  15, tx.Npix );
	CHECK( 255, tx.MaxVal );
	CHECK(  31, tx.Max  );
	CHECK(   0, tx.Min  );
	CHECK(  31, tx.Sum  );
	CHECK(   2, tx.Mean );  // as integer
	CHECK(   2, tx.CGx  );
	CHECK(   1, tx.CGy  );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "22", "ibar image" );
    try {
	gmBox		tx  ( "ibar.pgm" );
	float		sd = tx.get_std_deviation();
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
	gmBox		tx  ( "flat.pgm" );
	float		sd = tx.get_std_deviation();
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
//## gmBox Computation
//--------------------------------------------------------------------------
// Note:  The first failing CHECK outputs the test summary NOT OK.
// Thus raw output typically appears before the test summary unless it is
// issued after a failing CHECK.
// It is most consistent to issue raw output before any CHECK.
// It would be nice to output arrays only if the test failed.

  CASE( "31a", "row means - ibar image" );
    try {
	gmBox		tx  ( "ibar.pgm" );
	tx.find_Yrow_means( 0 );
//	tx.out_Yrow_means( &cout );
	CHECK(   5, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  -1, tx.Mean );		// not computed
	CHECK(  20, tx.YmaxMean );
	CHECK(  16, tx.YminMean );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31b", "column means - ibar image" );
    try {
	gmBox		tx  ( "ibar.pgm" );
	tx.find_Xcol_means( 0 );
//	tx.out_Xcol_means( &cout );
	CHECK(   5, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  -1, tx.Mean );		// not computed
	CHECK(  50, tx.XmaxMean );
	CHECK(  10, tx.XminMean );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31c", "ibar image" );
    try {
	gmBox		tx  ( "ibar.pgm" );
	tx.find_Yrow_means( 0 );
	tx.find_Xcol_means( 0 );
	tx.find_Yedges();
	tx.find_Xedges();
	tx.out_Yrow_means( &cout );
	tx.out_Xcol_means( &cout );
	CHECK(   5, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  -1, tx.Mean );		// not computed
	CHECK(  20, tx.YmaxMean );
	CHECK(  16, tx.YminMean );
	CHECK(   0, tx.Ytop     );
	CHECK(   3, tx.Ybot     );
	CHECK(  50, tx.XmaxMean );
	CHECK(  10, tx.XminMean );
	CHECK(   2, tx.Xleft    );
	CHECK(   2, tx.Xright   );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------

  CASE( "32", "black image" );
    try {
	gmBox		tx  ( "black.pgm" );
	tx.find_Yrow_means( 0 );
	tx.find_Xcol_means( 0 );
	tx.find_Yedges();
	tx.find_Xedges();
	tx.out_Yrow_means( &cout );
	tx.out_Xcol_means( &cout );
	CHECK(   3, tx.Ncol );
	CHECK(   4, tx.Nrow );
	CHECK(  -1, tx.Mean );		// not computed
	CHECK(   0, tx.YmaxMean );
	CHECK(   0, tx.YminMean );
	CHECK(   0, tx.Ytop     );
	CHECK(   3, tx.Ybot     );
	CHECK(   0, tx.XmaxMean );
	CHECK(   0, tx.XminMean );
	CHECK(   0, tx.Xleft    );
	CHECK(   2, tx.Xright   );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "33", "point image" );
    try {
	gmBox		tx  ( "point.pgm" );
	tx.find_Yrow_means( 0 );
	tx.find_Xcol_means( 0 );
	tx.find_Yedges();
	tx.find_Xedges();
	tx.out_Yrow_means( &cout );
	tx.out_Xcol_means( &cout );
	CHECK(   5, tx.Ncol );
	CHECK(   3, tx.Nrow );
	CHECK(   6, tx.YmaxMean );
	CHECK(   0, tx.YminMean );
	CHECK(   1, tx.Ytop     );
	CHECK(   1, tx.Ybot     );
	CHECK(  10, tx.XmaxMean );
	CHECK(   0, tx.XminMean );
	CHECK(   2, tx.Xleft    );
	CHECK(   2, tx.Xright   );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

