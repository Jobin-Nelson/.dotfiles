#!/usr/bin/env python3
#
# ██████╗  ██████╗ ████████╗    ██████╗      █████╗ ███████╗ ██████╗██╗██╗
# ██╔══██╗██╔═══██╗╚══██╔══╝    ╚════██╗    ██╔══██╗██╔════╝██╔════╝██║██║
# ██║  ██║██║   ██║   ██║        █████╔╝    ███████║███████╗██║     ██║██║
# ██║  ██║██║   ██║   ██║       ██╔═══╝     ██╔══██║╚════██║██║     ██║██║
# ██████╔╝╚██████╔╝   ██║       ███████╗    ██║  ██║███████║╚██████╗██║██║
# ╚═════╝  ╚═════╝    ╚═╝       ╚══════╝    ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝╚═╝
#

"""This program converts dot string to ascii flowchart"""

import argparse
import sys
import urllib.error
import urllib.parse
import urllib.request


def dot_to_ascii(dot: str, fancy: bool = True) -> str:
    url = 'https://dot-to-ascii.ggerganov.com/dot-to-ascii.php'

    # use nice box drawing char instead of + , | , -
    boxart = 1 if fancy else 0

    params = {
        'boxart': boxart,
        'src': dot,
    }

    url = url + '?' + urllib.parse.urlencode(params)
    try:
        with urllib.request.urlopen(url) as res:
            response = res.read().decode('utf-8')
    except urllib.error.URLError:
        print(f'Failed to get a response from {url}', file=sys.stderr)
        raise SystemExit(1)

    if response == '':
        raise SyntaxError('DOT string is not formatted correctly')

    return response


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert DOT string to ASCII flowchart.",
        epilog="""
example:

echo 'digraph {
    rankdir=LR;
    0 -> {1 2};
    1 -> {2};
    2 -> {0 1 3};
    3;
}' | dot2ascii.py
""",
    )
    parser.add_argument(
        "input",
        nargs="?",
        type=argparse.FileType('r'),
        default=sys.stdin,
        help="Input file containing DOT string (default: read from stdin)",
    )
    parser.add_argument(
        "-a", "--ascii", action="store_false", help="Output in ascii drawing characters"
    )
    args = parser.parse_args()

    dot_input = args.input.read()
    graph_ascii = dot_to_ascii(dot_input, args.ascii)

    print(graph_ascii)


if __name__ == "__main__":
    raise SystemExit(main())
