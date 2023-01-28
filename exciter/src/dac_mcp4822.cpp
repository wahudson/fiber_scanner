// 2023-01-07  William A. Hudson
//
// DAC Operation Program - dac_mcp4822
//    Send data to a MCP4822 DAC connected to Spi1 Universal SPI master.
//    Includes 16-bit extended shift data ExData.
//    ShiftLength_6 >= 16 determines length of ExData actually used.
//    Binary data only, no voltage/frequency conversions are performed.
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
//   rgpio uspi -1 --Speed_12=675 --EnableSerial_1=1 --ShiftLength_6=24
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

#include "uspi_mcp4822x.h"
#include "extShift.h"

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

    bool		csv      = 0;
    bool		raw      = 0;
    bool		a        = 0;
    bool		b        = 0;
    bool		gain1x   = 0;
    bool		gain2x   = 0;
    bool		shutdown = 0;

    yOpVal		warm;

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
	     if ( is( "--csv"        )) { csv        = 1; }
	else if ( is( "--raw"        )) { raw        = 1; }
	else if ( is( "-a"           )) { a          = 1; }
	else if ( is( "-b"           )) { b          = 1; }
	else if ( is( "--gain1x"     )) { gain1x     = 1; }
	else if ( is( "--gain2x"     )) { gain2x     = 1; }
	else if ( is( "--shutdown"   )) { shutdown   = 1; }

	else if ( is( "--warm="      )) { warm.set(    this->val() ); }

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

    if ( csv && raw ) {
	Error::msg( "require only one of:  --csv, --raw\n" );
    }

    if ( gain1x && gain2x ) {
	Error::msg( "require only one of:  --gain1x, --gain2x\n" );
    }

    if ( get_argc() && !(a || b) ) {
	Error::msg( "argv requires -a or -b\n" );
    }

    if ( ! get_argc() && csv && (a || b) ) {
	Error::msg( "--csv ignores -a or -b\n" );
    }

    if ( ! get_argc() && raw && (a || b) ) {
	Error::msg( "--raw ignores -a or -b\n" );
    }

    if ( !( get_argc() || csv || raw || shutdown ) ) {
	Error::msg( "require argv or --csv or --raw or --shutdown\n" );
    }
}


/*
* Show option flags.
*/
void
yOptLong::print_option_flags()
{
    cout << "--csv         = " << csv          << endl;
    cout << "--raw         = " << raw          << endl;
    cout << "-a            = " << a            << endl;
    cout << "-b            = " << b            << endl;
    cout << "--gain1x      = " << gain1x       << endl;
    cout << "--gain2x      = " << gain2x       << endl;
    cout << "--shutdown    = " << shutdown     << endl;

    cout << "--warm        = " << warm.Val     << endl;
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
    "    Operate MCP4822 dual DAC on Spi1\n"
    "usage:  " << ProgName << " [options] [-a|-b [vdac,ExData]..]\n"
    "    vdac                DAC value {0..4095}\n"
    "    ExData              16-bit extended shift value, left justified\n"
    "  channel select:  (one or both)\n"
    "    -a                  channel A\n"
    "    -b                  channel B\n"
    "  gain select:  (choose one)\n"
    "    --gain1x            gain setting 1x (default)\n"
    "    --gain2x            gain setting 2x\n"
    "  stream mode:  (read stdin), applied after argv data\n"
    "    --csv               stream CSV of 'channel,vdac,ExData', e.g.\n"
    "                            a,4095,0xf000\n"
    "    --raw               write raw 32-bit words to rgUniSpi\n"
    "  apply shutdown after all data:\n"
    "    --shutdown          apply shutdown, send ExData=0 if needed\n"
    "  options:\n"
    "    --warm=N            warmup count, default 5000000\n"
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
	if ( Amx.is_fake_mem() && ! Opx.TESTMODE ) {
	    cerr << "Using Fake memory" <<endl;
	}

	rgUniSpi		Uspix  ( &Amx, 1 );	// constructor

	extShift		Esx  ( 4 );		// extended shift bits
	uspi_mcp4822x		ADax  ( 0, &Uspix, &Esx );
	uspi_mcp4822x		BDax  ( 1, &Uspix, &Esx );

	if ( Opx.a ) {
	    ADax.set_Active();
	}

	if ( Opx.b ) {
	    BDax.set_Active();
	}

	if ( Opx.gain2x ) {
	    ADax.set_Gain2x();
	    BDax.set_Gain2x();
	}
	else {			// default
	    ADax.set_Gain1x();
	    BDax.set_Gain1x();
	}

	//---- Argv Data
	if ( Opx.get_argc() ) {

	    char*	arg;
	    char*	aptr;
	    char*	bptr;
	    uint32_t	vdac;
	    uint32_t	extv;

	    while ( ( arg = Opx.next_arg() ) )
	    {
		vdac = strtoul( arg, &aptr, 0 );
//		cout << "arg =" << arg << "  aptr =" << aptr
//		     << "  vdac=" << vdac <<endl;

		if ( *aptr != ',' ) {
		    Error::msg( "expected ',' in arg:  " ) << arg <<endl;
		    continue;
		}
		aptr++;

		extv = strtoul( aptr, &bptr, 0 );
//		cout << "aptr =" << aptr << "  bptr =" << bptr
//		     << "  extv=" << extv <<endl;

		if ( *bptr != '\0' ) {
		    Error::msg( "extra chars in arg:  " ) << arg <<endl;
		    continue;
		}

		if ( vdac > 0xfff ) {
		    Error::msg( "DAC value too large:  " ) << vdac <<endl;
		    continue;
		}

		if ( extv > 0xffff ) {
		    Error::msg( "ext shift too large:  0x" )
			<<hex << extv <<dec <<endl;
		    continue;
		}

		if ( Opx.a ) {
		    Esx.put_ExData( extv );
		    ADax.send_dac_12( vdac );
		    if ( Opx.verbose ) {
			Opx.trace_word( ADax.LastSend );
		    }
		}

		if ( Opx.b ) {
		    Esx.put_ExData( extv );
		    BDax.send_dac_12( vdac );
		    if ( Opx.verbose ) {
			Opx.trace_word( BDax.LastSend );
		    }
		}
	    }
	}

	//---- Stream Data
	if ( Opx.csv || Opx.raw ) {

	    int		loop_cnt     = 0;	// total read samples
	    int		overflow_cnt = 0;	// number of Tx fifo empty

	    const int		BuffSize = 32;
	    char		buff[BuffSize];
	    char		chr;		// channel character
	    uint32_t		vdac;		// DAC value
	    uint32_t		extv;		// extended shift

	    // Warm up loop - allow OS shift to higher core clock frequency
	    for ( unsigned i=0;  i < Opx.warm.Val;  i++ )
	    {
		Uspix.Stat.grab();
	    }

	    rv = clock_gettime( CLKID, &tpA );

	    while ( std::cin.good() )
	    {
		loop_cnt++;

		std::cin.getline( buff, BuffSize );
		    // exceeding BuffSize sets stream failbit
//		cout << "buff:" << buff << ":"<<endl;
//		cout << "n= " << std::cin.gcount() << endl;
		if ( std::cin.gcount() <= 1 ) {		// blank line or EOF
		    continue;
		}

		if ( std::cin.gcount() >= (BuffSize - 1) ) {
		    Error::msg( "line too long:  " ) << buff <<endl;
		    break;
		}

		if ( Opx.raw ) {

		    rv = sscanf( buff, "%i", &vdac );
			//#!! trailing chars not detected

		    if ( rv != 1 ) {
			Error::msg( "bad input:  " ) << buff <<endl;
			continue;
		    }

		    ADax.send_raw_32( vdac );
		    if ( Opx.verbose ) {
			Opx.trace_word( ADax.LastSend );
		    }
		}
		else if ( Opx.csv ) {

		    rv = sscanf( buff, "%c,%i,%i", &chr, &vdac, &extv );
			//#!! trailing chars not detected

		    if ( rv != 3 ) {
			Error::msg( "bad input:  " ) << buff <<endl;
			continue;
		    }

		    if ( vdac > 0xfff ) {
			Error::msg( "DAC value too large:  " ) << vdac <<endl;
			continue;
		    }

		    if ( extv > 0xffff ) {
			Error::msg( "ext shift too large:  " )
			    <<hex << extv <<dec <<endl;
			continue;
		    }

		    if      ( chr == 'a' ) {
			Esx.put_ExData( extv );
			ADax.send_dac_12( vdac );
			if ( Opx.verbose ) {
			    Opx.trace_word( ADax.LastSend );
			}
		    }
		    else if ( chr == 'b' ) {
			Esx.put_ExData( extv );
			BDax.send_dac_12( vdac );
			if ( Opx.verbose ) {
			    Opx.trace_word( BDax.LastSend );
			}
		    }
		    else {
			Error::msg( "bad channel letter:  " ) << chr <<endl;
		    }
		}

		if ( Uspix.Stat.get_TxEmpty_1() ) {	// it was empty
		    overflow_cnt++;	// empty is an underflow error
		}
	    }

	    rv = clock_gettime( CLKID, &tpB );

	    if ( rv ) { cerr << "Error:  clock_gettime() failed" << endl; }

		//#!! assuming no seconds overflow
	    int64_t	delta_ns =
		((tpB.tv_sec  - tpA.tv_sec) * ((int64_t) 1000000000)) +
		 (tpB.tv_nsec - tpA.tv_nsec);
		// Note 4 seconds overflows a 32-bit int.
		// Use careful promotion to 64-bit integer to avoid overflow.

	    int			ns_loop      = -1;
	    if ( loop_cnt ) {
		ns_loop      =         ( delta_ns / loop_cnt );
	    }

	    if ( ! Opx.TESTMODE ) {
		cerr << "    loop_cnt=     " << loop_cnt     <<endl;
		cerr << "    overflow_cnt= " << overflow_cnt <<endl;

		cerr << "    delta_ns= "
		     <<setw(10) <<right << delta_ns  << " ns,  "
		     <<setw(4)          << ns_loop   << " ns/loop"
		     <<endl;
	    }
	}

	//---- Apply Shutdown  (use last value set for ExData)
	if ( Opx.shutdown ) {
	    bool	aa = Opx.a;
	    bool	bb = Opx.b;

	    if ( (! aa) && (! bb) ) {
		aa = 1;
		bb = 1;
	    }

	    if ( aa ) {
		cerr << "shutdown A" << endl;
		ADax.set_Shutdown();
		ADax.send_dac_12( 2048 );
		if ( Opx.verbose ) {
		    Opx.trace_word( ADax.LastSend );
		}
	    }

	    if ( bb ) {
		cerr << "shutdown B" << endl;
		BDax.set_Shutdown();
		BDax.send_dac_12( 2048 );
		if ( Opx.verbose ) {
		    Opx.trace_word( BDax.LastSend );
		}
	    }
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

