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

    % input channels from PSD
    chInSum = addinput( dq, 'Dev1', 'ai2', 'Voltage' ); % PSD Sum Pin Signal
    chInX   = addinput( dq, 'Dev1', 'ai3', 'Voltage' ); % PSD X Pin Signal
    chInY   = addinput( dq, 'Dev1', 'ai5', 'Voltage' ); % PSD Y Pin Signal

    chInX.Range = [-5,5];
    chInY.Range = [-5,5];

    % DAQ sample rate
    dq.Rate  = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Parameters

    FreqX_Hz   = 100;		% fast scan sine wave
    LineCycY_n = 200 * 2;	% number of X cycles in ramp cycle
    FrameCnt_n = 1;		% number of frames (Y ramp cycles)

    totalTime_s = FrameCnt_n * LineCycY_n / FreqX_Hz;
    totalSamp_n = totalTime_s * sampRate;

    OutAmpX_V = 0.05;		% output amplitude, sine wave voltage peak
    OutAmpY_V = 0.05;		% output amplitude, ramp voltage peak

    % pi = 3.14159;

%% Y Waveform (slow triangle wave)

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    periodX_s = 1 / FreqX_Hz;			% period of one X sine cycle
    periodY_s = periodX_s * LineCycY_n;		% period of one Y ramp cycle

    quarterY_s = periodY_s / 4;			% quarter ramp cycle
    quarterY_n = round( quarterY_s / dt_s );

    dY_V = OutAmpY_V / quarterY_n ;		% Y ramp increment

    dY_V = OutAmpY_V * (dt_s / (periodY_s / 4));	% Y ramp increment

    % vector segments of Y ramp cycle
    A = [          0 :  dY_V : ( OutAmpY_V - dY_V ) ];
    B = [  OutAmpY_V : -dY_V : (-OutAmpY_V + dY_V ) ];
    C = [ -OutAmpY_V :  dY_V : ( 0         - dY_V ) ];

    outVecY = [A B C];		% concatenate row vectors
    n = 1;
    while ( n < FrameCnt_n )
	n = n + 1;
	outVecY = [outVecY A B C];
    end

    lengthY_n = length( outVecY );

    nsampX_n = periodX_s / dt_s;

%% X Waveform (fast sine wave)

    lengthX_n = lengthY_n;

    % vector of time values
    tVec_s = [0:(lengthX_n - 1)] * dt_s;

    wX = 2 * pi * FreqX_Hz;		% radian frequency

    outVecX = OutAmpX_V * sin( wX * tVec_s );

    % output parameters
    fprintf( 'FreqX_Hz      = %10.3f\n', FreqX_Hz      );
    fprintf( 'LineCycY_n    = %10.3f\n', LineCycY_n    );
    fprintf( 'FrameCnt_n    = %10.3f\n', FrameCnt_n    );
    fprintf( 'OutAmpX_V     = %10.3f\n', OutAmpX_V     );
    fprintf( 'OutAmpY_V     = %10.3f\n', OutAmpY_V     );
    fprintf( 'totalTime_s   = %10.3f\n', totalTime_s   );
    fprintf( 'totalSamp_n   = %10d\n',   totalSamp_n   );
    fprintf( 'sampRate      = %12.4e\n', sampRate      );
    fprintf( 'dt_s          = %12.4e\n', dt_s          );
    fprintf( 'periodX_s     = %12.4e\n', periodX_s     );
    fprintf( 'periodY_s     = %12.4e\n', periodY_s     );
    fprintf( 'quarterY_s    = %12.4e\n', quarterY_s    );
    fprintf( 'quarterY_n    = %10d\n',   quarterY_n    );
    fprintf( 'dY_V          = %12.4e\n', dY_V          );
    fprintf( 'lengthY_n     = %10d\n',   lengthY_n     );
    fprintf( 'nsampX_n      = %10.3f\n', nsampX_n      );

%% Run the DAQ

    outScanData = [transpose( outVecX ), transpose( outVecY )];
	    % transpose into column vectors, then concatenate rows

    inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

    ofile = "ras1.txt";
    fprintf( 'ofile         = %s\n', ofile );

    save( ofile, 'inScanData', '-ascii' );

