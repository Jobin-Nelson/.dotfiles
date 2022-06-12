#!/bin/bash

# Install packages
echo "Installing packages..."
sudo apt-get update && sudo apt-get -y full-upgrade
sudo apt-get -y install alacritty
sudo apt-get -y install tmux

# Prepping for symlink
echo "Creating config directories..."
mkdir -p $HOME/.config/{nvim,alacritty}
[ -f $HOME/.bashrc ] && mv $HOME/.bashrc $HOME/.bashrc_backup

# Creating symlinks
echo "Symlinking config files..."
ln -sf $HOME/.dotfiles/init.lua $HOME/.config/nvim/init.lua
ln -sf $HOME/.dotfiles/alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -sf $HOME/.dotfiles/.bashrc $HOME/.bashrc
ln -sf $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf

echo "Done!!!"
exit 0 
