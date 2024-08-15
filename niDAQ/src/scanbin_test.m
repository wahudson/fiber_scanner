%% 2024-08-09  William A. Hudson
%
% Test port of numbin to linearize sinusoidal raster scan.
%    Development only, NOT a tool.
%
% Status:  Initial version, not tested.

%% Parameters

    OfileBase = "lin0"'

    SampleX_n     =   1250;		% sinusoidal input
    SampleY_n     =   400;

    LinX_n        =   400;		% Linearized output, X FOV
    LinY_n        =   SampleY_n;

    Lin2X_n       =   2 * LinX_n;	% full cycle

	% Sweep origin is upper-left corner (-1.0, -1.0).  Galvo axis are:
	%   +X axis is right, dx > 0 positive
	%   +Y axis is down,  dy < 0 negative
	% This is the SAME as image coordinates.
	% rcm_uno.m treats +Y as up, then negates the Y values.

    diary_file = OfileBase + "-log.txt";
    diary( diary_file );	% appends to file if it already exists

    fprintf( 'SampleX_n     = %10d\n',   SampleX_n     );
    fprintf( 'SampleY_n     = %10d\n',   SampleY_n     );
    fprintf( 'LinX_n        = %10d\n',   LinX_n        );
    fprintf( 'LinY_n        = %10d\n',   LinY_n        );
    fprintf( 'Lin2X_n       = %10d\n',   Lin2X_n       );

%% Load data
    daq_file = "out16-daq-x1250.dat";
    sigVec = load( daq_file, '-ascii' );	% is a 1-column array

    sigVec_n = length( sigVec );
    sigMax_V = max( sigVec );
    sigMin_V = min( sigVec );

    fprintf( 'sigVec_n      = %10d\n',   sigVec_n      );
    fprintf( 'sigMax_V      = %10.3f\n', sigMax_V      );
    fprintf( 'sigMin_V      = %10.3f\n', sigMin_V      );

%% Linearize data

    linVec = scanbin( sigVec, SampleX_n, LinX_n );

    linVec_n = length( linVec );
    fprintf( 'linVec_n      = %10d\n',   linVec_n      );

    rasterIm = transpose( reshape( linVec, Lin2X_n, linY_n ) );
	% Raw raster matrix, upright image, mirrored X.
	% Function reshape( .., Nrow, Ncol ) generates output array by column,
	% leaving the image transposed.

    rasterIu = rasterIm( :, [1:LinX_n] );
	% Single FOV scaning left to right.

%% Save result data

    linVec_file = OfileBase + "-lin2-x" + Lin2X_n + ".dat";
    file_id = fopen( linVec_file, 'w' );
    fprintf( file_id, '%8.5f\n', linVec );
	% Vectors applied in column order.
    fclose( file_id );
    fprintf( 'linVec_file   = %s\n', linVec_file );

%% Show image

    fig1 = figure(1);  clf;
    imshow( rasterIm, DisplayRange=[sigMin_V, sigMax_V] );
	% Display each row horizontally, i.e. matrix is right-side-up.

    fig1_file = OfileBase + "-fig1.jpg";
    exportgraphics( fig1, fig1_file );
    fprintf( 'fig1_file     = %s\n', fig1_file );

%%--------------------------------------------------------------------------

function [ outVec ] = scanbin( inVec, Nxi, Nxb )  % {
    %
    % outVec =  output data column vector, cycle (2*Nxb)
    % inVec  =  input  data column vector, cycle Nxi
    % Nxi    =  number of samples in one cycle of Xi (i.e. 2*FOV)
    % Nxb    =  number of output bins across X FOV, Nxb << Nxi/2

    Nxi2 = int32( Nxi / 2 );			% round toward zero??
    bx2  = double( 1.0 ) / double( Nxb );	% half width of a bin

    inVec_n = length( inVec );
    outN_n  = (inVec_n * (2 * Nxb)) / Nxi;	% estimate output length

    fprintf( '   scanbin()\n' );
    fprintf( 'Nxi           = %10d\n',   Nxi           );
    fprintf( 'Nxb           = %10d\n',   Nxb           );
    fprintf( 'Nxi2          = %10d\n',   Nxi2          );
    fprintf( 'bx2           = %10.6f\n', bx2           );
    fprintf( 'outN_n        = %10d\n',   outN_n        );

    %% Compute Xmap[] array

    Xmap   = int32(  zeros(    Nxi,  1 ) );	% map column vector
    outVec = double( zeros( outN_n,  1 ) );	% output column vector

    % Initial values ensure nn=0 is skipped in the map.
    nn  = 0;			% output bin index
    Xi  = double( 0.0 );	% X position of input sample ii=0
    Xb  = double( -1.0 );	% X position of output bin   nn=0
    Xbt = Xb - bx2;		% X position threshold
    % pi =3.1415926535;		% is built-in

    for  ii = [0:Nxi2]		% { half cycle

	Xi = - cos( pi * (double( ii ) / double( Nxi2 )) );

	if ( Xi > Xbt )
	    nn = nn + 1;
	    Xb = ( double( 2.0 ) * (double( nn ) / double( Nxb )) ) - 1;
	    Xbt = Xb - bx2;
	end

	Xmap(ii+1) = nn;	% save bin map array Xmap[]

    end  % }

    %% Mirror for a full-cycle map:  (negative cosine slope)

    for  ii = [0:Nxi2]		% half cycle

        Xmap(Nxi2 + ii + 1) = Xmap(Nxi2 - ii + 1);
    end

    %% Linearize signal vector:

    jj    = 0;		% input map index within one cycle, {0 .. Nxi-1}
    np    = Xmap(1);	% current bin number of pVsum
    pVsum = double( 0.0 );	% current bin accumulated signal value
    pcnt  = 0;		% current bin count of samples accumulated
    kk    = 0;		% output outVec index

    for  ix = [1:inVec_n]	% { each signal value index

	ni = Xmap(jj+1);

	if ( ni ~= np )		% not equal !=

	    kk = kk + 1;
	    outVec(kk) = double( pVsum ) / double( pcnt );

	    pVsum = double( 0.0 );
	    pcnt  = 0;
	    np    = ni;
	end

	pVsum = double( pVsum ) + double( inVec(ix) );
		    % accumulate signal value
	pcnt  = pcnt + 1;

	% Next input cycle index
	jj = jj + 1;

	if ( jj >= Nxi )		% wrap around for next cycle

	    jj   = 0;
	    np   = Xmap(1);
	end

    end  % }

    whos	% list all variables:  name, size, type

end  % } function

