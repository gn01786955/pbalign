Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with space in file names.
  $ FA=$DATDIR/dir\ with\ spaces/reads.fasta 
  $ pbalign "$FA" "$FA" $OUTDIR/with_space.sam >/dev/null
  $ echo $?
  0

