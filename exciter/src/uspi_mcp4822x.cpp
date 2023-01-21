// 2023-01-05  William A. Hudson

// Operating mcp4822 DAC on rgUniSpi with extended shift register.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>	// std::ostringstream
#include <string>
#include <stdexcept>

using namespace std;

//#include "rgAddrMap.h"
//#include "rgUniSpi.h"
//#include "extShift.h"
#include "uspi_mcp4822x.h"

/*
* Constructor.
*    Once constructed, the channel cannot be changed.
*    Assume rgUniSpi is in normal mode, not "variable width mode".
*    The argument pointers are owned by the caller.
* Initial condition is:
*    Gain1x_1    = 0,  2x gain
*    nShutdown_1 = 0,  shutdown
*/
uspi_mcp4822x::uspi_mcp4822x(
    uint32_t		channel,	// 0= A, 1= B channel number
    rgUniSpi*		uspi,
    extShift*		exs
)
{
    if ( channel > 1 ) {
	std::ostringstream	css;
	css << "uspi_mcp4822x:  constructor requires channel={0,1}:  " << channel;
	throw std::range_error ( css.str() );
    }

    if ( uspi == NULL ) {
	std::ostringstream	css;
	css << "uspi_mcp4822x:  constructor requires rgUniSpi*";
	throw std::range_error ( css.str() );
    }

    if ( exs == NULL ) {
	std::ostringstream	css;
	css << "uspi_mcp4822x:  constructor requires extShift*";
	throw std::range_error ( css.str() );
    }

    Uspi    = uspi;
    ExShift = exs;

    Prefix = 0x0000 | (channel << 15);
}

//--------------------------------------------------------------------------
// Accessors
//--------------------------------------------------------------------------

/*
* Set Gain1x_1:  0= 2x, 1= 1x
*/
void
uspi_mcp4822x::put_Gain1x_1(
    uint32_t		v
)
{
    Prefix &= 0xdfff;
    Prefix |= (v & 0x1) << 13;
}


/*
* Set nShutdown_1:  0= shutdown, 1= active
*/
void
uspi_mcp4822x::put_nShutdown_1(
    uint32_t		v
)
{
    Prefix &= 0xefff;
    Prefix |= (v & 0x1) << 12;
}

//--------------------------------------------------------------------------
// Send rgUniSpi data
//--------------------------------------------------------------------------

// Send raw word to rgUniSpi
void
uspi_mcp4822x::send_raw_32(
    uint32_t		v
)
{
    do {			// wait for FIFO not full
	Uspi->Stat.grab();
    } while ( Uspi->Stat.get_TxFull_1() );

    Uspi->Fifo.write( v );

    LastSend = v;
}

/*
* Send data word to DAC channel, along with current ExShift value.
* call:
*    send_dac_12( v )
*    v = DAC 12-bit value, right justified.
*/
void
uspi_mcp4822x::send_dac_12(
    uint32_t		v
)
{
    uint32_t		word;

    word = (Prefix | (v & 0x0fff) ) << 16;
    word = word | ( ExShift->get_ExData() );

    send_raw_32( word );
}

