Note:
Program name has been changed from `pbalign.py` in version 0.1.0 
to `pbalign` in 0.2.0, pseudo namespace pbtools has been removed also.

Test pbalign
  $ CURDIR=$TESTDIR
  $ DATDIR=$CURDIR/../data
  $ OUTDIR=$CURDIR/../out
  $ STDDIR=$CURDIR/../stdout
  $ STDSIVDIR=/mnt/secondary-siv/testdata/pbalign-unittest/stdout/

  $ TMP1=$$.tmp.out
  $ TMP2=$$.tmp.stdout
  $ SAMTOM4=samtom4

#Test pbalign with all combinations of input & output formats
#input, reference and output formats are: fasta, fasta, and sam/cmp.h5
  $ Q=$DATDIR/lambda_query.fasta
  $ T="/mnt/secondary-siv/references/lambda/sequence/lambda.fasta"

  $ NAME=lambda
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ CMPOUT=$OUTDIR/$NAME.cmp.h5
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $CMPOUT $M4OUT
  $ pbalign $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

  $ pbalign $Q $T $CMPOUT 2>/dev/null
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "m120619_015854_42161_c100392070070000001523040811021231_s1_p0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 48428 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 34, 136, 17, 17, 34, 17, 136, 136, 136, 17, 136, 34, 136, 68,
           (14): 128, 34, 17, 136, 34, 17, 136, 17, 2, 34, 136, 136, 34, 34,
           (28): 68, 17, 68, 34, 17, 136, 136, 136, 17, 136, 136, 1, 17, 68,
           (42): 34, 17, 136, 136, 136, 34, 68, 34, 136, 17, 136, 17, 17, 68,
  $ rm tmpfile
 
#input, reference and output formats are: fasta, folder and sam/cmp.h5
  $ Q=$DATDIR/lambda_query.fasta
  $ T=/mnt/secondary-siv/references/lambda/

  $ NAME=lambda2
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ CMPOUT=$OUTDIR/$NAME.cmp.h5
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $CMPOUT $M4OUT
  $ pbalign $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T/sequence/lambda.fasta $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

  $ pbalign $Q $T $CMPOUT 2>/dev/null
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "m120619_015854_42161_c100392070070000001523040811021231_s1_p0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 48428 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 34, 136, 17, 17, 34, 17, 136, 136, 136, 17, 136, 34, 136, 68,
           (14): 128, 34, 17, 136, 34, 17, 136, 17, 2, 34, 136, 136, 34, 34,
           (28): 68, 17, 68, 34, 17, 136, 136, 136, 17, 136, 136, 1, 17, 68,
           (42): 34, 17, 136, 136, 136, 34, 68, 34, 136, 17, 136, 17, 17, 68,
  $ rm -f tmpfile


#input, reference and output formats are: fofn, fasta and sam/cmp.h5
  $ Q=$DATDIR/lambda_bax.fofn
  $ T="/mnt/secondary-siv/references/lambda/sequence/lambda.fasta"

  $ NAME=lambda3
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ CMPOUT=$OUTDIR/$NAME.cmp.h5
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $CMPOUT $M4OUT
  $ pbalign $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

  $ pbalign $Q $T $CMPOUT 2>/dev/null
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "m130220_114643_42129_c100471902550000001823071906131347_s1_p0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 79904 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 136, 34, 136, 34, 136, 68, 34, 68, 68, 68, 17, 68, 136, 68,
           (14): 136, 2, 34, 68, 68, 68, 17, 17, 136, 17, 17, 136, 136, 1, 17,
           (29): 17, 17, 34, 68, 17, 136, 68, 2, 17, 34, 17, 34, 17, 68, 68,
           (44): 68, 8, 136, 136, 17, 68, 34, 68, 34, 68, 136, 17, 2, 17, 130,
  $ rm -f tmpfile


#input, reference and output formats are: fofn, folder and sam/cmp.h5
  $ Q=$DATDIR/lambda_bax.fofn
  $ T=/mnt/secondary-siv/references/lambda/

  $ NAME=lambda4
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ CMPOUT=$OUTDIR/$NAME.cmp.h5
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $CMPOUT $M4OUT
  $ pbalign $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T/sequence/lambda.fasta $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

  $ pbalign $Q $T $CMPOUT 2>/dev/null
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "m130220_114643_42129_c100471902550000001823071906131347_s1_p0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 79904 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 136, 34, 136, 34, 136, 68, 34, 68, 68, 68, 17, 68, 136, 68,
           (14): 136, 2, 34, 68, 68, 68, 17, 17, 136, 17, 17, 136, 136, 1, 17,
           (29): 17, 17, 34, 68, 17, 136, 68, 2, 17, 34, 17, 34, 17, 68, 68,
           (44): 68, 8, 136, 136, 17, 68, 34, 68, 34, 68, 136, 17, 2, 17, 130,
  $ rm tmpfile
 

#Test --maxDivergence --minAnchorSize --minAccuracy 
  $ Q=$DATDIR/lambda_query.fasta
  $ T="/mnt/secondary-siv/references/lambda/sequence/lambda.fasta"

  $ NAME=lambda5
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $M4OUT
  $ pbalign --maxDivergence 40 --minAnchorSize 20 --minAccuracy 80 $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

#Test whether pbalign interprets minAccuracy and maxDivergence correclty.
  $ rm -f $SAMOUT $M4OUT
  $ pbalign --maxDivergence 0.4 --minAnchorSize 20 --minAccuracy 0.8 $Q $T $SAMOUT 2>/dev/null 
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

#Test --hitPolicy  random
  $ NAME=lambda_hitPolicy_random
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $M4OUT
  $ pbalign --hitPolicy random --seed 1 $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

#Test --hitPolicy  all
  $ NAME=lambda_hitPolicy_all
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $M4OUT
  $ pbalign --hitPolicy all $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT


#Test --hitPolicy  randombest
  $ NAME=lambda_hitPolicy_randombest
  $ SAMOUT=$OUTDIR/$NAME.sam
  $ M4OUT=$OUTDIR/$NAME.m4
  $ M4STDOUT=$STDSIVDIR/$NAME.m4

  $ rm -f $SAMOUT $M4OUT
  $ pbalign  --hitPolicy randombest --seed 1 $Q $T $SAMOUT 2>/dev/null
  $ $SAMTOM4 $SAMOUT $T $TMP1 && sort $TMP1 > $M4OUT && rm $TMP1
  $ diff $M4OUT $M4STDOUT

#Test --hitPolicy  allbest
  $ Q=$DATDIR/example_read.fasta
  $ T=$DATDIR/example_ref.fasta
  $ SAMOUT=$OUTDIR/hitPolicy_allbest.sam

  $ rm -f $SAMOUT
  $ pbalign --hitPolicy allbest $Q $T $SAMOUT 2>/dev/null

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

  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /AlnGroup  /AlnGroup
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /AlnInfo   /AlnInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /MovieInfo /MovieInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /RefInfo   /RefInfo
  $ h5diff $CCS_CMPOUT $BAS_CMPOUT /ref000001 /ref000001


#Test pbalign with -filterAdapterOnly
  $ Q=$DATDIR/test_filterAdapterOnly.fofn
  $ T=/mnt/secondary-siv/testdata/pbalign-unittest/data/references/H1_6_Scal_6x/
  $ O=$OUTDIR/test_filterAdapterOnly.sam
  $ rm -f $O
  $ pbalign $Q $T $O --filterAdapterOnly --algorithmOptions=" -holeNumbers 10817,14760" --seed=1 2>/dev/null
  $ tail -n+6 $O | cut -f 1-4

# Test pbalign with --pulseFile
# This is an experimental option which goes only with gmap,
# it enables users to bypass the pls2fasta step and use their own fasta 
# file instead, while keep the ability of generating cmp.h5 files with pulses 
# (i.e., --forQuiver).
  $ O=$OUTDIR/test_pulseFile.cmp.h5
  $ T=/mnt/secondary-siv/references/Ecoli_K12_DH10B/
  $ T=/mnt/secondary-siv/references/Ecoli_K12_DH10B/sequence/Ecoli_K12_DH10B.fasta
  $ pbalign $DATDIR/test_pulseFile.fasta $T $O --pulseFile $DATDIR/test_pulseFile.fofn --forQuiver --algorithm gmap --byread 2>/dev/null
  $ echo $?
  0

  $ O=$OUTDIR/test_pulseFile.cmp.h5
  $ T=/mnt/secondary-siv/references/Ecoli_K12_DH10B/
  $ T=/mnt/secondary-siv/references/Ecoli_K12_DH10B/sequence/Ecoli_K12_DH10B.fasta
  $ rm -f $O
  $ pbalign $DATDIR/test_pulseFile.fasta $T $O --pulseFile $DATDIR/test_pulseFile.fofn --forQuiver --algorithm blasr --byread 2>/dev/null
  $ echo $?
  0

#Test pbalign with space in file names.
  $ FA=$DATDIR/dir\ with\ spaces/reads.fasta 
  $ pbalign "$FA" "$FA" $OUTDIR/with_space.sam 2>/dev/null
  $ echo $?
  0

#Test pbalign with -hitPolicy leftmost
  $ Q=$DATDIR/test_leftmost_query.fasta
  $ T=$DATDIR/test_leftmost_target.fasta
  $ O=$OUTDIR/test_leftmost_out.sam 
  $ pbalign $Q $T $O --hitPolicy leftmost 2>/dev/null
  $ echo $?
  0
  $ tail -n+6 $O | cut -f 4 
  1

#Test pbalign with bam in bam out
  $ Q=/mnt/secondary-siv/testdata/pbalign-unittest/data/test_bam/tiny_bam.fofn
  $ T=/mnt/secondary-siv/references/lambda/sequence/lambda.fasta
  $ O=$OUTDIR/tiny_bam.bam
  $ rm -f $O
  $ pbalign $Q $T $O 2>/dev/null
  $ echo $?
  0
#Call samtools index to check whether out.bam is sorted or not
  $ samtools index $O $TMP1.bai && ls $TMP1.bai >/dev/null && echo $?
  0

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

