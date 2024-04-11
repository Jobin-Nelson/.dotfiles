#!/bin/bash


FONT=''

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

  FONT=$(printf '%s\n' "${FONTS[@]}" \
    | fzf --prompt 'Edit font: ' --layout=reverse --height='50%' --border --ansi)
}

function set_alacritty_font() {
  sed -i "s/^family = .*/family = \"$FONT\"/" "${ALACRITTY_FILE}"

    # sed -Ei "
    # s/set [$]font '.*'/set \$font '${font}'/
    # s/font pango:.* ([0-9][0-9]?)/font pango:${font} \1/
    # " "${I3_FILE}"

    echo "Font changed to $FONT"

    set_alacritty_style
    set_alacritty_size
  }

  function set_alacritty_style() {
    if [[ $FONT == 'JetBrainsMono Nerd Font' ]] \
      || [[ $FONT == 'SauceCodePro Nerd Font' ]]; then
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

  function set_alacritty_size() {
    case "$FONT" in
      'Ubuntu Mono Nerd Font')       sed -i 's/^size .*/size = 14/' "${ALACRITTY_FILE}" ;;
      'JetBrainsMono Nerd Font')     sed -i 's/^size .*/size = 11.5/' "${ALACRITTY_FILE}" ;;
      'SauceCodePro Nerd Font')      sed -i 's/^size .*/size = 13/' "${ALACRITTY_FILE}" ;;
      *)                             sed -i 's/^size .*/size = 11.5/' "${ALACRITTY_FILE}" ;;
    esac
  }

  function set_kitty_font() {
    sed -i "s/^\(font_family\s*\).*/\1${FONT}/1" "${KITTY_FILE}" \
      && kill -SIGUSR1 "${KITTY_PID}" \
      && echo "Font changed to $FONT"
  }

  function main() {
    local ALACRITTY_FILE I3_FILE FONT

    ALACRITTY_FILE="$HOME/.config/alacritty/alacritty.toml"
    I3_FILE="$HOME/.config/i3/config"
    KITTY_FILE="$HOME/.config/kitty/kitty.conf"

    get_font

    [[ -z $FONT ]] && { echo "None selected. Aborting!"; exit 1; }

    if [[ -n $KITTY_PID ]]; then 
      set_kitty_font
    else
      set_alacritty_font
    fi
  }

  main

