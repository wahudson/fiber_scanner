// 2018-08-31  William A. Hudson
//
// Testing:  dNcOsc  Numeric Controlled Oscillator.
//    10-19  Constructor, Wave table
//    20-29  Conversions qmk2float(), float2qmk(), phase2mag(), phase2frac(),
//		to_phase()
//    30-39  Stride, Phase accessors
//    50-59  next_index(), next_sample()
//    60-69  is_new_cycle(), next_index() rollover
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library
#include "dNcWave.h"
#include "dNcOsc.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

const int		TabSize = 128;
int32_t			Wtab[ TabSize ];	// wave table

dNcWave			Wx  ( TabSize, Wtab );	// constructor
dNcOsc			Tx  ( &Wx, 1, 0 );	// stride int, frac

//--------------------------------------------------------------------------
//## Constructor, Wave table
//--------------------------------------------------------------------------

  CASE( "10a", "Wave table init_sine()" );
    try {
	// Sine Wave table Q2.30 values +1.0 to -1.0
	Wx.init_sine( 0x40000000, 0.0 );	// amplitude, offset
//	Wx.write_wave( &cout );
	PASS( "init_sine()" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "10b", "Tx initial get_stride_qmk()" );
    try {
	CHECKX( 0x00001000, Tx.get_stride_qmk() );
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "11", "constructor" );
    try {
	dNcOsc			tx  ( &Wx, 2, 7 );
	CHECKX( 0x00002007, tx.get_stride_qmk() );
	CHECKX( 0x00000000, tx.get_phase_qmk() );
	PASS( "construct ok" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "12a", "constructor" );
    try {
	dNcOsc			tx  ( &Wx, 127, 0xff );
	CHECKX( 0x0007f0ff, tx.get_stride_qmk() );
	CHECKX( 0x00000000, tx.get_phase_qmk() );
	PASS( "construct ok" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "12b", "constructor" );
    try {
	dNcOsc			tx  ( &Wx, 128, 0 );
	FAIL( "no throw" );
    }
    catch ( logic_error& e ) {
	CHECK( "dNcOsc:  constructor:  stride_int exceeds wave table size",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "13", "constructor" );
    try {
	dNcOsc			tx  ( NULL, 2, 0 );
	FAIL( "no throw" );
    }
    catch ( logic_error& e ) {
	CHECK( "dNcOsc:  constructor requires dNcWave object",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "19", "constructor, odd wave table" );
    try {
	int32_t			wtab[ 11 ];		// wave table
	dNcWave			wx  ( 11, wtab );	// constructor
	dNcOsc			tx  ( &wx, 3, 4 );	// stride int, frac
	CHECKX( 0x00003004, tx.get_stride_qmk() );
	CHECKX( 0x00000000, tx.get_phase_qmk() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Conversions qmk2float(), float2qmk(), phase2mag(), phase2frac(), to_phase()
//--------------------------------------------------------------------------

  CASE( "21", "float2qmk() = 4098 * x" );
    try {
	CHECK(        4096, Tx.float2qmk(    1.0 ) );
	CHECK(     8192000, Tx.float2qmk( 2000.0 ) );
	CHECK(         409, Tx.float2qmk(    0.1 ) );
	CHECK(           4, Tx.float2qmk(    0.001 ) );
	CHECK(           0, Tx.float2qmk(    0.0 ) );
	CHECK(       -4096, Tx.float2qmk(   -1.0 ) );
	CHECK(    -8192000, Tx.float2qmk(-2000.0 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "22", "qmk2float()" );
    // Float convert to int, scaled to see frational part.
    try {
	CHECK(           0, (1000 * Tx.qmk2float(          0 )) );
	CHECK(        1000, (1000 * Tx.qmk2float(       4096 )) );
	CHECK(       -1000, (1000 * Tx.qmk2float(      -4096 )) );
	CHECK(     -100000, (1000 * Tx.qmk2float(    -409600 )) );
	CHECK(        7000, (1000 * Tx.qmk2float( 0x00007000 )) );
	CHECK(       -3000, (1000 * Tx.qmk2float( 0xffffd000 )) );
	CHECK(      250125, (1000 * Tx.qmk2float(    1024512 )) );
	CHECK(         244, (1000000 * Tx.qmk2float(         1 )) );
	CHECK(        -244, (1000000 * Tx.qmk2float(        -1 )) );
	CHECK(     1000244, (1000000 * Tx.qmk2float(      4097 )) );
//	cout << "qmk2float:  " << Tx.qmk2float( 0xfffff033 ) <<endl;
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "25", "phase2mag(), phase2frac(), Kbits=12" );
    try {
	CHECKX( 0x00000003, Tx.phase2mag(  0x000030a6 ) );
	CHECKX( 0x000000a6, Tx.phase2frac( 0x000030a6 ) );
	CHECKX( 0x000ff754, Tx.phase2mag(  0xff754f21 ) );
	CHECKX( 0x00000f21, Tx.phase2frac( 0xff754f21 ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "26", "to_phase()" );
    try {
	CHECKX( 0xff754f21, Tx.to_phase(  0x000ff754, 0x00000f21 ) );
	CHECKX( 0x874ab0bf, Tx.to_phase(  0x000874ab, 0x000000bf ) );
	CHECKX( 0xffffefff, Tx.to_phase(  0x000ffffe, 0x00000fff ) );
	CHECKX( 0xffffffff, Tx.to_phase(  0x000fffff, 0x00000fff ) );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "27", "to_phase()" );
    try {
	Tx.to_phase(  0x000fffff, 0x00001000 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::to_phase():  fraction exceeds Kbits (4095):  4096",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "28", "to_phase()" );
    try {
	Tx.to_phase(  0x00100000, 0x00000fff );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::to_phase():  integer exceeds 2^20 (1048575):  1048576",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## Stride, Phase accessors
//--------------------------------------------------------------------------

  CASE( "30a", "set_stride( float ) Error =0" );
    try {
	Tx.set_stride( 0.0 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_stride():  require (stride > 0):  0",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "30b", "set_phase( float ) allow =0" );
    try {
	Tx.set_phase( 0.0 );
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
	CHECK(           0, Tx.get_phase_float() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "31a", "set_stride( float )" );
    try {
	Tx.set_stride( 64.00 );
	CHECKX( 0x00040000, Tx.get_stride_qmk() );
	CHECK(          64, Tx.get_stride_float() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "31b", "set_phase( float )" );
    try {
	Tx.set_phase( 64.00 );
	CHECKX( 0x00040000, Tx.get_phase_qmk() );
	CHECK(          64, Tx.get_phase_float() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "32a", "set_stride( float )" );
    try {
	Tx.set_stride( 42.33 );
	CHECKX( 0x0002a547, Tx.get_stride_qmk() );
	CHECK(          42, Tx.get_stride_float() );	// convert to int
//	cout << Tx.get_stride_float() <<endl;
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "32b", "set_phase( float )" );
    try {
	Tx.set_phase( 42.33 );
	CHECKX( 0x0002a547, Tx.get_phase_qmk() );
	CHECK(          42, Tx.get_phase_float() );	// convert to int
//	cout << Tx.get_phase_float() <<endl;
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "33a", "set_stride( float ) maximum" );
    try {
	Tx.set_stride( 127.9999 );
	CHECKX( 0x0007ffff, Tx.get_stride_qmk() );
	CHECK(         127, Tx.get_stride_float() );	// convert to int
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "33b", "set_phase( float ) maximum" );
    try {
	Tx.set_phase( 127.9999 );
	CHECKX( 0x0007ffff, Tx.get_phase_qmk() );
	CHECK(         127, Tx.get_phase_float() );	// convert to int
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "36a", "set_stride( float ) exceed table" );
    try {
	Tx.set_stride( 128.0 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_stride():  stride exceeds WaveTable size:  128",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "36b", "set_phase( float ) exceed table" );
    try {
	Tx.set_phase( 128.0 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_phase():  phase exceeds WaveTable size:  128",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "37a", "set_stride( float ) Error negative" );
    try {
	Tx.set_stride( -42.33 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_stride():  require (stride > 0):  -42.33",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "37b", "set_phase( float ) Error negative" );
    try {
	Tx.set_phase( -42.33 );
	FAIL( "no throw" );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_phase():  require (phase >= 0):  -42.33",
	    e.what()
	);
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## next_index(), next_sample()
//--------------------------------------------------------------------------

  CASE( "50", "setup stride, phase" );
    try {
	Tx.set_stride( 16.0 );
	Tx.set_phase(   0.0 );
	CHECKX( 0x00010000, Tx.get_stride_qmk() );
	CHECK(          16, Tx.get_stride_float() );
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
	CHECK(           0, Tx.get_phase_float() );
	CHECK(           0, Tx.get_index() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "51", "next_index()" );
    try {
	CHECK(          16, Tx.next_index() );
	CHECK(          32, Tx.next_index() );
	CHECK(          48, Tx.next_index() );
	CHECK(          64, Tx.next_index() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "52", "setup stride, phase" );
    try {
	Tx.set_stride(  2.0 );
	Tx.set_phase(   0.0 );
	CHECKX( 0x00002000, Tx.get_stride_qmk() );
	CHECK(           2, Tx.get_stride_float() );
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
	CHECK(           0, Tx.get_index() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "53", "next_sample()" );
    try {
	CHECK(           0, Tx.get_index() );
	CHECKX( 0x0645e9b0, Tx.next_sample() );
	CHECKX( 0x0645e9b0, Wtab[2] );
	CHECK(           2, Tx.get_index() );
	CHECKX( 0x00002000, Tx.get_phase_qmk() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "54", "stride by 2.5, half step" );
    try {
	Tx.set_stride(  2.5 );
	Tx.set_phase(   0.0 );
	CHECKX( 0x00002800, Tx.get_stride_qmk() );
	CHECK(           2, Tx.get_stride_float() );	// convert to int
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
	CHECK(           0, Tx.get_index() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "55", "next_index()" );
    try {
	CHECK(           2, Tx.next_index() );
	CHECKX( 0x00002800, Tx.get_phase_qmk() );
	CHECK(           5, Tx.next_index() );
	CHECKX( 0x00005000, Tx.get_phase_qmk() );
	CHECK(           7, Tx.next_index() );
	CHECKX( 0x00007800, Tx.get_phase_qmk() );
	CHECK(          10, Tx.next_index() );
	CHECKX( 0x0000a000, Tx.get_phase_qmk() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## is_new_cycle(), next_index() rollover
//--------------------------------------------------------------------------

  CASE( "60", "is_new_cycle() at zero phase" );
    try {
	Tx.set_stride(  7.9999 );
	Tx.set_phase(   0.0000 );
	CHECK(           1, Tx.is_new_cycle() );
	CHECKX( 0x00007fff, Tx.get_stride_qmk() );
	CHECKX( 0x00000000, Tx.get_phase_qmk() );
	CHECK(           7, Tx.next_index() );
	CHECK(           0, Tx.is_new_cycle() );
	CHECKX( 0x00007fff, Tx.get_stride_qmk() );
	CHECKX( 0x00007fff, Tx.get_phase_qmk() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "61", "is_new_cycle() at MaxPhase" );
    try {
	CHECKX( 0x0007ffff, Tx.get_MaxPhase_qmk() );
	CHECKX( 0x0007ffff, Tx.float2qmk(  127.999999 ) );
	Tx.set_stride(   7.9999 );
	Tx.set_phase(  127.9999 );
	CHECK(           0, Tx.is_new_cycle() );
	CHECKX( 0x00007fff, Tx.get_stride_qmk() );
	CHECKX( 0x0007ffff, Tx.get_phase_qmk() );
	CHECK(           7, Tx.next_index() );
	CHECK(           1, Tx.is_new_cycle() );
	CHECKX( 0x00007fff, Tx.get_stride_qmk() );
	CHECKX( 0x00007ffe, Tx.get_phase_qmk() );
	CHECK(          15, Tx.next_index() );
	CHECK(           0, Tx.is_new_cycle() );
	CHECKX( 0x00007fff, Tx.get_stride_qmk() );
	CHECKX( 0x0000fffd, Tx.get_phase_qmk() );
    }
    catch ( range_error& e ) {
	CHECK( "dNcOsc::set_phase():  phase exceeds MaxPhase:  128",
	    e.what()
	);
	FAIL( "range exception" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------
  CASE( "99", "Done" );
}

