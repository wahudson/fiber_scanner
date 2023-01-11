// 2023-01-05  William A. Hudson

// Extended shift register data used by class uspi_mcp4822x.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>

using namespace std;

#include "extShift.h"

/*
* Constructor.
*    Once constructed, the data length cannot be changed.
*    len = number of extended data bits, 0..16
*/
extShift::extShift(
    uint32_t		len
)
{
    if ( len > 16 ) {
	std::ostringstream	css;
	css << "extShift:  constructor requires Len<=16:  " << len;
	throw std::range_error ( css.str() );
    }

    ExData = 0;			// data left justified in half-word
    ExMask = (1 << len) - 1;	// mask valid bits, right justified
    ExPos  = 16 - len;		// position of LSB
}

//--------------------------------------------------------------------------
// Accessors
//--------------------------------------------------------------------------

/*
* Set extended data.
*/
void
extShift::put_exdata(
    uint32_t		v
)
{
    ExData = (v & ExMask) << ExPos;

    // ExData = (v << ExPos) & 0xffff;
    //#!! ExMask is not really needed?
}

