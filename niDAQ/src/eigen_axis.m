%% 2022-08-07  William A. Hudson
%
% Apply constant sinusoid, sweep axis angle at single frequency.
% Generate an output waveform data set, and read back the corresponding
% input data set from PSD and Photodetector.
%

%% Parameters

    PreFix = 'd1';		% output file set prefix

    FreqR_Hz = 805;		% single frequency

    DatasetTime_s = 2.0;	% data set duration

    OutAmp_V = 0.05;		% output amplitude, sine wave voltage peak

    Pi = 3.1415926535;

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
    dq.Rate   = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Single axis sine wave

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    nSamps = round( DatasetTime_s / dt_s );

    % vector of time values
    tVec_s = [0:nSamps] * dt_s;

    wR = 2 * Pi * FreqR_Hz;		% angular frequency

    sineVecR = OutAmp_V * sin( wR * tVec_s );

    %>> FILE
    save( 'sineVecR.txt', 'sineVecR', '-ascii' );

%% Sweep Axis rotation

    for step = [0:6]

	AngleR_deg = 30 * step;		% angle from +X axis

	AngleR_rad = AngleR_deg * Pi / 180;

	% rotate axis of applied sine wave
	outVecX = cos( AngleR_rad ) * sineVecR;
	outVecY = sin( AngleR_rad ) * sineVecR;

	outScanData = [transpose( outVecX ), transpose( outVecY )];
		% transpose into column vectors, then concatenate rows

	inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

	%>> FILE
	ofile = PreFix + "_ang_" + AngleR_deg + ".txt";
	save( ofile, 'inScanData', '-ascii' );

    end

