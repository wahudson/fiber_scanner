// 2022-02-02  William A. Hudson

#ifndef gmGeoSpec_P
#define gmGeoSpec_P

//--------------------------------------------------------------------------
// gmGeoSpec - Geometry WxH+X+Y specification class.
//--------------------------------------------------------------------------

class gmGeoSpec {
  public:
    int			GeoW;	// width
    int			GeoH;	// height
    int			GeoX;	// X coordinate
    int			GeoY;	// Y coordinate

    const char*		GeoSpec;	// original spec string

    gmGeoSpec();			// constructor
    gmGeoSpec( const char* spec );

    void		parse( const char* spec );
};

#endif

