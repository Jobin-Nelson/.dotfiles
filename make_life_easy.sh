#!/bin/bash

# Install packages
echo "Installing packages..."
sudo apt-get -y install alacritty tmux zoxide git ripgrep fzf

# Starship prompt
echo "Setting up starship prompt..."
curl -sS https://starship.rs/install.sh | sh

echo "Done!!!"
exit 0 
