// 2021-11-14  William A. Hudson
//
// Testing:  dNcWave  Wave Table class for Numeric Controlled Oscillator.
//    10-19  Constructor
//    20-29  init_sine()
//--------------------------------------------------------------------------

#include <iostream>	// std::cerr
#include <stdexcept>	// std::stdexcept

#include "utLib1.h"		// unit test library
#include "dNcWave.h"

using namespace std;

//--------------------------------------------------------------------------

int main()
{

//--------------------------------------------------------------------------
//## Shared object
//--------------------------------------------------------------------------

const size_t		Ntab = 12;
int32_t			WaveTable[Ntab];

dNcWave			Tx  (Ntab, WaveTable);	// constructor


//--------------------------------------------------------------------------
//## Constructor
//--------------------------------------------------------------------------

  CASE( "10", "constructor" );
    try {
	dNcWave		tx  (Ntab, WaveTable);
	CHECK( 12, tx.get_size() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "11", "get_size()" );
    try {
	CHECK( 12, Tx.get_size() );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

//--------------------------------------------------------------------------
//## init_sine()
//--------------------------------------------------------------------------

  CASE( "20", "init_sine()" );
    try {
	Tx.init_sine( 1.0, 0.0 );
//	Tx.write_wave( &cout );
	PASS( "ok" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "21", "init_sine()" );
    try {
	dNcWave		tx  (Ntab, WaveTable);
	tx.init_sine( 1000.0, 0.0 );
//	tx.write_wave( &cout );
	CHECK(      0, tx.WavTab[0] );
	CHECK(   1000, tx.WavTab[3] );
	CHECK(      0, tx.WavTab[6] );
	CHECK(  -1000, tx.WavTab[9] );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "22", "init_sine()" );
    try {
	dNcWave		tx  (Ntab, WaveTable);
	tx.init_sine( 10000.0, 10000.0 );
//	tx.write_wave( &cout );
	CHECK(  10000, tx.WavTab[0] );
	CHECK(  20000, tx.WavTab[3] );
	CHECK(  10000, tx.WavTab[6] );
	CHECK(      0, tx.WavTab[9] );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

  CASE( "23", "init_sine()" );
    try {
	dNcWave		tx  (Ntab, WaveTable);
	tx.init_sine( 1048576.0, 0.0 );
//	tx.write_wave( &cout );
	PASS( "ok" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }

/******
  CASE( "25", "init_sine_float()" );
    try {
	float		*x;
	//Tx.init_sine_float( 500.0, 1000.0 );
	Tx.init_sine_float( 1.0, 0.0 );
	Tx.write_wave( &cout );
	for ( uint32_t i=0;  i<Ntab;  i++ ) {
	    x = (float*) &(WaveTable[i]);
	    cout << i << "  " << *x <<endl;
	}
	PASS( "ok" );
    }
    catch (...) {
	FAIL( "unexpected exception" );
    }
**********/

  CASE( "99", "Done" );
}

