Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with bam in bam out
  $ Q=/pbi/dept/secondary/siv/testdata/pbalign-unittest/data/all4mer-ccs/tiny_ccs.bam
  $ T=/pbi/dept/secondary/siv/testdata/pbalign-unittest/data/all4mer-ccs/all4mer_v2_30_1.fasta
  $ O=$OUTDIR/tiny_ccs.bam
  $ pbalign $Q $T $O >/dev/null

#Call samtools index to check whether out.bam is sorted or not
  $ samtools index $O $TMP1.bai && ls $TMP1.bai >/dev/null && echo $?
  0

  $ samtools view $O |wc -l
  8
