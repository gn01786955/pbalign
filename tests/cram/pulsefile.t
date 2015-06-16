Set up 
  $ . $TESTDIR/setup.sh

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

