
import unittest
import tempfile
import shutil
from os import path

from pbalign.pbalignrunner import PBAlignRunner

from test_setpath import ROOT_DIR, DATA_DIR

class Test_PBAlignRunner(unittest.TestCase):
    def setUp(self):
        self.rootDir = ROOT_DIR
        self.queryFile = path.join(self.rootDir, "data/subreads_dataset1.xml")
        self.referenceFile = path.join(self.rootDir, "data/reference_lambda.xml")
        self.configFile = path.join(self.rootDir, "data/1.config")
        self.OUT_DIR = tempfile.mkdtemp()
        self.bamOut = path.join(self.OUT_DIR, "lambda_out.bam")

    def tearDown(self):
        shutil.rmtree(self.OUT_DIR)

    def test_init(self):
        """Test PBAlignRunner.__init__()."""
        argumentList = ['--minAccuracy', '70', '--maxDivergence', '30',
                        self.queryFile, self.referenceFile,
                        self.bamOut]
        pbobj = PBAlignRunner(argumentList = argumentList)
        self.assertEqual(pbobj.start(), 0)

    def test_init_with_algorithmOptions(self):
        """Test PBAlignRunner.__init__() with --algorithmOptions."""
        argumentList = ['--algorithmOptions', '--minMatch 10 --useccsall',
                        self.queryFile, self.referenceFile,
                        self.bamOut]
        pbobj = PBAlignRunner(argumentList = argumentList)
        self.assertEqual(pbobj.start(), 0)

    def test_init_with_config_algorithmOptions(self):
        """Test PBAlignRunner.__init__() with a config file and --algorithmOptions."""
        argumentList = ['--algorithmOptions', '--maxMatch 20 --nCandidates 30',
                        '--configFile', self.configFile,
                        self.queryFile, self.referenceFile,
                        self.bamOut]

        pbobj = PBAlignRunner(argumentList = argumentList)
        self.assertEqual(pbobj.start(), 0)

    def test_init_expect_conflicting_options(self):
        """Test PBAlignRunner.__init__() with a config file and --algorithmOptions
        and expect a ValueError for conflicting options."""
        argumentList = ['--algorithmOptions', '--minMatch 10 --useccsall',
                        '--configFile', self.configFile,
                        self.queryFile, self.referenceFile,
                        self.bamOut]
        pbobj = PBAlignRunner(argumentList = argumentList)
        with self.assertRaises(ValueError) as cm:
            # Expect a ValueError since --minMatch and --minAnchorSize conflicts.
            pbobj.start()


if __name__ == "__main__":
    unittest.main()
