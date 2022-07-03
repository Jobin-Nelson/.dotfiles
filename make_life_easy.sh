#!/bin/bash

# Install packages
echo "Installing packages..."
sudo apt-get update && sudo apt-get -y full-upgrade
sudo apt-get -y install alacritty tmux zoxide git
git config --global user.name "Jobin Nelson"
git config --global user.email "jobinnelson369@gmail.com"

echo "Done!!!"
exit 0 
