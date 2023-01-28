#!/bin/bash

set -euo pipefail

function get_font() {
    declare -a FONTS

    FONTS=(
    'JetBrainsMono Nerd Font'
    'MesloLGS Nerd Font'
    'Hack Nerd Font'
    'SauceCodePro Nerd Font'
    )

    choice=$(printf '%s\n' "${FONTS[@]}" | fzf)

    [[ -z $choice ]] && { echo 'No font selected, aborting'; exit 1; }

    echo "${choice}"
}

function set_font() {
    local ALACRITTY_FILE I3_FILE choice

    ALACRITTY_FILE="$HOME/.config/alacritty/alacritty.yml"
    I3_FILE="$HOME/.config/i3/config"
    choice=$1

    sed -i "s/family: .*/family: $choice/" "${ALACRITTY_FILE}"
    sed -Ei "
    s/set [$]font '.*'/set \$font '${choice}'/
    s/font pango:.* ([0-9][0-9]?)/font pango:${choice} \1/
    " "${I3_FILE}"

    echo "Font changed to $choice"
}

function main() {
    local font

    font=$(get_font)
    set_font "${font}"
}

main

