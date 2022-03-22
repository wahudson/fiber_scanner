// 2022-03-14  William A. Hudson
//
// Sine Wave DAC Program.
//    Uses an MCP4822 DAC connected to Spi1 Universal SPI master.
//    Analog output is -1.000 V to +1.000 V with zero at code 2048:
//    code 4095  at +1.0235 V
//    code 4048  at +1.0000 V
//    code 2048  at  0.0000 V
//    code   48  at -1.0000 V
//    code    0  at -1.0240 V
//    A 12-bit DAC, LSB is 0.0005 V
//        Vout = 0.0005 V * (Code - 2048)
//        Code = (Vout / 0.0005 V) + 2048
// Provide external configuration:
//   rgpio fsel --mode=Alt4  16 17 18 19 20 21
//   rgpio uspi -1 --Spi_Enable_1=1
//   rgpio uspi -1 --Speed_12=200 --EnableSerial_1=1 --ShiftLength_6=16
// ? rgpio clock -0 --Enable_1=1 --Source_4=5 --Mash_2=0 --DivI_12=1000
// ? rgpio fsel --mode=Alt0  4
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <string>
#include <stdlib.h>
#include <stdexcept>	// std::stdexcept

using namespace std;

#include "rgAddrMap.h"
#include "rgUniSpi.h"

#include "dNcWave.h"
#include "dNcOsc.h"
#include "dNcScaler.h"

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

    bool		wave   = 0;
    bool		raw    = 0;
    const char*		nsamp;
    yOpVal		gain;
    const char*		stride = "";

    bool		verbose;
    bool		debug;
    bool		TESTOP;

  public:	// data values

    int			nsamp_n;		// number of samples
    float		stride_f;

    static const int	TxSize = 4;		// transmit fifo depth
    uint32_t		txval[TxSize];		// transmit fifo values
    int			txval_n;		// num elements used

  public:
    yOptLong( int argc,  char* argv[] );	// constructor

    void		parse_options();
    void		print_option_flags();
    void		print_usage();

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
    nsamp       = "";
    gain.Val    = 0;

    verbose     = 0;
    debug       = 0;
    TESTOP      = 0;

    nsamp_n     = 100;
}


/*
* Parse options.
*/
void
yOptLong::parse_options()
{
    while ( this->next() )
    {
	     if ( is( "--wave"       )) { wave       = 1; }
	else if ( is( "--raw"        )) { raw        = 1; }
	else if ( is( "--nsamp="     )) { nsamp      = this->val(); }
	else if ( is( "--gain="      )) { gain.set(    this->val() ); }
	else if ( is( "--stride="    )) { stride     = this->val(); }

	else if ( is( "--verbose"    )) { verbose    = 1; }
	else if ( is( "-v"           )) { verbose    = 1; }
	else if ( is( "--debug"      )) { debug      = 1; }
	else if ( is( "--TESTOP"     )) { TESTOP     = 1; }
	else if ( is( "--help"       )) { this->print_usage();  exit( 0 ); }
	else if ( is( "-"            )) {                break; }
	else if ( is( "--"           )) { this->next();  break; }
	else {
	    Error::msg( "unknown option:  " ) << this->current_option() <<endl;
	}
    }

    string	nsamp_s   ( nsamp );
    string	stride_s  ( stride );

    if ( nsamp_s.length() ) {
	nsamp_n = std::stoi( nsamp_s );
    }

    if ( stride_s.length() ) {
	stride_f = std::stof( stride_s );
    }

    if (                       gain.Val > 2047 ) {
	Error::msg( "require --gain={0..2047}:  "   ) <<
			       gain.Val <<endl;
    }

    txval_n = get_argc();
    if ( txval_n > TxSize ) {
	Error::msg( "limit 4 Tx_value args:  " ) << txval_n <<endl;
	txval_n = TxSize;
	return;
    }

    for ( int i=0;  i<txval_n;  i++ )
    {
	txval[i] = strtoul( next_arg(), NULL, 0 );
    }
}


/*
* Show option flags.
*/
void
yOptLong::print_option_flags()
{
    cout << "--wave        = " << wave         << endl;
    cout << "--raw         = " << raw          << endl;
    cout << "--nsamp       = " << nsamp        << endl;
    cout << "--gain        = " << gain.Val     << endl;
    cout << "--verbose     = " << verbose      << endl;
    cout << "--debug       = " << debug        << endl;

    char*	arg;
    while ( ( arg = next_arg() ) )
    {
	cout << "arg:          = " << arg          << endl;
    }

    cout << "nsamp_n       = " << nsamp_n      << endl;
    cout << "stride_f      = " << stride_f     << endl;

    cout.fill('0');
    for ( int i=0;  i<txval_n;  i++ )
    {
	cout << "txval:        = 0x" <<hex <<setw(8) << txval[i]  << endl;
    }
    cout.fill(' ');
}


/*
* Show usage.
*/
void
yOptLong::print_usage()
{
    cout <<
    "    Sine Wave DAC Program on Spi1\n"
    "usage:  " << ProgName << " [options]\n"
    "  output forms:  (default is none)\n"
    "    --wave              show wave table\n"
    "    --raw               show raw output data\n"
    "  options:\n"
    "    --nsamp=N           number of samples in inner loop\n"
    "    --gain=N            gain (N/2048) of full scale\n"
    "    --stride=F          stride (float) in table Nsize\n"
//  "    --gain_Qd12=N       gain (N/2048) of full scale\n"
//  "    --peak=N            peak amplitude (N/2048 * FS)\n"
//  "    --mVpp=F            amplitude in mVpp\n"
//  "    --ramp_n=N          ramp cycles\n"
//  "    --hold_n=N          hold cycles\n"
    "    --help              show this usage\n"
//  "  # -v, --verbose       verbose output\n"
    "    --debug             debug output\n"
    "  (options with GNU= only)\n"
    ;

// Hidden options:
//       --TESTOP       test mode show all options
}


//--------------------------------------------------------------------------
// Main program
//--------------------------------------------------------------------------

int
main( int	argc,
      char	*argv[]
) {
    int			rv;
    struct timespec	tpA;
    struct timespec	tpB;

    try {
	yOptLong		Opx  ( argc, argv );	// constructor

	Opx.parse_options();

	if ( Opx.TESTOP ) {
	    Opx.print_option_flags();
	    return ( Error::has_err() ? 1 : 0 );
	}

	if ( Error::has_err() )  return 1;

	rgAddrMap		Amx;			// constructor

	Amx.open_dev_mem();
	if ( Amx.is_fake_mem() ) {
	    cout << "Using Fake memory" <<endl;
	}

	rgUniSpi		Uspix  ( &Amx, 1 );	// constructor

	int32_t			Wtab[ 1024 ];		// wave table
	dNcWave			Wx  ( 128, Wtab );	// constructor
	dNcOsc			Nox  ( &Wx, 2, 0 );	// stride int, frac

	dNcScaler		Sox  ( 12 );		// Nbit

	// Scale wave table Q2.30 value.
	Sox.set_Gain(   Opx.gain.Val );
	Sox.set_Offset( 2048 );		// fixed for +- range

	Nox.set_stride( Opx.stride_f );
	Nox.set_phase(  0.0 );		// fixed for now

	// Show configuration
	{
	    cout <<dec <<fixed <<setprecision(4);

	    cout << "Wtab.Nsize = " << Wx.get_size()          <<endl;

	    cout << "Sox.Gain   = " << Sox.get_Gain()         <<endl;
	    cout << "Sox.Offset = " << Sox.get_Offset()       <<endl;

	    cout << "Nox.Stride = " << Nox.get_stride_float() <<endl;
	    cout << "Nox.Phase  = " << Nox.get_phase_float()  <<endl;
	    cout << "NperCycle  = " << Nox.get_nout()         <<endl;

//	    cout << "Stride = 0x" <<hex << Nox.get_stride_qmk() <<endl;
	}

	// Sine Wave table Q2.30 values +1.0 to -1.0
	Wx.init_sine( 0x40000000, 0.0 );

	if ( Opx.wave ) {
	    int32_t		nsize  = Wx.get_size();
	    int32_t		entry;
	    uint32_t		vdac;

	    cout << "     i  Entry          DAC   Float" <<endl;
	    cout <<fixed;

	    for ( int i=0;  i<nsize;  i++ )
	    {
		entry = Wx.WavTab[i];
		vdac  = Sox.scale( entry );

		cout <<setw(6) << i <<setfill('0')
		     << "  0x" <<setw(8) <<hex << entry <<setfill(' ')
		     << "  " <<setw(6) <<dec << vdac
		     << "  " <<setw(9) <<setprecision(6)
		     << Sox.float_Qd30( entry ) <<endl;
	    }
	}

    // Main Loop
	{
	    int		ii           = 0;	// loop counter
	    int		sample_cnt   = 0;	// total read samples
	    int		fifo_cnt     = 0;	// number of Tx fifo writes
	    int		overflow_cnt = 0;	// number of Tx fifo empty

	    uint32_t	vdac;			// DAC write word
	    int32_t	vsin;			// wave table sample

	    if ( Opx.raw ) {
		cout << "    ii   Vout      Code" <<endl;
		cout <<fixed <<setprecision(6);
	    }

	    rv = clock_gettime( CLKID, &tpA );

	    // initial fill of the 4-entry fifo
//	    for ( int i=0;  i < 4;  i++ )
//	    {
//		Uspix.Fifo.write( 0x0f0f );
//	    }

	    // Inner loop
	    //    This loop should never empty the Tx fifo, but a process
	    //    sleep might.
	    while ( sample_cnt++ < Opx.nsamp_n )
	    {
		Uspix.Stat.grab();	// query this sample only

		if ( ! Uspix.Stat.get_TxFull_1() ) {
		    vsin = Nox.next_sample();
		    vdac = Sox.scale( vsin );

		    if ( Opx.raw ) {	// show raw waveform output
			ii++;
			cout <<setw(6) << ii << "  "
			     <<setw(9) << Sox.float_Qd30( vsin )
			     <<setw(6) <<dec << vdac <<endl;
		    }

		    // d[15] = A/B select, 0= A, 1= B
		    // d[14] = X, unused
		    // d[13] = Gain, 0= 2x, 1= 1x (times 2.048 V FS)
		    // d[12] = SHDNn, 0= shutdown, 1= active

		    vdac = vdac || 0x3000;
		    // vdac = (Nox.next_sample() & 0x0fff) || 0x3000;

		    Uspix.Fifo.write( vdac );
		    fifo_cnt++;
		}

		if ( Uspix.Stat.get_TxEmpty_1() ) {	// it was empty
		    overflow_cnt++;	// empty is an underflow error
		}
	    }

	    rv = clock_gettime( CLKID, &tpB );

	    if ( rv ) { cerr << "Error:  clock_gettime() failed" << endl; }

	    int64_t	delta_ns =
		((tpB.tv_sec  - tpA.tv_sec) * ((int64_t) 1000000000)) +
		 (tpB.tv_nsec - tpA.tv_nsec);
		// Note 4 seconds overflows a 32-bit int.
		// Use careful promotion to 64-bit integer to avoid overflow.

	    int			ns_sample    = -1;
	    int			ns_fifo      = -1;
	    if ( sample_cnt ) {
		ns_sample    =         ( delta_ns / sample_cnt );
	    }
	    if ( fifo_cnt   ) {
		ns_fifo      =         ( delta_ns /   fifo_cnt );
	    }

	    cerr << "    sample_cnt=   " << sample_cnt <<endl;
	    cerr << "    fifo_cnt=     "
		 <<left  <<setw(8)          << fifo_cnt  << "  "
		         <<setw(6)  <<right << ns_fifo   << " ns/fifo_write"
		 <<endl;

	    cerr << "    overflow_cnt= " << overflow_cnt <<endl;

	    cerr << "    delta_ns= "
		 <<setw(10) <<right << delta_ns  << " ns,  "
		 <<setw(4)          << ns_sample << " ns/sample"
		 <<endl;
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

