#!/usr/bin/env bash

set -Eeuo pipefail


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# shellcheck disable=SC2034
SCRIPT_DIR="${0%/*}"

MY_THEME_DIR="$HOME/.config/my_theme"
CURRENT_THEME_DIR="${MY_THEME_DIR}/current"
DEFAULT_MARKER_FILE="${MY_THEME_DIR}/default_set"
MARKER='# MY THEME'

declare -A MY_THEME_CONFIGS=(
  [lazygit.yml]=$HOME/.config/lazygit/config.yml
  [btop.theme]=$HOME/.config/btop/themes/current.theme
  [mako.ini]=$HOME/.config/mako/config
  [opencode.json]=$HOME/.config/opencode/themes/current.json
  [pi.json]=$HOME/.config/pi/agent/themes/current.json
  [nvim.vim]=$HOME/.config/nvim/colors/current.vim
)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


usage() {
  local script="${0%%*/}"

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v]

DESCRIPTION
    Manage and set themes

OPTIONS
    -h   Print this [h]elp and exit
    -v   Print [v]erbose info
    -s   [S]et theme
    -d   Set [d]efault theme
    -D   Unset [d]efault theme
    -r   [R]estart apps

EXAMPLES
    ${script} -h

EOF
  exit 0
}

bail() {
  echo "$1"
  echo $'Aborting...\n'
  exit "${2-1}"
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


set_theme() {
  unset_default
  prepare_theme "${1}"
  set_theme_config
  restart_apps
}

set_theme_config() {
  local config target_config source_config
  for config in "${!MY_THEME_CONFIGS[@]}"; do
    target_config="${MY_THEME_CONFIGS[$config]}"
    source_config="${CURRENT_THEME_DIR}/${config}"
    if [[ -f $source_config ]]; then
      mkdir -pv "${target_config%/*}"
      ln -sf "${source_config}" "${target_config}"
    fi
  done
}

prepare_theme() {
  local default_theme="${CURRENT_THEME_DIR##*/}"
  local next_theme='next'

  local theme="${1:-$default_theme}"
  local theme_dir="${MY_THEME_DIR}/${theme}"
  local next_theme_dir="${MY_THEME_DIR}/${next_theme}"

  [[ -d $theme_dir ]] || bail "ERROR: No ${theme} theme found"
  [[ $theme == $default_theme ]] && return 0

  rm -rf "${CURRENT_THEME_DIR}" "${next_theme_dir}"
  cp -a "${theme_dir}" "${next_theme_dir}"
  mv "${next_theme_dir}" "${CURRENT_THEME_DIR}"
}

set_default() {
  sed -i 's/\(color_theme\).*/\1 = "default"/' ~/.config/btop/btop.conf
  sed -i "/${MARKER}/,+2 { /${MARKER}/! s/^/# / }" ~/.config/delta/delta.gitconfig
  sed -i "/${MARKER}/,+1 { /${MARKER}/! s/^/# / }" ~/.bashrc
  sed -i 's/^\(include\).*/\1 current-theme.conf/' ~/.config/kitty/kitty.conf
  sed -i 's/\("theme"\).*/\1: "opencode",/' ~/.config/opencode/tui.json
  sed -i 's/\("theme"\).*/\1: "dark",/' ~/.config/pi/agent/settings.json

  local config
  for config in "${MY_THEME_CONFIGS[@]}"; do
    rm -f "${config}"
  done

  touch "${DEFAULT_MARKER_FILE}"
  restart_apps
}

unset_default() {
  [[ -f ${DEFAULT_MARKER_FILE} ]] || return 0
  sed -i 's/\(color_theme\).*/\1 = "current"/' ~/.config/btop/btop.conf
  sed -i "/${MARKER}/,+2 { /${MARKER}/! s/^# // }" ~/.config/delta/delta.gitconfig
  sed -i "/${MARKER}/,+1 { /${MARKER}/! s/^# // }" ~/.bashrc
  sed -i 's!^\(include\).*!\1 ~/.config/my_theme/current/kitty.conf!' ~/.config/kitty/kitty.conf
  sed -i 's/\("theme"\).*/\1: "current",/' ~/.config/opencode/tui.json
  sed -i 's/\("theme"\).*/\1: "current",/' ~/.config/pi/agent/settings.json

  rm -f "${DEFAULT_MARKER_FILE}"
}

restart_apps() {
  pkill -SIGUSR2 btop || true
  pkill -SIGUSR1 kitty || true
}

set_background() {
  local bg
  bg=$(find "${MY_THEME_DIR}" -type f -path '*backgrounds/*' -print0 |
    fzf --read0 --no-multi --style=full --height=90% --preview-window='60%,nohidden')
  [[ -z $bg ]] && return 0

  reload.sh -w "${bg}"
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


[[ $# == 0 ]] && usage

while getopts ":hvs:dDrb" option; do
  case $option in
  h) usage ;;
  v) set -x ;;
  s) set_theme "${OPTARG}" ;;
  d) set_default ;;
  D) unset_default ;;
  r) restart_apps ;;
  b) set_background ;;
  *) bail "Error: Invalid option" ;;
  esac
done

