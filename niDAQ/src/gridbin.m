%% 2024-07-14  William A. Hudson
%
% Gridbin development to linearize sinusoidal raster scan.
%    Development only, NOT a tool.

%% Parameters
    OfileBase = "run01"'

    OutAmpX_V = 1.00;		% output amplitude, cosine wave voltage peak
    OutAmpY_V = 1.00;		% output amplitude, ramp voltage peak

    SampleX_n     =       1250;
    SampleY_n     =        400;

    dX0_V         =   5.0265e-03;
    dY_V          =  -4.0000e-06;

    dY0_V = dY_V * SampleX_n;

%% Load data
    daq_file = "out16-daq.txt";
    allScanData = load( daq_file, '-ascii' );
    %allScanData = transpose( load( daq_file, '-ascii' ) );
	% probably loads transposed?

    sigVec  = allScanData( : , 1 );
    outVecX = allScanData( : , 2 );
    outVecY = allScanData( : , 3 );

%% Grid image

    ngX = int32( OutAmpX_V / dX0_V );	% half amplitude
    ngY = int32( OutAmpY_V / dY0_V );

    gridX = [-ngX:ngX] * dX0_V;
    gridY = [-ngY:ngY] * dY0_V;

    [gridV, gridN] = gridbin( outVecX, outVecY, sigVec, gridX, gridY );
	% returns linear vectors, not array?
	% length of input vectors is unimportant.
	%#!! May want to strip pre/post transistion.

    imageX_n = length( gridX );
    imageY_n = length( gridY );

    rasterIm = transpose( reshape( gridV, imageX_n, imageY_n ) );

    fig1 = figure(1);  clf;
    imshow( rasterIm, DisplayRange=[sigMin_V, sigMax_V] );	% double FOV

%% Save data

    fig1_file = OfileBase + "-fig1.jpg";
    exportgraphics( fig1, fig1_file );
    fprintf( 'fig1_file      = %s\n', fig1_file );


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

