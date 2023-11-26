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
        'Rec Mono Semicasual'
        'Rec Mono Casual'
        'Rec Mono Duotone'
        'Rec Mono Linear'
    )

    choice=$(printf '%s\n' "${FONTS[@]}" \
        | fzf --prompt 'Edit font: ' --layout=reverse --height='50%' --border --ansi)

    echo "${choice}"
}

function set_font() {
    sed -i "s/family: .*/family: $font/" "${ALACRITTY_FILE}"

    # sed -Ei "
    # s/set [$]font '.*'/set \$font '${font}'/
    # s/font pango:.* ([0-9][0-9]?)/font pango:${font} \1/
    # " "${I3_FILE}"

    echo "Font changed to $font"
}

function set_style() {
    if [[ $font == 'JetBrainsMono Nerd Font' ]]; then
        sed -i "
        22s/style: .*/style: Medium/
        28s/style: .*/style: Medium Italic/
        " "${ALACRITTY_FILE}"
    else
        sed -i "
        22s/style: .*/style: Regular/
        28s/style: .*/style: Italic/
        " "${ALACRITTY_FILE}"
    fi
}

function set_size() {
    case "$font" in
        'Ubuntu Mono Nerd Font')       sed -i 's/size: .*/size: 14/' "${ALACRITTY_FILE}" ;;
        'Rec Mono'*)                   sed -i 's/size: .*/size: 13/' "${ALACRITTY_FILE}" ;;
        'Caskaydia Cove Nerd Font')    sed -i 's/size: .*/size: 12/' "${ALACRITTY_FILE}" ;;
        *)                             sed -i 's/size: .*/size: 11.5/' "${ALACRITTY_FILE}" ;;
    esac
}

function main() {
    local ALACRITTY_FILE I3_FILE font

    ALACRITTY_FILE="$HOME/.config/alacritty/alacritty.yml"
    I3_FILE="$HOME/.config/i3/config"

    font=$(get_font)

    [[ -z $font ]] && { echo "None selected. Aborting!"; exit 1; }

    set_font 
    # set_style 
    set_size
}

main

