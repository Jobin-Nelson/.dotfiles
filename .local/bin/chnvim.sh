#!/usr/bin/bash

NEOVIM=''
CURRENT_DISTRO=''

function bail() {
  echo -e "\n$1"
  echo -e "Aborting...\n"
  exit 1
}

function select_neovim() {
  NEOVIM=$(find "${HOME}/.config" -maxdepth 1 -mindepth 1 -type d -iname '*vim*' \
    | fzf --prompt 'Edit nvim: ' --layout=reverse --height='50%' --border --ansi)
}

function get_current_distro() {
  local origin_url
  origin_url=$(git -C "${HOME}/.config/nvim" config remote.origin.url)
  origin_url="${origin_url%.git}"
  origin_url="${origin_url##*/}"
  case "${origin_url}" in
    lazyvim_config) CURRENT_DISTRO='lazyvim';;
    AstroNvim)      CURRENT_DISTRO='astronvim';;
    my_nvim)      CURRENT_DISTRO='my_nvim';;
    *)              bail 'No match found for nvim distribution';;
  esac
}

function change_neovim() {
  local target_distro current_distro_config

  [[ -z $NEOVIM ]] && bail  'No nvim selected'

  target_distro="${NEOVIM##*/}"
  get_current_distro
  current_distro_config="${HOME}/.config/${CURRENT_DISTRO}"

  [[ -d $current_distro_config ]] && bail "Existing config found at ${current_distro_config}"
  [[ $target_distro == 'nvim' ]] && bail "${NEOVIM} already at ${HOME}/.config/nvim"

  mv ~/.config/{nvim,"${CURRENT_DISTRO}"}
  mv ~/.local/share/{nvim,"${CURRENT_DISTRO}"}
  mv ~/.local/state/{nvim,"${CURRENT_DISTRO}"}
  mv ~/.cache/{nvim,"${CURRENT_DISTRO}"}

  mv ~/.config/{"${target_distro}",nvim}
  mv ~/.local/share/{"${target_distro}",nvim}
  mv ~/.local/state/{"${target_distro}",nvim}
  mv ~/.cache/{"${target_distro}",nvim}

  echo "${NEOVIM} successfully changed to ${HOME}/.config/nvim"
}

function main() {
  select_neovim
  change_neovim
}

main 
