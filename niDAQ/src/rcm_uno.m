%% 2024-06-28  William A. Hudson
%
% RCM single-frame raster scan galvanometer Microscope.
%    Generate output XY waveforms, and read back the corresponding input
%    data set from Photodetector.
% Microscope operation:
%    Adjust sample position.  Fill in Comments.  Change OfileBase name.  Run.
% Assumptions:
%    X galvo is fast scan, -cos(wt) wave, starting t=0 at left edge.
%    Y galvo is slow scan, ramp wave from top to bottom.
%    Galvo position voltage is +- about zero.  Both start at zero at time 0.
% Git:  https://github.com/wahudson/fiber_scanner/niDAQ/src

%% Parameters, user edit:

    % Caution!  Fill in correct comments BEFORE running script.

    Objective_mag = 5;		% objective magnification (compute FOV)

    Comments = [		% output to log file
	"# Sample:  UASF target"
	"# Stage:  Z= 0.00 mm, Y= 0.00 mm, X=0.00 mm"
	"# PD_Gain:  40 db"
	"# Pinhole:  0 mm"
	"# Laser:  Iset = 30 mA"
	"# WavePlate:  0 deg"
	"# Operator:  xxx"
	"# Note:  "
    ];

    PreView     = 1;		% 1= preview loop, 0= high-res data capture

    FilePrefix  = "out";	% output file name without number or suffixes

    if ( PreView )
	SampleX_n  = 640;	% number of samples in an X cycle (even /4)
	SampleY_n  = 200;	% number of X cycles (lines) in Y ramp
    else
	SampleX_n  = 2560;	% high-res
	SampleY_n  = 800;
    end

    OutAmpX_V = 1.00;		% output amplitude, cosine wave voltage peak
    OutAmpY_V = 1.00;		% output amplitude, ramp voltage peak

    Cal5x_um_per_V = 1373;	% calibration 5x objective um/V  of OutAmpY_V
				% (JWW and WH 2024-08-06)

    Version = "rcm_uno.m  2024-08-20";	% base script from Git

%% Update save counter

    % Auto update or manually set initial value that will be incremented.
    if ( not( exist( 'SaveNum' ) ) )
	SaveNum = 0;
    end

    SaveNum = SaveNum + 1;
    OfileBase = FilePrefix + sprintf( "%02d", SaveNum );

%% Destroy previous objects??

%% DAQ configuration
    % addoutput/addinput order is column order in data matrix

    % construct DataAcquisition object
    dq = daq( 'ni' );

    % output channels for XY drive signals
    chOutX = addoutput( dq, 'Dev1', 'ao0', 'Voltage' );
    chOutY = addoutput( dq, 'Dev1', 'ao1', 'Voltage' );

    % input channel from photodetector
    chInSig = addinput( dq, 'Dev1', 'ai1', 'Voltage' ); % Reflected intensity

    chInSig.Range = [-5,5];

    % DAQ sample rate (4 ch 62500, 2 ch 125000, 1 ch 250000 max)
    dq.Rate  = 125000;		% set samples per second

    sampRate = dq.Rate;		% actual sample rate from DAQ
    dt_s     = 1 / sampRate;	% sample interval

%% Log Output

    diary_file = OfileBase + "-log.txt";
    diary( diary_file );	% appends to file if it already exists

    date = datetime( 'now' );
    date.Format = 'yyyy-MM-dd HH:mm:ss';

    fprintf( '##Date:       = %s\n',     date          );
    fprintf( '%s\n', Comments );	% for each element of vector
    fprintf( 'Version:      = %s\n',     Version       );

    fovX_um  = OutAmpX_V * Cal5x_um_per_V * (Objective_mag / 5);
    fovY_um  = OutAmpY_V * Cal5x_um_per_V * (Objective_mag / 5);

    freqX_Hz = 1 / (SampleX_n * dt_s);	% X frequency, cosine wave

    periodX_s = SampleX_n * dt_s;	% period of one X cosine cycle

    fprintf( 'Objective_mag = %10d\n',   Objective_mag );
    fprintf( 'SampleX_n     = %10d\n',   SampleX_n     );
    fprintf( 'SampleY_n     = %10d\n',   SampleY_n     );
    fprintf( 'OutAmpX_V     = %10.3f\n', OutAmpX_V     );
    fprintf( 'OutAmpY_V     = %10.3f\n', OutAmpY_V     );
    fprintf( 'Cal5x_um_per_V= %10.3f\n', Cal5x_um_per_V);
    fprintf( 'fovX_um       = %10.3f\n', fovX_um       );
    fprintf( 'fovY_um       = %10.3f\n', fovY_um       );
    fprintf( 'sampRate      = %12.4e\n', sampRate      );
    fprintf( 'dt_s          = %12.4e\n', dt_s          );
    fprintf( 'freqX_Hz      = %10.3f\n', freqX_Hz      );
    fprintf( 'periodX_s     = %12.4e\n', periodX_s     );

%% Y Waveform (slow ramp FOV)

    frameSamp_n = SampleY_n * SampleX_n;	% total samples in FOV
    frameSamp_s = frameSamp_n * dt_s;

    dY_V = -2 * OutAmpY_V / frameSamp_n;	% Y ramp increment (negative)

    % vector of ramp Y from top to bottom
    waveY = ([ 0 : (frameSamp_n - 1) ] * dY_V) + OutAmpY_V;

    frameLen_n = length( waveY );		% length of frame in samples

%% X Waveform (fast cosine wave FOV)

    % pi = 3.14159;	% is built-in

    % vector of time values over FOV
    tVec_s = [0:(frameSamp_n - 1)] * dt_s;

    wX = 2 * pi * freqX_Hz;		% radian frequency

    waveX = -1 * OutAmpX_V * cos( wX * tVec_s );	% begin at left edge

    dX0_V = OutAmpY_V * sin( wX * dt_s );	% X step size at X=0
    dY0_V = dY_V * SampleX_n;			% Y step size at Y=0

    fprintf( 'wX            = %12.4e\n', wX            );
    fprintf( 'frameSamp_n   = %10d\n',   frameSamp_n   );
    fprintf( 'frameSamp_s   = %10.3f\n', frameSamp_s   );
    fprintf( 'dX0_V         = %12.4e\n', dX0_V         );
    fprintf( 'dY0_V         = %12.4e\n', dY0_V         );
    fprintf( 'dY_V          = %12.4e\n', dY_V          );

    % A frame is sweep right and sweep left over FOV.

%% Transition/Preamble waveforms

    % Transition with a half cosine wave of duration periodX_s, allowing
    %     simple reshape() of inScanData into an image.

    trans_n = SampleX_n;	% transition duration is one X cycle
    trans_s = trans_n * dt_s;

    % vector of time values
    transVec_s = [0:(trans_n - 1)] * dt_s;

    % transition vector from 1.0 to 0.0 in half an X cycle
    transVec = 0.5 * cos( (wX / 2) * transVec_s );

    % Image Frame begins in upper-left corner, ends in lower-left corner.
    %     These transition vectors connect image frame to (0.0, 0.0)

    preX  = OutAmpX_V * (transVec - 0.5);	% from 0 to -X
    postX = OutAmpX_V * (-0.5 - transVec);	% from -X to 0

    preY  = OutAmpY_V * ( 0.5 - transVec);	% from 0 to +Y
    postY = OutAmpY_V * (-0.5 - transVec);	% from -Y to 0

    fprintf( 'trans_s       = %12.4e\n', trans_s       );
    fprintf( 'trans_n       = %10d\n',   trans_n       );

%% Assemble output XY drive

    outVecX = [ preX  waveX  postX ];	% concatenate row vectors
    outVecY = [ preY  waveY  postY ];

    rawLen_n = length( outVecX );	% raw length without final zero point

    % Force zero at end point, leave galvo at rest.
    outVecX = [outVecX, 0.0];
    outVecY = [outVecY, 0.0];

    % Note:  pre/post transitions are one image line at top/bottom.

    % outVecY = 0.0 - outVecY;	% galvo +voltage is downwards
	% Objective mirror cube reverses the image.

    outScanData = [transpose( outVecX ), transpose( outVecY )];
	    % transpose into column vectors, then concatenate rows

    imageX_n  = SampleX_n;
    imageY_n  = int32( rawLen_n / SampleX_n );
    imageXu_n = int32( imageX_n / 2 );		% single sweep over FOV

    fprintf( 'frameLen_n    = %10d\n',   frameLen_n    );
    fprintf( 'rawLen_n      = %10d\n',   rawLen_n      );
    fprintf( 'imageX_n      = %10d\n',   imageX_n      );
    fprintf( 'imageY_n      = %10d\n',   imageY_n      );
    fprintf( 'imageXu_n     = %10d\n',   imageXu_n     );

%% Run the DAQ/Image loop

    Nrun = 1;
    if ( PreView )
	Nrun = 9999;
    end

    for  ii = [1 : Nrun]	% {

    %% Run the DAQ

	inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

	allScanData = [ inScanData, outScanData ];

	% Range of chInSig, first column of inScanData
	sigMax_V = max( allScanData(:,1) );
	sigMin_V = min( allScanData(:,1) );
	fprintf( 'sigMax_V      = %10.3f\n', sigMax_V      );
	fprintf( 'sigMin_V      = %10.3f\n', sigMin_V      );

    %% Raster Image

	if ( PreView )
	    % Quick and dirty view, not linearized.

	    rasterIb = inScanData( 1:rawLen_n );	% remove final zero
	    rasterIm = transpose( reshape( rasterIb, imageX_n, imageY_n ) );
		% Raw raster matrix, upright image, mirrored X.
		% Function reshape( .., Nrow, Ncol ) walks output array by
		% column leaving the image transposed.

	    rasterIu = rasterIm( :, [1:imageXu_n] );
		% Single FOV scaning left to right.

	    fprintf( '    image_ii  = %10d\n', ii              );
	    fig4 = figure(4);  clf;	% redraw same figure

	    % imshow( rasterIu, DisplayRange=[sigMin_V, sigMax_V] );

	    imshow( rasterIu, DisplayRange=[sigMin_V, sigMax_V], ...
	        XData=[0, fovX_um], YData=[0, fovY_um] );
	    % Specifying YData re-scales image loosing pixel accuracy.

	    subtitle( sprintf( "FOV = %3.0f um", fovY_um ) );
	    axis on;
	    ylabel( "um" );
	    xlabel( "um" );
	end

    end  % }

%% Linearize data

    LinX_n = SampleY_n;		% width of FOV, make X same as Y
    LinY_n = SampleY_n;

    fprintf( 'LinX_n        = %10d\n',   LinX_n        );
    fprintf( 'LinY_n        = %10d\n',   LinY_n        );

    linVec = scanbin( inScanData, SampleX_n, LinX_n );
	% Bidirectional scan, Nx = 2*LinX_n
	% Custom function, mean of samples falling in linear bins.

%% Save linVec

    lin2_file = OfileBase + "-lin-x" + (2*LinX_n) + ".dat";
    file_id = fopen( lin2_file, 'w' );

    fprintf( file_id, '%8.5f\n', linVec );
	% Vectors applied in column order.

    fclose( file_id );

    fprintf( 'lin2_file     = %s\n',     lin2_file     );

%% Raster Image

    tmpVec = linVec([1 : ((2*LinX_n) * LinY_n)]);
	% truncate for image only

    rasterIm = transpose( reshape( tmpVec, (2*LinX_n), LinY_n ) );
	% Raw raster matrix, upright image, mirrored X.
	% Function reshape( .., Nrow, Ncol ) walks output array by column
	% leaving the image transposed.

    rasterIu = rasterIm( :, [1:LinX_n] );
	% Single FOV scaning left to right.

%% Show primary image, autoscaled

    fig4 = figure();  clf;	% auto-increment figure numbers
    fig_file = OfileBase + "-fig.jpg";

    imshow( rasterIu, DisplayRange=[sigMin_V, sigMax_V] );

    subtitle( sprintf( "FOV = %3.0f um", fovY_um ) );
    axis on;
    ylabel( "pixel" );
    xlabel( "pixel" );

    exportgraphics( fig4, fig_file );
	% Save pretty image, small file.
	% Note pixel-per-bit is NOT preserved in output file.

    fprintf( 'fig_file      = %s\n', fig_file );

%% Save original raw data, full scan
    % compact single-column output  -daq-x2500.dat

    daq1_file = OfileBase + "-daq-x" + SampleX_n + ".dat";
    file_id = fopen( daq1_file, 'w' );

    fprintf( file_id, '%8.5f\n', inScanData );
	% Vectors applied in column order.

    fclose( file_id );

    fprintf( 'daq1_file     = %s\n',     daq1_file     );

    gzip(   daq1_file );
    delete( daq1_file );
	% Stupid matlab gzip keeps original file also!!


%% Save 8-bit image normalized over signal range
    % Directly useable image, but loss of accuracy.
if ( 1 )
    image_file = OfileBase + "-image.pgm";

    sigRange_V = sigMax_V - sigMin_V;
    image_im = uint8( (rasterIu - sigMin_V) * double( 256 / sigRange_V ) );
	    % scale +-5 V signal to 8-bit unsigned

    imwrite( image_im, image_file );	% default Encoding="rawbits"

    fprintf( 'image_file    = %s\n',     image_file    );
end


%% Save 16-bit grayscale image for further processing
    % Preserve DAQ accuracy, but not directly useable.
if ( 0 )
    gray_file = OfileBase + "-gray.pgm";

    gray_im = uint16( (rasterIu + 5.0) * double( (64 * 1024) / 10.0 ) );
	    % scale +-5 V signal to 16-bit unsigned

    imwrite( gray_im, gray_file );	% default Encoding="rawbits"

    fprintf( 'gray_file     = %s\n',     gray_file     );
end


%% Debug

if ( 0 )	% raw full data output (debug)
    daq_file = OfileBase + "-daq.dat";
    save( daq_file, 'allScanData', '-ascii' );
	% Format %16.7e, total 3*(16 char) plus <CR><NL>

    fprintf( 'daq_file      = %s\n', daq_file );
    % gzip( daq_file );
end

if ( 0 )
    % formatted output
    daq2_file = OfileBase + "-daq.txt";
    file_id = fopen( daq2_file, 'w' );

    fprintf( file_id, '%8.5f %8.5f %8.5f\n', transpose( allScanData ) );
	% Vectors applied in column order (many ways to screw up).

    fclose( file_id );

    fprintf( 'daq2_file     = %s\n', daq2_file );
end

%   whos	% list all variables:  name, size, type

%% Close log file
    diary off;


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
    outN_n  = int32( (inVec_n * (2 * Nxb)) / Nxi );  % estimate output length

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

