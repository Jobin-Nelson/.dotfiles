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

function setup_aur() {
    banner 'Setting up AUR'
	local PARU_DIR

	PARU_DIR="$HOME/playground/open_source/paru"

    mkdir -pv "${PARU_DIR%/*}"

    sudo pacman -S --needed base-devel git

	git clone 'https://aur.archlinux.org/paru.git' "${PARU_DIR}"
	cd "${PARU_DIR}" && makepkg -si
}

function install_packages() {
    banner 'Installing packages'
	sudo pacman -Syyu --no-confirm \
		pyenv nodejs npm man-db man-pages curl unzip tmux zoxide fzf ripgrep \
		shellcheck jq neovim vim alacritty zathura zathura-pdf-poppler mpv tk \
        starship cronie podman aria2 rsync pacman-contrib netcat neofetch

    paru -S --no-confirm \
        brave-bin google-chrome nsxiv visual-studio-code-bin teams

	# To setup man pages
	mandb

    # Enable cron
    systemctl enable --now cronie.service
}

function install_neovim() {
    banner 'install neovim'
    local DOWNLOAD_DIR NEOVIM_DIR

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
    . "$HOME/.cargo/env"
    rustup component add rust-analyzer
}

function setup_repos() {
    banner 'Setting Up Repositories'
    local REPOS PROJECT_DIR RUST_BINARIES
    REPOS=(
        'learn'
        'leet_daily'
        'second_brain'
        'email_updater'
        'aoclib'
        'exercism_rust_track'
        'todo'
        'waldl'
    )

    RUST_BINARIES=(
        'todo'
        'waldl'
    )

    PROJECT_DIR="$HOME/playground/projects"

    mkdir -pv "${PROJECT_DIR}"

    for repo in "${REPOS[@]}"; do
        git clone --depth 1 "git@github.com:Jobin-Nelson/${repo}" "${PROJECT_DIR}/${repo}"
    done

    for binary in "${RUST_BINARIES[@]}"; do
        cargo install --path "${PROJECT_DIR}/${binary}"
    done
}

function download_wallpapers() {
    banner 'Downloading Wallpapers'
    local WALLPAPERS WALLPAPER_DIR
    WALLPAPERS=(
        'https://w.wallhaven.cc/full/m9/wallhaven-m96d8m.jpg'
        'https://w.wallhaven.cc/full/49/wallhaven-49m5d1.jpg'
    )
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
    mkdir -pv "${WALLPAPER_DIR}"

    for wallpaper in "${WALLPAPERS[@]}"; do
        curl "$wallpaper" -o "${WALLPAPER_DIR}/${wallpaper##*/}"
    done
}

function install_fonts() {
    banner 'Installing Fonts'
    local FONTS BASE_URL DOWNLOAD_DIR FONT_DIR
    FONTS=(
        'JetBrainsMono'
        'Hack'
        'Meslo'
        'SourceCodePro'
    )

    BASE_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2'
    DOWNLOAD_DIR="$HOME/Downloads"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -pv "${DOWNLOAD_DIR}" "${FONT_DIR}" 

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
    # echo 1 | sudo tee '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpapers/wallhaven-m96d8m.jpg"
}

function configure_package_manager() {
    banner 'Configuring package managers'
    sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j8"/' /etc/makepkg.conf
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
}

function switch_to_integrated_graphics() {
    banner 'Switching to integrated graphics'
	paru -S --no-confirm envycontrol
	envycontrol -s integrated
}

function switch_to_X11() {
    banner 'Switching to X11'
    sudo sed -Ei 's/#(WaylandEnable=false)/\1/' /etc/gdm/custom.conf
}

function install_hyprland() {
    banner 'Installing Hyprland window manager'

    paru -S --no-confirm \
        hyprland-git dunst polkit-kde-agent waybar-hyprland-git wl-clipboard \
        hyprpaper-git grim slurp brightnessctl wlr-randr swaylock
}

function main() {

    setup_aur
    install_packages
    install_neovim
    install_python_rust
    setup_repos
    download_wallpapers
    install_fonts
    configure_gnome
    configure_package_manager
    switch_to_integrated_graphics
    # switch_to_X11
    # install_hyprland

    banner 'Setup Done!!!'
}

main
