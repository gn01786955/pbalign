Set up 
  $ . $TESTDIR/setup.sh

#Test --useccs=useccsdenovo, whether attribute /ReadType is 'CCS'
  $ Q=$DATDIR/lambda_bax.fofn
  $ T="/mnt/secondary-siv/references/lambda/sequence/lambda.fasta"
  $ CMPOUT=$OUTDIR/lambda_denovo.cmp.h5

  $ rm -f $CMPOUT
  $ pbalign $Q $T $CMPOUT --useccs=useccsdenovo --algorithmOptions=" -holeNumbers 0-100" 2>/dev/null
  $ h5dump -a /ReadType $CMPOUT | grep "CCS"
     (0): "CCS"

#Test --forQuiver can not be used together with --useccs
  $ pbalign $Q $T $CMPOUT --useccs=useccsdenovo --algorithmOptions=" -holeNumbers 0-100" --forQuiver 1>/dev/null 2>/dev/null || echo 'fail as expected'
  fail as expected


#Test whether pbalign can produce sam output for non-PacBio reads
#  $ Q=$DATDIR/notSMRT.fasta
#  $ T="/mnt/secondary-siv/references/lambda/sequence/lambda.fasta"
#  $ SAMOUT=$OUTDIR/notSMRT.sam
#
#  $ rm -f $SAMOUT $CMPOUT
#  $ pbalign $Q $T $SAMOUT 2>/dev/null


# Test whether (ccs.h5) produces
# identical results as (bas.h5 and --useccs=useccsdenovo).
  $ Q=$DATDIR/test_ccs.fofn 
  $ T=/mnt/secondary-siv/references/ecoli_k12_MG1655/sequence/ecoli_k12_MG1655.fasta
  $ CCS_CMPOUT=$OUTDIR/test_ccs.cmp.h5

  $ rm -f $CCS_CMPOUT
  $ pbalign $Q $T $CCS_CMPOUT 2>/dev/null

  $ Q=$DATDIR/test_bas.fofn
  $ BAS_CMPOUT=$OUTDIR/test_bas.cmp.h5

  $ rm -f $BAS_CMPOUT
  $ pbalign $Q $T $BAS_CMPOUT --useccs=useccsdenovo 2>/dev/null
  $ /mnt/secondary/Smrtpipe/builds/Internal_Mainline_Nightly_LastSuccessfulBuild/smrtcmds/bin/smrtwrap cmph5tools.py sort $BAS_CMPOUT --deep --inPlace
  $ /mnt/secondary/Smrtpipe/builds/Internal_Mainline_Nightly_LastSuccessfulBuild/smrtcmds/bin/smrtwrap cmph5tools.py sort $CCS_CMPOUT --deep --inPlace

  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /AlnGroup  /AlnGroup
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /AlnInfo   /AlnInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /MovieInfo /MovieInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /RefInfo   /RefInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /ref000001 /ref000001


