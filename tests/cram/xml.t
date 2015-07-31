Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with xml in bam out
  $ Q=$DATDIR/subreads_dataset1.xml
  $ T=$DATDIR/reference_lambda.xml
  $ O=$OUTDIR/xml_in_bam_out.bam
  $ rm -f $O
  $ pbalign $Q $T $O --algorithmOptions=" -holeNumbers 1-2000" >/dev/null 2>/dev/null
  $ echo $?
  0

#Test pbalign with xml in xml out
  $ Q=$DATDIR/subreads_dataset1.xml
  $ T=$DATDIR/reference_lambda.xml
  $ O=$OUTDIR/xml_in_xml_out.xml
  $ rm -f $O
  $ pbalign $Q $T $O --algorithmOptions=" -holeNumbers 1-2000" >/dev/null 2>/dev/null
  $ echo $?
  0

  $ ls $OUTDIR/xml_in_xml_out.bam.bai && echo $? # bam index exists
  *.bai (glob)
  0

  $ ls $OUTDIR/xml_in_xml_out.bam.pbi && echo $? # pbi index exists
  *.pbi (glob)
  0

#Test pbalign with up-to-dated xml inputs
  $ Q=$DATDIR/subreads_dataset2.xml
  $ T=$DATSIVDIR/ecoli.fasta
  $ O=$OUTDIR/xml_in_bam_out_2.bam
  $ rm -f $O
  $ pbalign $Q $T $O --algorithmOptions=" -holeNumbers 1-2000" >/dev/null 2>/dev/null
  $ echo $?
  0

