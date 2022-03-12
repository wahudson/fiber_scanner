// 2016-05-02  William A. Hudson

// Option parsing base class.
//--------------------------------------------------------------------------

#ifndef yOption_P
#define yOption_P


//--------------------------------------------------------------------------
// yOption class
//--------------------------------------------------------------------------

class yOption {
  private:
    int			Argc;
    char**		Argv;
    char*		Vp;

  public:
    char*		ProgName;

  public:
    yOption();
    yOption( int argc,  char* argv[] );	// constructor
    yOption( yOption  *opx );		// constructor

    int			get_argc();
    char*		next_arg();
    bool		next();
    bool		is( const char* opt );
    char*		val();
    char*		current_option();
};

#endif

