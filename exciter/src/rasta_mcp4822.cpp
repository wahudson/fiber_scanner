// 2023-01-27  William A. Hudson

// Raster Scan dual-DAC Program.
//     Uses mcp4822 DAC on rgUniSpi with extended shift register.
//     ChA is sine wave (fast axis)
//     ChB is triangle wave (slow axis)
// Schematic:  (initial version)
//    kicad/dual_dac_v1/
//    Analog output is -1.000 V to +1.000 V with zero at code 2048:
//    code 4095  at -1.0235 V
//    code 4048  at -1.0000 V
//    code 2048  at  0.0000 V
//    code   48  at +1.0000 V
//    code    0  at +1.0240 V
//    A 12-bit DAC, LSB is 0.0005 V
//        Vout = -0.0005 V * (Code - 2048)	Inverting output
//        Code = -(Vout / 0.0005 V) + 2048
// Provide external configuration:  e.g.
//   rgpio fsel --mode=Alt4  16 17 18 19 20 21
//   rgpio uspi -1 --SpiEnable_1=1
//   rgpio uspi -1 --Speed_12=3999 --EnableSerial_1=1 --ShiftLength_6=19
//   rgpio uspi -1 --OutMsbFirst_1=1  --ChipSelects_3=0
// Output frequency:
//   Tsclk_s = 2 * (Speed_12 + 1) * Tsys_s     SCLK period (seconds)
//   Tcyc_s  = Npoints * Nsclk * Tsclk_s       Waveform period (seconds)
//   Nsclk   = ShiftLength_6 + 2.5             Number of SCLK cycles in sample
//   Tsys_s  = 2.000e-09  system clock period (seconds)
//   Npoints = number of samples in a waveform cycle (--npoints)
//   ShiftLength_6 = 19  number of bits shifted in a SPI transaction
// Examples:
//   # view wave data on stdout, around 300 Hz
//   rasta_mcp4822 --sim --waveA --npoints=10 --nlines=10 --gainA=2048
//   # run slow scan, small amplitude, around 3 Hz
//   rasta_mcp4822 --npoints=1000 --nlines=500 --gainA=204 --gainB=204
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <stdlib.h>
#include <stdexcept>	// std::stdexcept

using namespace std;

#include "rgAddrMap.h"
#include "rgUniSpi.h"

#include "uspi_mcp4822x.h"
#include "extShift.h"

#include "dNcWave.h"
#include "dNcScaler.h"

#include "dNcTriangle.h"

#include "Error.h"
#include "yOption.h"
#include "yOpVal.h"

#define CLKID	CLOCK_MONOTONIC_RAW

//--------------------------------------------------------------------------
// Option Handling
//--------------------------------------------------------------------------

class yOptLong : public yOption {

//  public:	// inherited
//    char*		ProgName;
//    int		get_argc();
//    char*		next_arg();
//    bool		next();
//    bool		is( const char* opt );
//    char*		val();
//    char*		current_option();

  public:	// option values

    bool		sim      = 0;
    bool		nrz      = 0;
    bool		shutdown = 0;

    yOpVal		npoints;
    yOpVal		nlines;
    yOpVal		nframes;
    yOpVal		gainA;
    yOpVal		gainB;
    yOpVal		warm;

    bool		waveA    = 0;

    bool		verbose;
    bool		debug;
    bool		TESTOP;
    bool		TESTMODE = 0;

  public:
    yOptLong( int argc,  char* argv[] );	// constructor

    void		parse_options();
    void		print_option_flags();
    void		print_usage();

    void		trace_word( uint32_t v );
};


/*
* Constructor.  Init options with default values.
*    Pass in the main() argc and argv parameters.
* call:
*    yOptLong	Opx  ( argc, argv );
*    yOptLong	Opx = yOptLong::yOptLong( argc, argv );
*/
yOptLong::yOptLong( int argc,  char* argv[] )
    : yOption( argc, argv )
{
    npoints.Val = 10;		// points in a full sine cycle
    nlines.Val  = 10;		// bidirectional lines
    nframes.Val = 1;
    gainA.Val   = 204;
    gainB.Val   = 204;
    warm.Val    = 5000000;

    verbose     = 0;
    debug       = 0;
    TESTOP      = 0;
}


/*
* Parse options.
*/
void
yOptLong::parse_options()
{
    while ( this->next() )
    {
	     if ( is( "--sim"        )) { sim        = 1; }
	else if ( is( "--nrz"        )) { nrz        = 1; }
	else if ( is( "--shutdown"   )) { shutdown   = 1; }

	else if ( is( "--npoints="   )) { npoints.set( this->val() ); }
	else if ( is( "--nlines="    )) { nlines.set(  this->val() ); }
	else if ( is( "--nframes="   )) { nframes.set( this->val() ); }
	else if ( is( "--gainA="     )) { gainA.set(   this->val() ); }
	else if ( is( "--gainB="     )) { gainB.set(   this->val() ); }
	else if ( is( "--warm="      )) { warm.set(    this->val() ); }

	else if ( is( "--waveA"      )) { waveA      = 1; }
	else if ( is( "--verbose"    )) { verbose    = 1; }
	else if ( is( "-v"           )) { verbose    = 1; }
	else if ( is( "--debug"      )) { debug      = 1; }
	else if ( is( "--TESTOP"     )) { TESTOP     = 1; }
	else if ( is( "--TESTMODE"   )) { TESTMODE   = 1; }
	else if ( is( "--help"       )) { this->print_usage();  exit( 0 ); }
	else if ( is( "-"            )) {                break; }
	else if ( is( "--"           )) { this->next();  break; }
	else {
	    Error::msg( "unknown option:  " ) << this->current_option() <<endl;
	}
    }

    if ( get_argc() ) {
	Error::msg( "extra argv\n" );
    }
}


/*
* Show option flags.
*/
void
yOptLong::print_option_flags()
{
    cout << "--sim         = " << sim          << endl;
    cout << "--nrz         = " << nrz          << endl;
    cout << "--shutdown    = " << shutdown     << endl;

    cout << "--npoints     = " << npoints.Val  << endl;
    cout << "--nlines      = " << nlines.Val   << endl;
    cout << "--nframes     = " << nframes.Val  << endl;
    cout << "--gainA       = " << gainA.Val    << endl;
    cout << "--gainB       = " << gainB.Val    << endl;
    cout << "--warm        = " << warm.Val     << endl;
    cout << "--waveA       = " << waveA        << endl;
    cout << "--verbose     = " << verbose      << endl;
    cout << "--debug       = " << debug        << endl;

    char*	arg;
    while ( ( arg = next_arg() ) )
    {
	cout << "arg:          = " << arg          << endl;
    }
}


/*
* Show usage.
*/
void
yOptLong::print_usage()
{
    cout <<
    "    Raster Scan MCP4822 dual DAC on Spi1\n"
    "usage:  " << ProgName << " [options]\n"
    "  raster config:\n"
    "    --npoints=N         N sample points in a cycle (bidirectional line)\n"
    "    --nlines=N          N bidirectional lines (cycles) in a frame\n"
    "    --nframes=N         N frames to issue, default 1\n"
    "    --gainA=N           gain (N/2048) of full scale\n"
    "    --gainB=N           gain (N/2048) of full scale\n"
    "  at end of data:\n"
    "    --nrz               no return to zero at end of data\n"
    "    --shutdown          apply shutdown, send ExData=0 if needed\n"
    "  options:\n"
    "#   --warm=N            warmup count, default 5000000\n"
    "    --sim               simulated voltages on stdout\n"
    "    --waveA             show sine wave table\n"
    "    --help              show this usage\n"
    "    -v, --verbose       verbose output, show SPI words\n"
//  "    --debug             debug output\n"
    "  (options with GNU= only)\n"
    ;

// Hidden options:
//       --TESTOP       test mode show all options
//       --TESTMODE     test mode disable awkward output
}

/*
* Output a 32-bit hex word for trace/debug.
* call:
*    trace_word( 0xffffffff );
*/
void
yOptLong::trace_word( uint32_t v )
{
	cout.fill('0');
	cout << "+ 0x" <<hex <<setw(8) << v <<endl;

	cout <<dec;
	cout.fill(' ');
}


//--------------------------------------------------------------------------
// Main program
//--------------------------------------------------------------------------

int
main( int	argc,
      char	*argv[]
) {

    try {
	yOptLong		Opx  ( argc, argv );	// constructor

	Opx.parse_options();

	if ( Opx.TESTOP ) {
	    Opx.print_option_flags();
	    return ( Error::has_err() ? 1 : 0 );
	}

	if ( Error::has_err() )  return 1;

	int		Npoints = Opx.npoints.Val;	// points in line
	int		Ncycles = Opx.nlines.Val;	// cycles in frame
	int		Nframes = Opx.nframes.Val;	// number of frames

	rgAddrMap		Amx;			// constructor

	Amx.open_dev_mem();
	if ( Amx.is_fake_mem() && ! Opx.TESTMODE ) {
	    cerr << "Using Fake memory" <<endl;
	}

	rgUniSpi		Uspix  ( &Amx, 1 );	// constructor

	extShift		Esx  ( 4 );		// extended shift bits
	uspi_mcp4822x		ADax  ( 0, &Uspix, &Esx );
	uspi_mcp4822x		BDax  ( 1, &Uspix, &Esx );

	dNcScaler		Ascx  ( 12 );
	dNcScaler		Bscx  ( 12 );

	dNcTriangle		Trix  ( 4.0, -4.0 );

	const int		TabSize = 8 * 1024;
	int32_t			Wtab[ TabSize ];	// wave table

	if ( Npoints > TabSize ) {
	    Error::msg( "Npoints exceeds TabSize\n" );
	    return ( 1 );
	}

	dNcWave			Wx  ( Npoints, Wtab );

	// Sine Wave table Q2.30 values +1.0 to -1.0
	Wx.init_sine( 0x40000000, 0.0 );

	int		iv_max = Npoints * 1 / 4;
	int		iv_min = Npoints * 3 / 4;

	// Add sync marks in LSB of wave table
	{
	    for ( int ii=0;  ii <= Npoints;  ii++ )	// points in line cycle
	    {
		Wx.WavTab[ii] &= 0xfffffff0;	// clear LSB

		if ( ii <= iv_max ) {		// rising slope
		    Wx.WavTab[ii] |= 0x1;
		}
		else if ( ii <= iv_min ) {	// falling slope
		    Wx.WavTab[ii] |= 0x0;
		}
		else {
		    Wx.WavTab[ii] |= 0x1;
		}
	    }
	}

	// Triangle Wave
	Trix.set_slope_points( Ncycles, Ncycles );	// rise, fall
	Trix.init_point(  0.0, +1 );	// start in center, rising
//	Trix.init_point( -1.0, +1 );

	cout.fill('0');
	cout << "yMin_Qd30= 0x" <<hex <<setw(8) << Trix.get_yMin_Qd30() <<endl;
	cout << "yMax_Qd30= 0x" <<hex <<setw(8) << Trix.get_yMax_Qd30() <<endl;

	cout << "dyUp_Qd30= 0x" <<hex <<setw(8) << Trix.get_dyUp_Qd30() <<endl;
	cout << "dyDn_Qd30= 0x" <<hex <<setw(8) << Trix.get_dyDn_Qd30() <<endl;
	cout <<dec;
	cout.fill(' ');

	// Configure DAC
	ADax.set_Active();
	BDax.set_Active();

	ADax.set_Gain1x();
	BDax.set_Gain1x();

	// Configure Scale factors
	Ascx.set_Gain( Opx.gainA.Val );
	Ascx.set_Offset( 2048 );

	Bscx.set_Gain( Opx.gainB.Val );
	Bscx.set_Offset( 2048 );

	if ( Opx.waveA ) {
	    int32_t		nsize  = Wx.get_size();
	    int32_t		entry;
	    uint32_t		mark;
	    uint32_t		vdac;

	    cout << "# waveA table" <<endl;
	    cout << "     i  Entry       Mark   DAC   Float" <<endl;
	    cout <<fixed;

	    for ( int i=0;  i<nsize;  i++ )
	    {
		entry = Wx.WavTab[i];
		mark  = entry & 0x3;
		vdac  = Ascx.scale_Qd30( entry );

		cout <<setw(6) << i <<setfill('0')
		     << "  0x" <<setw(8) <<hex << entry <<setfill(' ')
		     << "  " <<setw(2) <<dec << mark
		     << "  " <<setw(6) <<dec << vdac
		     << "  " <<setw(9) <<setprecision(6)
		     << Ascx.float_Qd30( entry ) <<endl;
	    }
	}

	uint32_t	vsin  = 0;
	uint32_t	vtri  = 0;
	uint32_t	adac  = 0;
	uint32_t	bdac  = 0;

	uint32_t	amark = 0;
	uint32_t	bmark = 0;

	int		ii;	// count triangle cycles
	int		jj;	// count sine cycles
	int		kk;	// count frames

	// Initialize BDax
	vtri  = Trix.get_y_Qd30();
	bmark = Trix.is_rising();
	amark = Wtab[0];			//#!! maybe
	Esx.put_exdata( (bmark << 1) | amark );
	bdac  = Bscx.scale_Qd30( vtri );
	BDax.send_dac_12( bdac );

	cout << "gainA=   " << Ascx.get_Gain() <<endl;
	cout << "gainB=   " << Bscx.get_Gain() <<endl;
	cout << "Npoints= " << Npoints <<endl;
	cout << "Ncycles= " << Ncycles <<endl;
	cout << "Nframes= " << Nframes <<endl;
	cout.precision(4);
	cout <<fixed;

	cout << "    j    i Mark  Anorm    Bnorm   Adac  Bdac" <<endl;

	for ( kk = 1;  kk <= Nframes;  kk++ )		// frames
	{
	    for ( jj = 1;  jj <= Ncycles;  jj++ )	// line cycles in frame
	    {
		for ( ii = 0;  ii <= Npoints - 1;  ii++ )  // points in line
		{
		    vsin  = Wtab[ii];
		    amark = vsin & 0x1;			// sync mark
		    Esx.put_exdata( (bmark << 1) | amark );

		    if ( (ii == iv_min) || (ii == iv_max) ) {	// turn-around

			vtri  = Trix.next_sample_Qd30();
			bmark = Trix.is_rising();		// sync mark
			Esx.put_exdata( (bmark << 1) | amark );

			bdac  = Bscx.scale_Qd30( vtri );
			BDax.send_dac_12( bdac );

			// skip ADax sample to preserve timing
		    }
		    else {
			adac = Ascx.scale_Qd30( vsin );
			ADax.send_dac_12( adac );
		    }

		    if ( Opx.sim ) {

			cout << " " <<setw(4) << jj
			     << " " <<setw(4) << ii
			     << "  " <<setw(1) << bmark <<setw(1) << amark
			     << " " <<setw(8) << Trix.Qd30_2float( vsin )
			     << " " <<setw(8) << Trix.Qd30_2float( vtri )
			     << " " <<setw(5) << adac
			     << " " <<setw(5) << bdac
			     <<endl;
		    }

		    // xv = ASim.out_mV( ADax.LastSend );
		    // yv = BSim.out_mV( BDax.LastSend );
		    // cout <<setw(5) << xv
		    //	    <<setw(5) << yv <<endl;
		}
	    }
	}

	if ( ! Opx.nrz ) {
	    // return to zero output
	    cout << "Zero output" <<endl;
	    ADax.send_dac_12( 2048 );
	    BDax.send_dac_12( 2048 );
	}

	if ( Opx.shutdown ) {
	    // return to zero output
	    cout << "Shutdown DAC (Hi-Z)" <<endl;
	    ADax.set_Shutdown();
	    BDax.set_Shutdown();
	    ADax.send_dac_12( 2048 );
	    BDax.send_dac_12( 2048 );
	}

    }
    catch ( std::exception& e ) {
	Error::msg() << e.what() <<endl;
    }
    catch (...) {
	Error::msg( "unexpected exception\n" );
    }

    return ( Error::has_err() ? 1 : 0 );
}

