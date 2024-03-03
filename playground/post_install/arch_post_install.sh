#!/bin/bash

function banner() {
	local termwidth padding_len padding
	termwidth="$(tput cols)"
	padding_len="$(((termwidth - 2 - ${#1}) / 2))"
	padding=$(printf '%0.1s' ={1..500})

	tput setaf 3
	printf '※%.0s' ※$(seq 1 "${termwidth}")
	echo
	printf '%*.*s %s %*.*s\n' 0 "${padding_len}" "${padding}" "$1" 0 "${padding_len}" "${padding}"
	printf '※%.0s' ※$(seq 1 "${termwidth}")
	echo -e "\n"
	tput sgr0
}

function update_packages() {
	banner 'Updating Packages'
	sudo pacman -Syyu --noconfirm
}

function install_rust() {
	banner 'Installing rust'
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. "$HOME/.cargo/env"
	rustup component add rust-analyzer
}

function setup_aur() {
	banner 'Setting up AUR'
	local PARU_DIR

	PARU_DIR="$HOME/playground/open_source/paru"

	mkdir -pv "${PARU_DIR%/*}"

	sudo pacman -Sy --needed --noconfirm base-devel git

	git clone 'https://aur.archlinux.org/paru.git' "${PARU_DIR}"
	cd "${PARU_DIR}" && makepkg -si
}

function configure_package_manager() {
	banner 'Configuring package managers'
	sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j8"/' /etc/makepkg.conf
	sudo sed -i "
        s/^#Color/Color/
        s/^#ParallelDownloads.*/ParallelDownloads = 5/
    " /etc/pacman.conf
}

function install_packages() {
	banner 'Installing packages'
	sudo pacman -Sy --noconfirm \
		pyenv man-db man-pages curl unzip tmux zoxide fzf ripgrep fd nsxiv \
		shellcheck jq neovim vim alacritty zathura zathura-pdf-mupdf mpv tk \
		starship cronie podman aria2 rsync pacman-contrib netcat neofetch \
		ttf-jetbrains-mono-nerd ttf-hack-nerd ttf-meslo-nerd ttf-sourcecodepro-nerd \
    syncthing net-tools 

	paru -S --noconfirm \
		nvm visual-studio-code-bin

	flatpak install \
		com.google.Chrome \
		com.brave.Browser \
		com.github.IsmaelMartinez.teams_for_linux \
		com.github.tchx84.Flatseal \
		org.gnome.Boxes

	# To setup man pages
	mandb

	# Enable services
	systemctl enable --now cronie.service
	systemctl enable --now "syncthing@${USER}"
}

function install_astronvim() {
	banner 'Installing Astronvim'
	local CONFIG_DIR

	CONFIG_DIR="$HOME/.config/nvim"

	git clone --depth 1 https://github.com/AstroNvim/AstroNvim "${CONFIG_DIR}" &&
		git clone --depth 1 git@github.com:Jobin-Nelson/astronvim_config.git "${CONFIG_DIR}/lua/user"
}

function install_lazyvim() {
	banner 'Installing LazyVim'
	local CONFIG_DIR

	CONFIG_DIR="$HOME/.config/nvim"

	git clone --depth 1 git@github.com:Jobin-Nelson/lazyvim_config.git "${CONFIG_DIR}"
}

function install_neovim() {
	banner 'Install Neovim'
	sudo pacman -S --noconfirm neovim
	# local DOWNLOAD_DIR NEOVIM_DIR

	# DOWNLOAD_DIR="$HOME/Downloads"
	# NEOVIM_DIR="${DOWNLOAD_DIR}/nvim-linux64"

	# curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -o "${NEOVIM_DIR}.tar.gz"
	# tar -xzvf "${NEOVIM_DIR}.tar.gz" -C "${DOWNLOAD_DIR}"
	# sudo mv "${NEOVIM_DIR}/bin/nvim" /usr/bin/
	# rm -rf "${NEOVIM_DIR}" "${NEOVIM_DIR}.tar.gz"
}

function install_doom_emacs() {
	banner 'Installing Emacs'

	sudo pacman -Sy --needed --noconfirm \
		emacs ripgrep fd

	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
	~/.config/emacs/bin/doom install
}

function install_python() {
	banner 'Installing python'
	pyenv install 3.11 && pyenv global 3.11
	curl -sSL https://install.python-poetry.org | python3 -
}

function setup_repos() {
	banner 'Setting Up Repositories'
	local REPOS PROJECT_DIR RUST_BINARIES
	REPOS=(
		'learn'
		'leet_daily'
		'email_updater'
		'aoclib'
		'exercism_rust_track'
		'todo'
		'waldl'
		'org_files'
	)

	RUST_BINARIES=(
		'todo'
		'waldl'
		'leet_daily'
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

function install_recursive_font() {
	local RECURSIVE_LINK DOWNLOAD_DIR FONT_DIR

	RECURSIVE_LINK='https://github.com/arrowtype/recursive/releases/download/v1.085/ArrowType-Recursive-1.085.zip'
	RECURSIVE_FONT="${RECURSIVE_LINK##*/}"
	DOWNLOAD_DIR="$HOME/Downloads"
	FONT_DIR="$HOME/.local/share/fonts"

	curl -L "${RECURSIVE_LINK}" -o "${DOWNLOAD_DIR}/${RECURSIVE_FONT}"
	unzip "${DOWNLOAD_DIR}/${RECURSIVE_FONT}" '*RecMono*' -d "${FONT_DIR}/${RECURSIVE_FONT%.zip}"
	rm "${DOWNLOAD_DIR}/${RECURSIVE_FONT}"
}

function install_fonts() {
	banner 'Installing Fonts'
	local FONTS BASE_URL DOWNLOAD_DIR FONT_DIR
	FONTS=(
		'JetBrainsMono'
		'Hack'
		'Meslo'
		'SourceCodePro'
		'CascadiaCode'
		'UbuntuMono'
	)

	BASE_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1'
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

	install_recursive_font

	fc-cache
}

function configure_gnome() {
	banner 'Configuring Gnome'
	# echo 1 | sudo tee '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
	gsettings set org.gnome.shell.app-switcher current-workspace-only true
	gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpapers/wallhaven-m96d8m.jpg"
	gsettings set org.gnome.TextEditor keybindings 'vim'
}

function switch_to_integrated_graphics() {
	banner 'Switching to integrated graphics'
	paru -S --noconfirm envycontrol
	envycontrol -s integrated
}

function switch_to_X11() {
	banner 'Switching to X11'
	sudo sed -Ei 's/#(WaylandEnable=false)/\1/' /etc/gdm/custom.conf
}

function install_hyprland() {
	banner 'Installing Hyprland window manager'

	paru -S --noconfirm \
		hyprland dunst polkit-kde-agent waybar wl-clipboard \
		hyprpaper grim slurp brightnessctl wlr-randr swaylock rofi
}

function setup_done() {
	banner 'Setup Done!!!'

	echo -e '\nRestart System for changes to take effect\n'
}

function main() {

	update_packages
	install_rust
	setup_aur
	configure_package_manager
	install_packages
	# install_astronvim
	# install_lazyvim
	install_neovim
	# install_doom_emacs
	install_python
	setup_repos
	download_wallpapers
	# install_fonts
	configure_gnome
	switch_to_integrated_graphics
	# switch_to_X11
	# install_hyprland
	setup_done
}

main
