#!/bin/bash

# Install packages
sudo apt-get -y install alacritty

# Creating symlinks
ln -sf ~/.dotfiles/init.lua ~/.config/nvim/init.lua
ln -sf ~/.dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
