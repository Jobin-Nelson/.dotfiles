#!/usr/bin/env python3
'''This program sets up everything for the daily leetcode problem'''
from pathlib import Path
import requests
import subprocess, argparse
from typing import Sequence, Optional
from datetime import datetime

def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="find today's leetcode problem")
    parser.add_argument('-f', '--file', action='store_true', help='create a file if not existing')
    parser.add_argument('-c', '--vscode', action='store_true', help='open file in vscode')
    parser.add_argument('-v', '--vim', action='store_true', help='open file in neovim')
    args = parser.parse_args(argv)

    # api request to get the daily question link
    base_url = 'https://leetcode.com'
    query_url = base_url + '/graphql'
    query = {
      "query": "query questionOfToday {\n\tactiveDailyCodingChallengeQuestion {\n\t\tdate\n\t\tlink\n\t}\n}\n",
      "operationName": "questionOfToday"
    }

    r = requests.post(query_url, json=query)
    if r.ok:
        response = r.json()
        daily_qn_link = base_url + response['data']['activeDailyCodingChallengeQuestion']['link']
        subprocess.run(['brave-browser', daily_qn_link], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    else:
        print(f'Received response {r.status_code}')
        print('Aborting program!')
        return 1

    filename = Path(daily_qn_link).name + '.py'
    today = datetime.now()
    p = Path.home() / 'playground' / 'learn' / 'competitive_programming' / today.strftime('%B').lower()
    p.mkdir(exist_ok=True)
    p /= filename

    # creating and populating the file if it's not created already
    if args.file:
        if p.exists():
            print('File already exists')
        else:
            with open(p, 'w') as f:
                print(f'Creating file {filename} at {p}')
                f.write(f"'''\nCreated Date: {today.strftime('%d-%m-%Y')}\nQn:\nLink: {daily_qn_link}\nNotes:\n'''\ndef main():\n\tpass\n\nif __name__ == '__main__':\n")

    # opening the file in vscode
    if args.vscode:
        subprocess.run(['code', str(p)])
    
    # opening file in neovim
    if args.vim:
        subprocess.run(['nvim', str(p)])
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
