Set up 
  $ . $TESTDIR/setup.sh

#Test pbalign with dataset in and out
  $ D=$TESTDATASETS/lambda/2372215/0007_tiny/m150404_101626_42267_c100807920800000001823174110291514_s1_p0.hdfsubread.xml
  $ T=$REFDIR/lambda/reference.dataset.xml
  $ O=$OUTDIR/tiny_bam.bam
  $ rm -f $O
  $ pbalign $D $T $O 2>/dev/null && echo $?
  0

Try feeding an aligned bam back in...
  $ RA=$OUTDIR/tiny_bam_realigned.bam
  $ pbalign $O $T $RA 2>/dev/null
  0

Call samtools index to check whether out.bam is sorted or not and coverage is sufficient and basic mapped stats
  $ samtools index $O $TMP1.bai && ls $TMP1.bai >/dev/null && echo $?
  0
  $ samtools depth $O | awk '{sum+=$3} END {print sum}' | python -c "print 131996349/48502"
  2721
  $ samtools flagstat $O
  18696 + 0 in total (QC-passed reads + QC-failed reads)
  0 + 0 duplicates
  18696 + 0 mapped (100.00%:-nan%)
  0 + 0 paired in sequencing
  0 + 0 read1
  0 + 0 read2
  0 + 0 properly paired (-nan%:-nan%)
  0 + 0 with itself and mate mapped
  0 + 0 singletons (-nan%:-nan%)
  0 + 0 with mate mapped to a different chr
  0 + 0 with mate mapped to a different chr (mapQ>=5)


