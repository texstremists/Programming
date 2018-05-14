# Makefile for mex files.
#
# Example:
#
#    make MATLABDIR=/usr/local/MATLAB/R2015b/
#
MATLABDIR   ?= /usr/local/matlab
MEX         ?= $(MATLABDIR)/bin/mex
MEXEXT      ?= $(shell $(MATLABDIR)/bin/mexext)
RM          ?= rm
SOURCES     := $(wildcard *.cc)
TARGETS     := $(SOURCES:.cc=.$(MEXEXT))

all: $(TARGETS)

%.$(MEXEXT): %.cc
	$(MEX) $<

clean:
	$(RM) -rf *.$(MEXEXT)
