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
// Gate output is SPI bit 17.
// Provide external configuration:
//   rgpio fsel --mode=Alt4  16 17 18 19 20 21
//   rgpio uspi -1 --SpiEnable_1=1
//   rgpio uspi -1 --Speed_12=675 --EnableSerial_1=1 --ShiftLength_6=17
//   rgpio uspi -1 --OutMsbFirst_1=1  --ChipSelects_3=0
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
#include "dNcRamp.h"

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
    yOpVal		ncyc;
    yOpVal		nramp;
    yOpVal		gain;
    const char*		stride = "1.0";
    yOpVal		warm;

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
    ncyc.Val    = 20;
    nramp.Val   = 10;
    gain.Val    = 0;
    warm.Val    = 5000000;

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
	else if ( is( "--ncyc="      )) { ncyc.set(    this->val() ); }
	else if ( is( "--nramp="     )) { nramp.set(   this->val() ); }
	else if ( is( "--gain="      )) { gain.set(    this->val() ); }
	else if ( is( "--stride="    )) { stride     = this->val(); }
	else if ( is( "--warm="      )) { warm.set(    this->val() ); }

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
    //#!! could allow gain to be negative, gain.Val is unsigned.

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
    cout << "--ncyc        = " << ncyc.Val     << endl;
    cout << "--nramp       = " << nramp.Val    << endl;
    cout << "--gain        = " << gain.Val     << endl;
    cout << "--warm        = " << warm.Val     << endl;
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
    "    --nsamp=N           number of SPI (Fifo) samples to write\n"
    "    --ncyc=N            number of waveform cycles to issue\n"
    "    --nramp=N           number of ramp up/down cycles to issue\n"
    "    --gain=N            gain (N/2048) of full scale\n"
    "    --stride=F          stride (float) in table Nsize\n"
//  "    --gain_Qd12=N       gain (N/2048) of full scale\n"
//  "    --peak=N            peak amplitude (N/2048 * FS)\n"
//  "    --mVpp=F            amplitude in mVpp\n"
//  "    --ramp_n=N          ramp cycles\n"
//  "    --hold_n=N          hold cycles\n"
    "    --warm=N            warmup count, default 5000000\n"
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
	    cerr << "Using Fake memory" <<endl;
	}

	const int		TabSize = 128 * 1024;

	rgUniSpi		Uspix  ( &Amx, 1 );	// constructor

	int32_t			Wtab[ TabSize ];	// wave table
	dNcWave			Wx  ( TabSize, Wtab );	// constructor
	dNcOsc			Nox  ( &Wx, 2, 0 );	// stride int, frac

	dNcRamp			Sox  ( 12 );		// Nbits full scale

	// Scale wave table Q2.30 value.
	Sox.set_Gain(      0 );		// initial value is replaced
	Sox.set_Offset( 2048 );		// fixed for +- range
	Sox.set_HiGain(       Opx.gain.Val );	// gain (N/2048) of full scale
	Sox.set_RampDuration( Opx.nramp.Val );	// ramp cycles
	Sox.set_HoldDuration( Opx.ncyc.Val );	// hold cycles

	Nox.set_stride( Opx.stride_f );
	Nox.set_phase(  0.0 );		// fixed for now

	// Show configuration
	{
	    cerr <<dec <<fixed <<setprecision(4);

	    cerr << "Wtab.Nsize = " << Wx.get_size()          <<endl;

	    cerr << "Sox.Gain   = " << Sox.get_Gain()         <<endl;
	    cerr << "Sox.Offset = " << Sox.get_Offset()       <<endl;
	    cerr << "Sox.HiGain_Qd12   = " << Sox.get_HiGain_Qd12()   <<endl;
	    cerr << "Sox.GainStep_Qd12 = " << Sox.get_GainStep_Qd12() <<endl;
	    cerr << "Sox.RampDuration  = " << Sox.get_RampDuration()  <<endl;
	    cerr << "Sox.HoldDuration  = " << Sox.get_HoldDuration()  <<endl;

	    cerr << "Nox.Stride = " << Nox.get_stride_float() <<endl;
	    cerr << "Nox.Phase  = " << Nox.get_phase_float()  <<endl;
	    cerr << "NperCycle  = " << Nox.get_nout()         <<endl;

//	    cerr << "Stride = 0x" <<hex << Nox.get_stride_qmk() <<endl;
	}

	// Sine Wave table Q2.30 values +1.0 to -1.0
	Wx.init_sine( 0x40000000, 0.0 );

	// Add sync marks in LSB of wave table
	{
	    int32_t	nsize  = Wx.get_size();		// convert to signed
	    int32_t	istride;

	    istride = Nox.get_stride_float() + 1;	// truncate to int

	    cerr << "nsize   = " << nsize   <<endl;
	    cerr << "istride = " << istride <<endl;

	    for ( int i=0;  i<nsize;  i++ )
	    {
		Wx.WavTab[i] &= 0xfffffff0;	// clear LSB
	    }

	    for ( int i=0;  i<istride;  i++ )
	    {
		Wx.WavTab[i+0]       |= 0x1;	// zero crossing rise
		Wx.WavTab[i+nsize/2] |= 0x1;	// zero crossing fall
		Wx.WavTab[i+nsize/8] |= 0x1;	// asymmetric mark
	    }
	}

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
	    int		notdone      = 1;	// main loop
	    int		cycle_cnt    = 0;	// cycles output
	    int		ii           = 0;	// loop counter
	    int		loop_cnt     = 0;	// total read samples
	    int		fifo_cnt     = 0;	// number of Tx fifo writes
	    int		overflow_cnt = 0;	// number of Tx fifo empty

	    const uint32_t	DacPrefix = 0x3000;	// 16-bit word
			// d[15] = A/B select, 0= A, 1= B
			// d[14] = X, unused
			// d[13] = Gain, 0= 2x, 1= 1x (times 2.048 V FS)
			// d[12] = SHDNn, 0= shutdown, 1= active
			// d[11:0] = DAC value

	    uint32_t	vdac;			// DAC write word
	    int32_t	vsin;			// wave table sample
	    uint32_t	sync;			// sync mark bits

	    if ( Opx.raw ) {
		cout << "    ii   Wtab      Code Sync" <<endl;
		cout <<fixed <<setprecision(6);
	    }

	    // Warm up loop - allow OS shift to higher core clock frequency
	    for ( unsigned i=0;  i < Opx.warm.Val;  i++ )
	    {
		Uspix.Stat.grab();
	    }

	    // Initial fill of the 4-entry fifo with zero (code 2048)
	    vdac = (0x0800 | DacPrefix) << 16;
	    for ( int i=0;  i < 4;  i++ )
	    {
		Uspix.Fifo.write( vdac );
	    }

	    rv = clock_gettime( CLKID, &tpA );

	    // Inner loop
	    //    This loop should never empty the Tx fifo, but a process
	    //    sleep might.
//	    while ( fifo_cnt < Opx.nsamp_n )	// --nsamp becomes obsolete
	    while ( notdone )
	    {
		loop_cnt++;
		Uspix.Stat.grab();	// query this sample only

		if ( ! Uspix.Stat.get_TxFull_1() ) {
		    Uspix.Fifo.write( vdac );	// previous sample
		    fifo_cnt++;

		    if ( Nox.is_new_cycle() ) {
			notdone = Sox.ramp_step();
			cycle_cnt++;
			if ( Opx.debug ) {
			    cout << "cyc= " << cycle_cnt
				<< "  notdone= " << notdone <<endl;
			}
		    }

		    vsin = Nox.next_sample();
		    vdac = Sox.scale( vsin );
		    sync = vsin & 0x1;		// sync mark

		    if ( Opx.raw ) {	// show raw waveform output
			ii++;
			cout <<setw(6) << ii << "  "
			     <<setw(9) << Sox.float_Qd30( vsin )
			     <<setw(6) << vdac << "  "
			     <<setw(2) << sync <<endl;
		    }

		    vdac = (vdac | DacPrefix) << 16;
		    // output MSB, i.e. bit 31, first

		    vdac |= (sync << 15);	// save for next write
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

	    int			ns_loop      = -1;
	    int			ns_fifo      = -1;
	    if ( loop_cnt ) {
		ns_loop      =         ( delta_ns / loop_cnt );
	    }
	    if ( fifo_cnt   ) {
		ns_fifo      =         ( delta_ns / fifo_cnt );
	    }

	    cerr << "    cycle_cnt=    " << cycle_cnt <<endl;
	    cerr << "    loop_cnt=     " << loop_cnt <<endl;
	    cerr << "    fifo_cnt=     "
		 <<left  <<setw(8)          << fifo_cnt  << "  "
		         <<setw(6)  <<right << ns_fifo   << " ns/fifo_write"
		 <<endl;

	    cerr << "    overflow_cnt= " << overflow_cnt <<endl;

	    cerr << "    delta_ns= "
		 <<setw(10) <<right << delta_ns  << " ns,  "
		 <<setw(4)          << ns_loop   << " ns/loop"
		 <<endl;

	    float		Fsamp_Hz = 1.0e9 / ns_fifo;
	    float		Fcyc_Hz  = Fsamp_Hz / Nox.get_nout();

	    cerr <<dec <<fixed <<setprecision(1);
	    cerr << "Fsamp = " <<setw(10) << Fsamp_Hz << " Hz" <<endl;
	    cerr << "Fcyc  = " <<setw(10) << Fcyc_Hz  << " Hz" <<endl;
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

