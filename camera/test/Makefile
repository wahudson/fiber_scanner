# 2022-01-19  William A. Hudson

# Run all test suites.

PATH = /usr/bin:/bin

SHELL = /bin/sh

test:
	cd src                && make
	cd t_gmBox            && make test
	cd t_gmGeoSpec        && make test
	cd t_gmNetpgm         && make test
	cd t_gmStats          && make test
	cd t_pgm_box          && make test
	cd t_pgm_stats        && make test
	cd t_pgm_swatch       && make test
	cd t_pgm_width        && make test

clean:
	cd t_gmBox            && make clean
	cd t_gmGeoSpec        && make clean
	cd t_gmNetpgm         && make clean
	cd t_gmStats          && make clean
	cd t_pgm_box          && make clean
	cd t_pgm_stats        && make clean
	cd t_pgm_swatch       && make clean
	cd t_pgm_width        && make clean

