#!/bin/bash

function banner() {
    local termwidth padding_len padding 
    termwidth="$(tput cols)"
    padding_len="$(((termwidth - 2 - ${#1})/2))" 
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
	sudo pacman -Syyu \
		pyenv \
		nodejs \
		npm \
		man-db \
		man-pages \
		curl \
		unzip \
		tmux \
		zoxide \
		fzf \
		ripgrep \
		shellcheck \
		jq \
		neovim \
        alacritty \
        zathura \
        mpv \
        tk-dev \

	# To setup man pages
	mandb
}

function install_neovim() {
    local DOWNLOAD_DIR NEOVIM_DIR
    banner 'install neovim'

    DOWNLOAD_DIR="$HOME/Downloads"
    NEOVIM_DIR="${DOWNLOAD_DIR}/nvim-linux64"

	curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -o "${NEOVIM_DIR}.tar.gz"
    tar -xzvf "${NEOVIM_DIR}.tar.gz" -C "${DOWNLOAD_DIR}" 
    sudo mv "${NEOVIM_DIR}/bin/nvim" /usr/bin/
    rm -rf "${NEOVIM_DIR}" "${NEOVIM_DIR}.tar.gz"
}

function install_python_rust() {
    banner 'Installing python'
    pyenv install 3.11.1 && pyenv global 3.11.1

    banner 'Installing rust'
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    banner 'Installing rust analyzer'
    local OPEN_SOURCE_DIR RUST_ANALYZER_DIR

	OPEN_SOURCE_DIR="$HOME/playground/open_source"
	RUST_ANALYZER_DIR="${OPEN_SOURCE_DIR}/rust-analyzer"

	mkdir -p "${OPEN_SOURCE_DIR}" 
	git clone --depth 1 https://github.com/rust-lang/rust-analyzer.git "${RUST_ANALYZER_DIR}" && \
		cd "${RUST_ANALYZER_DIR}" || exit 1
	cargo xtask install --server
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

function configure_gnome() {
    banner 'Configuring Gnome'
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpapers/wallhaven-m96d8m.jpg"
}

function setup_aur() {
    banner 'Setting up AUR'
	local OPEN_SOURCE_DIR AUR_DIR

	OPEN_SOURCE_DIR="$HOME/playground/open_source"
	AUR_DIR="${OPEN_SOURCE_DIR}/yay"

	git clone 'https://aur.archlinux.org/yay.git' "${AUR_DIR}"
	cd "${AUR_DIR}" && makepkg -si
}

function switch_to_integrated_graphics() {
    banner 'Switching to integrated graphics'
	yay -s envycontrol
	envycontrol -s integrated
}

function main() {

	install_packages
    install_neovim
    install_python_rust
    setup_repos
    download_wallpapers
    install_fonts
    configure_gnome
	setup_aur
	switch_to_integrated_graphics

    banner 'Setup Done!!!'
}

main
