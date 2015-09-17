
# FIXME this should probably live somewhere more general, e.g. pbdataset?

"""
Consolidate AlignmentSet .bam files
"""

import functools
import logging
import os.path as op
import sys

from pbcommand.models import get_pbparser, FileTypes
from pbcommand.cli import pbparser_runner
from pbcommand.utils import setup_log
from pbcore.io import openDataSet


class Constants(object):
    TOOL_ID = "pbalign.tasks.consolidate_bam"
    VERSION = "0.1.0"
    DRIVER = "python -m pbalign.tasks.consolidate_bam --resolved-tool-contract "
    CONSOLIDATE_ID = "pbalign.task_options.consolidate_aligned_bam"
    N_FILES_ID = "pbalign.task_options.consolidate_n_files"


def get_parser():
    p = get_pbparser(Constants.TOOL_ID,
                     Constants.VERSION,
                     "AlignmentSet consolidate",
                     __doc__,
                     Constants.DRIVER,
                     is_distributed=True)

    p.add_input_file_type(FileTypes.DS_ALIGN, "align_in", "Input AlignmentSet",
                          "Gathered AlignmentSet to consolidate")
    p.add_output_file_type(FileTypes.DS_ALIGN,
                           "ds_out",
                           "AlignmentSet",
                           "Consolidated AlignmentSet",
                           "final.alignmentset.xml")
    p.add_boolean(Constants.CONSOLIDATE_ID, "consolidate",
        default=False,
        name="Consolidate .bam",
        description="Merge chunked/gathered .bam files")
    p.add_int(Constants.N_FILES_ID, "consolidate_n_files",
        default=1,
        name="Number of .bam files",
        description="Number of .bam files to create in consolidate mode")
    return p


def run_consolidate(dataset_file, output_file, consolidate, n_files):
    with openDataSet(dataset_file) as ds_in:
        # XXX shouldn't the file count check be done elsewhere?
        if consolidate and len(ds_in.toExternalFiles()) != 1:
            new_resource_file = op.splitext(output_file)[0] + ".bam" # .fasta?
            ds_in.consolidate(new_resource_file, numFiles=n_files)
            ds_in._induceIndices()
        ds_in.write(output_file)
    return 0


def args_runner(args):
    return run_consolidate(
        dataset_file=args.align_in,
        output_file=args.ds_out,
        consolidate=args.consolidate,
        n_files=args.consolidate_n_files)


def rtc_runner(rtc):
    return run_consolidate(
        dataset_file=rtc.task.input_files[0],
        output_file=rtc.task.output_files[0],
        consolidate=rtc.task.options[Constants.CONSOLIDATE_ID],
        n_files=rtc.task.options[Constants.N_FILES_ID])


def main(argv=sys.argv):
    logging.basicConfig(level=logging.DEBUG)
    log = logging.getLogger()
    return pbparser_runner(argv[1:],
                           get_parser(),
                           args_runner,
                           rtc_runner,
                           log,
                           setup_log)


if __name__ == '__main__':
    sys.exit(main())
