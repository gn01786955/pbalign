Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with xml in bam out
  $ Q=$DATDIR/subread_dataset1.xml
  $ T=$DATDIR/reference_lambda.xml
  $ O=$OUTDIR/xml_in_bam_out.bam
  $ rm -f $O
  $ pbalign $Q $T $O --algorithmOptions=" -holeNumbers 1-2000" 2>/dev/null
  $ echo $?
  0

#Test pbalign with xml in xml out
  $ Q=$DATDIR/subread_dataset1.xml
  $ T=$DATDIR/reference_lambda.xml
  $ O=$OUTDIR/xml_in_xml_out.xml
  $ rm -f $O
  $ pbalign $Q $T $O --algorithmOptions=" -holeNumbers 1-2000" 2>/dev/null
  $ echo $?
  0

