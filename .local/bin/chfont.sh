#!/usr/bin/env bash
#
#  ██████╗██╗  ██╗███████╗ ██████╗ ███╗   ██╗████████╗
# ██╔════╝██║  ██║██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝
# ██║     ███████║█████╗  ██║   ██║██╔██╗ ██║   ██║
# ██║     ██╔══██║██╔══╝  ██║   ██║██║╚██╗██║   ██║
# ╚██████╗██║  ██║██║     ╚██████╔╝██║ ╚████║   ██║
#  ╚═════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝
#


FONT="${FONT:-}"

function get_font() {
  declare -a FONTS

  FONTS=(
    'JetBrainsMono Nerd Font'
    'MesloLGS Nerd Font'
    'Hack Nerd Font'
    'SauceCodePro Nerd Font'
    'CaskaydiaCove Nerd Font'
    'Hasklug Nerd Font'
    'UbuntuMono Nerd Font'
    'FiraCode Nerd Font'
    'RobotoMono Nerd Font'
    'RecMonoCasual Nerd Font'
    'RecMonoSmCasual Nerd Font'
    'RecMonoDuotone Nerd Font'
    'RecMonoLinear Nerd Font'
    'GeistMono Nerd Font'
    'Iosevka Nerd Font'
    'Maple Mono'
  )

  FONT=$(printf '%s\n' "${FONTS[@]}" \
    | fzf --prompt 'Edit font: ' --layout=reverse --height='50%')
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
    || [[ $FONT == 'SauceCodePro Nerd Font' ]] \
    || [[ $FONT == 'FiraCode Nerd Font' ]]; then
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
    'UbuntuMono Nerd Font')        sed -i 's/^size .*/size = 13.5/' "${alacritty_file}" ;;
    'JetBrainsMono Nerd Font')     sed -i 's/^size .*/size = 13/' "${alacritty_file}" ;;
    'SauceCodePro Nerd Font')      sed -i 's/^size .*/size = 11.3/' "${alacritty_file}" ;;
    'CaskaydiaCove Nerd Font')     sed -i 's/^size .*/size = 13.5/' "${alacritty_file}" ;;
    'RobotoMono Nerd Font')        sed -i 's/^size .*/size = 12/' "${alacritty_file}" ;;
    Rec*\ Nerd\ Font)              sed -i 's/^size .*/size = 12/' "${alacritty_file}" ;;
    *)                             sed -i 's/^size .*/size = 14/' "${alacritty_file}" ;;
  esac
}

function set_kitty_style() {
  sed -i 's/^\(font_family.*style=\)"[^"]*"/\1"Regular"/' "${kitty_file}"
  sed -i 's/^\(italic_font.*style=\)"[^"]*"/\1"Italic"/' "${kitty_file}"
  if [[ $FONT == 'JetBrainsMono Nerd Font' ]] \
    || [[ $FONT == 'SauceCodePro Nerd Font' ]] \
    || [[ $FONT == 'Hasklug Nerd Font' ]] \
    || [[ $FONT == 'FiraCode Nerd Font' ]]; then
    sed -i 's/^\(font_family.*style=\)"[^"]*"/\1"Medium"/' "${kitty_file}"
    sed -i 's/^\(italic_font.*style=\)"[^"]*"/\1"Medium Italic"/' "${kitty_file}"
  fi
}

function set_kitty_size() {
  case "$FONT" in
    'SauceCodePro Nerd Font')      sed -i 's/^\(font_size\) .*/\1 12.6/' "${kitty_file}" ;;
    'CaskaydiaCove Nerd Font')     sed -i 's/^\(font_size\) .*/\1 12.3/' "${kitty_file}" ;;
    'RobotoMono Nerd Font')        sed -i 's/^\(font_size\) .*/\1 12/'   "${kitty_file}" ;;
    Rec*\ Nerd\ Font)              sed -i 's/^\(font_size\) .*/\1 11.6/' "${kitty_file}" ;;
    *)                             sed -i 's/^\(font_size\) .*/\1 11.3/' "${kitty_file}" ;;
  esac
}

function set_kitty_font() {
  local kitty_file ff
  local -a font_families

  kitty_file="$HOME/.config/kitty/kitty.conf"
  font_families=(
    font_family
    bold_font
    italic_font
    bold_italic_font
  )
  for ff in "${font_families[@]}"; do
    sed -i 's/^\('"${ff}"'\s*family=\)"[^"]*"/\1"'"${FONT}"'"/1' "${kitty_file}"
  done

  set_kitty_style
  set_kitty_size

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

