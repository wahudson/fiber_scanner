// 2022-05-03  William A. Hudson
//
// Testing:  dNcRamp  Gain Ramp class for Numeric Controlled Oscillator.
//    10-19  Constructors
//    20-29  Configure set_HiGain()
//    30-39  Configure set_RampDuration()
//    40-49  Configure set_HoldDuration()
//    50-59  ramp_step() sequence
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <sstream>	// std::ostringstream
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library
#include "dNcRamp.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

dNcRamp		Tx  ( 12 );	// constructor


//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "constructor, 12-bit" );
    try {
	CHECK(   12, Tx.get_Nbits() );
	CHECK( 4095, Tx.get_MaskFS() );
	CHECK(    0, Tx.get_Gain() );
	CHECK(    0, Tx.get_Offset() );
	CHECKX( 0x00001000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00001000, Tx.get_GainStep_Qd12() );
	CHECK(           1, Tx.get_RampDuration() );
	CHECK(         100, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         100, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "constructor, 10-bit" );
    try {
	dNcRamp		tx  ( 10 );
	CHECK(   10, tx.get_Nbits() );
	CHECK( 1023, tx.get_MaskFS() );
	CHECK(    0, tx.get_Gain() );
	CHECK(    0, tx.get_Offset() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "12", "constructor, 17-bit throw" );
    try {
	dNcRamp		tx  ( 17 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcScaler:  constructor requires Nbits<=16:  17",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Configure set_HiGain()
//--------------------------------------------------------------------------

  CASE( "20", "setup" );
    try {
	Tx.reset_init();
	Tx.set_HiGain( 1025 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  700 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "21a", "set_HiGain( -1 ) error" );
    try {
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( -1 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_HiGain() must be positive:  -1",
	    e.what()
	);
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21b", "set_HiGain() too large" );
    try {
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( 0x00004000 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_HiGain() too large:  16384",
	    e.what()
	);
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "22", "set_HiGain( 0 ) good" );
    try {
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( 0 );
	CHECKX( 0x00000000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000001, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "23", "set_HiGain( 1 )" );
    try {
	CHECKX( 0x00000000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000001, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( 1 );
	CHECKX( 0x00001000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "24", "set_HiGain()" );
    try {
	CHECKX( 0x00001000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000100, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( 2048 );
	CHECKX( 0x00800000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00080000, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "25a", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(    750 );
	Tx.set_HiGain( 1027 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  500 );
	Tx.TESTset_Gain_Qd12( 0x00033000 );
	CHECKX( 0x00403000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040300, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         500, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         500, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "25b", "set_HiGain() no Gain change" );
    try {
	CHECKX( 0x00403000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040300, Tx.get_GainStep_Qd12() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	Tx.set_HiGain( 2048 );
	CHECKX( 0x00800000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00080000, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         500, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         500, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Configure set_RampDuration()
//--------------------------------------------------------------------------

  CASE( "30", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(      0 );
	Tx.set_HiGain( 1025 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  700 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "31a", "set_RampDuration( -1 ) error" );
    try {
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	Tx.set_RampDuration( -1 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_RampDuration() must be positive:  -1",
	    e.what()
	);
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31b", "set_RampDuration( 0 ) error" );
    try {
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	Tx.set_RampDuration( 0 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_RampDuration() must be positive:  0",
	    e.what()
	);
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "34", "set_RampDuration()" );
    try {
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	Tx.set_RampDuration( 0x1000 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000401, Tx.get_GainStep_Qd12() );
	CHECK(        4096, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "35", "set_RampDuration() very large positive" );
    try {
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000401, Tx.get_GainStep_Qd12() );
	CHECK(        4096, Tx.get_RampDuration() );
	Tx.set_RampDuration( 0x40000099 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00000001, Tx.get_GainStep_Qd12() );
	CHECKX( 0x40000099, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "36a", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(    750 );
	Tx.set_HiGain( 1028 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  500 );
	Tx.TESTset_Gain_Qd12( 0x00033000 );
	CHECKX( 0x00404000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040400, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         500, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         500, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "36b", "set_RampDuration() no Gain change" );
    try {
	CHECKX( 0x00404000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040400, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	Tx.set_RampDuration( 2 );
	CHECKX( 0x00404000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00202000, Tx.get_GainStep_Qd12() );
	CHECK(           2, Tx.get_RampDuration() );
	CHECK(         500, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         500, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Configure set_HoldDuration()
//--------------------------------------------------------------------------

  CASE( "40", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(      0 );
	Tx.set_HiGain( 1025 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  700 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "41a", "set_HoldDuration( -1 ) error" );
    try {
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(         700, Tx.get_HoldCnt() );
	Tx.set_HoldDuration( -1 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_HoldDuration() must be positive:  -1",
	    e.what()
	);
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "41b", "set_HoldDuration( 0 ) error" );
    try {
	Tx.set_HoldDuration( 0 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcRamp::set_HoldDuration() must be positive:  0",
	    e.what()
	);
	CHECK(         700, Tx.get_HoldDuration() );
	CHECK(         700, Tx.get_HoldCnt() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "44", "set_HoldDuration()" );
    try {
	Tx.set_HoldDuration( 42099 );
	CHECKX( 0x00401000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040100, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(       42099, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(       42099, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "46a", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(    750 );
	Tx.set_HiGain( 1028 );
	Tx.set_RampDuration(   16 );
	Tx.set_HoldDuration(  500 );
	Tx.TESTset_Gain_Qd12( 0x00033000 );
	CHECKX( 0x00404000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040400, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(         500, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         500, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "46b", "set_HoldDuration() no Gain change" );
    try {
	Tx.set_HoldDuration( 8000423 );
	CHECKX( 0x00404000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00040400, Tx.get_GainStep_Qd12() );
	CHECK(          16, Tx.get_RampDuration() );
	CHECK(     8000423, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(     8000423, Tx.get_HoldCnt() );
	CHECKX( 0x00033000, Tx.get_Gain_Qd12() );
	CHECK(         750, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## ramp_step() sequence
//--------------------------------------------------------------------------

  CASE( "50", "setup" );
    try {
	Tx.reset_init();
	Tx.set_Gain(      0 );
	Tx.set_HiGain(   99 );
	Tx.set_RampDuration( 3 );
	Tx.set_HoldDuration( 200 );
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(         200, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         200, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "51", "ramp_step() from beginning" );
    try {
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(         200, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(         200, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
	CHECK(  3, Tx.ramp_step() );
	CHECKX( 0x00021000, Tx.get_Gain_Qd12() );
	CHECK(          33, Tx.get_Gain() );
	CHECK(  3, Tx.ramp_step() );
	CHECKX( 0x00042000, Tx.get_Gain_Qd12() );
	CHECK(          66, Tx.get_Gain() );
	CHECK(         200, Tx.get_HoldCnt() );
	CHECK(  2, Tx.ramp_step() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(          99, Tx.get_Gain() );
	CHECK(         200, Tx.get_HoldCnt() );
	CHECK(  2, Tx.ramp_step() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(          99, Tx.get_Gain() );
	CHECK(         199, Tx.get_HoldCnt() );
	CHECK(  2, Tx.ramp_step() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(          99, Tx.get_Gain() );
	CHECK(         198, Tx.get_HoldCnt() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "52", "set_HoldDuration() during hold" );
    try {
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(         200, Tx.get_HoldDuration() );
	CHECK(           2, Tx.get_RampState() );
	CHECK(         198, Tx.get_HoldCnt() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	Tx.set_HoldDuration( 1 );
	CHECK(           1, Tx.get_HoldDuration() );
	CHECK(           1, Tx.get_HoldCnt() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "53", "ramp_step() hold" );
    try {
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(           1, Tx.get_HoldDuration() );
	CHECK(           2, Tx.get_RampState() );
	CHECK(           1, Tx.get_HoldCnt() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(  1, Tx.ramp_step() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(          99, Tx.get_Gain() );
	CHECK(           0, Tx.get_HoldCnt() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "54", "ramp_step() down" );
    try {
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(           1, Tx.get_HoldDuration() );
	CHECK(           1, Tx.get_RampState() );
	CHECK(           0, Tx.get_HoldCnt() );
	CHECKX( 0x00063000, Tx.get_Gain_Qd12() );
	CHECK(          99, Tx.get_Gain() );
	CHECK(  1, Tx.ramp_step() );
	CHECKX( 0x00042000, Tx.get_Gain_Qd12() );
	CHECK(          66, Tx.get_Gain() );
	CHECK(  1, Tx.ramp_step() );
	CHECKX( 0x00021000, Tx.get_Gain_Qd12() );
	CHECK(          33, Tx.get_Gain() );
	CHECK(  0, Tx.ramp_step() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
	CHECK(  0, Tx.ramp_step() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "55", "restart_ramp()" );
    try {
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(           1, Tx.get_HoldDuration() );
	CHECK(           0, Tx.get_RampState() );
	CHECK(           0, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
	Tx.restart_ramp();
	CHECKX( 0x00063000, Tx.get_HiGain_Qd12() );
	CHECKX( 0x00021000, Tx.get_GainStep_Qd12() );
	CHECK(           3, Tx.get_RampDuration() );
	CHECK(           1, Tx.get_HoldDuration() );
	CHECK(           3, Tx.get_RampState() );
	CHECK(           1, Tx.get_HoldCnt() );
	CHECKX( 0x00000000, Tx.get_Gain_Qd12() );
	CHECK(           0, Tx.get_Gain() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

