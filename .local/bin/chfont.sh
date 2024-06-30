#!/bin/bash


FONT="${FONT:-}"

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
    'RobotoMono Nerd Font'
    'RecMonoCasual Nerd Font'
    'RecMonoSmCasual Nerd Font'
    'RecMonoDuotone Nerd Font'
    'RecMonoLinear Nerd Font'
  )

  FONT=$(printf '%s\n' "${FONTS[@]}" \
    | fzf --prompt 'Edit font: ' --layout=reverse --height='50%' --border)
}

function set_alacritty_font() {
  local alacritty_file

  alacritty_file="$HOME/.config/alacritty/alacritty.toml"

  sed -i "s/family = .*/family = \"$FONT\"/" "${alacritty_file}"

  set_alacritty_style
  set_alacritty_size
}

function set_alacritty_style() {
  if [[ $FONT == 'JetBrainsMono Nerd Font' ]] \
    || [[ $FONT == 'RobotoMono Nerd Font' ]] \
    || [[ $FONT == 'SauceCodePro Nerd Font' ]] \
    then
    sed -zi '
    s/style = "[^"]*"/style = "Medium Italic"/3
    s/style = "[^"]*"/style = "Medium"/4
    ' "${alacritty_file}"
    return
  fi
  sed -zi '
  s/style = "[^"]*"/style = "Italic"/3
  s/style = "[^"]*"/style = "Regular"/4
  ' "${alacritty_file}"
}

function set_alacritty_size() {
  case "$FONT" in
    'Ubuntu Mono Nerd Font')       sed -i 's/^size .*/size = 13.5/' "${alacritty_file}" ;;
    'JetBrainsMono Nerd Font')     sed -i 's/^size .*/size = 13/' "${alacritty_file}" ;;
    'SauceCodePro Nerd Font')      sed -i 's/^size .*/size = 14.3/' "${alacritty_file}" ;;
    'Caskaydia Cove Nerd Font')    sed -i 's/^size .*/size = 13.5/' "${alacritty_file}" ;;
    Rec*\ Nerd\ Font)              sed -i 's/^size .*/size = 12/' "${alacritty_file}" ;;
    *)                             sed -i 's/^size .*/size = 14/' "${alacritty_file}" ;;
  esac
}

function set_kitty_font() {
  local kitty_file

  kitty_file="$HOME/.config/kitty/kitty.conf"
  sed -i "s/^\(font_family\s*\).*/\1${FONT}/1" "${kitty_file}"
  [[ -n $KITTY_PID ]] && kill -SIGUSR1 "${KITTY_PID}"
}

function set_wofi_font() {
  local wofi_file

  wofi_file="$HOME/.config/wofi/style.css"
  sed -i 's/font-family: ".*"/font-family: "'"${FONT}"'"/' "${wofi_file}"
}

function set_waybar_font() {
  local waybar_file

  waybar_file="$HOME/.config/waybar/style.css"
  sed -i "s/font-family: .*;/font-family: ${FONT};/" "${waybar_file}"

  [[ $XDG_CURRENT_DESKTOP == 'Hyprland' ]] && reload.sh -w &>/dev/null
}

function set_hyprlock_font() {
  local hyprlock_file

  hyprlock_file="$HOME/.config/hypr/hyprlock.conf"
  sed -i "s/font_family = .*/font_family = ${FONT}/" "${hyprlock_file}"
}

function main() {
  [[ -z $FONT ]] && get_font

  [[ -z $FONT ]] && { echo "None selected. Aborting!"; exit 1; }

  set_kitty_font
  set_alacritty_font
  set_wofi_font
  set_waybar_font
  set_hyprlock_font

  echo "Font changed to $FONT"
}

main

