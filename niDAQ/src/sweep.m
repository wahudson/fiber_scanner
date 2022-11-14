%% 2022-08-04  William A. Hudson
%
% Generate an output waveform data set, and read back the corresponding
% input data set from PSD and Photodetector.
%

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
    chInY   = addinput( dq, 'Dev1', 'ai4', 'Voltage' ); % PSD Y Pin Signal

    chInX.Range = [-5,5];
    chInY.Range = [-5,5];

    % DAQ sample rate
    d.Rate   = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Parameters

    FreqX_Hz = 805;
    FreqY_Hz = 806;

    DatasetTime_s = 5.0;	% data set duration

    OutAmp_V = 0.05;		% output amplitude, sine wave voltage peak

    pi = 3.14159;

%% Output waveforms

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    nSamps = round( DatasetTime_s / dt_s );

    % vector of time values
    tVec_s = [0:nSamps] * dt_s;

    wX = 2 * pi * FreqX_Hz;
    wY = 2 * pi * FreqY_Hz;

    outVecX = OutAmp_V * sin( wX * tVec_s );
    outVecY = OutAmp_V * sin( wY * tVec_s );

    outScanData = [transpose( outVecX ), transpose( outVecY )];
	    % transpose into column vectors, then concatenate rows

    % outScanData = transpose( [outVecX; outVecY] );
	    % concatenate into a 2-row matrix, then transpose

    inScanData = readwrite( dq, outScanData )

    ofile = "xyz" + ".txt";
    save( 'file.txt', 'inScanData', ... , '-ascii', '-tabs' );


%% Loop

    for ii = [1 2 3]
	ii

	ofile = "xyz" + ii + ".txt"
    end

