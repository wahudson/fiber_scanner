// 2022-02-02  William A. Hudson
//
// Testing:  gmGeoSpec - Geometry WxH+X+Y specification class.
//    10-19  .
//    20-29  .
//    30-39  .
//    40-49  .
//    50-59  .
//    60-98  .
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library

#include "gmGeoSpec.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "gmGeoSpec constructor" );
    try {
	gmGeoSpec		tx;
	CHECK(  0, tx.GeoW );
	CHECK(  0, tx.GeoH );
	CHECK(  0, tx.GeoX );
	CHECK(  0, tx.GeoY );
	CHECK(  "", tx.GeoSpec );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "gmGeoSpec null spec" );
    try {
	gmGeoSpec	tx  ( NULL );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "gmGeoSpec:parse():  null spec",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "12a", "good spec" );
    try {
	gmGeoSpec	tx  ( "2x3+5+7" );
	CHECK(  2, tx.GeoW );
	CHECK(  3, tx.GeoH );
	CHECK(  5, tx.GeoX );
	CHECK(  7, tx.GeoY );
	CHECK(  "2x3+5+7", tx.GeoSpec );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "12b", "good spec" );
    try {
	gmGeoSpec	tx  ( "21x31+51+71" );
	CHECK(  21, tx.GeoW );
	CHECK(  31, tx.GeoH );
	CHECK(  51, tx.GeoX );
	CHECK(  71, tx.GeoY );
	CHECK(  "21x31+51+71", tx.GeoSpec );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "13", "incomplete spec" );
    try {
	gmGeoSpec	tx  ( "2x3+5+" );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "gmGeoSpec:parse():  bad WxH+X+Y spec:  '2x3+5+'",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "14", "bad spec" );
    try {
	gmGeoSpec	tx  ( "2a3+5+7" );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "gmGeoSpec:parse():  bad WxH+X+Y spec:  '2a3+5+7'",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "15", "negative spec" );
    try {
	gmGeoSpec	tx  ( "-2x3+5+7" );
	FAIL( "no throw" );
    }
    catch ( runtime_error& e ) {
	CHECK( "gmGeoSpec:parse():  disallow negative WxH+X+Y spec:  '-2x3+5+7'",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Computation  parse()
//--------------------------------------------------------------------------

  CASE( "21", "good spec" );
    try {
	gmGeoSpec	tx;
	tx.parse( "21x31+51+71" );
	CHECK(  21, tx.GeoW );
	CHECK(  31, tx.GeoH );
	CHECK(  51, tx.GeoX );
	CHECK(  71, tx.GeoY );
	CHECK(  "21x31+51+71", tx.GeoSpec );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

