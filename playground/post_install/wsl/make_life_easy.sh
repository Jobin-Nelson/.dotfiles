#!/bin/bash

function banner() {
    local termwidth padding_len padding 
    termwidth="$(tput cols)"
    padding_len="$(( (termwidth - 2 - ${#1})/2 ))" 
    padding=$(printf '%0.1s' ={1..500})

    tput setaf 3
    printf '※%.0s' ※$(seq 1 "${termwidth}")
    echo
    printf '%*.*s %s %*.*s\n' 0 "${padding_len}" "${padding}" "$1" 0 "${padding_len}" "${padding}"
    printf '※%.0s' ※$(seq 1 "${termwidth}")
    echo -e "\n"
    tput sgr0
}

function install_packages() {
    banner 'Installing packages'
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
        fzf \
        ripgrep \
        shellcheck \
        jq
}

function install_pyenv_nvm_rustup() {
    # Installing Pyenv
    banner 'Installing pyenv'
    curl https://pyenv.run | bash

    # Installing NVM
    banner 'Installing nvm'
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh" | bash

    # Install Rustup
    banner 'Installing rustup'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Starship prompt
    banner 'Installing starship prompt'
    curl -sS "https://starship.rs/install.sh" | sh

    # Setting up pyenv, nvm, rust-analyzer
    banner 'Sourcing .bashrc'
    . "$HOME/.bashrc"
}

function setup_python_node_rustanalyzer() {
    banner 'Installing python'
    pyenv install 3.11.1 && pyenv global 3.11.1

    banner 'Installing node'
    nvm install node && nvm use node

    banner 'Installing rust-analyzer'
    rustup component run rust-analyzer
}

function install_neovim() {
    banner 'Installing Neovim'
    curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb -o "$NEOVIM"
    sudo dpkg -i "$NEOVIM"
    rm "$NEOVIM"
}

function install_fonts() {
    local FONTS BASE_URL DOWNLOAD_DIR FONT_DIR
    banner 'Installing Fonts'
    FONTS=(
        'JetBrainsMono'
        'Hack'
        'Meslo'
        'SourceCodePro'
    )

    BASE_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2'
    DOWNLOAD_DIR="$HOME/Downloads"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "${DOWNLOAD_DIR}" "${FONT_DIR}" 

    for font in "${FONTS[@]}"; do
        echo -e "\nDownloading font ${font}\n"
        curl -L "${BASE_URL}/${font}.zip" -o "${DOWNLOAD_DIR}/${font}.zip"

        echo -e "\nExtracting font ${font}\n"
        unzip "${DOWNLOAD_DIR}/${font}.zip" -d "${FONT_DIR}/${font}" -x '*Windows*'
        rm "${DOWNLOAD_DIR}/${font}.zip"
    done

    fc-cache
}

function setup_repos() {
    local REPOS PROJECT_DIR
    banner 'Setting Up Repositories'
    REPOS=(
        'leet_daily'
        'second_brain'
        'email_updater'
        'aoclib'
        'exercism_rust_track'
        'todo'
    )

    PROJECT_DIR="$HOME/playground/projects"

    mkdir -p "${PROJECT_DIR}"

    for repo in "${REPOS[@]}"; do
        git clone --depth 1 "git@github.com:Jobin-Nelson/${repo}" "${PROJECT_DIR}/${repo}"
    done

    git clone --depth 1 "git@github.com:Jobin-Nelson/learn" "$HOME/playground/learn"
}

function download_wallpapers() {
    local WALLPAPERS DOWNLOAD_DIR
    banner 'Downloading Wallpapers'
    WALLPAPERS=(
        'https://w.wallhaven.cc/full/m9/wallhaven-m96d8m.jpg'
        'https://w.wallhaven.cc/full/49/wallhaven-49m5d1.jpg'
    )
    DOWNLOAD_DIR="$HOME/Pictures/wallpapers"
    mkdir -p "$DOWNLOAD_DIR"

    for wallpaper in "${WALLPAPERS[@]}"; do
        curl "$wallpaper" -o "${DOWNLOAD_DIR}/${wallpaper##*/}"
    done
}

function configure_pop_os() {
    banner 'Configuring POP-OS'
    # echo 1 | sudo tee '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpapers/wallhaven-m96d8m.jpg"
    sudo apt-get install alacritty zathura mpv 
}

function install_i3wm() {
    sudo apt-get install -y \
        i3 \
        i3lock \
        polybar \
        dmenu \
        alacritty \
        feh \
        brightnessctl \
        compton

    sudo usermod -aG video "${USER}"
}

function main() {
    local OPEN_SOURCE_DIR NEOVIM
    OPEN_SOURCE_DIR="$HOME/playground/open_source"
    NEOVIM="$HOME/Downloads/nvim-linux64.deb"

    install_packages
    install_pyenv_nvm_rustup
    setup_python_node_rustanalyzer
    install_neovim
    setup_repos

    [[ -z $WSL ]] || return 0

    install_fonts
    download_wallpapers
    configure_pop_os
    install_i3wm

    banner 'Setup Done!!!'
}

main

