#!/usr/bin/bash

function help() {
  echo
  echo "This script reloads anything"
  echo 
  echo "Syntax: ${0##*/} [-h|w|p <wallpaper>|g]"
  echo 'options:'
  echo 'h   Print this [h]elp'
  echo 'w   Reload waybar'
  echo 'p   Reload hyprpaper'
  echo 'g   Reload gpg-agent'
  echo
}

function waybar() {
  killall waybar
  /usr/bin/waybar &
}

function hyprpaper() {
  local wallpaper

  wallpaper=$1
  hyprctl hyprpaper unload all \
    && hyprctl hyprpaper preload "${wallpaper}" \
    && hyprctl hyprpaper wallpaper "eDP-1,${wallpaper}" 

    sed -i "
    s|^\(preload = \).*|\1$wallpaper|
    s|^\(wallpaper = ,\).*|\1$wallpaper|
    " "$HOME/.config/hypr/hyprpaper.conf"

    [[ "${wallpaper: -4}" == ".png" ]] && sed -i "
    s|\(path = \)[^#]*|\1$wallpaper |
    " "$HOME/.config/hypr/hyprlock.conf"
}

function gpg_agent() {
  gpg-connect-agent reloadagent /bye
}

while getopts 'hwp:g' option; do
  case $option in
    h) help ;;
    w) waybar ;;
    p) hyprpaper "${OPTARG}";;
    g) gpg_agent ;;
    *) 
      echo "Invalid flag"
      help
      ;;
  esac
done

(( $# == 0 )) && help
