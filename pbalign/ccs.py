
"""
VERY thin wrapper on top of pbalign to provide a tool contract-driven task
specific to CCS reads.
"""

import sys

from pbcommand.models import FileTypes

from pbalign import pbalignrunner
import pbalign.options

class Constants(pbalign.options.Constants):
    TOOL_ID = "pbalign.tasks.pbalign_ccs"
    DRIVER_EXE = "python -m pbalign.ccs --resolved-tool-contract"
    INPUT_FILE_TYPE = FileTypes.DS_CCS
    OUTPUT_FILE_TYPE = FileTypes.DS_ALIGN_CCS
    OUTPUT_FILE_NAME = "aligned.ccs.xml"
    # some modified defaults
    ALGORITHM_OPTIONS_DEFAULT = "-minMatch 12 -bestn 1 -minPctIdentity 70.0"
    USECCS_DEFAULT = "useccsdenovo"

def get_parser():
    return pbalign.options.get_contract_parser(Constants)

def main(argv=sys.argv):
    return pbalignrunner.main(
        argv=argv,
        get_parser_func=get_parser)

if __name__ == "__main__":
    sys.exit(main())
