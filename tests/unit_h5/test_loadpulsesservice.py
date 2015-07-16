"""Test pbalign.forquiverservice.loadpulses."""
import unittest
from os import path, remove
from shutil import copyfile
from pbalign.forquiverservice.loadpulses import LoadPulsesService
from argparse import Namespace
from tempfile import mkstemp
from test_setpath import ROOT_DIR, DATA_DIR


class Test_LoadPulsesService(unittest.TestCase):
    """Test pbalign.forquiverservice.loadpulses."""
    def setUp(self):
        """Set up tests."""
        self.inCmpFile = path.join(DATA_DIR, "testloadpulses.cmp.h5")
        self.outCmpFile = mkstemp(suffix=".cmp.h5")[1]

        self.basFile = path.join(ROOT_DIR, "data/lambda_bax.fofn")
        copyfile(self.inCmpFile, self.outCmpFile)
        self.options = Namespace(metrics="DeletionQV", byread=False)
        self.obj = LoadPulsesService(self.basFile,
                self.outCmpFile, self.options)

    def tearDown(self):
        remove(self.outCmpFile)

    def test_run(self):
        """Test LoadPulsesService.__init__()."""
        _output, errCode, _errMsg = self.obj.run()
        self.assertEqual(errCode, 0)

if __name__ == "__main__":
    unittest.main()
