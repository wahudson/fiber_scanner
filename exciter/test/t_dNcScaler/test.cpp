// 2022-03-10  William A. Hudson
//
// Testing:  dNcScaler  Signal Scaler class for Numeric Controlled Oscillator.
//    10-19  Constructors
//    20-29  Configure set_Gain(), set_Offset()
//    30-39  Scale values scale()  v= Q2.30
//    40-49  Conversions for Q2.30  Qd30_float(), float_Qd30()
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <sstream>	// std::ostringstream
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library
#include "dNcScaler.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

dNcScaler		Tx  ( 12 );	// constructor


//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "constructor, 10-bit" );
    try {
	dNcScaler	tx  ( 10 );
	CHECK( 10,   tx.get_Nbits() );
	CHECK( 1023, tx.get_MaskFS() );
	CHECK( 1,    tx.get_Gain() );
	CHECK( 0,    tx.get_Offset() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "constructor, 12-bit" );
    try {
	CHECK( 12,   Tx.get_Nbits() );
	CHECK( 4095, Tx.get_MaskFS() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Configure set_Gain(), set_Offset()
//--------------------------------------------------------------------------

  CASE( "20a", "set_Gain() float rounds to int" );
    try {
	Tx.set_Gain( 42.39 );		// float converts to int
	CHECK( 42,   Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "20b", "set_Gain() negative OK" );
    try {
	Tx.set_Gain( -2 );
	CHECK( -2, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "21a", "set_Gain() max positive" );
    try {
	Tx.set_Gain( 4095 );
	CHECK( 4095, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21b", "set_Gain() too positive" );
    try {
	Tx.set_Gain( 4096 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcScaler::set_Gain() too large:  4096",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "22b", "set_Gain() max negative" );
    try {
	Tx.set_Gain( -4095 );
	CHECK( -4095, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "22b", "set_Gain() too negative" );
    try {
	Tx.set_Gain( -4096 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcScaler::set_Gain() too large:  -4096",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "25a", "set_Offset() max positive" );
    try {
	Tx.set_Offset( 4095 );
	CHECK( 4095, Tx.get_Offset() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "25b", "set_Offset() too positive" );
    try {
	Tx.set_Offset( 4096 );
    }
    catch ( range_error& e ) {
	CHECK( "dNcScaler::set_Offset() too large:  4096",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "26", "set_Offset() negative not allowed" );
    try {
	Tx.set_Offset( -1 );
    }
    catch ( range_error& e ) {
	CHECK( "dNcScaler::set_Offset() too large:  -1",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Scale values scale()  v= Q2.30
//--------------------------------------------------------------------------

  CASE( "30", "setup" );
    try {
	Tx.set_Gain(      1 );
	Tx.set_Offset(    0 );
	CHECK(    1, Tx.get_Gain()   );
	CHECK(    0, Tx.get_Offset() );
	CHECK(    0, Tx.scale(    0 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "32", "scale()" );
    try {
	Tx.set_Gain(   1000 );
	Tx.set_Offset(    0 );
	CHECK(  1000, Tx.get_Gain()   );
	CHECK(     0, Tx.get_Offset() );
	CHECK(     0, Tx.scale( 0x00000000 ) );
	CHECK(  1000, Tx.scale( 0x40000000 ) );	// 1.00
	CHECK(   500, Tx.scale( 0x20000000 ) );	// 0.50
	CHECK(  1500, Tx.scale( 0x60000000 ) );	// 1.50
	CHECK(  1999, Tx.scale( 0x7fffffff ) );
	CHECK(     0, Tx.scale( 0xc0000000 ) );	// clamp -v
	CHECK(  1003, Tx.scale( 0x40400000 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "33", "scale()" );
    try {
	Tx.set_Gain(   1000 );
	Tx.set_Offset( 2048 );
	CHECK(  1000, Tx.get_Gain()   );
	CHECK(  2048, Tx.get_Offset() );
	CHECK(  2048, Tx.scale( 0x00000000 ) );
	CHECK(  4047, Tx.scale( 0x7fffffff ) );
	CHECK(  3048, Tx.scale( 0x40000000 ) );	// 1.00
	CHECK(  1048, Tx.scale( 0xc0000001 ) );	// -1.00
	CHECK(  2047, Tx.scale( -1         ) );
	CHECK(  3048, Tx.scale( 1.0 * (float) 0x40000000 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "34", "scale()" );
    try {
	Tx.set_Gain(   2000 );
	Tx.set_Offset( 2048 );
	CHECK(  2000, Tx.get_Gain()   );
	CHECK(  2048, Tx.get_Offset() );
	CHECK(  2048, Tx.scale( 0x00000000 ) );
	CHECK(  4048, Tx.scale( 0x40000000 ) );	// 1.00
	CHECK(  3048, Tx.scale( 0x20000000 ) );	// 0.50
	CHECK(    48, Tx.scale( 0xc0000000 ) );	// -1.00
	CHECK(  1048, Tx.scale( 0xe0000000 ) );	// -0.50
	CHECK(  4095, Tx.scale( 0x7fffffff ) );	// saturate
	CHECK(  4095, Tx.scale( 0x60000000 ) );	// 1.50  saturate
	CHECK(     0, Tx.scale( 0xa0000000 ) );	// -1.50  saturate
	CHECK(     0, Tx.scale( -1.1 * (float) 0x40000000 ) );
	CHECK(     0, Tx.scale( Tx.Qd30_float( -1.1 ) ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Conversions for Q2.30  Qd30_float(), float_Qd30()
//--------------------------------------------------------------------------

  CASE( "41", "Qd30_float()" );
    try {
	CHECKX( 0x00000000, Tx.Qd30_float(  0.00 ) );
	CHECKX( 0x40000000, Tx.Qd30_float(  1.00 ) );
	CHECKX( 0xc0000000, Tx.Qd30_float( -1.00 ) );
	CHECKX( 0x60000000, Tx.Qd30_float(  1.50 ) );
	CHECKX( 0xa0000000, Tx.Qd30_float( -1.50 ) );
	CHECKX( 0xb9999980, Tx.Qd30_float( -1.10 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "42", "float_Qd30()" );
    try {
	char			cstr[16];
	sprintf( cstr, "%7.4f", Tx.float_Qd30( 0x40000000 ) );
	CHECK( " 1.0000", cstr );
	sprintf( cstr, "%7.4f", Tx.float_Qd30( 0xa0000000 ) );
	CHECK( "-1.5000", cstr );
	sprintf( cstr, "%7.4f", Tx.float_Qd30( 0x00000000 ) );
	CHECK( " 0.0000", cstr );
	sprintf( cstr, "%12.9f", Tx.float_Qd30( 0x40000080 ) );
	CHECK( " 1.000000119", cstr );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

