#!/bin/bash

# Install packages
echo "Installing packages..."
sudo apt-get update && sudo apt-get -y full-upgrade
sudo apt-get -y install alacritty tmux zoxide git ripgrep

echo "Done!!!"
exit 0 
