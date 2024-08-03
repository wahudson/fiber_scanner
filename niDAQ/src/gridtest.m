%% 2024-07-14  William A. Hudson
%
% Test gridbin() to linearize sinusoidal raster scan.
%    Development only, NOT a tool.
%
% Status:  Functional with issues.
%    It actually made a linearized image!
%    Has NaN in some bins near X=0.
%    Pre/Post transition traces overlap the image.
%    Development on hold in favor of other methods.  2024-08-02

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
	% is a 3-column array, as expected

%% Extract foreward scan data
    % For each scan cycle keep only the first half cycle.

    halfCycle_n = SampleX_n / 2;	% number of samples in half cycle

    ix_vec = [1 : halfCycle_n];		% index range of a half cycle

    fwdScanData = zeros( (SampleY_n * halfCycle_n), 3 );

    for  iy = [0:(SampleY_n - 1)]	% each scan line
    % {
	istride = iy * SampleX_n;	% input  index stride, full cycle
	ostride = iy * halfCycle_n;	% output index stride, half cycle

	fwdScanData((ostride + ix_vec),:) = allScanData((istride + ix_vec),:);
    end  % }

    fprintf( 'halfCycle_n   = %10d\n', halfCycle_n     );

% Extract column vectors

    sigVec  = fwdScanData( : , 1 );
    outVecX = fwdScanData( : , 2 );
    outVecY = fwdScanData( : , 3 );

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

    gridX = double( [-ngX:ngX] ) * dX0_V;
    gridY = double( [-ngY:ngY] ) * dY0_V;
	% unbeliveable matlab:  int_array * float => int_array

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

    % pixel map to see gridbin output organization
    pix_n = length( outVecX );
    numVec = transpose( [1:pix_n] );	% column vector

    % [gridV, gridN] = gridbin( outVecX, outVecY, numVec,  gridX, gridY );
    % [gridV, gridN] = gridbin( outVecX, outVecY, outVecX, gridX, gridY );
	% outVecX is column vector 250000x1

    whos	% list all variables:  name, size, type

	% Matrix dimension:  is (Nrow x Ncol), Nrow is vertical Y dimension.
	%
	% outVecX    250000x1		col vector
	% gridV		401x399
	% gridX		  1x399		row vector
	% gridY		  1x401

%% Show image

    fig1 = figure(1);  clf;
    imshow( gridV, DisplayRange=[sigMin_V, sigMax_V] );
	% Display each row horizontally, i.e. matrix is right-side-up.

    fig1_file = OfileBase + "-fig1.jpg";
    exportgraphics( fig1, fig1_file );
    fprintf( 'fig1_file      = %s\n', fig1_file );

%% Save result data

    gridV_file = OfileBase + "-grid-x" + SampleX_n + ".dat";
    file_id = fopen( gridV_file, 'w' );
    fprintf( file_id, '%8.5f\n', transpose( gridV ) );
	% Vectors applied in column order.
    fclose( file_id );
    fprintf( 'gridV_file     = %s\n', gridV_file );

    gridN_file = OfileBase + "-grin-x" + SampleX_n + ".dat";
    file_id = fopen( gridN_file, 'w' );
    fprintf( file_id, '%4d\n', transpose( gridN ) );
	% Vectors applied in column order.
    fclose( file_id );
    fprintf( 'gridN_file     = %s\n', gridN_file );

