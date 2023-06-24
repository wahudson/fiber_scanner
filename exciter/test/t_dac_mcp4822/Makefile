# 2018-04-30  William A. Hudson

# Makefile:  Run test suite.


#	Device Under Test (DUT) location, from tmp/
BIN = $(PWD)/../bin

PATH = /usr/bin:/bin:$(BIN)

SHELL = /bin/sh


test:
	rm -rf tmp
	mkdir  tmp
	./test.pl

clean:
	rm -rf tmp

#	update golden reference
golden:
	mv  tmp/[0-9]*.check.*  ref/

less:
	head -10000 tmp/[0-9]*.check.*  | less -p '^==>'

