%% 2025-01-20  William A. Hudson
%#! Matlab
%
% Read commands on serial port.
% Initial exploration.

%% Serial Port

    serialportfind()

    sp = serialport( "COM3", 19200 );

    sp.Terminator
    sp.Timeout		% in seconds

    sp			% view properties

%% Main Loop

    while true
	cline = readline( sp );		% string without line terminator
	fprintf( 'cline=%s=\n', cline );

	strarray = split( [cline] );	% split on whitespace
	cmd = strarray(1);
	strarray

	cellarray = split( cline );	% split on whitespace
	cellcmd = cellarray{1};
	cellarray

	fprintf( 'cmd=%s=\n', cmd );

	switch  cmd		% no fall thru
	  case "echo"
		fprintf( 'do_echo\n' );
		writeline( sp, join( strarray(2:end) ) );
	  case "preview"
		fprintf( 'do_preview\n' );
	  case "image"
		ofile = strarray(2);
		fprintf( 'do_image:  =%s=\n', ofile );
	  case "done"
		fprintf( 'do_done\n' );
		break;
	  otherwise
		fprintf( 'unrecognized cmd:  %s\n', cmd );
	end

	writeline( sp, ">" );
    end

    fprintf( 'Done\n' );

