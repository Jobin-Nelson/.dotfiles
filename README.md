# Dotfiles

## Ansible Pull

- `sudo pacman -S git ansible wl-clipboard`
- `ansible-pull -K -U https://github.com/jobin-nelson/config-setup`

## Custom setup script

- `curl --proto '=https' --tlsv1.2 -sSfL 'https://raw.githubusercontent.com/Jobin-Nelson/.dotfiles/refs/heads/main/playground/post_install/arch_post_install.sh' | sh -s -- -a`

## Setup dotfiles manually

- Setup ssh key with github

```bash
mkdir -pv $HOME/playground/backup && mv -v $HOME/.{bash_profile,bashrc} $_
git clone --depth 5 --bare git@github.com:Jobin-Nelson/.dotfiles.git $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot config --local core.worktree $HOME
dot config --local --unset core.bare
dot checkout -f
dot submodule update --init --depth 5
```

## Post Install (OPTIONAL)

### Arch linux

```bash
cd /home/jobin/playground/post_install
./arch_post_install.sh
```

Further setup is documented in [Arch notes](./playground/post_install/arch_notes.md)

#### Cronjobs

```crontab
0 12 * * Sun /home/jobin/.local/bin/weekly_jobs.sh
0 16 * * *   rclone -v sync ~/playground/second_brain GoogleDriveEncrypt:
0 16 * * *   rclone -v sync ~/playground/org_files GoogleDriveOrgFiles:
```

#### Install gsconnect for Gnome

- `sudo pacman -S gnome-browser-connector`: install connector package
- https://extensions.gnome.org/extension/1319/gsconnect/

### WSL

```
# UNCONFIGURED FSTAB FOR BASE SYSTEM
# C: /mnt/c drvfs rw,noatime,uid=1000,gid=1000,case=off,umask=0027,fmask=0137, 0 0
C:/Users/jobin/playground/projects/second_brain /home/jobin/playground/projects/second_brain drvfs rw,noatime,uid=1000,gid=1000,case=off 0 0
```

### Install packages manually

- `sudo apt-get -y install alacritty tmux zoxide git`
- [pyenv](https://github.com/pyenv/pyenv)
- [nvm](https://github.com/nvm-sh/nvm)
- [rust](https://rustup.rs/)
- [neovim](https://github.com/neovim/neovim)
- [starship](https://starship.rs/)

