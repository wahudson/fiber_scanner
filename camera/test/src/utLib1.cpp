// 2017-05-20  William A. Hudson

// utLib1 version 1.01 -- Unit Test Library.

// User interface is thru #define macros.
// Class methods operate on state of a test.  No object.
//
// Test identifier is always output.
// Failing tests show only failed checks.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
//#include <string>
#include <string.h>	// strcmp()

#include "utLib1.h"

using namespace std;


/*
* Static member definition.
*/
    const char*		utLib1::Id        = "";
    const char*		utLib1::Headline  = "";

    bool		utLib1::OutCase   = 1;
    bool		utLib1::IsOk      = 0;
    bool		utLib1::GotAssert = 1;


/*
* Constructor.  Not used.
*/
utLib1::utLib1()
{
}


/*
* Mark a new test case.
*    This begins a new test sequence.
* call:
*    utLib1::ut_CASE( "42a", "headline text" )
*/
void
utLib1::ut_CASE(
    const char		*id,
    const char		*headline
)
{
  // Report previous test
    if ( ! GotAssert ) {
	utLib1::ut_FAIL( 0, "no asserts" );
    }
    else {
	utLib1::output_case();
    }

  // Start new test
    Id         = id;
    Headline   = headline;
    OutCase    = 0;
    IsOk       = 1;
    GotAssert  = 0;
}


/*
* Output a test result headline.  (private)
*    Can call multiple times on same test, only first one will output.
* call:
*    utLib1::output_case()
*/
void
utLib1::output_case()
{
    if ( ! OutCase ) {
	if ( IsOk ) {
	    cout << Id << "  OK" <<endl;
	}
	else {
	    cout <<endl;
	    cout << Id << "  NOT OK - " << Headline <<endl;
	}
    }
    OutCase = 1;
}


/*
* Flag a failed branch.
* call:
*    utLib1::ut_FAIL( 33, "fail text" )
*/
void
utLib1::ut_FAIL(
    int			line,
    const char		*text
)
{
    IsOk       = 0;
    GotAssert  = 1;

    utLib1::output_case();

    if ( line ) {
	cout << "      FAIL " << text << " (line " << line << ")" <<endl;
    }
    else {
	cout << "      FAIL " << text <<endl;
    }
}


/*
* Flag a passing branch.
*    Use to mark a taken branch as OK.
*    Only marks an assert, does not make the test pass.
* call:
*    utLib1::ut_PASS( "text" )
*/
void
utLib1::ut_PASS(
    const char		*text
)
{
    GotAssert  = 1;
}


/*
* Check comparison -- cstrings
* call:
*    utLib1::ut_CHECK( line, "good", exp )
*/
void
utLib1::ut_CHECK(
    int			line,
    const char		*ref,
    const char		*exp
)
{
    GotAssert  = 1;

    if ( strcmp( exp, ref ) != 0 ) {
	IsOk = 0;
	utLib1::output_case();
	cout << "CHECK str (line " << line << ")" <<endl;
	cout << "< " << ref <<endl;
	cout << "> " << exp <<endl;
    }
}


/*
* Check comparison -- int
* call:
*    utLib1::ut_CHECK( line, 42, exp )
*/
void
utLib1::ut_CHECK(
    int			line,
    int			ref,
    int			exp
)
{
    GotAssert  = 1;

    if ( exp != ref ) {
	IsOk = 0;
	utLib1::output_case();
	cout << "CHECK int (line " << line << ")" <<endl;
	cout << "< " << ref <<endl;
	cout << "> " << exp <<endl;
    }
}


/*
* Check comparison -- hex output
*    Note:  Overload of ut_CHECK() could be made to work (and was kind of
*    cool), but seemed to have too many problems with overload ambiguity
*    due to integral conversions.  The overload ambiguity also had backward
*    compatibility problems.
* call:
*    utLib1::ut_CHECKX( line, 0x16, exp )
*/
void
utLib1::ut_CHECKX(
    int			line,
    unsigned int	ref,
    unsigned int	exp
)
{
    GotAssert  = 1;

    if ( exp != ref ) {
	IsOk = 0;
	utLib1::output_case();
	cout << "CHECKX hex (line " << line << ")" <<endl;
	cout.fill('0');
	cout <<hex;
	cout << "< 0x" <<setw(8) << ref <<endl;
	cout << "> 0x" <<setw(8) << exp <<endl;
	cout.fill(' ');
	cout <<dec;
    }
}

