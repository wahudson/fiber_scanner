// 2022-02-02  William A. Hudson

// gmGeoSpec - Geometry WxH+X+Y specification class.
//--------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>      // std::ostringstream
#include <string>
#include <stdexcept>

using namespace std;

#include "gmGeoSpec.h"


/*
* Constructor.
*/
gmGeoSpec::gmGeoSpec()
{
    GeoW = 0;	// width 0 indicates uninitialized
    GeoH = 0;
    GeoX = 0;
    GeoY = 0;

    GeoSpec = "";
}

/*
* Constructor.
*/
gmGeoSpec::gmGeoSpec( const char* spec )
{
    parse( spec );
}

//--------------------------------------------------------------------------
// Computation
//--------------------------------------------------------------------------

/*
* Parse spec into component values.
*    Require both (W > 0) and (H > 0).
*    Maybe require X and Y >0, but negative values usually mean measure from
*    the opposit edge.
* call:
*    parse( "WxH+X+Y" )
*/
void
gmGeoSpec::parse( const char* spec )
{
    int			rv;

    if ( spec == NULL ) {
	std::ostringstream      css;
	css << "gmGeoSpec:parse():  null spec";
	throw std::runtime_error ( css.str() );
    }

    GeoSpec = spec;

    rv = sscanf( spec, "%d x %d + %d + %d", &GeoW, &GeoH, &GeoX, &GeoY );

    if ( rv != 4 ) {
	std::ostringstream      css;
	css << "gmGeoSpec:parse():  bad WxH+X+Y spec:  '" << spec << "'";
	throw std::runtime_error ( css.str() );
    }

    if ( (GeoW < 0) || (GeoH < 0) || (GeoX < 0) || (GeoY < 0) ) {
	std::ostringstream      css;
	css << "gmGeoSpec:parse():  disallow negative WxH+X+Y spec:  '"
	    << spec << "'";
	throw std::runtime_error ( css.str() );
    }
    // simpler spec, at least to start
}

