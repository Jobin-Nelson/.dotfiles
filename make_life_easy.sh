#!/bin/bash

# Install packages
echo -e '\nInstalling packages...\n'
sudo apt-get -y install \
    git \
    curl \
    libfuse2 \
    make \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    liblzma-dev \
    tk-dev \
    unzip \
    tmux \
    zoxide \
    ripgrep \
    fzf \
    shellcheck

# Installing Pyenv
echo -e '\nInstalling pyenv...\n'
curl https://pyenv.run | bash

# Installing NVM
echo -e '\nInstalling nvm...\n'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Install Rustup
echo -e '\nInstalling rustup...\n'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Starship prompt
echo -e '\nInstalling up starship prompt...\n'
curl -sS "https://starship.rs/install.sh" | sh

# Setting up pyenv, nvm, rust-analyzer
echo -e '\nSourcing .bashrc...\n'
source ~/.bashrc

pyenv update
echo -e '\nInstalling python...\n'
pyenv install 3.11.1 && pyenv global 3.11.1

echo -e '\nInstalling node...\n'
nvm install node && nvm use node

echo -e '\nInstalling rust-analyzer...\n'
mkdir -p "$HOME/playground/open_source/" && cd "$_" || exit 1
git clone --depth 1 https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer || exit 1
cargo xtask install --server

# Configuring pop-os settings
# echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode
# gsettings set org.gnome.shell.app-switcher current-workspace-only true

echo "Done!!!"
exit 0 
