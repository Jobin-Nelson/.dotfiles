#!/usr/bin/env python3
'''This program helps you with cheatsheet on any language through command line''' 
from __future__ import annotations
import requests
import argparse
from typing import Optional, Sequence

def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description='Searches for cheatsheet on any stuff')
    parser.add_argument('-l', '--lang', 
            help='specify the language you want the cheatsheet for [default: %(default)s]', 
            default='python')
    parser.add_argument('query', nargs='+', help='get cheatsheet on the query string')
    args = parser.parse_args(argv)

    base_url = 'https://cht.sh'
    cht_url = f"{base_url}/{args.lang}/{'+'.join(args.query)}"
    print('Requested url:', cht_url)

    r = requests.get(cht_url)
    if r.ok:
        print(r.text)
    else: 
        print(f'recieved status code: {r.status_code}')
        print('Aborting program')
        return 1
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
