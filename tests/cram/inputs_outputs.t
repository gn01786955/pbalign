Set up 
  $ . $TESTDIR/setup.sh

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
  $ $CMPH5TOOLS sort $CMPOUT --deep --inPlace
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "rg1-0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 48428 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 34, 136, 68, 128, 136, 136, 136, 34, 136, 34, 34, 17, 68, 34,
           (14): 68, 34, 17, 68, 34, 17, 34, 34, 68, 136, 16, 17, 17, 136, 136,
           (29): 17, 34, 136, 68, 32, 136, 68, 17, 68, 34, 34, 17, 136, 34, 17,
           (44): 136, 68, 17, 34, 68, 34, 34, 68, 17, 136, 68, 68, 17, 68, 34,
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
  $ $CMPH5TOOLS sort $CMPOUT --deep --inPlace
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "rg1-0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 48428 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 34, 136, 68, 128, 136, 136, 136, 34, 136, 34, 34, 17, 68, 34,
           (14): 68, 34, 17, 68, 34, 17, 34, 34, 68, 136, 16, 17, 17, 136, 136,
           (29): 17, 34, 136, 68, 32, 136, 68, 17, 68, 34, 34, 17, 136, 34, 17,
           (44): 136, 68, 17, 34, 68, 34, 34, 68, 17, 136, 68, 68, 17, 68, 34,
  $ rm tmpfile


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
  $ $CMPH5TOOLS sort $CMPOUT --deep --inPlace
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "rg1-0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 79904 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 68, 68, 68, 34, 68, 68, 34, 68, 17, 34, 34, 136, 32, 34, 68,
           (15): 34, 68, 68, 68, 136, 136, 136, 136, 34, 68, 34, 128, 136, 17,
           (29): 136, 136, 136, 17, 136, 68, 17, 17, 17, 17, 128, 136, 136,
           (42): 136, 136, 34, 34, 68, 68, 128, 136, 136, 136, 16, 17, 17, 64,

  $ rm tmpfile

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
  $ $CMPH5TOOLS sort $CMPOUT --deep --inPlace
  $ h5dump -g /ref000001 $CMPOUT > tmpfile 
  $ sed -n '2,11p' tmpfile
  GROUP "/ref000001" {
     GROUP "rg1-0" {
        DATASET "AlnArray" {
           DATATYPE  H5T_STD_U8LE
           DATASPACE  SIMPLE { ( 79904 ) / ( H5S_UNLIMITED ) }
           DATA {
           (0): 68, 68, 68, 34, 68, 68, 34, 68, 17, 34, 34, 136, 32, 34, 68,
           (15): 34, 68, 68, 68, 136, 136, 136, 136, 34, 68, 34, 128, 136, 17,
           (29): 136, 136, 136, 17, 136, 68, 17, 17, 17, 17, 128, 136, 136,
           (42): 136, 136, 34, 34, 68, 68, 128, 136, 136, 136, 16, 17, 17, 64,

  $ rm tmpfile
