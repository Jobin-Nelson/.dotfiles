#!/bin/bash

# Install packages
sudo apt-get -y install neovim
sudo apt-get -y install alacritty

# Creating symlinks
ln -sf ~/.dotfiles/init.vim ~/.config/nvim/init.vim
ln -sf ~/.dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile
