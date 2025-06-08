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
    -d, --dotfiles      Setup dotfiles
    -p, --packages      Install all packages
    -n, --nvm           Install node version manager
    -g, --gnome         Configure gnome
    -w, --wallpapers    Download wallpapers
    -a, --all           Setup all

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
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


update_packages() {
  banner 'Updating Packages'
  sudo pacman -Syyu --noconfirm
}

install_rust() {
  banner 'Installing rust'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || return 0
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
  rustup component add rust-analyzer
}

setup_aur() {
  banner 'Setting up AUR'
  local paru_dir="$HOME/playground/open_source/paru"

  install_rust

  [[ -d $paru_dir ]] && return 0

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
  grep -q '^ILoveCandy' /etc/pacman.conf \
    || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
}

setup_dotfiles() {
  local backup_dir="$HOME/playground/backup" 
  local dotfiles="$HOME/.dotfiles"

  [[ -d $dotfiles ]] && return 0

  git clone --bare --depth 5 git@github.com:Jobin-Nelson/.dotfiles.git "${dotfiles}"

  mkdir -pv "${backup_dir}" && mv -v "$HOME"/.{bash_profile,bashrc} "${backup_dir}"
  git --git-dir="${dotfiles}" --work-tree="$HOME" config --local status.showUntrackedFiles no
  git --git-dir="${dotfiles}" --work-tree="$HOME" checkout -f
  git --git-dir="${dotfiles}" --work-tree="$HOME" submodule update --init --depth 5
}

install_packages() {
  banner 'Installing packages'
  sudo pacman -Sy --noconfirm \
    git man-db man-pages curl unzip tmux zoxide fzf ripgrep fd bat nsxiv \
    jq neovim vim alacritty zathura zathura-pdf-mupdf mpv \
    starship cronie podman aria2 rsync pacman-contrib netcat fastfetch \
    ttf-jetbrains-mono-nerd ttf-hack-nerd ttf-meslo-nerd ttf-sourcecodepro-nerd \
    syncthing net-tools bash-completion ufw pandoc \
    marksman\
    bash-language-server shfmt shellcheck \
    pyright \
    lua-language-server \
    vscode-json-languageserver yaml-language-server \
    github-cli

  flatpak install \
    com.visualstudio.code \
    com.google.Chrome \
    com.github.tchx84.Flatseal \
  #   org.gnome.Boxes

  # To setup man pages
  mandb

  # Enable services
  systemctl enable --now cronie.service
  systemctl enable --now "syncthing@${USER}"

  # paru -S --noconfirm \
  #   visual-studio-code-bin google-chrome
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
  command -v uv &>/dev/null && return 0
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_nvm() {
  banner 'Installing Node Version Manager'
  command -v nvm &>/dev/null && return 0
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | NVM_DIR="$HOME/.config/nvm" PROFILE=/dev/null bash
  # shellcheck disable=SC1091
  . "$HOME/.config/nvm/nvm.sh" && nvm install node && nvm install-latest-npm
}

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

configure_gnome() {
  banner 'Configuring Gnome'
  # echo 1 | sudo tee '/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
  gsettings set org.gnome.shell.app-switcher current-workspace-only true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
  gsettings set org.gnome.TextEditor keybindings 'vim'

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

install_hyprland() {
  banner 'Installing Hyprland window manager'

  sudo pacman -S --noconfirm --needed \
    hyprland dunst polkit-kde-agent waybar wl-clipboard \
    hyprpaper grim slurp brightnessctl wlr-randr hyprlock wofi
}

install_awesome() {
  banner 'Installing Awesome window manager'

  sudo pacman -S --noconfirm --needed \
    xorg-server xorg-xinit awesome nitrogen ly \
    brightnessctl pipewire-pulse pipewire-alsa awesome \
    xclip
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
  sudo ufw enable

  systemctl enable --now ufw
}

setup_done() {
  banner 'Setup Done!!!'

  echo $'\nRestart System for changes to take effect\n'
}

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
  configure_gnome
  download_wallpapers
  setup_firewall
  # switch_to_integrated_graphics
  # switch_to_X11
  # install_hyprland
  # setup_done
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
    -p | --packages) setup_aur; install_packages ;;
    -n | --nvm) install_nvm ;;
    -g | --gnome) configure_gnome ;;
    -w | --wallpapers) download_wallpapers ;;
    -a | --all) main ;;
    -f | --firewall) setup_firewall ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  [[ ${#args[@]} -eq 0 ]] || die "${0} doesn't take positional arguments"

  return 0
}

[[ $# == 0 ]] && usage
setup_colors
parse_params "$@"

