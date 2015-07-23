#!/usr/bin/env python
###############################################################################
# Copyright (c) 2011-2013, Pacific Biosciences of California, Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * Neither the name of Pacific Biosciences nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
# THIS LICENSE.  THIS SOFTWARE IS PROVIDED BY PACIFIC BIOSCIENCES AND ITS
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
# NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PACIFIC BIOSCIENCES OR
# ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

"""This script defines class PBAlignRunner.

PBAlignRunner uses AlignService to align PacBio reads in FASTA/BASE/PULSE/FOFN
formats to reference sequences, then uses FilterServices to filter out
alignments that do not satisfy filtering criteria, and finally generates a SAM
or CMP.H5 file.

"""

# Author: Yuan Li

import logging
import time
import sys
import shutil

from pbcommand.cli import pacbio_args_or_contract_runner
from pbcommand.utils import setup_log
from pbcore.util.Process import backticks
from pbcore.util.ToolRunner import PBToolRunner


from pbalign.__init__ import get_version
from pbalign.options import (ALGORITHM_CANDIDATES, get_argument_parser,
    resolved_tool_contract_to_args)
from pbalign.alignservice.blasr import BlasrService
from pbalign.alignservice.bowtie import BowtieService
from pbalign.alignservice.gmap import GMAPService
from pbalign.utils.fileutil import getFileFormat, FILE_FORMATS, real_ppath
from pbalign.utils.tempfileutil import TempFileManager
from pbalign.pbalignfiles import PBAlignFiles
from pbalign.filterservice import FilterService
from pbalign.forquiverservice.forquiver import ForQuiverService
from pbalign.bampostservice import BamPostService

class PBAlignRunner(PBToolRunner):

    """Tool runner."""

    def __init__(self, args=None, argumentList=()):
        """Initialize a PBAlignRunner object.
           argumentList is a list of arguments, such as:
           ['--debug', '--maxHits', '10', 'in.fasta', 'ref.fasta', 'out.sam']
        """
        desc = "Utilities for aligning PacBio reads to reference sequences."
        if args is None: # FIXME unit testing hack
            args = get_argument_parser().parse_args(argumentList)
        self.args = args
        # args.verbosity is computed by counting # of 'v's in '-vv...'.
        # However in parseOptions, arguments are parsed twice to import config
        # options and then overwrite them with argumentList (e.g. command-line)
        # options.
        #self.args.verbosity = 1 if (self.args.verbosity is None) else \
        #    (int(self.args.verbosity) / 2 + 1)
        self.args.verbosity = 2 if self.args.verbose else 1
        super(PBAlignRunner, self).__init__(desc)
        self._alnService = None
        self._filterService = None
        self.fileNames = PBAlignFiles()
        self._tempFileManager = TempFileManager()

    def _setupParsers(self, description):
        pass

    def _addStandardArguments(self):
        pass

    def getVersion(self):
        """Return version."""
        return get_version()

    def _createAlignService(self, name, args, fileNames, tempFileManager):
        """
        Create and return an AlignService by algorithm name.
        Input:
            name           : an algorithm name such as blasr
            fileNames      : an PBAlignFiles object
            args           : pbalign options
            tempFileManager: a temporary file manager
        Output:
            an object of AlignService subclass (such as BlasrService).
        """
        if name not in ALGORITHM_CANDIDATES:
            errMsg = "ERROR: unrecognized algorithm {algo}".format(algo=name)
            logging.error(errMsg)
            raise ValueError(errMsg)

        service = None
        if name == "blasr":
            service = BlasrService(args, fileNames, tempFileManager)
        elif name == "bowtie":
            service = BowtieService(args, fileNames, tempFileManager)
        elif name == "gmap":
            service = GMAPService(args, fileNames, tempFileManager)
        else:
            errMsg = "Service for {algo} is not implemented.".\
                     format(algo=name)
            logging.error(errMsg)
            raise ValueError(errMsg)

        service.checkAvailability()
        return service

    def _makeSane(self, args, fileNames):
        """
        Check whether the input arguments make sense or not.
        """
        errMsg = ""
        if args.useccs == "useccsdenovo":
            args.readType = "CCS"

        if fileNames.inputFileFormat == FILE_FORMATS.CCS:
            args.readType = "CCS"

        if args.forQuiver:
            if args.useccs is not None:
                errMsg = "Options --forQuiver and --useccs should not " + \
                         "be used together, since Quiver is not designed to " + \
                         "polish ccs reads. if you want to align ccs reads" + \
                         "in cmp.h5 format with pulse QVs loaded, use " + \
                         "--loadQVs with --useccs instead."
                raise ValueError(errMsg)
            args.loadQVs = True

        outFormat = getFileFormat(fileNames.outputFileName)
        if args.loadQVs:
            if fileNames.pulseFileName is None:
                errMsg = "The input file has to be in bas/pls/ccs.h5 " + \
                         "format, or --pulseFile needs to be specified, "
            if outFormat != FILE_FORMATS.CMP:
                errMsg = "The output file has to be in cmp.h5 format, "
            if errMsg != "":
                errMsg += "in order to load pulse QVs."
                logging.error(errMsg)
                raise ValueError(errMsg)

        if outFormat == FILE_FORMATS.BAM or outFormat == FILE_FORMATS.XML:
            if args.algorithm != "blasr":
                errMsg = "Must choose blasr in order to output a bam file."
                raise ValueError(errMsg)
            if args.filterAdapterOnly:
                errMsg = "-filterAdapter does not work when out format is BAM."
                raise ValueError(errMsg)

    def _parseArgs(self):
        """Overwrite ToolRunner.parseArgs(self).
        Parse PBAlignRunner arguments considering both args in argumentList and
        args in a config file (specified by --configFile).
        """
        pass

    def _output(self, inSam, refFile, outFile, readType=None, smrtTitle=False):
        """Generate a SAM, BAM or a CMP.H5 file.
        Input:
            inSam   : an input SAM/BAM file. (e.g. fileName.filteredSam)
            refFile : the reference file. (e.g. fileName.targetFileName)
            outFile : the output SAM/BAM or CMP.H5 file.
                      (i.e. fileName.outputFileName)
            readType: standard or cDNA or CCS (can be None if not specified)
        Output:
            output, errCode, errMsg
        """
        output, errCode, errMsg = "", 0, ""

        outFormat = getFileFormat(outFile)

        if outFormat == FILE_FORMATS.BAM:
            pass # Nothing to be done
        if outFormat == FILE_FORMATS.SAM:
            logging.info("OutputService: Genearte the output SAM file.")
            logging.debug("OutputService: Move {src} as {dst}".format(
                src=inSam, dst=outFile))
            try:
                shutil.move(real_ppath(inSam), real_ppath(outFile))
            except shutil.Error as e:
                output, errCode, errMsg = "", 1, str(e)
        elif outFormat == FILE_FORMATS.CMP:
            #`samtoh5 inSam outFile -readType readType
            logging.info("OutputService: Genearte the output CMP.H5 " +
                         "file using samtoh5.")
            prog = "samtoh5"
            cmd = "samtoh5 {samFile} {refFile} {outFile}".format(
                samFile=inSam, refFile=refFile, outFile=outFile)
            if readType is not None:
                cmd += " -readType {0} ".format(readType)
            if smrtTitle:
                cmd += " -smrtTitle "
            # Execute the command line
            logging.debug("OutputService: Call \"{0}\"".format(cmd))
            output, errCode, errMsg = backticks(cmd)
        elif outFormat == FILE_FORMATS.XML:
            logging.info("OutputService: Generating the output XML file".
                         format(samFile=inSam, outFile=outFile))
            from pbcore.io import AlignmentSet
            # Create {out}.xml, given {out}.bam
            outBam = str(outFile[0:-3]) + "bam"
            AlignmentSet(real_ppath(outBam)).write(outFile)

        if errCode != 0:
            errMsg = prog + " returned a non-zero exit status." + errMsg
            logging.error(errMsg)
            raise RuntimeError(errMsg)
        return output, errCode, errMsg

    def _cleanUp(self, realDelete=False):
        """ Clean up temporary files and intermediate results. """
        logging.debug("Clean up temporary files and directories.")
        self._tempFileManager.CleanUp(realDelete)

    def run(self):
        """
        The main function, it is called by PBToolRunner.start().
        """
        startTime = time.time()
        logging.info("pbalign version: {version}".format(version=get_version()))
        # FIXME
        #logging.debug("Original arguments: " + str(self._argumentList))

        # Create an AlignService by algorithm name.
        self._alnService = self._createAlignService(self.args.algorithm,
                                                    self.args,
                                                    self.fileNames,
                                                    self._tempFileManager)

        # Make sane.
        self._makeSane(self.args, self.fileNames)

        # Run align service.
        try:
            self._alnService.run()
        except RuntimeError:
            return 1

        # Create a temporary filtered SAM/BAM file as output for FilterService.
        outFormat = getFileFormat(self.fileNames.outputFileName)
        suffix = ".bam" if outFormat in \
                [FILE_FORMATS.BAM, FILE_FORMATS.XML] else ".sam"
        self.fileNames.filteredSam = self._tempFileManager.\
            RegisterNewTmpFile(suffix=suffix)

        # Call filter service on SAM or BAM file.
        self._filterService = FilterService(self.fileNames.alignerSamOut,
                                            self.fileNames.targetFileName,
                                            self.fileNames.filteredSam,
                                            self.args.algorithm,
                                            #self._alnService.name,
                                            self._alnService.scoreSign,
                                            self.args,
                                            self.fileNames.adapterGffFileName)
        try:
            self._filterService.run()
        except RuntimeError:
            return 1

        # Sort bam before output
        if outFormat in [FILE_FORMATS.BAM, FILE_FORMATS.XML]:
            # Sort/make index for BAM output.
            try:
                BamPostService(self.fileNames).run()
            except RuntimeError:
                return 1

        # Output all hits in SAM, BAM or CMP.H5.
        try:
            useSmrtTitle = False
            if (self.args.algorithm != "blasr" or
                self.fileNames.inputFileFormat == FILE_FORMATS.FASTA):
                useSmrtTitle = True

            self._output(
                inSam=self.fileNames.filteredSam,
                refFile=self.fileNames.targetFileName,
                outFile=self.fileNames.outputFileName,
                readType=self.args.readType,
                smrtTitle=useSmrtTitle)
        except RuntimeError:
            return 1

        # Load QVs to cmp.h5 for Quiver
        if outFormat == FILE_FORMATS.CMP and \
            self.args.forQuiver or self.args.loadQVs:
            # Call post service for quiver.
            try:
                ForQuiverService(self.fileNames, self.args).run()
            except RuntimeError:
                return 1

        # Delete temporay files anyway to make
        self._cleanUp(False if (hasattr(self.args, "keepTmpFiles") and
                               self.args.keepTmpFiles is True) else True)

        endTime = time.time()
        logging.info("Total time: {:.2f} s.".format(float(endTime - startTime)))
        return 0

def args_runner(args):
    # PBAlignRunner inherits PBToolRunner. So PBAlignRunner.start() parses args,
    # sets up logging and finally returns run().
    return PBAlignRunner(args).start()

def resolved_tool_contract_runner(resolved_tool_contract):
    args = resolved_tool_contract_to_args(resolved_tool_contract)
    return args_runner(args)

def main(argv=sys.argv):
    logging.basicConfig(level=logging.INFO)
    log = logging.getLogger()
    mp = get_argument_parser()
    return pacbio_args_or_contract_runner(argv[1:],
                                          mp,
                                          args_runner,
                                          resolved_tool_contract_runner,
                                          log,
                                          lambda *args: log)

if __name__ == "__main__":
    sys.exit(main())
