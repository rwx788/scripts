#!/usr/bin/env python3

import plistlib
import datetime
import time

# Generate deep nested array
a_list = [1]
for i in range(0,5):
    a_list = [a_list.copy()]

pl = dict(
    aString = "Doodah",
    aList = ["A", "B", 12, 32.1, [1, 2, 3]],
    aListOfLists = a_list,
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

with open('./test.plist', 'wb') as fp:
    plistlib.dump(pl, fp, fmt=plistlib.FMT_XML)
