// 2017-05-20  William A. Hudson

#ifndef utLib1_P
#define utLib1_P

//--------------------------------------------------------------------------
// Unit Test Library.
//--------------------------------------------------------------------------

class utLib1 {
  private:
    static const char	*Id;		// short id "42a"
    static const char	*Headline;	// headline text

    static bool		OutCase;	// header has been output
    static bool		IsOk;		// test has passed
    static bool		GotAssert;	// test has an assert

  private:
    static void		output_case();

  public:
    utLib1();

    static void		ut_CASE(
			    const char        *id,
			    const char        *headline
			);

    static void		ut_FAIL(
			    int			line,
			    const char		*text

			);

    static void		ut_PASS(
			    const char		*text
			);

    static void		ut_CHECK(
			    int                 line,
			    const char		*ref,
			    const char		*exp
			);

    static void		ut_CHECK(
			    int                 line,
			    int			ref,
			    int			exp
			);

    static void		ut_CHECKX(
			    int                 line,
			    unsigned int	ref,
			    unsigned int	exp
			);
};


/*
* User interface.
*/

#define  CASE(ID,HD)	utLib1::ut_CASE( ID, HD )

#define  FAIL(T)	utLib1::ut_FAIL( __LINE__, (T) )
#define  PASS(T)	utLib1::ut_PASS( T )

#define  CHECK(REF,EXP)	utLib1::ut_CHECK( __LINE__, (REF), (EXP) )
#define  CHECKX(REF,EXP)  utLib1::ut_CHECKX( __LINE__, (REF), (EXP) )


#endif

