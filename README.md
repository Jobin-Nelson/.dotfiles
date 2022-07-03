# Dotfiles

## Install packages
- `sudo apt-get -y install alacritty tmux zoxide git`
- [pyenv](https://github.com/pyenv/pyenv)
- [nvm](https://github.com/nvm-sh/nvm)
- [rust](https://rustup.rs/)
- [neovim](https://github.com/neovim/neovim)

## Dotfiles
- Setup ssh key with github
- `git clone --bare git@github.com:Jobin-Nelson/.dotfiles.git $HOME/.dotfiles`
- `alias df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
- `df checkout`
