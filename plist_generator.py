#!/usr/bin/env python3
import argparse
import datetime
import plistlib
import time

# Parse arguments
parser = argparse.ArgumentParser(description='Generate property list file.')
parser.add_argument('--output', '-o', default='test.plist',
                    help='Output file name and path')
parser.add_argument('--nested-array', '-na', type=int,
                    help='Levels of nesting for the array structure, default = 5')

args = parser.parse_args()

pl = dict(
    aString = "Doodah",
    aList = ["A", "B", 12, 32.1, [1, 2, 3]],
	aFloat = 0.1,
    anInt = 728,
    aDict = dict(
        anotherString = "<hello & hi there!>",
        aThirdString = "M\xe4ssig, Ma\xdf",
        aTrueValue = True,
        aFalseValue = False,
    ),
    someData = b"<binary gunk>",
    someMoreData = b"<lots of binary gunk>" * 10,
    aDate = datetime.datetime.fromtimestamp(time.mktime(time.gmtime())),
)

# Generate deep nested array
if args.nested_array is not None:
    a_list = [1]
    for i in range(0, args.nested_array):
        a_list = [a_list.copy()]
    pl.update(aListOfLists = a_list)

with open(args.output, 'wb') as fp:
    plistlib.dump(pl, fp, fmt=plistlib.FMT_XML)
