#!/usr/bin/env python3
"""
Things to backup before wipe (bbw) 😄
- dotfiles
- projects
- nvim
- gclone
"""

from __future__ import annotations
from pathlib import Path
from typing import overload
import shutil
import asyncio


async def exec_cmd(cmd: list[str]) -> bool:
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.DEVNULL,
        stderr=asyncio.subprocess.DEVNULL,
    )
    await proc.wait()
    return proc.returncode == 0


@overload
def git_cmd(cwd: Path, git_dir: None = None, work_tree: None = None) -> list[str]: ...
@overload
def git_cmd(cwd: Path, git_dir: Path, work_tree: Path) -> list[str]: ...

def git_cmd(cwd: Path, git_dir: Path|None = None, work_tree: Path|None = None) -> list[str]:
    cmd = ['git', '-C', str(cwd)]
    if git_dir: cmd.extend(['--git-dir', str(git_dir)])
    if work_tree: cmd.extend(['--work-tree', str(work_tree)])
    return cmd


async def git_push(cmd: list[str]):
    commit_args = ['commit', '--no-gpg-sign', '-a', '-m', 'chore: bbw.py backup commit']
    push_args = ['push', 'origin', 'HEAD']

    await exec_cmd(cmd + commit_args)
    if await exec_cmd(cmd + push_args):
        print(f'{cmd[2]} successfully pushed to remote')


async def git_status(cmd: list[str]):
    status_args = ['status', '--porcelain', '--untracked-files=normal']
    cmd.extend(status_args)

    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.DEVNULL,
    )

    stdout = await proc.stdout.readline()
    if stdout: print(f'{cmd[2]} repo is dirty')

async def main() -> int:
    home = Path.home()
    dotfiles = home / '.dotfiles'
    projects = home / 'playground' / 'projects'

    extra_repos = [
        home / '.config' / 'nvim',
        home / '.password-store'
    ]

    git_operations = [ git_push, git_status ]

    await git_push(git_cmd(home, dotfiles, home))

    for operation in git_operations:
        print('=' * 40)
        await asyncio.gather(
            *(operation(git_cmd(p)) for p in projects.iterdir() if p.is_dir()),
            *(operation(git_cmd(p)) for p in extra_repos if p.is_dir())
        )
    return 0


def check_requirements():
    executables = [
        'git',
        'gclone.sh',
    ]
    not_found = list(filter(lambda x: not shutil.which(x), executables))
    if not_found: raise SystemExit(f"Executable {', '.join(not_found)} not found in PATH")


if __name__ == '__main__':
    check_requirements()
    raise SystemExit(asyncio.run(main()))
