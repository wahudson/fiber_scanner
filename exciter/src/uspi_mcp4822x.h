// 2023-01-05  William A. Hudson

#ifndef uspi_mcp4822x_P
#define uspi_mcp4822x_P

#include <iostream>

#include "rgAddrMap.h"
#include "rgUniSpi.h"

#include "extShift.h"

//--------------------------------------------------------------------------
// Operating mcp4822 DAC on rgUniSpi with extended shift register.
//--------------------------------------------------------------------------

class uspi_mcp4822x {
  private:
    rgUniSpi*		Uspi;
    extShift*		ExShift;

    uint32_t		Prefix;		// config prefix bits [15:12]
	// Prefix[15] = 0  Chan_1       0= A, 1= B fixed channel number
	// Prefix[14] = 0  Unused_1
	// Prefix[13] = 0  Gain1x_1     0= 2x, 1= 1x
	// Prefix[12] = 0  nShutdown_1  0= shutdown, 1= active

  public:
    uspi_mcp4822x(		// constructor
	uint32_t	channel,	// 0= A, 1= B
	rgUniSpi*	uspi,
	extShift*	exs
    );

    uint32_t		LastSend;	// assembled word last sent to Uspi

    void		send_raw_32( uint32_t w );

    void		send_dac_12( uint32_t v );

    // Accessor functions
    uint32_t		get_Chan_1()	{ return  ((Prefix >> 15) & 0x1); }
			// Cannot change Chan_1 after construction.

    uint32_t		get_Gain1x_1()	{ return  ((Prefix >> 13) & 0x1); }
    void		put_Gain1x_1(   uint32_t v );

    uint32_t		get_nShutdown_1()  { return  ((Prefix >> 12) & 0x1); }
    void		put_nShutdown_1( uint32_t v );

    // Preferred interface
    void		set_Gain1x()	{ Prefix |=  (0x1 << 13); }
    void		set_Gain2x()	{ Prefix &= ~(0x1 << 13); }

    void		set_Active()	{ Prefix |=  (0x1 << 12); }
    void		set_Shutdown()	{ Prefix &= ~(0x1 << 12); }
};

#endif

