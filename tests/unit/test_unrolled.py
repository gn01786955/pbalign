
"""
Test unrolled alignment support for SubreadSet input.  The output should be
identical to the same command using pseudo-polymerase reads reconstructed by
bam2bam as input.
"""

import subprocess
import tempfile
import unittest
import os.path as op

from pbcore.io import AlignmentSet

DATA = "/pbi/dept/secondary/siv/testdata/pbalign-unittest/data/unrolled"
REFERENCE = "/mnt/secondary/iSmrtanalysis/install/smrtanalysis_2.4.0.140820/common/references/All4mer_V2_11_V2_13_V2_15_V2_44_circular_72x_l50256/sequence/All4mer_V2_11_V2_13_V2_15_V2_44_circular_72x_l50256.fasta"
BASE_ARGS = [
    "pbalign",
    "--nproc", "8",
    "--hitPolicy=leftmost",
    "--algorithmOptions", "-bestn 1 -forwardOnly -fastMaxInterval -maxAnchorsPerPosition 30000 -ignoreHQRegions -minPctIdentity 60",
]

@unittest.skipUnless(op.isdir(DATA) and op.isfile(REFERENCE),
                     "missing {d} or {r}".format(r=REFERENCE, d=DATA))
class TestUnrolledBAM(unittest.TestCase):

    def _run_args(self, args, aln_file):
        self.assertEqual(subprocess.call(args), 0)
        with AlignmentSet(aln_file) as ds:
            self.assertEqual(len(ds), 1)
            bam = ds.resourceReaders()[0]
            qlen = bam[0].qEnd - bam[0].qStart
            alen = bam[0].aEnd - bam[0].aStart
            # length of unrolled polymerase read (unaligned)
            self.assertEqual(qlen, 22395)
            self.assertTrue(alen > 21000,
                            "alignment length is only {l}".format(l=alen))

    def test_polymerase_bam(self):
        aln_file = tempfile.NamedTemporaryFile(suffix=".polymerase.bam").name
        args = BASE_ARGS + [
            op.join(DATA, "m54006_151021_185942.polymerase.bam"),
            REFERENCE,
            aln_file,
        ]
        self._run_args(args, aln_file)

    def test_subreadset(self):
        aln_file = tempfile.NamedTemporaryFile(suffix=".unrolled.bam").name
        args = BASE_ARGS + [
            "--noSplitSubreads",
            op.join(DATA, "m54006_151021_185942.subreadset.xml"),
            REFERENCE,
            aln_file,
        ]
        self._run_args(args, aln_file)


if __name__ == "__main__":
    unittest.main()
