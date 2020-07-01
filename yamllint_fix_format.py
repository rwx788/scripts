#!/usr/bin/env python3

import sys
import yaml as pyyaml
import textwrap

from pathlib import Path

# Validate that at least one argument was provided
arguments = len(sys.argv) - 1
if arguments == 0:
    sys.exit('No arguments, please provide file name')

# We need this to override zero indent in case of lists
class MyDumper(pyyaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super(MyDumper, self).increase_indent(flow, False)

# This hack allows to keep multiline comments as blocks, using `>` yaml syntax
def str_presenter(dumper, data):
    try:
        dlen = len(data.splitlines())
        if '\n' in data:
            return dumper.represent_scalar(u'tag:yaml.org,2002:str', data, style='>')
    except TypeError as ex:
        return dumper.represent_scalar(u'tag:yaml.org,2002:str', data)
    return dumper.represent_scalar(u'tag:yaml.org,2002:str', data)


# Overriding scalar representation for the multiline strings
pyyaml.add_representer(str, str_presenter, Dumper=MyDumper)
# Receive parameters from the pipeline
path = Path(sys.argv[1])

yaml = None
try:
    with open(path, 'r', encoding="utf-8") as yaml_file:
        yaml = pyyaml.safe_load(yaml_file)

    with open(path, 'w', encoding="utf-8") as yaml_file:
        dump = pyyaml.dump( yaml,
                            Dumper=MyDumper,
                            indent=2,
                            width=82,
                            explicit_start=True,
                            default_flow_style=False,
                            allow_unicode=True,
                            encoding=None,
                            sort_keys=False )
        yaml_file.write(dump)
except pyyaml.YAMLError as exc:
    print(exc)
    sys.exit()
