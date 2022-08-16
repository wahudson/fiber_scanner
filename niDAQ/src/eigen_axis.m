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
    DecayTime_s   = 1.0;	% resonance decay time with data

    OutAmp_V = 0.10;		% output amplitude, sine wave voltage peak

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

    % add dead time to see resonance decay
    nZeros   = round( DecayTime_s / dt_s );
    sineVecR = [ sineVecR, zeros( 1, nZeros ) ];

    % output status
    fprintf( 'FreqR_Hz      = %10.3f\n', FreqR_Hz );
    fprintf( 'OutAmp_V      = %10.3f\n', OutAmp_V );
    fprintf( 'DatasetTime_s = %10.3f\n', DatasetTime_s );
    fprintf( 'DecayTime_s   = %10.3f\n', DecayTime_s   );
    fprintf( 'dt_s          = %12.4e\n', dt_s   );
    fprintf( 'nSamps        = %10d\n',   nSamps );
    fprintf( 'nZeros        = %10d\n',   nZeros );

    %>> FILE
    ofile = PreFix + "_sineVecR.txt";
    fprintf( 'sineVecR:  %s\n', ofile );
    sineColR = transpose( sineVecR );
    save( ofile, 'sineColR', '-ascii' );
	% A saved row vector has space separated values.

%% Sweep Axis rotation

    pause( 'on' );	% enable process sleep

    for step = [0:18]

	AngleR_deg = 10 * step;		% angle from +X axis, integer

	AngleR_rad = AngleR_deg * Pi / 180;

	AngleR_str = sprintf( "%03d", AngleR_deg );

	% rotate axis of applied sine wave
	outVecX = cos( AngleR_rad ) * sineVecR;
	outVecY = sin( AngleR_rad ) * sineVecR;

	outScanData = [transpose( outVecX ), transpose( outVecY )];
		% transpose into column vectors, then concatenate rows

	inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

	%>> FILE
	ofile = PreFix + "_ang_" + AngleR_str + ".txt";
	fprintf( 'outFile:  %s\n', ofile );
	save( ofile, 'inScanData', '-ascii' );

	% wait for fiber resonance to decay
	fprintf( 'sleep(5)\n' );
	pause( 5 );

    end

