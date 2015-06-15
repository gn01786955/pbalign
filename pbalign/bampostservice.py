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

"""This script defines BamPostService, which
   * calls 'samtools sort' to sort out.bam, and
   * calls 'samtools index' to make out.bai index, and
   * calls 'makePbi.py' to make out.pbi index file.
"""

# Author: Yuan Li

from __future__ import absolute_import
import logging
from pbalign.service import Service
from pbalign.utils.progutil import Execute


class BamPostService(Service):

    """Sort a bam, makes bam index and PacBio index."""
    @property
    def name(self):
        """Name of bam post service."""
        return "BamPostService"

    @property
    def progName(self):
        return "samtools"

    @property
    def cmd(self):
        return ""

    def __init__(self, filenames):
        """Initialize a BamPostService object.
            Input - unsortedBamFile: a filtered, unsorted bam file
                    refFasta : a reference fasta file
            Output - sortedBamFile: sorted BAM file
                     outBaiFile: index BAI file
        """
        self.refFasta = filenames.targetFileName

        # filtered, unsorted bam file.
        self.unsortedBamFile = filenames.filteredSam
        self.outBamFile = filenames.outBamFileName
        self.outBaiFile = filenames.outBaiFileName
        self.outPbiFile = filenames.outPbiFileName

    def _sortbam(self, unsortedBamFile, sortedBamFile):
        """Sort unsortedBamFile and output sortedBamFile."""
        if not sortedBamFile.endswith(".bam"):
            raise ValueError("sorted bam file name %s must end with .bam" %
                             sortedBamFile)
        sortedPrefix = sortedBamFile[0:-4]
        cmd = 'samtools sort -m 4G {unsortedBamFile} {prefix}'.format(
            unsortedBamFile=unsortedBamFile, prefix=sortedPrefix)
        Execute(self.name, cmd)

    def _makebai(self, sortedBamFile, outBaiFile):
        """Build *.bai index file."""
        cmd = "samtools index {sortedBamFile} {outBaiFile}".format(
            sortedBamFile=sortedBamFile, outBaiFile=outBaiFile)
        Execute(self.name, cmd)

    def _makepbi(self, sortedBamFile, refFasta):
        """Generate *.pbi PacBio BAM index."""
        from pbalign.utils.fileutil import isExist
        from pbcore.util.Process import backticks
        refFai = refFasta + ".fai"
        if not isExist(refFai):
            cmd = "samtools faidx {fa}".format(fa=refFasta)
            _output, errCode, _errMsg = backticks(cmd)
            if errCode != 0:  # If fail to build refFasta.fai
                logging.warning("samtools faidx failed to create {fai}.".
                                format(fai=refFai))

        if isExist(refFai):
            cmd = "makePbi.py --referenceFasta {refFasta} {sortedBamFile}".\
                  format(refFasta=refFasta, sortedBamFile=sortedBamFile)
            Execute(self.name, cmd)

    def run(self):
        """ Run the BAM post-processing service. """
        logging.info(self.name + ": Sort and build index for a bam file.")
        self._sortbam(unsortedBamFile=self.unsortedBamFile,
                      sortedBamFile=self.outBamFile)
        self._makebai(sortedBamFile=self.outBamFile,
                      outBaiFile=self.outBaiFile)

        # TODO: enable _makepbi after 'makePbi.py' is moved out of
        # GenomicConsensus.
        #self._makepbi(sortedBamFile=self.sortedBamFile,
        #              refFasta=self.refFasta)
