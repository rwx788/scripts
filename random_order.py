#!/usr/bin/env python3

import random

filename = 'names.txt'

with open(filename) as f:
    content = f.readlines()
content = [x.strip() for x in content]

random.shuffle(content)
random.shuffle(content)
random.shuffle(content)

print (*content, sep ="\n")
