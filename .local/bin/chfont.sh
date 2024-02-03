#!/bin/bash

function get_font() {
  declare -a FONTS

  FONTS=(
    'JetBrainsMono Nerd Font'
    'MesloLGS Nerd Font'
    'Hack Nerd Font'
    'SauceCodePro Nerd Font'
    'Caskaydia Cove Nerd Font'
    'Ubuntu Mono Nerd Font'
    'FiraCode Nerd Font'
    'Rec Mono Semicasual'
    'Rec Mono Casual'
    'Rec Mono Duotone'
    'Rec Mono Linear'
    'GeistMono Nerd Font'
    'RobotoMono Nerd Font'
  )

  choice=$(printf '%s\n' "${FONTS[@]}" \
    | fzf --prompt 'Edit font: ' --layout=reverse --height='50%' --border --ansi)

  echo "${choice}"
}

function set_font() {
  sed -i "s/^family = .*/family = \"$font\"/" "${ALACRITTY_FILE}"

    # sed -Ei "
    # s/set [$]font '.*'/set \$font '${font}'/
    # s/font pango:.* ([0-9][0-9]?)/font pango:${font} \1/
    # " "${I3_FILE}"

    echo "Font changed to $font"
  }

  function set_style() {
    if [[ $font == 'JetBrainsMono Nerd Font' ]]; then
      sed -zi '
      s/style = "[^"]*"/style = "Medium Italic"/3
      s/style = "[^"]*"/style = "Medium"/4
      ' "${ALACRITTY_FILE}"
      return
    fi
    sed -zi '
    s/style = "[^"]*"/style = "Italic"/3
    s/style = "[^"]*"/style = "Regular"/4
    ' "${ALACRITTY_FILE}"
  }

  function set_size() {
    case "$font" in
      'Ubuntu Mono Nerd Font')       sed -i 's/^size .*/size = 12/' "${ALACRITTY_FILE}" ;;
      'JetBrainsMono Nerd Font')     sed -i 's/^size .*/size = 10/' "${ALACRITTY_FILE}" ;;
      'SauceCodePro Nerd Font')      sed -i 's/^size .*/size = 11.5/' "${ALACRITTY_FILE}" ;;
      *)                             sed -i 's/^size .*/size = 10.5/' "${ALACRITTY_FILE}" ;;
    esac
  }

  function set_kitty_font() {
    sed -i "s/^\(font_family\s*\).*/\1${font}/1" "${KITTY_FILE}"
    echo "Font changed to $font"
  }

  function main() {
    local ALACRITTY_FILE I3_FILE font

    ALACRITTY_FILE="$HOME/.config/alacritty/alacritty.toml"
    I3_FILE="$HOME/.config/i3/config"
    KITTY_FILE="$HOME/.config/kitty/kitty.conf"

    font=$(get_font)

    [[ -z $font ]] && { echo "None selected. Aborting!"; exit 1; }

    [[ $TERM == 'xterm-kitty' ]] && set_kitty_font && return

    set_font
    set_style
    set_size
  }

  main

