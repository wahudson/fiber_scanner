%% 2022-08-29  William A. Hudson
%#! Matlab
%
% Fiber scanner DAQ with lockin calculation.

% Apply constant sinusoid, sweep frequency.
% Generate an output waveform data set, and read back the corresponding
% input data set from PSD and Photodetector.
% Compute lockin results, and output table entry for each frequency.
% Also output raw data at select frequency points.
%
% CAUTION:  Output file names are over-written each time.  Change PreFix.
% Files:
%    k1_LItable.txt		lockin output
%    k1_set_3_daq.txt		sample DAQ data
%    k1_set_3_sine.txt		sample sine wave reference
%
% Try to use only row-vectors, since we want element-wise operations and
% NOT matrix results.

%% Parameters

    PreFix = 'k3';		% output file set prefix

    Tbegin_s      = 1.0;	% settling time to begin analysis
    DatasetTime_s = 2.0;	% total data set duration
    Twait_s       = 5.0;	% wait time between points

    OutAmp_V = 0.10;		% output amplitude, sine wave voltage peak

    Pi = 3.1415926535;

    oFileName = PreFix + "_LItable.txt";		% lockin output table file

    oFileID = fopen( oFileName, 'Wt' );
	% 'Wt' = write with automatic flushing, text mode
	% default encoding "UTF-8"

    pause( 'on' );		% enable process sleep

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
	%#!! what about other channels?

    % DAQ sample rate
    dq.Rate   = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Sample time vector

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    nSamps = round( DatasetTime_s / dt_s );

    % vector of time values
    tVec_s = [0:nSamps] * dt_s;		% row vector (nSamps+1)

    % index for stable portion of data trace
    kB     = round( Tbegin_s / dt_s );	% index for begin stable
    kEnd   = nSamps;			% last element to analyze

    % output status
    fprintf( 'OutAmp_V      = %10.3f\n', OutAmp_V );
    fprintf( 'Tbegin_s      = %10.3f\n', Tbegin_s      );
    fprintf( 'DatasetTime_s = %10.3f\n', DatasetTime_s );
    fprintf( 'dt_s          = %12.4e\n', dt_s   );
    fprintf( 'kB            = %10d\n',   kB   );
    fprintf( 'kEnd          = %10d\n',   kEnd );
    fprintf( 'nSamps        = %10d\n',   nSamps );
    fprintf( '\n' );

%% Output Table heading
    % oTabOrder:   Freq  Lxi   Lxq   Lyi   Lyq   Ex    Px    Ey    Py    Pe    Mex   Mey
    oTabFormat  = "%8.2f %8.5f %8.5f %8.5f %8.5f %8.4f %8.3f %8.4f %8.3f %8.3f %8.4f %8.4f\n";
    oTabHeading = "FreqR_Hz   Lxi_mm   Lxq_mm   Lyi_mm   Lyq_mm    Ex_mm   Px_deg    Ey_mm   Py_deg   Pe_deg Meanx_mm Meany_mm";
    %                805.00 -0.24257  0.30519 -0.26231 -0.31579   0.7797  128.478   0.8210 -129.714 -258.192  -0.0971   0.3758

    fprintf(          "%s\n", oTabHeading );
    fprintf( oFileID, "%s\n", oTabHeading );

%% Sweep Frequency
    % resonance center is ~805 Hz

    FreqCenter_Hz = 805;
    FreqStep_Hz   = 0.5;

    SetNums     = [ 1:21 ];

    SaveSetNums = zeros( 1, length( SetNums ) );	% logical row vector

%    SaveSetNums( [2,3] ) = 1;		% save only these sets
    SaveSetNums(10) = 1;
    SaveSetNums(13) = 1;
    SaveSetNums(7) = 1;

    for jSetNum = SetNums	% foreach integer in range i.e. [-10:+10]
	fprintf( 'jSetNum       = %10d\n',   jSetNum );

	FreqR_Hz = FreqCenter_Hz + (FreqStep_Hz * (jSetNum - 10));

    % Single axis sine wave
	fprintf( 'FreqR_Hz      = %10.3f\n', FreqR_Hz );

	wR = 2 * Pi * FreqR_Hz;		% angular frequency

	sineVecR = OutAmp_V * sin( wR * tVec_s );	% row vector

	AngleR_deg = 0;			% angle from +X axis, integer

	AngleR_rad = AngleR_deg * Pi / 180;

	AngleR_str = sprintf( "%03d", AngleR_deg );

    % rotate axis of applied sine wave
	outVecX = cos( AngleR_rad ) * sineVecR;		% row vector
	outVecY = sin( AngleR_rad ) * sineVecR;

	outScanData = [transpose( outVecX ), transpose( outVecY )];
		% transpose into column vectors, then concatenate rows

    % drive DAQ outputs, read inputs
	inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

    % save only sample sets
	if ( SaveSetNums(jSetNum) )

	    ofile = PreFix + "_set_" + jSetNum + "_daq.txt";
	    fprintf( 'outFile:  %s\n', ofile );
	    save( ofile, 'inScanData', '-ascii' );

	    ofile = PreFix + "_set_" + jSetNum + "_sine.txt";
	    fprintf( 'outFile:  %s\n', ofile );
	    sineColR = transpose( sineVecR );
	    save( ofile, 'sineColR', '-ascii' );
		% A saved row vector has space separated values.
	    %#!! perhaps combine in one file
	end

    % extract stable portion of data trace
	Vsum_V = transpose( inScanData(kB:kEnd,2) );
	Vx_V   = transpose( inScanData(kB:kEnd,3) );
	Vy_V   = transpose( inScanData(kB:kEnd,4) );
		    % row vectors

    % compute PSD position for X and Y measurements (row vectors)
	Dx_mm = 5 * (Vx_V ./ Vsum_V);
	Dy_mm = 5 * (Vy_V ./ Vsum_V);

    % mean values for reference
	Meanx_mm = mean( Dx_mm );
	Meany_mm = mean( Dy_mm );

    % Reference sine waves, wrt original t=0
	RIvec = sin( wR * tVec_s[kB:kEnd] );	% in-phase   reference
	RQvec = cos( wR * tVec_s[kB:kEnd] );	% quadrature reference
		    % row vectors

    % compute quadrature lockin result (row vector element-wise product)
	Lxi_mm = mean( Dx_mm .* RIvec );
	Lxq_mm = mean( Dx_mm .* RQvec );

	Lyi_mm = mean( Dy_mm .* RIvec );
	Lyq_mm = mean( Dy_mm .* RQvec );

    % compute amplitude and phase relative to +X axis (the ellipse extent)
	Ex_mm  = 2 * sqrt( Lxi_mm^2 + Lxq_mm^2 );
	Px_rad = atan2( Lxq_mm, Lxi_mm );
	Px_deg = Px_rad * 180 / Pi;

	Ey_mm  = 2 * sqrt( Lyi_mm^2 + Lyq_mm^2 );
	Py_rad = atan2( Lyq_mm, Lyi_mm );
	Py_deg = Py_rad * 180 / Pi;

    % Compute ellipse phase, as in
	    % x = Ex * sin( u )
	    % y = Ey * sin( u + Pe )
	Pe_rad = Py_rad - Px_rad;
	Pe_deg = Pe_rad * 180 / Pi;

    % output results
	% oTabOrder:   Freq  Lxi   Lxq   Lyi   Lyq   Ex    Px    Ey    Py    Pe    Mex   Mey

	fprintf(          oTabFormat, ...
	    FreqR_Hz, ...
	    Lxi_mm, Lxq_mm, ...
	    Lyi_mm, Lyq_mm, ...
	    Ex_mm,  Px_deg, ...
	    Ey_mm,  Py_deg, ...
	    Pe_deg, ...
	    Meanx_mm, Meany_mm ...
	);

	fprintf( oFileID, oTabFormat, ...
	    FreqR_Hz, ...
	    Lxi_mm, Lxq_mm, ...
	    Lyi_mm, Lyq_mm, ...
	    Ex_mm,  Px_deg, ...
	    Ey_mm,  Py_deg, ...
	    Pe_deg, ...
	    Meanx_mm, Meany_mm ...
	);

    % wait for fiber resonance to decay
	fprintf( 'sleep(%3.1f)\n', Twait_s );
	pause( Twait_s );

    end		% for loop

    fclose( oFileID );

