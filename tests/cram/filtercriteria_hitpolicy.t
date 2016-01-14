Set up 
  $ . $TESTDIR/setup.sh

##Test --maxDivergence --minAnchorSize --minAccuracy 
#  $ Q=$DATDIR/lambda_query.fasta
#  $ T="/pbi/dept/secondary/siv/references/lambda/sequence/lambda.fasta"
#
#  $ NAME=lambda5
#  $ SAMOUT=$OUTDIR/$NAME.sam
#  $ M4OUT=$OUTDIR/$NAME.m4
#  $ M4STDOUT=$STDSIVDIR/$NAME.m4
#
#  $ rm -f $SAMOUT $M4OUT
#  $ pbalign --maxDivergence 40 --minAnchorSize 20 --minAccuracy 80 $Q $T $SAMOUT 2>/dev/null
#  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
#  $ diff $M4OUT $M4STDOUT
#
##Test whether pbalign interprets minAccuracy and maxDivergence correclty.
#  $ rm -f $SAMOUT $M4OUT
#  $ pbalign --maxDivergence 0.4 --minAnchorSize 20 --minAccuracy 0.8 $Q $T $SAMOUT 2>/dev/null 
#  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
#  $ diff $M4OUT $M4STDOUT
#
##Test --hitPolicy  random
#  $ NAME=lambda_hitPolicy_random
#  $ SAMOUT=$OUTDIR/$NAME.sam
#  $ M4OUT=$OUTDIR/$NAME.m4
#  $ M4STDOUT=$STDSIVDIR/$NAME.m4
#
#  $ rm -f $SAMOUT $M4OUT
#  $ pbalign --hitPolicy random --seed 1 $Q $T $SAMOUT 2>/dev/null
#  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
#  $ diff $M4OUT $M4STDOUT
#
##Test --hitPolicy  all
#  $ NAME=lambda_hitPolicy_all
#  $ SAMOUT=$OUTDIR/$NAME.sam
#  $ M4OUT=$OUTDIR/$NAME.m4
#  $ M4STDOUT=$STDSIVDIR/$NAME.m4
#
#  $ rm -f $SAMOUT $M4OUT
#  $ pbalign --hitPolicy all $Q $T $SAMOUT 2>/dev/null
#  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
#  $ diff $M4OUT $M4STDOUT
#
#
##Test --hitPolicy  randombest
#  $ NAME=lambda_hitPolicy_randombest
#  $ SAMOUT=$OUTDIR/$NAME.sam
#  $ M4OUT=$OUTDIR/$NAME.m4
#  $ M4STDOUT=$STDSIVDIR/$NAME.m4
#
#  $ rm -f $SAMOUT $M4OUT
#  $ pbalign  --hitPolicy randombest --seed 1 $Q $T $SAMOUT 2>/dev/null
#  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
#  $ diff $M4OUT $M4STDOUT

#Test --hitPolicy  allbest
  $ Q=$DATDIR/example_read.fasta
  $ T=$DATDIR/example_ref.fasta
  $ SAMOUT=$OUTDIR/hitPolicy_allbest.sam

  $ rm -f $SAMOUT
  $ pbalign --hitPolicy allbest $Q $T $SAMOUT >/dev/null



#Test pbalign with -hitPolicy leftmost
  $ Q=$DATDIR/test_leftmost_query.fasta
  $ T=$DATDIR/test_leftmost_target.fasta
  $ O=$OUTDIR/test_leftmost_out.sam 
  $ pbalign $Q $T $O --hitPolicy leftmost >/dev/null
  $ echo $?
  0
  $ grep -v '@' $O | cut -f 4 
  1


