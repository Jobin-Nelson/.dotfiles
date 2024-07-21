# Dotfiles

## Ansible Pull

- `sudo pacman -S git ansible wl-clipboard`
- `ansible-pull -K -U https://github.com/jobin-nelson/config-setup`

## Setup dotfiles manually

- Setup ssh key with github

```bash
mkdir -p $HOME/playground/backup && mv $HOME/.{bash_profile,bashrc} $_
git clone --depth 5 --bare git@github.com:Jobin-Nelson/.dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot checkout
dot submodule update --init
```

## Post Install (OPTIONAL)

### Arch linux

```bash
cd /home/jobin/playground/post_install
./arch_post_install.sh
```

Further setup is documented in [Arch notes](./playground/post_install/arch_notes.md)

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

