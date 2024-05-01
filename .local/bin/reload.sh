#!/usr/bin/bash

function help() {
  echo
  echo "This script reloads anything"
  echo 
  echo "Syntax: ${0##*/} [-h|w|p <wallpaper>|g|k <wallpaper>]"
  echo 'options:'
  echo 'h   Print this [h]elp'
  echo 'w   Reload waybar'
  echo 'p   Reload hyprpaper'
  echo 'g   Reload gpg-agent'
  echo 'k   Reload kde wallpaper'
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

function kde_wallpaper() {
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
        var allDesktops = desktops();
        print (allDesktops);
        for (i=0;i<allDesktops.length;i++) {{
            d = allDesktops[i];
            d.wallpaperPlugin = "org.kde.image";
            d.currentConfigGroup = Array("Wallpaper",
                                         "org.kde.image",
                                         "General");
            d.writeConfig("Image", "'"$1"'")
        }}
    '
}

while getopts 'hwp:gk:' option; do
  case $option in
    h) help ;;
    w) [[ $XDG_CURRENT_DESKTOP == 'Hyprland' ]] && waybar ;;
    p) [[ $XDG_CURRENT_DESKTOP == 'Hyprland' ]] && hyprpaper "${OPTARG}";;
    g) command -v gpg &>/dev/null && gpg_agent ;;
    k) [[ $XDG_CURRENT_DESKTOP == 'KDE' ]] && kde_wallpaper "${OPTARG}";;
    *) echo "Invalid flag" && help ;;
  esac
done

(( $# == 0 )) && help
