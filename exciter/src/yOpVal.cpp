// 2018-01-26  William A. Hudson
//
// Option Argument class.
//     Idea is each option is an object.
//--------------------------------------------------------------------------

#include <stdlib.h>	// strtoul()

#include "yOpVal.h"


/*
* Constructor.
*/
yOpVal::yOpVal()
{
    Given = 0;
    Val   = 0;
}


/*
* Set argument value.
*    Return true if error messages have been sent.
* call:
*    set( "--enable=1" )
*/
void
yOpVal::set( const char*  arg )
{
    Given = 1;
    Val   = strtoul( arg, NULL, 0 );
}

