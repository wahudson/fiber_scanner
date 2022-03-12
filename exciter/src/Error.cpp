// Author:  William A. Hudson  2017-12-01
//
// Error class.
//     Provide a global error message stream and flag.
//--------------------------------------------------------------------------

#include <iostream>
#include "Error.h"


// Init static Class Data:
int		Error::Error_cnt = 0;
std::ostream*	Error::cErr      = &std::cerr;


/*
* Init error stream.  (class method)
*    Optional - default is cerr.
*    This allows substituting an ostringstream for testing.
* call:
*    Error::Init_ostream( &cerr )
*/
void
Error::Init_ostream( std::ostream* erx )
{
    cErr = erx;
}


/*
* Get error flag.  (class method)
*    Return true if error messages have been sent.
* call:
*    Error::has_err()
*/
int
Error::has_err()
{
    return  Error_cnt;
}


/*
* Send error message.  (class method)
*    Returns an error stream with initial message "Error:  ".
*    This allows appending further output and using io manipulators.
*    User is rsponsible for the terminating newline.
*    Option to pass cstring text as an argument.
* call:
*    Error::msg() << "text" << .. <<endl;
*    Error::msg( "text\n" );
*    Error::msg( "text" ) << .. <<endl;
*/
std::ostream&
Error::msg()
{
    Error_cnt++;
    *cErr << "Error:  ";
    return  *cErr;
}

std::ostream&
Error::msg( const char* text )
{
    Error::msg() << text;
    return  *cErr;
}

