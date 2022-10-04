%% 2022-09-20  William A. Hudson
%#! Matlab
%
% Fiber scanner DAQ - DC Voltmeter for testing channels.

% Configuration in the code.
% Drive out zero volts, measure input channels, repeat loop.
%
% Try to use only row-vectors, since we want element-wise operations and
% NOT matrix results.

%% Parameters

    % PreFix = 'v1';		% output file set prefix

    nMeas      = 7;		% number of measurements

    Tbegin_s   = 0.2;		% settling time to begin analysis
    Tmeasure_s = 1.0;		% measurement analysis time
    Twait_s    = 0.0;		% wait time between points
    DatasetTime_s = Tbegin_s + Tmeasure_s;	% total data set duration

    Pi = 3.1415926535;

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

    chInSig.Range = [-10,10];
    chInSum.Range = [-10,10];
    chInX.Range   = [-5,5];
    chInY.Range   = [-5,5];
	% Range [-10,10] is the default.
	% Note a single-ended range [0,10] is not accepted.

    % DAQ sample rate
    dq.Rate   = 62500;		% set samples per second
    sampRate = dq.Rate;

%% Sample time vector

    % sample interval from DAQ sample rate
    dt_s = 1 / sampRate;

    nSamps = round( DatasetTime_s / dt_s );

    % vector of time values
    % tVec_s = [0:nSamps] * dt_s;		% row vector

    kB     = round( Tbegin_s / dt_s );	% index for begin stable
    kEnd   = nSamps;			% last element of measurement

    % output status
    fprintf( 'Tbegin_s      = %10.3f\n', Tbegin_s      );
    fprintf( 'Tmeasure_s    = %10.3f\n', Tmeasure_s    );
    fprintf( 'DatasetTime_s = %10.3f\n', DatasetTime_s );
    fprintf( 'dt_s          = %12.4e\n', dt_s   );
    fprintf( 'kB            = %10d\n',   kB     );
    fprintf( 'nSamps        = %10d\n',   nSamps );
    fprintf( '\n' );

% Drive output row vector
    outVecX = zeros( 1, nSamps );	% row vector
    outVecY = zeros( 1, nSamps );

    outScanData = [transpose( outVecX ), transpose( outVecY )];
	    % transpose into column vectors, then concatenate rows

%% Output Table heading
    oTabFormat  = "%4d %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f %8.5f\n";
    oTabHeading = " Num  SdSig_V  MnSig_V    SdX_V    MnX_V    SdY_V    MnY_V  SdSum_V  MnSum_V";
    %                 1  0.01049  2.57573  0.00113 -0.93703  0.00043  0.28489  0.00451  3.37882

    fprintf( "%s\n", oTabHeading );

%% Loop repeated measurement

    for jSetNum = [1:nMeas]	% foreach measurement integer

    % drive DAQ outputs, read inputs
	inScanData = readwrite( dq, outScanData, "OutputFormat","Matrix" );

    % extract measurement portion of data trace
	VSig_V = transpose( inScanData(kB:kEnd,1) );
	VSum_V = transpose( inScanData(kB:kEnd,2) );
	VX_V   = transpose( inScanData(kB:kEnd,3) );
	VY_V   = transpose( inScanData(kB:kEnd,4) );
		    % row vectors

    % voltage measurements
	MnSig_V = mean( VSig_V );
	MnSum_V = mean( VSum_V );
	MnX_V   = mean( VX_V );
	MnY_V   = mean( VY_V );

	SdSig_V = std( VSig_V );
	SdSum_V = std( VSum_V );
	SdX_V   = std( VX_V );
	SdY_V   = std( VY_V );

	% Note SD is the RMS AC amplitude, using 1/(N-1) instead of 1/N.
	% True RMS includes the DC offset (i.e. mean) value.
	% Matlab std() returning both SD and mean did not work (R2022a feature).

    % output results
	fprintf(          oTabFormat, ...
	    jSetNum, ...
	    SdSig_V, MnSig_V, ...
	    SdX_V,   MnX_V, ...
	    SdY_V,   MnY_V, ...
	    SdSum_V, MnSum_V ...
	);

    % peak detection
	% PkSum_Vpp = max( VSum_V ) - min( VSum_V );

    % wait between points for fiber resonance to decay
	if ( Twait_s > 0 )
	    pause( Twait_s );
	end

    end		% for loop

