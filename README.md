# Dotfiles

- Setup ssh key with github

```shell
mkdir -p $HOME/playground/backup && mv $HOME/.{bash_profile,bashrc} $_
git clone --depth 5 --bare git@github.com:Jobin-Nelson/.dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot checkout
dot submodule update --init
```

## Post Install

### Arch linux

```bash
cd /home/jobin/playground/post_install
./arch_post_install.sh
```

Further setup is documented in [Arch notes](./playground/post_install/arch_notes.md)

### Ubuntu & derivatives

```bash
cd /home/jobin/playground/post_install
./make_life_easy.sh
```

if running on WSL

```bash
WSL=1 $HOME/make_life_easy.sh
```

### Install packages manually

- `sudo apt-get -y install alacritty tmux zoxide git`
- [pyenv](https://github.com/pyenv/pyenv)
- [nvm](https://github.com/nvm-sh/nvm)
- [rust](https://rustup.rs/)
- [neovim](https://github.com/neovim/neovim)
- [starship](https://starship.rs/)

## Ansible Pull

- `sudo pacman -S git ansible wl-clipboard`
- `ansible-pull -K -U https://github.com/jobin-nelson/config-setup`
