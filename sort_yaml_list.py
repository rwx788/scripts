#!/usr/bin/env python3

import yaml
with open('sort.yaml') as f:
    data = yaml.load(f, Loader=yaml.FullLoader)

    print(yaml.dump(sorted(data, key=lambda x: list(x.keys())[0].lower() if type(x) is dict else x.lower() )))
