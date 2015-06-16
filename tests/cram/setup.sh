#!/usr/bin/bash

#Note:
#Program name has been changed from `pbalign.py` in version 0.1.0 
#to `pbalign` in 0.2.0, pseudo namespace pbtools has been removed also.

CURDIR=$TESTDIR
DATDIR=$CURDIR/../data
OUTDIR=$CURDIR/../out
STDDIR=$CURDIR/../stdout
SIVDIR=/mnt/secondary-siv/testdata/pbalign-unittest
DATSIVDIR=$SIVDIR/data/
STDSIVDIR=$SIVDIR/stdout/

TMP1=$$.tmp.out
TMP2=$$.tmp.stdout
SAMTOM4=samtom4
CMPH5TOOLS="/mnt/secondary/Smrtpipe/builds/Internal_Mainline_Nightly_LastSuccessfulBuild/smrtcmds/bin/smrtwrap cmph5tools.py "

