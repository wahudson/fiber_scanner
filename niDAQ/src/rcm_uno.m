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

%% Parameters, user edit:

    % Caution!  Fill in correct comments BEFORE running script.

    Comments = [		% output to log file
	"# Sample:  UASF target"
	"# Stage:  Z= 0.00 mm, Y= 0.000 inch, X=0.00 mm"
	"# Laser:  Iset = 30 mA"
	"# PD_Gain:  40 db"
	"# Pinhole:  0 mm"
	"# Operator:  xxx"
	"# Note:  "
    ];

    OfileBase = "out1";		% output file base-name (without suffix)
				%    File suffix is appended.

    SampleX_n  = 1200;		% number of samples in an X cycle (even)
    FrameY_n   = 800;		% number of X cycles in Y ramp

    OutAmpX_V = 1.00;		% output amplitude, cosine wave voltage peak
    OutAmpY_V = 1.00;		% output amplitude, ramp voltage peak

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
 %  chInB   = addinput( dq, 'Dev1', 'ai2', 'Voltage' ); % Transmitted

    chInSig.Range = [-5,5];
 %  chInB.Range   = [-5,5];

    % DAQ sample rate (4 ch 62500, 2 ch 125000, 1 ch 250000 max)
    dq.Rate  = 62500;		% set samples per second

    sampRate = dq.Rate;		% actual sample rate from DAQ
    dt_s     = 1 / sampRate;	% sample interval

%% Log Output

    diary_file = OfileBase + "-log.txt";
    diary( diary_file );	% appends to file if it already exists

    date = datetime( 'now' );
    date.Format = 'yyyy-MM-dd HH:mm:ss';

    fprintf( "%s\n", date );
    fprintf( "%s\n", Comments );	% for each element of vector

    freqX_Hz = 1 / (SampleX_n * dt_s);	% X frequency, cosine wave

    fprintf( 'SampleX_n     = %10d\n',   SampleX_n     );
    fprintf( 'FrameY_n      = %10d\n',   FrameY_n      );
    fprintf( 'OutAmpX_V     = %10.3f\n', OutAmpX_V     );
    fprintf( 'OutAmpY_V     = %10.3f\n', OutAmpY_V     );
    fprintf( 'freqX_Hz      = %10.3f\n', freqX_Hz      );
    fprintf( 'sampRate      = %12.4e\n', sampRate      );
    fprintf( 'dt_s          = %12.4e\n', dt_s          );

%% Y Waveform (slow ramp FOV)

    dY_V = - OutAmpY_V / FrameY_n;	% Y ramp increment (negative)

    frameSamp_n = FrameY_n * SampleX_n;	% total samples in FOV

    % vector of ramp Y from top to bottom
    waveY = ([ 0 : (frameSamp_n - 1) ] * dY_V) + OutAmpY_V;

    if ( length( waveY ) != FrameY_n )
	fprintf( "Error:  FrameY_n != length( waveY ) = %d\n", length( waveY );
    end

    frameY_n = length( waveY );		% length of frame in samples

%% X Waveform (fast cosine wave FOV)

    % pi = 3.14159;	% is built-in

    % vector of time values over FOV
    tVec_s = [0:(frameSamp_n - 1)] * dt_s;

    wX = 2 * pi * freqX_Hz;		% radian frequency

    waveX = -1 * OutAmpX_V * cos( wX * tVec_s );	% begin at left edge


    periodX_s = SampleX_n / dt_s;	% period of one X cosine cycle
    periodY_s = FrameY_n / dt_s;	% period of one Y ramp cycle

    frameX_n  = SampleX_n;		% width of frame in samples

    fprintf( 'frameSamp_n   = %10d\n',   frameSamp_n   );
    fprintf( 'periodX_s     = %12.4e\n', periodX_s     );
    fprintf( 'periodY_s     = %12.4e\n', periodY_s     );
    fprintf( 'dY_V          = %12.4e\n', dY_V          );

    % A frame is sweep right and sweep left over FOV.

    % figure(1);  clf;
    % plot( tVec_s, waveX, tVec_s, waveY );

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

    preX  = OutAmpX_V * (transVec - 1.0);	% from 0 to -X
    postX = OutAmpX_V * (0.0 - transVec);	% from -X to 0

    preY  = OutAmpY_V * (1.0 - transVec);	% from 0 to +Y
    postY = OutAmpY_V * (0.0 - transVec);	% from -Y to 0

    fprintf( 'trans_s       = %12.4e\n', trans_s       );
    fprintf( 'trans_n       = %10d\n',   trans_n       );
    fprintf( 'frameX_n      = %10d\n',   frameX_n      );
    fprintf( 'frameY_n      = %10d\n',   frameY_n      );

%% Assemble output XY drive

    outVecX = [ preX  waveX  postX ];	% concatenate row vectors
    outVecY = [ preY  waveY  postY ];

    rawLen_n = length( outVecX );	% raw length without final zero point

    % Force zero at end point, leave galvo at rest.
    outVecX = [outVecX, 0.0];
    outVecY = [outVecY, 0.0];

    fprintf( 'rawLen_n      = %10d\n',   rawLen_n      );

    % figure(2);  clf;
    % len = length( outVecX );
    % plot( [1:len], outVecX, [1:len], outVecY );

%% Run the DAQ

    outVecY = 0.0 - outVecY;	% galvo +voltage is downwards ??

    outScanData = [transpose( outVecX ), transpose( outVecY )];
	    % transpose into column vectors, then concatenate rows

    inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

    allScanData = [ inScanData, outScanData ];

    % Range of chInSig, first column of inScanData
    sigMax_V = max( allScanData(:,1) );
    sigMin_V = min( allScanData(:,1) );
    fprintf( 'sigMax_V      = %10.3f\n', sigMax_V      );
    fprintf( 'sigMin_V      = %10.3f\n', sigMin_V      );

    daq_file = OfileBase + "-daq.dat";
    save( daq_file, 'allScanData', '-ascii' );
	% Format %16.7e, total 3*(16 char) plus <CR><NL>
	%#!! saving to USB drive is slow, perhaps after image plot

    fprintf( 'daq_file      = %s\n', daq_file );

    % gzip( daq_file );

if ( 0 )
    % formatted output
    daq2_file = OfileBase + "-daq.txt";
    file_id = fopen( daq2_file, 'w' );

    fprintf( file_id, '%8.5f %8.5f %8.5f\n', transpose( allScanData ) );
	% Vectors applied in column order (many ways to screw up).

    fclose( file_id );
end

%% Raster Image

    % Full raw raster image, one pixel per sample (no resolution loss).

    imageX_n = SampleX_n;
    imageY_n = int32( rawLen_n / SampleX_n );

    fprintf( 'imageX_n      = %10.3f\n', imageX_n      );
    fprintf( 'imageY_n      = %10.3f\n', imageY_n      );

    rasterIb = inScanData( 1:rawLen_n );		% remove final zero
    rasterIm = transpose( reshape( rasterIb, imageX_n, imageY_n ) );
	% Raw raster matrix, upright image.
	% Function reshape( .., Nrow, Ncol ) walks output array by column
	% (imageX_n), leaving the image transposed.

    % Note:  pre/post transitions are one image line at top/bottom.

if ( 1 )
    fig3 = figure(3);  clf;

    imshow( rasterIm, DisplayRange=[sigMin_V, sigMax_V] );
	% display grayscale image of matrix in figure
	% Probably remove auto-scale for image comparison.

    fig_file = OfileBase + "-fig.jpg";
    exportgraphics( fig3, fig_file );
	% note pixel-per-bit is NOT preserved in output file

    fprintf( 'fig_file      = %s\n', fig_file );
end

%% PGM 8-bit grayscale image

if ( 1 )
    % Write manual pgm file, since imwrite() is broken.

    % Scale to grayscale [0 .. 256] range for PGM file.
    pngIm = int32( 256 * (rasterIb - sigMin_V) / (sigMax_V - sigMin_V) );

    pgm_file = OfileBase + "-image.pgm";
    file_id = fopen( pgm_file, 'w' );

    fprintf( file_id, "P2\n" );
    fprintf( file_id, "%d %d %d\n", imageX_n, imageY_n, 256 );
    fprintf( file_id, "%d\n", pngIm );		% one line per element

    fclose(  file_id );

    fprintf( 'pgm_file      = %s\n', pgm_file );

    % Read back for display.
    %     Hopefully imshow() will preserve one display pixel per pixel.

    figure(4);  clf;
    imshow( pngIm );
    % readIm = imread( pgm_file );
    % imshow( readIm );
end

%% Close log file
    diary off;

