#!/usr/bin/python
from os import path
import ConfigParser

"""Define test data path for pbalign."""

THIS_DIR = path.dirname(path.abspath(__file__))
ROOT_DIR = path.dirname(THIS_DIR)
NOSE_CFG = path.join(THIS_DIR, "nose.cfg")

def _get_data_std_dir():
    """Get the data directory which contains all the unittests files.
    """
    nosecfg = ConfigParser.SafeConfigParser()
    nosecfg.readfp(open(NOSE_CFG), 'r')
    if nosecfg.has_section('data'):
        data_dir = path.abspath(nosecfg.get('data', 'dataDir'))
        std_dir = path.abspath(nosecfg.get('data', 'stdDir'))
        return data_dir, std_dir
    else:
        msg = "Unable to find section [DATA] option [dataDir]" + \
              "and [stdDir] in config file {f}.".format(f=NOSE_CFG)
        raise KeyError(msg)

OUT_DIR =  path.join(ROOT_DIR, "out")
DATA_DIR, STD_DIR = _get_data_std_dir()

