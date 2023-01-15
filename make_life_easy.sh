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
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh" | bash

# Install Rustup
echo -e '\nInstalling rustup...\n'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Starship prompt
echo -e '\nInstalling up starship prompt...\n'
curl -sS "https://starship.rs/install.sh" | sh

# Setting up pyenv, nvm, rust-analyzer
echo -e '\nSourcing .bashrc...\n'
. "$HOME/.bashrc"

pyenv update
echo -e '\nInstalling python...\n'
pyenv install 3.11.1 && pyenv global 3.11.1

echo -e '\nInstalling node...\n'
nvm install node && nvm use node

echo -e '\nInstalling rust-analyzer...\n'
OPEN_SOURCE_DIR="$HOME/playground/open_source"
mkdir -p "$OPEN_SOURCE_DIR" 
git clone --depth 1 https://github.com/rust-lang/rust-analyzer.git "$OPEN_SOURCE_DIR/rust-analyzer" && \
    cd "$OPEN_SOURCE_DIR/rust-analyzer" || exit 1
cargo xtask install --server

# Install fonts
function install_fonts() {
    FONTS=(\
        "JetBrainsMono" \
        "Hack" \
        "Meslo" \
    )

    BASE_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2'
    DOWNLOAD_DIR="$HOME/Downloads"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$DOWNLOAD_DIR" "$FONT_DIR" 

    for font in "${FONTS[@]}"; do
        echo -e "\nDownloading font ${font}\n"
        curl -L "${BASE_URL}/${font}.zip" -o "${DOWNLOAD_DIR}/${font}.zip"

        echo -e "\nExtracting font ${font}\n"
        unzip "${DOWNLOAD_DIR}/${font}.zip" -d "${FONT_DIR}/${font}" -x '*Windows*'
        rm "${DOWNLOAD_DIR}/${font}.zip"
    done
}

# Cloning useful repos
function setup_repos() {
    REPOS=(\
        "leet_daily" \
        "second_brain" \
        "email_updater" \
        "aoclib" \
        "exercism_rust_track" \
        "todo" \
    )

    PROJECT_DIR="$HOME/playground/projects"

    mkdir -p "$PROJECT_DIR"

    for repo in "${REPOS[@]}"; do
        git clone --depth 1 "git@github.com:Jobin-Nelson/$repo" "${PROJECT_DIR}/$repo"
    done

    git clone --depth 1 "git@github.com:Jobin-Nelson/learn" "$HOME/playground/learn"
}

# Downloading favourite wallpapers
function download_wallpapers() {
    links=(\
        'https://w.wallhaven.cc/full/m9/wallhaven-m96d8m.jpg' \
        'https://w.wallhaven.cc/full/49/wallhaven-49m5d1.jpg' \
    )
    DOWNLOAD_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$DOWNLOAD_DIR"

    for link in "${links[@]}"; do
        curl "$link" -o "${DOWNLOAD_DIR}/${link##*/}"
    done
}

install_fonts
setup_repos
download_wallpapers

# Configuring pop-os settings
# echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode
# gsettings set org.gnome.shell.app-switcher current-workspace-only true
# gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpapers/wallhaven-m96d8m.jpg"

echo -e "\nSetup Done!!!\n"
exit 0 
