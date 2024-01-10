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
    await proc.communicate()
    return proc.returncode == 0


@overload
async def git_push(cwd: str, git_dir: None = None, work_tree: None = None): ...
@overload
async def git_push(cwd: str, git_dir: str, work_tree: str): ...

async def git_push(cwd: str, git_dir: str|None = None, work_tree: str|None = None):
    cmd = ['git', '-C', cwd]
    if git_dir: cmd.extend(['--git-dir', git_dir])
    if work_tree: cmd.extend(['--work-tree', work_tree])

    commit_args = ['commit', '-a', '-m', 'chore: bbw.py backup commit']
    push_args = ['push', 'origin', 'HEAD']

    await exec_cmd(cmd + commit_args)
    if await exec_cmd(cmd + push_args):
        print(f'{git_dir or cwd} successfully backed up')


async def main() -> int:
    home = Path.home()
    dotfiles = home / '.dotfiles'
    projects = home / 'playground' / 'projects'
    nvim = home / '.config' / 'nvim'

    await asyncio.gather(
        git_push(*map(str, [home, dotfiles, home])),
        git_push(str(nvim)),
        *(git_push(str(p)) for p in projects.iterdir() if p.is_dir()),
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
