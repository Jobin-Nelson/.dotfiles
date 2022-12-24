#!/bin/bash

# Install packages
echo "Installing packages..."
sudo apt-get -y install alacritty tmux zoxide git ripgrep fzf

# Installing Pyenv
curl https://pyenv.run | bash

# Installing NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Install Rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Setting up Pyenv, NVM, Rustup
source ~/.bashrc

pyenv update
pyenv install 3.11.1
pyenv global 3.11.1

nvm install node
nvm use node

mkdir -p ~/playground/open_source/ && cd $_
git clone --depth 1 https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer
cargo xtask install --server

# Configuring pop-os settings
echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# Starship prompt
echo "Setting up starship prompt..."
curl -sS "https://starship.rs/install.sh" | sh

echo "Done!!!"
exit 0 
