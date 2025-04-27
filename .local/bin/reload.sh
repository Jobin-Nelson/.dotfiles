#!/usr/bin/env bash

function help() {
  echo
  echo "This script reloads anything"
  echo 
  echo "Syntax: ${0##*/} [-h|w <wallpaper>|g|b]"
  echo 'options:'
  echo 'h   Print this [h]elp'
  echo 'b   Reload waybar'
  echo 'w   Set wallpaper'
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

function set_wallpaper() {
  local wallpaper=$1
  case "${XDG_CURRENT_DESKTOP}" in
    'Hyprland') hyprpaper "${wallpaper}" ;;
    'KDE') kde_wallpaper "${wallpaper}" ;;
    'GNOME') gnome_wallpaper "${wallpaper}" ;;
    *) bail 'Could not detect current desktop'
  esac
}

function bail() {
  echo "$1"
  exit 1
}


function kde_wallpaper() {
  local wallpaper=$1

  qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
                                     "org.kde.image",
                                     "General");
        d.writeConfig("Image", "'"${wallpaper}"'")
    }}
  '
}

function gnome_wallpaper() {
  local wallpaper=$1

  gsettings set org.gnome.desktop.background picture-uri-dark "file://${wallpaper}"
}

while getopts 'hw:gb' option; do
  case $option in
    h) help ;;
    w) set_wallpaper "${OPTARG}" ;;
    b) [[ $XDG_CURRENT_DESKTOP == 'Hyprland' ]] && waybar ;;
    g) command -v gpg &>/dev/null && gpg_agent ;;
    *) echo "Invalid flag" && help ;;
  esac
done

(( $# == 0 )) && help
