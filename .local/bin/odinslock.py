#!/usr/bin/env python3
#
#            _ _           _            _
#   ___   __| (_)_ __  ___| | ___   ___| | __
#  / _ \ / _` | | '_ \/ __| |/ _ \ / __| |/ /
# | (_) | (_| | | | | \__ \ | (_) | (__|   <
#  \___/ \__,_|_|_| |_|___/_|\___/ \___|_|\_\
#

'''
Script to encrypt and decrypt files/directories
'''

import argparse
import shutil
import subprocess
import sys
import tarfile
from itertools import compress, tee
from operator import methodcaller, not_
from pathlib import Path
from typing import Iterable, NoReturn, Sequence, TypeVar, Callable

# Region: -- utility functions
A = TypeVar('A')
B = TypeVar('B')
C = TypeVar('C')


def partition(
    predicate: Callable[[A], bool], iterable: Iterable[A]
) -> tuple[Iterable[A], Iterable[A]]:
    t1, t2, p = tee(iterable, 3)
    p1, p2 = tee(map(predicate, p))
    return (compress(t1, map(not_, p1)), compress(t2, p2))


def compose(f: Callable[[B], C], g: Callable[[A], B]) -> Callable[[A], C]:
    def inner(x: A) -> C:
        return f(g(x))

    return inner


# End Region: -- utility functions


class OpenSSL:
    executable = 'openssl'
    __args = [
        'enc',
        '-aes-256-cbc',
        '-salt',
        '-pbkdf2',
        '-iter',
        '1000000',
        '-md',
        'sha512',
        '-base64',
    ]

    def __init__(self, in_file: Path) -> None:
        self.in_file = ['-in', str(in_file)]

    def _cmd(self) -> list[str]:
        return [OpenSSL.executable] + OpenSSL.__args + self.in_file

    def _encrypt_cmd(self) -> list[str]:
        return self._cmd() + ['-e']

    def _decrypt_cmd(self) -> list[str]:
        return self._cmd() + ['-d']

    def _get_out_file_arg(self, out_file: str | Path) -> list[str]:
        return ['-out', str(out_file)]

    def encrypt(self, out_file: str | Path) -> None:
        exec_cmd(
            self._encrypt_cmd() + self._get_out_file_arg(out_file), 'Encryption failed'
        )

    def decrypt(self, out_file: str | Path) -> None:
        exec_cmd(
            self._decrypt_cmd() + self._get_out_file_arg(out_file), 'Decryption failed'
        )


def exec_cmd(cmd: list[str], failure_message: str) -> NoReturn | None:
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        bail(failure_message, 4)


def to_path(path: str | Path) -> Path:
    return Path(path).expanduser().resolve()


def print_prefix(banner: str, it: Iterable[Path]) -> None:
    for i in it:
        print(banner, i)


def bail(message: str, code: int) -> NoReturn:
    print(message, file=sys.stderr)
    raise SystemExit(code)


def copy(paths: Iterable[Path], destination: Path) -> None:
    create_dir(destination)
    for p in paths:
        if p.is_dir():
            shutil.copytree(p, destination / p.stem)
        else:
            shutil.copy2(p, destination)


def create_dir(dir: Path) -> NoReturn | None:
    try:
        dir.mkdir()
    except FileExistsError:
        bail(f'{dir} already exists', 1)


def file2dir(filepath: Path) -> Path:
    return filepath.parent / file2stem(filepath)


def file2stem(filepath: Path) -> str:
    return filepath.stem.partition('.')[0]


def check_executable_exists() -> NoReturn | None:
    executables = [
        OpenSSL.executable,
    ]
    missing_executables = [e for e in executables if not shutil.which(e)]
    if missing_executables:
        bail(f'Executable {missing_executables} not found in PATH', 2)


def copy_n_compress(input_files: list[Path], output_file: Path) -> str:
    is_present = methodcaller('exists')
    to_dir = compose(file2dir, to_path)
    output_dir = to_dir(output_file)

    paths = map(to_path, input_files)
    missing_paths, existing_paths = partition(is_present, paths)
    print_prefix('Missing path:', missing_paths)
    copy(existing_paths, output_dir)
    return archive(output_file, output_dir)


def archive(compress_name: Path, directory: Path) -> str:
    return shutil.make_archive(
        str(compress_name), 'gztar', root_dir=directory.parent, base_dir=directory.name
    )


def unarchive(filepath: Path):
    try:
        with tarfile.open(filepath, 'r:gz') as tar:
            tar.extractall()
    except FileNotFoundError:
        bail(f'File {filepath} not found', 3)


def encrypt(args: argparse.Namespace) -> None:
    check_executable_exists()
    compressed_output_str = copy_n_compress(args.input, args.output)
    encrypted_output_str = compressed_output_str + '.enc'
    compressed_output = to_path(compressed_output_str)
    openssl = OpenSSL(compressed_output)
    openssl.encrypt(encrypted_output_str)
    cleanup(compressed_output, args.output)


def decrypt(args: argparse.Namespace) -> None:
    check_executable_exists()
    encrypted_file = to_path(args.input)
    decrypted_file = encrypted_file.parent / encrypted_file.stem
    openssl = OpenSSL(encrypted_file)
    openssl.decrypt(decrypted_file)
    unarchive(decrypted_file)
    cleanup(decrypted_file)


def cleanup(*files: Path) -> None:
    for file in files:
        if file.is_dir():
            shutil.rmtree(file)
        else:
            file.unlink()


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description='After the Allfather, symbolizing wisdom and secrecy',
        epilog='No gaze shall graze your secrets',
    )
    subparser = parser.add_subparsers(required=True)

    enc_parser = subparser.add_parser('encrypt')
    enc_parser.add_argument(
        '-i',
        '--input',
        type=Path,
        nargs='+',
        help='Files to be encrypted',
        required=True,
    )
    enc_parser.add_argument(
        '-o',
        '--output',
        type=Path,
        help='Files to be encrypted',
        default=Path('sentinel'),
    )
    enc_parser.set_defaults(func=encrypt)

    dec_parser = subparser.add_parser('decrypt')
    dec_parser.add_argument(
        '-i', '--input', type=Path, help='File to be decrypted', required=True
    )
    dec_parser.set_defaults(func=decrypt)
    args = parser.parse_args(argv)
    args.func(args)

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
