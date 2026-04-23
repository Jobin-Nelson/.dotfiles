#!/usr/bin/env bash
#
#  █████╗ ██████╗  ██████╗██╗  ██╗    ██████╗  ██████╗ ███████╗████████╗
# ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝
# ███████║██████╔╝██║     ███████║    ██████╔╝██║   ██║███████╗   ██║
# ██╔══██║██╔══██╗██║     ██╔══██║    ██╔═══╝ ██║   ██║╚════██║   ██║
# ██║  ██║██║  ██║╚██████╗██║  ██║    ██║     ╚██████╔╝███████║   ██║
# ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚══════╝   ╚═╝
#
# ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
# ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
# ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
# ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
# ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
# ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
#

set -euo pipefail

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

usage() {
  local script

  script=$(basename "${BASH_SOURCE[0]}")

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v] [-d]

DESCRIPTION
    Arch post install script

OPTIONS
    -h, --help          Print this help and exit
    -v, --verbose       Print script debug info
    -a, --all           Setup all
    -d, --dotfiles      Setup dotfiles
    -p, --packages      Install all packages
    -n, --nvm           Install node version manager
    -r, --rust          Install rust
    -g, --gnome         Configure gnome
    -w, --wallpapers    Download wallpapers
    -f, --firewall      Setup firewall
    --nvidia            Install nvidia drivers
    --hyprland          Install hyprland

EXAMPLES
    ${script} -d

EOF
  exit
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

banner() {
  local termwidth padding_len padding
  termwidth="$(tput cols)"
  padding_len="$(((termwidth - 2 - ${#1}) / 2))"
  padding=$(printf '%0.1s' ={1..500})

  tput setaf 3
  printf '※%.0s' ※$(seq 1 "${termwidth}")
  echo
  printf '%*.*s %s %*.*s\n' 0 "${padding_len}" "${padding}" "$1" 0 "${padding_len}" "${padding}"
  printf '※%.0s' ※$(seq 1 "${termwidth}")
  echo
  tput sgr0
}

msg() {
  echo >&2 -e "${GREEN}${1-}${NOFORMAT}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${RED}${msg}${NOFORMAT}"
  exit "$code"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Installs                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

update_packages() {
  banner 'Updating Packages'
  sudo pacman -Syyu --noconfirm
}

install_rust() {
  banner 'Installing rust'
  sudo pacman -Sy --needed --noconfirm \
    rustup

  rustup default stable
  cargo install --locked bacon bacon-ls
}

install_language_server_packages() {
  banner 'Installing LSPs'
  sudo pacman -Sy --noconfirm --needed \
    marksman \
    bash-language-server shfmt shellcheck \
    lua-language-server \
    vscode-json-languageserver yaml-language-server \
    prettier tailwindcss-language-server

  paru -S --noconfirm --needed \
    emmet-language-server vtsls
}

install_dev_packages() {
  banner 'Installing Dev packages'
  sudo pacman -Sy --noconfirm --needed \
    git tmux vim neovim zoxide fzf ripgrep fd bat jq \
    github-cli delta lazydocker lazygit just \
    tree-sitter-cli bash-completion

  paru -S --noconfirm --needed \
    lazysql-bin resterm-bin
}

install_ai_packages() {
  banner 'Installing AI packages'
  sudo pacman -Sy --noconfirm --needed \
    opencode

  # claude code
  curl -fsSL https://claude.ai/install.sh | bash

  # openspec
  install_nvm
  npm install -g @fission-ai/openspec@latest

  # pi
  npm install -g @mariozechner/pi-coding-agent
  pi install npm:pi-plan-mode
  pi install npm:@aliou/pi-guardrails
}

install_base_packages() {
  sudo pacman -Sy --noconfirm --needed \
    man-db man-pages curl unzip \
    kitty nsxiv zathura zathura-pdf-mupdf tree pass \
    starship cronie aria2 rsync pacman-contrib netcat fastfetch \
    wf-recorder wl-clipboard \
    proton-vpn-gtk-app net-tools ufw \
    newsboat googleworkspace-cli zip \
    aerc pandoc

  # To setup man pages
  mandb

  # Enable services
  systemctl enable --now cronie.service

  # Setup desktop ui for kitty
  kitten desktop-ui enable-portal
}

install_container_packages() {
  banner 'Installing container packages'
  sudo pacman -Sy --noconfirm --needed \
    podman docker docker-buildx docker-compose
}

install_font_packages() {
  banner 'Installing fonts'
  sudo pacman -Sy --noconfirm --needed \
    ttf-jetbrains-mono-nerd \
    ttf-hack-nerd \
    ttf-meslo-nerd \
    ttf-sourcecodepro-nerd \
    ttf-cascadia-code-nerd \
    ttf-firacode-nerd
}

install_browser_packages() {
  banner 'Installing browsers'
  sudo pacman -Sy --noconfirm --needed \
    chromium firefox

  paru -S --noconfirm --needed \
    google-chrome
}

install_media_packages() {
  banner 'Installing media packages'
  sudo pacman -Sy --noconfirm --needed \
    mpv mpd rmpc ffmpeg yt-dlp imagemagick
}

install_aur_packages() {
  paru -S --noconfirm --needed \
    localsend-bin ufw-docker visual-studio-code-bin \
    bibata-cursor-theme
}

install_packages() {
  banner 'Installing packages'

  install_dev_packages
  install_base_packages
  install_container_packages
  install_font_packages
  install_browser_packages
  install_media_packages
  install_language_server_packages
  install_ai_packages

  install_aur_packages
}

install_astronvim() {
  banner 'Installing Astronvim'
  local nvim_dir="$HOME/.config/nvim"

  [[ -d $nvim_dir ]] && return 0
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "${nvim_dir}" &&
    git clone --depth 1 git@github.com:Jobin-Nelson/astronvim_config.git "${nvim_dir}/lua/user"
}

install_lazyvim() {
  banner 'Installing LazyVim'
  local nvim_dir="$HOME/.config/nvim"

  [[ -d $nvim_dir ]] && return 0
  git clone --depth 1 git@github.com:Jobin-Nelson/lazyvim_config.git "${nvim_dir}"
}

install_neovim() {
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

install_doom_emacs() {
  banner 'Installing Emacs'
  local emacs_dir="$HOME/.config/emacs"

  sudo pacman -Sy --needed --noconfirm \
    emacs ripgrep fd

  [[ -d $emacs_dir ]] && return 0
  git clone --depth 1 https://github.com/doomemacs/doomemacs "${emacs_dir}" &&
    "${emacs_dir}/bin/doom" install
}

install_python() {
  banner 'Installing python'

  sudo pacman -Sy --needed --noconfirm \
    python-uv ruff pyright
}

install_nvm() {
  banner 'Installing Node Version Manager'
  command -v nvm &>/dev/null && return 0
  sudo pacman -S --noconfirm --needed \
    nvm
  # shellcheck disable=SC1091
  source /usr/share/nvm/init-nvm.sh
  nvm install node --latest-npm
}

install_fonts() {
  banner 'Installing Fonts'
  local base_url download_dir font_dir
  local -a fonts
  fonts=(
    'JetBrainsMono'
    'Hack'
    'Meslo'
    'SourceCodePro'
    'CascadiaCode'
    'UbuntuMono'
    'Recursive'
  )

  base_url='https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1'
  download_dir="$HOME/Downloads"
  font_dir="$HOME/.local/share/fonts"
  mkdir -pv "${download_dir}" "${font_dir}"

  for font in "${fonts[@]}"; do
    echo -e "\nDownloading font ${font}\n"
    curl -L "${base_url}/${font}.zip" -o "${download_dir}/${font}.zip"

    echo -e "\nExtracting font ${font}\n"
    unzip "${download_dir}/${font}.zip" -d "${font_dir}/${font}" -x '*Windows*'
    rm "${download_dir}/${font}.zip"
  done

  fc-cache
}

install_awesome() {
  banner 'Installing Awesome window manager'

  sudo pacman -S --noconfirm --needed \
    xorg-server xorg-xinit awesome nitrogen ly \
    brightnessctl pipewire-pulse pipewire-alsa awesome \
    xclip
}

install_nvidia() {
  banner 'Installing Nvidia'
  install_nvidia_drivers
  # install_nvidia_container
  install_vulkan
}

install_vulkan() {
  # Install Vulkan drivers matching detected GPU hardware
  # (NVIDIA Vulkan is handled by nvidia.sh via nvidia-utils)

  local -A vulkan_drivers=(
    [Intel]=vulkan-intel
    [AMD]=vulkan-radeon
    [Apple]=vulkan-asahi
  )

  local -a packages=()

  local vendor
  for vendor in "${!vulkan_drivers[@]}"; do
    if lspci | grep -iE "(VGA|Display).*$vendor" >/dev/null; then
      packages+=("${vulkan_drivers[$vendor]}")
    fi
  done

  if ((${#packages[@]} > 0)); then
    sudo pacman -S --noconfirm --needed "${packages[@]}"
  fi
}

install_nvidia_drivers() {
  lspci | grep -iq nvidia && return 0

  # Turing (16xx, 20xx), Ampere (30xx), Ada (40xx), and newer recommend the open-source kernel modules
  local nvidia_driver_package
  if lspci | grep -iq nvidia | grep -qE "RTX [2-9][0-9]|GTX 16"; then
    nvidia_driver_package='nvidia-open-dkms'
  else
    nvidia_driver_package='nvidia-dkms'
  fi

  # Check which kernel is installed and set appropriate headers package
  local kernel_headers='linux-headers'
  kernel_headers="linux-headers" # Default
  if pacman -Q linux-zen &>/dev/null; then
    kernel_headers="linux-zen-headers"
  elif pacman -Q linux-lts &>/dev/null; then
    kernel_headers="linux-lts-headers"
  elif pacman -Q linux-hardened &>/dev/null; then
    kernel_headers="linux-hardened-headers"
  fi

  # Enable multilib repository for 32-bit libraries
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
  fi

  sudo pacman -Syy

  local -a packages_to_install=(
    "${nvidia_driver_package}"
    "${kernel_headers}"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "egl-wayland"
    "libva-nvidia-driver" # for VA-API hardware acceleration
    "qt5-wayland"
    "qt6-wayland"
  )

  paru -S --needed --noconfirm "${packages_to_install[@]}"

  # Configure modprobe for early KMS
  echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

  # Configure mkinitcpio for early loading
  local mkinitcpio_conf="/etc/mkinitcpio.conf"

  # Define modules
  local nvidia_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

  # Create backup
  sudo cp -b "$mkinitcpio_conf" "${mkinitcpio_conf}.backup"

  # Remove any old nvidia modules to prevent duplicates
  sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$mkinitcpio_conf"
  # Add the new modules at the start of the MODULES array
  sudo sed -i -E "s/^(MODULES=\\()/\\1${nvidia_modules} /" "$mkinitcpio_conf"
  # Clean up potential double spaces
  sudo sed -i -E 's/  +/ /g' "$mkinitcpio_conf"

  sudo mkinitcpio -P
}

install_nvidia_container() {
  sudo pacman -Sy --noconfirm --needed \
    nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Setups                           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

setup_repos() {
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

setup_aur() {
  banner 'Setting up AUR'
  local paru_dir="$HOME/playground/open_source/paru"

  install_rust

  command -v paru &>/dev/null && return 0

  mkdir -pv "${paru_dir%/*}"

  sudo pacman -Sy --needed --noconfirm base-devel git

  git clone --depth 1 'https://aur.archlinux.org/paru.git' "${paru_dir}"
  cd "${paru_dir}" && makepkg -si
}

configure_package_manager() {
  banner 'Configuring package managers'
  sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j8"/' /etc/makepkg.conf
  sudo sed -i "
        s/^#Color/Color/
        s/^#ParallelDownloads.*/ParallelDownloads = 5/
    " /etc/pacman.conf
  grep -q '^ILoveCandy' /etc/pacman.conf ||
    sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
}

setup_dotfiles() {
  local backup_dir="$HOME/playground/backup"
  local dotfiles="$HOME/.dotfiles"

  [[ -d $dotfiles ]] && return 0

  git clone --bare --depth 5 git@github.com:Jobin-Nelson/.dotfiles.git "${dotfiles}"

  mkdir -pv "${backup_dir}" && mv -v "$HOME"/.{bash_profile,bashrc} "${backup_dir}"

  dot_git() {
    git --git-dir="${dotfiles}" --work-tree="$HOME" "${@}"
  }

  dot_git config --local status.showUntrackedFiles no

  # for vim-fugitive support
  dot_git config --local core.worktree "$HOME"
  dot_git config --local --unset core.bare

  # checkout and initialize submodules
  dot_git checkout -f
  dot_git submodule update --init --depth 5
}

download_wallpapers() {
  banner 'Downloading Wallpapers'
  local -a wallpapers=(
    'https://w.wallhaven.cc/full/m9/wallhaven-m96d8m.jpg'
    'https://w.wallhaven.cc/full/49/wallhaven-49m5d1.jpg'
  )
  local wallpaper_dir="$HOME/Pictures/wallpapers"
  mkdir -pv "${wallpaper_dir}"

  local wallpaper
  for wallpaper in "${wallpapers[@]}"; do
    curl "${wallpaper}" -o "${wallpaper_dir}/${wallpaper##*/}"
  done
}

configure_gnome() {
  banner 'Configuring Gnome'
  # echo 1 | sudo tee '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
  gsettings set org.gnome.shell.app-switcher current-workspace-only true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
  gsettings set org.gnome.TextEditor keybindings 'vim'
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings "switch-to-application-${i}" "['<Super>${i}']"
  done
}

switch_to_integrated_graphics() {
  banner 'Switching to integrated graphics'
  paru -S --noconfirm envycontrol
  envycontrol -s integrated
}

switch_to_X11() {
  banner 'Switching to X11'
  sudo sed -Ei 's/#(WaylandEnable=false)/\1/' /etc/gdm/custom.conf
}

setup_mimetypes() {
  update-desktop-database ~/.local/share/applications

  # Open directories in file manager
  # xdg-mime default org.gnome.Nautilus.desktop inode/directory

  # Open all images with imv
  xdg-mime default nsxiv.desktop image/png
  xdg-mime default nsxiv.desktop image/jpeg
  xdg-mime default nsxiv.desktop image/gif
  xdg-mime default nsxiv.desktop image/webp
  xdg-mime default nsxiv.desktop image/bmp
  xdg-mime default nsxiv.desktop image/tiff

  # Open PDFs with the Document Viewer
  xdg-mime default google-chrome.desktop application/pdf

  # Use Chromium as the default browser
  xdg-settings set default-web-browser google-chrome.desktop
  xdg-mime default google-chrome.desktop x-scheme-handler/http
  xdg-mime default google-chrome.desktop x-scheme-handler/https

  # Open video files with mpv
  xdg-mime default mpv.desktop video/mp4
  xdg-mime default mpv.desktop video/x-msvideo
  xdg-mime default mpv.desktop video/x-matroska
  xdg-mime default mpv.desktop video/x-flv
  xdg-mime default mpv.desktop video/x-ms-wmv
  xdg-mime default mpv.desktop video/mpeg
  xdg-mime default mpv.desktop video/ogg
  xdg-mime default mpv.desktop video/webm
  xdg-mime default mpv.desktop video/quicktime
  xdg-mime default mpv.desktop video/3gpp
  xdg-mime default mpv.desktop video/3gpp2
  xdg-mime default mpv.desktop video/x-ms-asf
  xdg-mime default mpv.desktop video/x-ogm+ogg
  xdg-mime default mpv.desktop video/x-theora+ogg
  xdg-mime default mpv.desktop application/ogg

  # Use Hey for mailto: links
  # xdg-mime default HEY.desktop x-scheme-handler/mailto

  # Open text files with nvim
  xdg-mime default nvim.desktop text/plain
  xdg-mime default nvim.desktop text/english
  xdg-mime default nvim.desktop text/x-makefile
  xdg-mime default nvim.desktop text/x-c++hdr
  xdg-mime default nvim.desktop text/x-c++src
  xdg-mime default nvim.desktop text/x-chdr
  xdg-mime default nvim.desktop text/x-csrc
  xdg-mime default nvim.desktop text/x-java
  xdg-mime default nvim.desktop text/x-moc
  xdg-mime default nvim.desktop text/x-pascal
  xdg-mime default nvim.desktop text/x-tcl
  xdg-mime default nvim.desktop text/x-tex
  xdg-mime default nvim.desktop application/x-shellscript
  xdg-mime default nvim.desktop text/x-c
  xdg-mime default nvim.desktop text/x-c++
  xdg-mime default nvim.desktop application/xml
  xdg-mime default nvim.desktop text/xml
}

increase_file_watchers() {
  # Increase inotify file watchers for VS Code, webpack, and other dev tools (default 8192 is too low)
  echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/90-omarchy-file-watchers.conf >/dev/null
  sudo sysctl --system >/dev/null 2>&1
}

setup_firewall() {
  systemctl disable --now ufw

  sudo ufw disable
  sudo ufw reset
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw limit ssh
  sudo ufw allow http
  sudo ufw allow https
  sudo ufw allow syncthing

  # allow for localsend
  sudo ufw allow 53317/udp
  sudo ufw allow 53317/tcp

  # Allow Docker containers to use DNS on host
  sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns'

  # Allow tailscale
  sudo ufw allow in on tailscale0

  sudo ufw --force enable

  systemctl enable ufw

  sudo ufw-docker install
  sudo ufw reload
}

increase_sudo_tries() {
  # Give the user 10 instead of 3 tries to fat finger their password before lockout
  echo "Defaults passwd_tries=10" | sudo tee /etc/sudoers.d/passwd-tries
  sudo chmod 440 /etc/sudoers.d/passwd-tries

  # Set for hyprlock too
  sudo sed -i 's/^# *deny = .*/deny = 10/' /etc/security/faillock.conf
}

setup_ssh() {
  banner 'Setting up ssh'

  mkdir -m 700 ~/.ssh
  curl -sSfL https://github.com/jobin-nelson.keys >~/.ssh/authorized_keys
}

setup_done() {
  banner 'Setup Done!!!'

  echo $'\nRestart System for changes to take effect\n'
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Hyprland                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

install_hyprland() {
  banner 'Installing Hyprland window manager'

  hypr_install_packages
  hypr_setup_walker
  hypr_setup_powerprofilesdaemon
  # hypr_setup_wifi
  setup_mimetypes
  increase_sudo_tries
  hypr_battery_optimize
  increase_file_watchers
}

hypr_install_packages() {
  sudo pacman -S --noconfirm --needed \
    hyprland hyprpaper hyprshot hypridle hyprpicker \
    hyprland-guiutils hyprpicker hyprsunset \
    xdg-desktop-portal-hyprland gnome-keyring \
    fcitx5 fcitx5-gtk fcitx5-qt \
    mako polkit-kde-agent waybar wl-clipboard \
    satty grim slurp brightnessctl hyprlock \
    swaybg swayosd bluetui wiremix btop \
    gvfs-mtp gvfs-nfs gvfs-smb \
    libreoffice-fresh uwsm \
    nautilus power-profiles-daemon
}

hypr_setup_walker() {
  # walker
  paru -S --noconfirm --needed walker elephant elephant-desktopapplications
  elephant service enable
  systemctl enable --now --user elephant.service

  # Ensure Walker service is started automatically on boot
  mkdir -p ~/.config/autostart/
  cp $HOME/.config/hypr/applications/walker/walker.desktop ~/.config/autostart/

  # And is restarted if it crashes or is killed
  mkdir -p ~/.config/systemd/user/app-walker@autostart.service.d/
  cp $HOME/.config/hypr/applications/walker/restart.conf ~/.config/systemd/user/app-walker@autostart.service.d/restart.conf

  # Create pacman hook to restart walker after updates
  sudo mkdir -p /etc/pacman.d/hooks
  sudo tee /etc/pacman.d/hooks/walker-restart.hook >/dev/null <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = walker
Target = walker-debug
Target = elephant*

[Action]
Description = Restarting Walker services after system update
When = PostTransaction
Exec = $HOME/.config/hypr/bin/hypr-restart-walker.sh
EOF

}

hypr_setup_powerprofilesdaemon() {
  if $HOME/.config/hypr/bin/hypr-battery-present.sh; then
    cat <<EOF | sudo tee "/etc/udev/rules.d/99-power-profile.rules"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="/usr/bin/systemd-run --no-block --collect --unit=hypr-power-profile-battery --property=After=power-profiles-daemon.service $HOME/.config/hypr/bin/hypr-powerprofiles-set.sh battery"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="/usr/bin/systemd-run --no-block --collect --unit=hypr-power-profile-ac --property=After=power-profiles-daemon.service $HOME/.config/hypr/bin/hypr-powerprofiles-set.sh ac"
EOF

    sudo udevadm control --reload 2>/dev/null
    sudo udevadm trigger --subsystem-match=power_supply 2>/dev/null
  fi
}

hypr_setup_wifi() {
  if $HOME/.config/hypr/bin/hypr-battery-present.sh; then
    cat <<EOF | sudo tee "/etc/udev/rules.d/99-wifi-powersave.rules"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="/usr/bin/systemd-run --no-block --collect --unit=hypr-wifi-powersave-on $HOME/.config/hypr/bin/hypr-wifi-powersave.sh on"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="/usr/bin/systemd-run --no-block --collect --unit=hypr-wifi-powersave-off $HOME/.config/hypr/bin/hypr-wifi-powersave.sh off"
EOF

    sudo udevadm control --reload
    sudo udevadm trigger --subsystem-match=power_supply
  fi
}

hypr_battery_optimize() {
  if ls /sys/class/power_supply/BAT* &>/dev/null && [[ ! -f $HOME/.config/systemd/user/hypr-battery-monitor.service ]]; then
    mkdir -p ~/.config/systemd/user

    cp $HOME/.config/hypr/hypr-battery-monitor.* ~/.config/systemd/user/

    systemctl --user daemon-reload
    systemctl --user enable --now hypr-battery-monitor.timer || true
  fi
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          MAIN                            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

main() {
  update_packages
  setup_aur
  configure_package_manager
  install_packages
  setup_dotfiles
  # install_astronvim
  # install_lazyvim
  # install_neovim
  # install_doom_emacs
  install_python
  install_nvm
  # setup_repos
  # install_fonts
  # configure_gnome
  download_wallpapers
  setup_firewall
  # switch_to_integrated_graphics
  # switch_to_X11
  install_hyprland
  install_nvidia
  setup_ssh
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

parse_params() {
  # default values of variables set from params

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -d | --dotfiles) setup_dotfiles ;;
    -p | --packages)
      setup_aur
      install_packages
      ;;
    -n | --nvm) install_nvm ;;
    -r | --rust) install_rust ;;
    -g | --gnome) configure_gnome ;;
    -w | --wallpapers) download_wallpapers ;;
    -a | --all) main ;;
    -f | --firewall) setup_firewall ;;
    --nvidia) install_nvidia ;;
    --hyprland) install_hyprland ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  [[ ${#args[@]} -eq 0 ]] || die "${0} doesn't take positional arguments"

  return 0
}

# Exit early when being sourced
[[ "${BASH_SOURCE[0]}" == "${0}" ]] || return 0

[[ $# == 0 ]] && usage
setup_colors
parse_params "$@"
