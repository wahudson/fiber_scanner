// 2018-01-26  William A. Hudson

// Option Argument class.
//--------------------------------------------------------------------------

#ifndef yOpVal_P
#define yOpVal_P

#include <stdint.h>

//--------------------------------------------------------------------------
// yOpVal class
//--------------------------------------------------------------------------

class yOpVal {

  public:
    bool		Given;	// flag that option was given
    uint32_t		Val;	// option value


  public:
    yOpVal();		// constructor

    void		set( const char*  arg );
};

#endif

