%% 2024-07-14  William A. Hudson
%
% Test gridbin() to linearize sinusoidal raster scan.
%    Development only, NOT a tool.

%% Parameters

    OfileBase = "grid0"'

    OutAmpX_V = 1.00;		% output amplitude, cosine wave voltage peak
    OutAmpY_V = 1.00;		% output amplitude, ramp voltage peak

    SampleX_n     =       1250;
    SampleY_n     =        400;

    dX0_V         =   5.0265e-03;
    dY_V          =   4.0000e-06;	% positive step size

    dY0_V = dY_V * SampleX_n;

	% Sweep origin is upper-left corner (-1.0, -1.0).  Galvo axis are:
	%   +X axis is right, dx > 0 positive
	%   +Y axis is down,  dy < 0 negative
	% This is the SAME as image coordinates.
	% rcm_uno.m treats +Y as up, then negates the Y values.

    diary_file = OfileBase + "-log.txt";
    diary( diary_file );	% appends to file if it already exists

    fprintf( 'SampleX_n     = %10d\n',   SampleX_n     );
    fprintf( 'SampleY_n     = %10d\n',   SampleY_n     );
    fprintf( 'OutAmpX_V     = %10.3f\n', OutAmpX_V     );
    fprintf( 'OutAmpY_V     = %10.3f\n', OutAmpY_V     );
    fprintf( 'dX0_V         = %12.4e\n', dX0_V         );
    fprintf( 'dY0_V         = %12.4e\n', dY0_V         );
    fprintf( 'dY_V          = %12.4e\n', dY_V          );

%% Load data
    daq_file = "out16-daq.txt";
    allScanData = load( daq_file, '-ascii' );
    %allScanData = transpose( load( daq_file, '-ascii' ) );
	%#!! probably loads transposed?

    sigVec  = allScanData( : , 1 );
    outVecX = allScanData( : , 2 );
    outVecY = allScanData( : , 3 );

    sigMax_V = max( sigVec );
    sigMin_V = min( sigVec );

    fprintf( 'sigVec_n      = %10d\n', length( sigVec  ) );
    fprintf( 'outVecX_n     = %10d\n', length( outVecX ) );
    fprintf( 'outVecY_n     = %10d\n', length( outVecY ) );

    fprintf( 'sigMax_V      = %10.3f\n', sigMax_V      );
    fprintf( 'sigMin_V      = %10.3f\n', sigMin_V      );

%% Linear Grid

    ngX = int32( OutAmpX_V / dX0_V );	% half amplitude
    ngY = int32( OutAmpY_V / dY0_V );

    gridX = [-ngX:ngX] * dX0_V;
    gridY = [-ngY:ngY] * dY0_V;

    imageX_n = length( gridX );
    imageY_n = length( gridY );

    fprintf( 'ngX           = %10d\n',   ngX           );
    fprintf( 'ngY           = %10d\n',   ngY           );
    fprintf( 'imageX_n      = %10d\n',   imageX_n      );
    fprintf( 'imageY_n      = %10d\n',   imageY_n      );

%% Gridbin

    [gridV, gridN] = gridbin( outVecX, outVecY, sigVec, gridX, gridY );
	% returns two arrays
	% length of input vectors is unimportant.
	%#!! May want to strip pre/post transistion.

    whos	% list all variables:  name, size, type

%% Show image

    rasterIm = reshape( gridV, imageX_n, imageY_n );
    %rasterIm = transpose( reshape( gridV, imageX_n, imageY_n ) );
	%#!! gridV is probably right side up?

    fig1 = figure(1);  clf;
    imshow( rasterIm, DisplayRange=[sigMin_V, sigMax_V] );	% double FOV

    fig1_file = OfileBase + "-fig1.jpg";
    exportgraphics( fig1, fig1_file );
    fprintf( 'fig1_file      = %s\n', fig1_file );

%% Save result data

    gridV_file = OfileBase + "-grid-x" + SampleX_n + ".dat";
    file_id = fopen( gridV_file, 'w' );
    fprintf( file_id, '%8.5f\n', gridV );
	% Vectors applied in column order.
    fclose( file_id );
    fprintf( 'gridV_file     = %s\n', gridV_file );

    gridN_file = OfileBase + "-grin-x" + SampleX_n + ".dat";
    file_id = fopen( gridN_file, 'w' );
    fprintf( file_id, '%4d\n', gridN );
	% Vectors applied in column order.
    fclose( file_id );
    fprintf( 'gridN_file     = %s\n', gridN_file );

