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

    Version = "rcm_uno.m  2024-08-14";	% base script from Git

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

    outVecY = 0.0 - outVecY;	% galvo +voltage is downwards

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

	% Full raw raster image, one pixel per sample (no resolution loss).

	rasterIb = inScanData( 1:rawLen_n );		% remove final zero
	rasterIm = transpose( reshape( rasterIb, imageX_n, imageY_n ) );
	    % Raw raster matrix, upright image, mirrored X.
	    % Function reshape( .., Nrow, Ncol ) walks output array by column
	    % (imageX_n), leaving the image transposed.

	rasterIu = rasterIm( :, [1:imageXu_n] );
	    % Single FOV scaning left to right.

	if ( PreView )
	    % Quick and dirty view, not linearized.
	    fprintf( '    image_ii  = %10d\n', ii              );
	    fig4 = figure(4);  clf;	% redraw same figure

	    % imshow( rasterIu, DisplayRange=[sigMin_V, sigMax_V] );

	    imshow( rasterIu, DisplayRange=[sigMin_V, sigMax_V], ...
	        XData=[0, fovX_um], YData=[0, fovY_um] );
	    % Specifying YData re-scales image loosing pixel accuracy.

	    subtitle( sprintf( "FOV = %3.0f um", fovY_um ) );
	    axis on;
	    ylabel( "pixel" );
	    xlabel( "pixel" );
	end

    end  % }

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

%% Save data, full scan
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
if ( 1 )
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

%% Close log file
    diary off;

