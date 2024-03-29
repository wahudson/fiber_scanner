// 2023-01-05  William A. Hudson
//
// Testing:  uspi_mcp4822x class - Operating mcp4822 DAC on rgUniSpi.
//    10-19  Constructor
//    20-29  Set Prefix bits  put_Gain1x_1(), put_nShutdown_1()
//    30-39  Send data to rgUniSpi, send_dac_12()
//    40-49  Preferred set_Gain1x(), set_Gain2x(), set_Active(), set_Shutdown()
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <sstream>	// std::ostringstream
#include <stdexcept>	// std::stdexcept

#include "rgAddrMap.h"
#include "rgUniSpi.h"

#include "utLib1.h"		// unit test library
#include "uspi_mcp4822x.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

rgAddrMap		Amx;			// constructor
Amx.open_fake_mem();

rgUniSpi		Uspix  ( &Amx, 1 );	// constructor
extShift		Esx  ( 8 );		// constructor

//--------------------------------------------------------------------------
//## Constructor, get_Chan_1()
//--------------------------------------------------------------------------

  CASE( "10", "constructor chA" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "constructor chB" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "13", "constructor, bad channel" );
    try {
	uspi_mcp4822x	tx  ( 2, &Uspix, &Esx );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "uspi_mcp4822x:  constructor requires channel={0,1}:  2",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "14", "constructor, bad Esx" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, NULL );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "uspi_mcp4822x:  constructor requires extShift*",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "15", "constructor, bad Uspix" );
    try {
	uspi_mcp4822x	tx  ( 0, NULL, &Esx );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "uspi_mcp4822x:  constructor requires rgUniSpi*",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Set Prefix bits  put_Gain1x_1(), put_nShutdown_1()
//--------------------------------------------------------------------------

  CASE( "20", "put_Gain1x_1()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.put_Gain1x_1( 1 );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21", "put_nShutdown_1()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.put_nShutdown_1( 1 );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "24", "put_Gain1x_1()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.put_Gain1x_1( 0 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "25", "put_nShutdown_1()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.put_nShutdown_1( 0 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Send data to rgUniSpi, send_dac_12()
//--------------------------------------------------------------------------

// Using librgpio Fake Memory and rgUniSpi.Fifo.read() to read back FIFO
// data value that was sent.  -- A nice testability feature.

  CASE( "30", "chB send_dac_12()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.send_dac_12(   0x00000ccc );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	CHECKX(           0x8ccc0000, Uspix.Fifo.read() );
	CHECKX(           0x8ccc0000, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31", "chA send_dac_12()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.send_dac_12(   0x00000ccc );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	CHECKX(           0x0ccc0000, Uspix.Fifo.read() );
	CHECKX(           0x0ccc0000, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "32a", "send_dac_12() ones" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	tx.send_dac_12(   0x00000fff );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0xbfff0000, Uspix.Fifo.read() );
	CHECKX(           0xbfff0000, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "32b", "send_dac_12() zeros" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0xffffffff );
	CHECKX(           0xffffffff, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	tx.send_dac_12(   0xfffff000 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0xb0000000, Uspix.Fifo.read() );
	CHECKX(           0xb0000000, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "33a", "send_dac_12() ExData" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	Esx.put_exdata(   0x000000ff );
	tx.send_dac_12(   0x00000000 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0xb000ff00, Uspix.Fifo.read() );
	CHECKX(           0xb000ff00, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "33b", "send_dac_12() ExData" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0xffffffff );
	CHECKX(           0xffffffff, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	Esx.put_exdata(   0xffffff00 );
	tx.send_dac_12(   0x00000000 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0xb0000000, Uspix.Fifo.read() );
	CHECKX(           0xb0000000, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "34", "send_dac_12() data pattern" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	Esx.put_exdata(   0x000000cc );
	tx.send_dac_12(   0x00000777 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0xb777cc00, Uspix.Fifo.read() );
	CHECKX(           0xb777cc00, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "35a", "send_dac_12() data pattern" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 0 );
	tx.put_nShutdown_1( 1 );
	Esx.put_exdata(   0x00000033 );
	tx.send_dac_12(   0x00000ccc );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0x1ccc3300, Uspix.Fifo.read() );
	CHECKX(           0x1ccc3300, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "35b", "send_dac_12() data pattern" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	Uspix.Fifo.write( 0xffffffff );
	CHECKX(           0xffffffff, Uspix.Fifo.read() );
	tx.put_Gain1x_1( 0 );
	tx.put_nShutdown_1( 1 );
	Esx.put_exdata(   0x00000033 );
	tx.send_dac_12(   0x00000ccc );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0x1ccc3300, Uspix.Fifo.read() );
	CHECKX(           0x1ccc3300, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }


//--------------------------------------
  CASE( "37", "chA send_raw_32()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	Uspix.Fifo.write( 0x00000000 );
	CHECKX(           0x00000000, Uspix.Fifo.read() );
	tx.LastSend     = 0x00000000;
	CHECKX(           0x00000000, tx.LastSend );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.send_raw_32(   0xfccccccc );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	CHECKX(           0xfccccccc, Uspix.Fifo.read() );
	CHECKX(           0xfccccccc, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "38", "chB send_raw_32()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	Uspix.Fifo.write( 0xffffffff );
	CHECKX(           0xffffffff, Uspix.Fifo.read() );
	tx.LastSend     = 0xffffffff;
	CHECKX(           0xffffffff, tx.LastSend );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.send_raw_32(   0x03333333 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	CHECKX(           0x03333333, Uspix.Fifo.read() );
	CHECKX(           0x03333333, tx.LastSend );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Preferred set_Gain1x(), set_Gain2x(), set_Active(), set_Shutdown()
//--------------------------------------------------------------------------

  CASE( "41a", "set_Gain1x()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.set_Gain1x();
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "41b", "set_Gain2x()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.set_Gain2x();
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "42a", "set_Active()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.set_Active();
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "42b", "set_Shutdown()" );
    try {
	uspi_mcp4822x	tx  ( 0, &Uspix, &Esx );
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
	tx.set_Shutdown();
	CHECK(  0,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "43a", "set_Gain2x()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.set_Gain2x();
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  0,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "43b", "set_Gain1x()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.set_Gain1x();
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "44a", "set_Shutdown()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.set_Shutdown();
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  0,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "44a", "set_Active()" );
    try {
	uspi_mcp4822x	tx  ( 1, &Uspix, &Esx );
	tx.put_Gain1x_1( 1 );
	tx.put_nShutdown_1( 1 );
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
	tx.set_Active();
	CHECK(  1,  tx.get_Chan_1() );
	CHECK(  1,  tx.get_Gain1x_1() );
	CHECK(  1,  tx.get_nShutdown_1() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

