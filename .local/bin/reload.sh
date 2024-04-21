#!/usr/bin/bash

function help() {
  echo
  echo "This script reloads anything"
  echo 
  echo "Syntax: ${0##*/} [-h|w|p <wallpaper>]"
  echo 'options:'
  echo 'h   Print this [h]elp'
  echo 'w   Reload waybar'
  echo 'p   Reload hyprpaper'
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
}

while getopts 'hwp:' option; do
  case $option in
    h) help ;;
    w) waybar ;;
    p) hyprpaper "${OPTARG}";;
    *) 
      echo "Invalid flag"
      help
      ;;
  esac
done

(( $# == 0 )) && help
