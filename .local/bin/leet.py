#!/usr/bin/env python3
'''This program sets up everything for the daily leetcode problems'''
from __future__ import annotations
from typing import Sequence
from pathlib import Path
import argparse, json, datetime, webbrowser, subprocess
import urllib.request, urllib.parse

TODAY = datetime.datetime.now()
LEET_DAILY_DIR = (Path.home()
    / 'playground'
    / 'projects'
    / 'learn'
    / 'competitive_programming'
    / f'{TODAY:%Y}'
    / f'{TODAY:%B}'.lower()
)

def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog='leet',
        description='leet helps with doing leetcode daily',
        epilog='Happy leetcoding'
    )
    parser.add_argument('-b', '--browser', action='store_false', help='do not open browser')
    parser.add_argument('-f', '--file', action='store_false', help='do not create a file')
    parser.add_argument('-n', '--neovim', action='store_false', help='do not open neovim')
    args = parser.parse_args(argv)

    daily_qn_link = get_daily_qn_link()
    leet_file = LEET_DAILY_DIR / Path(daily_qn_link).with_suffix('.py').name

    if args.browser: webbrowser.open(daily_qn_link)
    if args.file: create_file(leet_file, daily_qn_link)
    if args.neovim: subprocess.run(['nvim', str(leet_file)])

    return 0


def get_daily_qn_link() -> str:
    base_url = 'https://leetcode.com/graphql/'
    query = {
      "query": "query questionOfToday {\n\tactiveDailyCodingChallengeQuestion {\n\t\tdate\n\t\tlink\n\t}\n}\n",
      "operationName": "questionOfToday"
    }
    # query_enc = urllib.parse.urlencode(query).encode('utf-8')
    req = urllib.request.Request(base_url, json.dumps(query).encode('utf-8'))
    req.add_header('Content-Type', 'application/json')
    req.add_header('User-Agent', 'Mozilla/5.0')
    res = urllib.request.urlopen(req)
    return base_url.rstrip('/graphql/') + json.loads(res.read())['data']['activeDailyCodingChallengeQuestion']['link']


def create_file(leet_file: Path, daily_qn_link: str):
    if leet_file.exists(): return leet_file
    leet_file.parent.mkdir(exist_ok=True)
    with open(leet_file, 'w') as f:
        f.write(f"""\
'''
Created Date: {TODAY:%Y-%m-%d}
Qn: 
Link: {daily_qn_link}
Notes:
'''
def main():
    pass

if __name__ == '__main__':
""")


if __name__ == '__main__':
    raise SystemExit(main())

