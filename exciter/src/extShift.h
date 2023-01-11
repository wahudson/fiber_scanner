// 2023-01-05  William A. Hudson

#ifndef extShift_P
#define extShift_P

#include <iostream>

//--------------------------------------------------------------------------
// Extended shift register data used by class uspi_mcp4822x.
//--------------------------------------------------------------------------

class extShift {
  private:
    uint32_t		ExData;		// data left justified in half-word
    uint32_t		ExMask;		// mask valid bits, right justified
    uint32_t		ExPos;		// position of LSB

  public:
    extShift(			// constructor
	uint32_t	len		// number of extended data bits, 0..16
    );

    // raw data access
    uint32_t		get_ExData()		{ return  ExData; }
    void		put_ExData( uint32_t v )  { ExData = v & 0xffff; }

    uint32_t		get_ExPos()		{ return  ExPos; }

    // extended data length
    uint32_t		get_exlen()		{ return  (16 - ExPos); }

    // right justified data
    uint32_t		get_exdata()		{ return  (ExData >> ExPos); }
    void		put_exdata( uint32_t v );
};

#endif

