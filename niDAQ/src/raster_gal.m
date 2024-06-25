%% 2024-01-09  William A. Hudson
%
% Raster scan galvanometer.
% Generate an output waveform data set, and read back the corresponding
% input data set from PSD and Photodetector.
% Assumptions:
%    X galvo is fast scan, sine wave.
%    Y galvo is slow scan, triangle wave.
%    Galvo position voltage is +- about zero.  Both start at zero at time 0.

%% Destroy previous objects??

%% DAQ configuration
    % addoutput/addinput order is column order in data matrix

    % construct DataAcquisition object
    dq = daq( 'ni' );

    % output channels for piezo drive signals
    chOutX = addoutput( dq, 'Dev1', 'ao0', 'Voltage' );
    chOutY = addoutput( dq, 'Dev1', 'ao1', 'Voltage' );

    % input channel from photodetector
    chInSig = addinput( dq, 'Dev1', 'ai1', 'Voltage' ); % Intensity Signal

    chInSig.Range = [-5,5];

    % input channels from PSD
 %  chInSum = addinput( dq, 'Dev1', 'ai2', 'Voltage' ); % PSD Sum Pin Signal
 %  chInX   = addinput( dq, 'Dev1', 'ai3', 'Voltage' ); % PSD X Pin Signal
 %  chInY   = addinput( dq, 'Dev1', 'ai5', 'Voltage' ); % PSD Y Pin Signal

 %  chInSum.Range = [-5,5];
 %  chInX.Range   = [-5,5];
 %  chInY.Range   = [-5,5];

    % DAQ sample rate
    dq.Rate  = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Parameters

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

    FreqX_Hz   = 100;		% fast scan sine wave
    LineCycY_n = 200 * 2;	% number of X cycles in ramp cycle
    FrameCnt_n = 1;		% number of frames (Y ramp cycles)

%   FreqX_Hz   = 6250;		% DEBUG - 10 samples per cycle
%   LineCycY_n = 4 * 2;

    OutAmpX_V = 1.00;		% output amplitude, sine wave voltage peak
    OutAmpY_V = 1.00;		% output amplitude, ramp voltage peak

    % pi = 3.14159;

    totalTime_s = FrameCnt_n * LineCycY_n / FreqX_Hz;
    totalSamp_n = totalTime_s * sampRate;

    uniXsamp_n = (sampRate / FreqX_Hz) / 2;	% uni-direction num samples
    uniYsamp_n = LineCycY_n / 2;

%% Log Output

    diary_file = OfileBase + "-log.txt";
    diary( diary_file );	% appends to file if it already exists

    date = datetime( 'now' );
    date.Format = 'yyyy-MM-dd HH:mm:ss';

    fprintf( "%s\n", date );
    fprintf( "%s\n", Comments );	% for each element of vector

    fprintf( 'FreqX_Hz      = %10.3f\n', FreqX_Hz      );
    fprintf( 'LineCycY_n    = %10.3f\n', LineCycY_n    );
    fprintf( 'FrameCnt_n    = %10.3f\n', FrameCnt_n    );
    fprintf( 'OutAmpX_V     = %10.3f\n', OutAmpX_V     );
    fprintf( 'OutAmpY_V     = %10.3f\n', OutAmpY_V     );
    fprintf( 'uniXsamp_n    = %10.3f\n', uniXsamp_n    );
    fprintf( 'uniYsamp_n    = %10.3f\n', uniYsamp_n    );
    fprintf( 'totalTime_s   = %10.3f\n', totalTime_s   );
    fprintf( 'totalSamp_n   = %10d\n',   totalSamp_n   );

%% Y Waveform (slow triangle wave)

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    periodX_s = 1 / FreqX_Hz;			% period of one X sine cycle
    periodY_s = periodX_s * LineCycY_n;		% period of one Y ramp cycle

    quarterY_s = periodY_s / 4;			% quarter ramp cycle
    quarterY_n = quarterY_s / dt_s;

    dY_V = OutAmpY_V / quarterY_n ;		% Y ramp increment

    % vector segments of Y ramp cycle
    A = [          0 :  dY_V : ( OutAmpY_V - dY_V ) ];
    B = [  OutAmpY_V : -dY_V : (-OutAmpY_V + dY_V ) ];
    C = [ -OutAmpY_V :  dY_V : ( 0         - dY_V ) ];

    % Note parameters are all floating point.  Number of samples in each
    % ramp segment may vary due to rounding.  Good enough for initial use.

    outVecY = [A B C];		% concatenate row vectors

    n = 1;
    while ( n < FrameCnt_n )	% add ramp cycles to fill out frame
	n = n + 1;
	outVecY = [outVecY A B C];
    end

    lengthY_n = length( outVecY );

%% X Waveform (fast sine wave)

    lengthX_n = lengthY_n;

    % vector of time values
    tVec_s = [0:(lengthX_n - 1)] * dt_s;

    wX = 2 * pi * FreqX_Hz;		% radian frequency

    outVecX = OutAmpX_V * sin( wX * tVec_s );

    fprintf( 'sampRate      = %12.4e\n', sampRate      );
    fprintf( 'dt_s          = %12.4e\n', dt_s          );
    fprintf( 'periodX_s     = %12.4e\n', periodX_s     );
    fprintf( 'periodY_s     = %12.4e\n', periodY_s     );
    fprintf( 'quarterY_s    = %12.4e\n', quarterY_s    );
    fprintf( 'quarterY_n    = %10d\n',   quarterY_n    );
    fprintf( 'dY_V          = %12.4e\n', dY_V          );
    fprintf( 'lengthY_n     = %10d\n',   lengthY_n     );

    % figure(1);  clf;
    % plot( tVec_s, outVecX, tVec_s, outVecY );

%% Run the DAQ

    % Force zero at end point, leave galvo at rest.
    outVecX = [outVecX, 0.0];
    outVecY = [outVecY, 0.0];

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

    fprintf( 'daq_file      = %s\n', daq_file );

    % gzip( daq_file );

if ( 1 )
    % formatted output
    daq2_file = OfileBase + "-daq.txt";
    file_id = fopen( daq2_file, 'w' );

    fprintf( file_id, '%8.5f %8.5f %8.5f\n', transpose( allScanData ) );
	% Vectors applied in column order (many ways to screw up).

    fclose(  file_id );
end

%% Plot one line across center

    periodX_n = int32( periodX_s / dt_s );	% samples in one X sine cycle
    center_ix = int32( quarterY_n * 2 );	% index of first center (zero Y)
    fprintf( 'periodX_n     = %10.3f\n', periodX_n     );
    fprintf( 'center_ix     = %10.3f\n', center_ix     );

    rn = [(center_ix - periodX_n):(center_ix + periodX_n)];
				% index range of two X cycles at center Y=0
if ( 1 )
    figure(2);  clf;
   %plot( rn, inScanData(rn) );
    plot( rn, inScanData(rn), '-o' );	% solid line, circle markers
    ylim([-0.010 0.090]);	% prevent auto-scale
end

%% Raster Image

    % Full non-linear raster image, one pixel per sample (no resolution loss).
    fig3 = figure(3);  clf;

    imageX_n = periodX_n;
    imageY_n = int32( lengthY_n / periodX_n );
    fprintf( 'imageX_n      = %10.3f\n', imageX_n      );
    fprintf( 'imageY_n      = %10.3f\n', imageY_n      );

    rasterIb = inScanData( 1:lengthY_n );		% remove final zero
    rasterIm = reshape( rasterIb, imageX_n, imageY_n );	% raster matrix
	% Nrow= [] deduced dimension, Ncol= periodX_n one full cycle

    imshow( rasterIm, DisplayRange=[sigMin_V, sigMax_V] );
	% display grayscale image of matrix in figure
	% Probably remove auto-scale for image comparison.

    fig_file = OfileBase + "-fig.jpg";
    exportgraphics( fig3, fig_file );
	% note pixel-per-bit is NOT preserved in output file

    fprintf( 'fig_file      = %s\n', fig_file );

%% Save 8-bit grayscale image.

    % Scale float to grayscale [0.0 .. 1.0] range for imwrite().
    pngIm = (rasterIm - sigMin_V) / (sigMax_V - sigMin_V);

    pgm_file = OfileBase + "-image.pgm";
    imwrite( rasterIm, "pgm_file", Encoding,"ASCII", MaxValue,256 );
	% imwrite() should scale [0.0 .. 1.0] data by 256, write 8-bit.
	% Encoding,"rawbits" - for binary

    fprintf( 'pgm_file      = %s\n', pgm_file );

    % Read back to verify pgm image.
    figure(4);  clf;
    readIm = imread( pgm_file );
    imshow( readIm );

%% Plot XY intensity

if ( 1 )
    % scale intensity to fit in range 0..1
    iu = (inScanData + 0.005 ) / 0.150;		% intensity vector {0.0 .. 1.0}

    xx = outScanData(:,1);		% column vectors
    yy = outScanData(:,2);
    rm = [(center_ix - quarterY_n):(center_ix + quarterY_n)];
				% index range positive Y ramp

    figure(5);  clf;
    colormap( gray(256) );
    scatter( xx(rm), yy(rm), [], iu(rm), "filled" );

	% [] is default point size in examples
	% row vs column vectors??

    % sz = zeros( 1, length( rm ) ) + 36;	% row vector
	% in case point size needs to be a vector for scatter() color
end

%% Close log file
    diary off;

