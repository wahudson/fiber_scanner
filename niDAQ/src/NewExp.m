%% 2024-08-30  William A. Hudson
%
% Bootstrap Matlab into a new experiment directory.
%    Make new directory  ../exYYYY_MM_DD_name
%    Copy in rcm_uno.m  from current directory.
%    Change to directory.
%
% Caution!  Assume Matlab is already in an experiment directory.
%
% Git:  https://github.com/wahudson/fiber_scanner/niDAQ/src

%% Parameters, user edit:

    ExpName = "galvo";		% experiment suffix name

%% Automation

    date = datetime( 'now' );
    date.Format = 'yyyy_MM_dd';
    datestr = sprintf( "%s", date );

    expDir = strcat( "../ex" , datestr , "_" , ExpName , "/" );

    fprintf( "New Directory:  %s\n", expDir );

    mkdir( expDir );
	% Warning if dir exists.

    copyfile( "rcm_uno.m", expDir );
    copyfile( "NewExp.m",  expDir );

    cd( expDir );

    clear all;			% remove all vars from workspace

    fprintf( "Please:  Close all tabs in Matlab script window.\n" );
    fprintf( "    Open scripts in the new directory.\n" );

    %open( "./rcm_uno.m" );

