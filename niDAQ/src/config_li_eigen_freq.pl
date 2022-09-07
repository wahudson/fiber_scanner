#! /usr/bin/perl -w
# 2022-09-04  William A. Hudson

# Configure "eigen_freq.m" ouput file names for "li_eigen_freq" input.
# File names of form:
#       f1_f805_ang_060.txt
#                   ^^^ DrvAng_deg
#           ^^^ FreqR_Hz

# usage:  ls f1*.txt | config_li_eigen_freq.pl

# One-liner:
# ls raw/f1_f*_ang_*.txt |
#    perl -ne'chomp($_); m/_f(\d+)_ang_(\d+)/; print( "$_  $1  $2\n" )'

print( "   InFile          FreqR_Hz  DrvAng_deg\n" );

while ( <> )
{
    chomp($_);

    m/_f(\d+)_ang_(\d+)/;

    print( "$_  $1  $2\n" );
}

