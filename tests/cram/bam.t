Set up 
  $ . $TESTDIR/setup.sh

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


