// 2023-01-05  William A. Hudson
//
// Testing:  extShift class -- Extended shift register data class.
//    10-19  Constructor
//    20-29  Raw put_ExData(), get_ExData()
//    30-39  Normal access put_exdata(), get_exdata()
//    40-49  .
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <sstream>	// std::ostringstream
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library
#include "extShift.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

extShift		Tx  ( 12 );	// constructor

//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "constructor, 0-bit" );
    try {
	extShift	tx  ( 0 );
	CHECK(   0,     tx.get_exlen() );
	CHECK(  16,     tx.get_ExPos() );
	CHECKX( 0x0000, tx.get_ExData() );
	CHECKX( 0x0000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "constructor, 3-bit" );
    try {
	extShift	tx  ( 3 );
	CHECK(   3,     tx.get_exlen() );
	CHECK(  13,     tx.get_ExPos() );
	CHECKX( 0x0000, tx.get_ExData() );
	CHECKX( 0x0000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "12", "constructor, 16-bit" );
    try {
	extShift	tx  ( 16 );
	CHECK(  16,     tx.get_exlen() );
	CHECK(   0,     tx.get_ExPos() );
	CHECKX( 0x0000, tx.get_ExData() );
	CHECKX( 0x0000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "13", "constructor, 17-bit" );
    try {
	extShift	tx  ( 17 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "extShift:  constructor requires Len<=16:  17",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Raw put_ExData(), get_ExData()
//--------------------------------------------------------------------------
// Object bit length has no effect, ExData is always 16-bits.

  CASE( "20", "raw put_ExData()" );
    try {
	extShift	tx  ( 7 );
	CHECK(   7,     tx.get_exlen() );
	CHECKX(        0x00000000, tx.get_ExData() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	tx.put_ExData( 0xffff0000 );
	CHECKX(        0x00000000, tx.get_ExData() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21", "raw put_ExData()" );
    try {
	extShift	tx  ( 3 );
	CHECK(   3,     tx.get_exlen() );
	CHECKX(        0x00000000, tx.get_ExData() );
	tx.put_ExData( 0x3333aaaa );
	CHECKX(        0x0000aaaa, tx.get_ExData() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "22", "raw put_ExData()" );
    try {
	extShift	tx  ( 14 );
	CHECK(  14,     tx.get_exlen() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	tx.put_ExData( 0xcccc5555 );
	CHECKX(        0x00005555, tx.get_ExData() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Normal access put_exdata(), get_exdata()
//--------------------------------------------------------------------------

  CASE( "30a", "7-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 7 );
	CHECK(   7,     tx.get_exlen() );
	tx.put_ExData( 0x00000000 );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
	tx.put_exdata( 0x0000007f );
	CHECKX(        0x0000fe00, tx.get_ExData() );
	CHECKX(        0x0000007f, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "30b", "7-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 7 );
	CHECK(   7,     tx.get_exlen() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	CHECKX(        0x0000007f, tx.get_exdata() );
	tx.put_exdata( 0xffffff80 );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "31a", "12-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 12 );
	CHECK(  12,     tx.get_exlen() );
	tx.put_ExData( 0x00000000 );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
	tx.put_exdata( 0x00000555 );
	CHECKX(        0x00005550, tx.get_ExData() );
	CHECKX(        0x00000555, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31b", "12-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 12 );
	CHECK(  12,     tx.get_exlen() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	CHECKX(        0x00000fff, tx.get_exdata() );
	tx.put_exdata( 0xfffff555 );
	CHECKX(        0x00005550, tx.get_ExData() );
	CHECKX(        0x00000555, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "32a", "16-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 16 );
	CHECK(  16,     tx.get_exlen() );
	tx.put_ExData( 0x00000000 );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
	tx.put_exdata( 0x0000c33c );
	CHECKX(        0x0000c33c, tx.get_ExData() );
	CHECKX(        0x0000c33c, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "32b", "16-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 16 );
	CHECK(  16,     tx.get_exlen() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	CHECKX(        0x0000ffff, tx.get_exdata() );
	tx.put_exdata( 0xffff3cc3 );
	CHECKX(        0x00003cc3, tx.get_ExData() );
	CHECKX(        0x00003cc3, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "33a", "0-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 0 );
	CHECK(   0,     tx.get_exlen() );
	tx.put_ExData( 0x00000000 );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
	tx.put_exdata( 0xffffc33c );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "33b", "0-bit put_exdata() cooked" );
    try {
	extShift	tx  ( 0 );
	CHECK(   0,     tx.get_exlen() );
	tx.put_ExData( 0x0000ffff );
	CHECKX(        0x0000ffff, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
	tx.put_exdata( 0x0000c33c );
	CHECKX(        0x00000000, tx.get_ExData() );
	CHECKX(        0x00000000, tx.get_exdata() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

