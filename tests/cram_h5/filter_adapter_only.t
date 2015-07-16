Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with -filterAdapterOnly
  $ Q=$DATDIR/test_filterAdapterOnly.fofn
  $ T=/mnt/secondary-siv/testdata/pbalign-unittest/data/references/H1_6_Scal_6x/
  $ O=$OUTDIR/test_filterAdapterOnly.sam
  $ rm -f $O
  $ pbalign $Q $T $O --filterAdapterOnly --algorithmOptions=" -holeNumbers 10817,14760" --seed=1 2>/dev/null
  $ grep -v '@' $O | cut -f 1-4

