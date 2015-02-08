"""Test pbalign.util/fileutil.py"""

import unittest
from os import path
from pbalign.utils.fileutil import getFileFormat, \
    isValidInputFormat, isValidOutputFormat, getFilesFromFOFN, \
    checkInputFile, checkOutputFile, checkReferencePath, \
    real_upath, real_ppath, isExist
import filecmp
from test_setpath import ROOT_DIR, OUT_DIR, DATA_DIR


class Test_fileutil(unittest.TestCase):
    """Test pbalign.util/fileutil.py"""
    def setUp(self):
        self.rootDir = ROOT_DIR
        self.outDir = OUT_DIR
        self.dataDir = path.join(DATA_DIR,
                                 "testLoadPulses/Analysis_Results/")

    def test_isValidInputFormat(self):
        """Test isValidInputFormat()."""
        self.assertTrue(isValidInputFormat( getFileFormat("ab.fasta")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.fa")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.pls.h5")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.plx.h5")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.bas.h5")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.bax.h5")) )
        self.assertTrue(isValidInputFormat( getFileFormat("ab.fofn")) )
        self.assertFalse(isValidInputFormat( getFileFormat("ab.sam")) )
        self.assertFalse(isValidInputFormat( getFileFormat("ab.cmp.h5")) )
        self.assertFalse(isValidInputFormat( getFileFormat("ab.xyz")) )

    def test_isValidOutputFormat(self):
        """Test isOutputFormat()."""
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.fasta")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.fa")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.pls.h5")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.plx.h5")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.bas.h5")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.bax.h5")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.fofn")) )
        self.assertTrue(isValidOutputFormat( getFileFormat("ab.sam")) )
        self.assertTrue(isValidOutputFormat( getFileFormat("ab.cmp.h5")) )
        self.assertFalse(isValidOutputFormat( getFileFormat("ab.xyz")) )

    def test_getFilesFromFOFN(self):
        """Test getFilesFromFOFN()."""
        fofnFN = path.join(self.rootDir, "data/ecoli_lp.fofn")
        fns = [self.dataDir +
               "m121215_065521_richard_c100425710150000001823055001121371_s1_p0.pls.h5",
               self.dataDir +
               "m121215_065521_richard_c100425710150000001823055001121371_s2_p0.pls.h5"]
        self.assertEqual(fns, getFilesFromFOFN(fofnFN))

    def test_checkInputFile(self):
        """Test checkInputFile()."""
        fastaFN = path.join(self.rootDir,  "data/ecoli.fasta")
        plsFN = self.dataDir + \
                "m121215_065521_richard_c100425710150000001823055001121371_s1_p0.pls.h5"
        self.assertTrue(filecmp.cmp(fastaFN, checkInputFile(fastaFN)))
        self.assertTrue(filecmp.cmp(plsFN, checkInputFile(plsFN)))

        fofnFN = path.join(self.rootDir,  "data/ecoli_lp.fofn")
        self.assertTrue(filecmp.cmp(fofnFN, checkInputFile(fofnFN)))


    def test_checkOutputFile(self):
        """Test checkOutputFile()."""
        samFN = path.join(self.outDir, "lambda_out.sam")
        cmpFN = path.join(self.outDir, "lambda_out.cmp.h5")
        self.assertTrue(filecmp.cmp(samFN, checkOutputFile(samFN)))
        self.assertTrue(filecmp.cmp(cmpFN, checkOutputFile(cmpFN)))


    def test_checkReferencePath(self):
        """Test checkReferencePath()."""
        refDir = "/mnt/secondary/Smrtanalysis/opt/smrtanalysis/common/" + \
            "references"
        refPath = path.join(refDir, "lambda")
        refPath, refFastaOut, refSaOut, isWithinRepository, annotation = \
            checkReferencePath(refPath)
        self.assertTrue(filecmp.cmp(refFastaOut,
                                    path.join(refPath,
                                              "sequence/lambda.fasta")))
        self.assertTrue(filecmp.cmp(refSaOut,
                                    path.join(refPath,
                                              "sequence/lambda.fasta.sa")))
        self.assertTrue(isWithinRepository)

        refpath, refFastaOut, refSaOut, isWithinRepository, annotation = \
                checkReferencePath(refFastaOut)
        self.assertTrue(filecmp.cmp(refFastaOut,
                                    path.join(refPath,
                                              "sequence/lambda.fasta")))
        self.assertTrue(filecmp.cmp(refSaOut,
                                    path.join(refPath,
                                              "sequence/lambda.fasta.sa")))
        self.assertTrue(isWithinRepository)


        fastaFN = "{0}/data/ecoli.fasta".format(self.rootDir)

        refpath, refFastaOut, refSaOut, isWithinRepository, annotation = \
                checkReferencePath(fastaFN)
        self.assertTrue(filecmp.cmp(refpath, refFastaOut))
        self.assertIsNone(refSaOut)
        self.assertFalse(isWithinRepository)

        refPathWithAnnotation = path.join(DATA_DIR, "references/H1_6_Scal_6x/")
        _refPath, _refFaOut, _refSaOut, _isWithinRepository, annotation = \
            checkReferencePath(refPathWithAnnotation)
        self.assertEqual(path.abspath(annotation),
            path.abspath(path.join(refPathWithAnnotation,
            "annotations/H1_6_Scal_6x_adapters.gff")))

    def test_isExist(self):
        """Test isExist(ff)."""
        self.assertFalse(isExist(None))

    def test_realpath(self):
        """Test real_upath and real_ppath."""
        print real_upath("ref with space")
        self.assertTrue(real_upath("ref with space").endswith("ref\ with\ space"))
        self.assertTrue(real_upath("ref\ with\ space").endswith("ref\ with\ space"))
        self.assertTrue(real_ppath("ref with space").endswith("ref with space"))
        self.assertTrue(real_ppath("ref\ with\ space").endswith("ref with space"))


if __name__ == "__main__":
    unittest.main()

