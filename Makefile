####################################################################
#  SLICOT main makefile                                            #
#  Top Level Makefile for generating SLICOT Library object file.   #
#  SLICOT, Release 4.0                          ./slicot/makefile  #
#  October 31, 1996                                                #
#  Revised December 7, 1999                                        #
####################################################################
#
#  This makefile creates/updates the SLICOT Library object file, and
#  compiles, links, and runs the example programs for the SLICOT 
#  Library. To perform all these actions, enter
#       make
#
#  To create/update the library for SLICOT, enter 
#       make lib
#
#  To compile, link, and run the example programs, enter 
#       make example
#
#  To remove the object files for SLICOT routines, enter
#       make cleanlib
#
#  To remove the files with the computed results, enter
#       make cleanexample
#
####################################################################

include make.inc

all: lib example

clean: cleanlib cleanexample

lib:
	( cd src; $(MAKE) )

example:
	( cd examples; $(MAKE) )

cleanlib:
	( cd src; $(MAKE) clean )

cleanexample:
	( cd examples; $(MAKE) clean )
