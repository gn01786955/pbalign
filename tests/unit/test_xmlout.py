
import unittest
from os import path
from pbalign.pbalignrunner import PBAlignRunner
from test_setpath import ROOT_DIR, OUT_DIR
from pbcore.io import AlignmentSet, ReferenceSet

class Test_PBAlignRunner(unittest.TestCase):
    def setUp(self):
        self.rootDir = ROOT_DIR
        self.queryFile = path.join(self.rootDir, "data/subreads_dataset1.xml")
        self.referenceFile = path.join(self.rootDir, "data/reference_lambda.xml")
        self.configFile = path.join(self.rootDir, "data/1.config")
        self.bamOut = path.join(OUT_DIR, "lambda_out.bam")
        self.xmlOut = path.join(OUT_DIR, "lambda_out.xml")

    def test_init_xml(self):
        """Test PBAlignRunner.__init__() to XML."""
        argumentList = ['--minAccuracy', '70', '--maxDivergence', '30',
                        self.queryFile, self.referenceFile,
                        self.xmlOut]
        pbobj = PBAlignRunner(argumentList=argumentList)
        self.assertEqual(pbobj.start(), 0)
        aln = AlignmentSet(self.xmlOut)
        self.assertEqual(aln.externalResources[0].reference,
                         ReferenceSet(self.referenceFile).toExternalFiles()[0])

if __name__ == "__main__":
    unittest.main()
