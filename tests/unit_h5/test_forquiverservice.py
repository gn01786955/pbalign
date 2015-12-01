"""Test pbalign.forquiverservice.forquiver."""
import unittest
from os import path, remove
from shutil import copyfile
from pbalign.forquiverservice.forquiver import ForQuiverService
from pbalign.pbalignfiles import PBAlignFiles
from tempfile import mkstemp
from test_setpath import DATA_DIR

class Opt(object):
    """Simulate PBAlign options."""
    def __init__(self):
        """Option class."""
        self.verbosity = 2
        self.metrics = "DeletionQV, InsertionQV"
        self.byread = None


class Test_ForQuiverService(unittest.TestCase):
    """Test pbalign.forquiverservice.forquiver."""
    def setUp(self):
        self.inCmpFile = path.join(DATA_DIR, "testforquiver.cmp.h5")
        self.outCmpFile = mkstemp(suffix=".cmp.h5")[1]

        copyfile(self.inCmpFile, self.outCmpFile)
        self.basFile = path.join(DATA_DIR, "lambda_bax.fofn")

        refpath = "/pbi/dept/secondary/siv/references/lambda/"

        self.fileNames = PBAlignFiles()
        self.fileNames.SetInOutFiles(self.basFile, refpath,
                                     self.outCmpFile, None, None)
        self.options = Opt()
        self.obj = ForQuiverService(self.fileNames, self.options)

    def tearDown(self):
        remove(self.outCmpFile)

    def test_run(self):
        """Test ForQuiverService.__init__()."""
        self.obj.run()

if __name__ == "__main__":
    unittest.main()
