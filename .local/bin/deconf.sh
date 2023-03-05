#!/bin/bash

function set_gnome() {
    sed -i "
    s/.*\(alias rwl=\)/# \1/
    s/.*\(alias rwl='gsettings\)/\1/
    " "$BASHRC"

    sed -i '
    s/.*"C-w"/# "C-w"/
    s/.*\("C-w")      while read file; do gsettings\)/\1/
    ' "$NSXIV_KEY_HANDLER"
}

function set_hyprland() {
    sed -i "
    s/.*\(alias rwl=\)/# \1/
    s/.*\(alias rwl='w=\)/\1/
    " "$BASHRC"

    sed -i '
    s/.*"C-w"/# "C-w"/
    s/.*\("C-w")      while read file; do ff=\)/\1/
    ' "$NSXIV_KEY_HANDLER"
}

function main() {
    local BASHRC NSXIV_KEY_HANDLER DE

    BASHRC="$HOME/.bashrc"
    NSXIV_KEY_HANDLER="$HOME/.config/nsxiv/exec/key-handler"
    DE=$1

    if [[ $DE == 'gnome' ]]; then
        set_gnome
    elif [[ $DE == 'hyprland' ]]; then
        set_hyprland
    else
        echo 'Invalid Desktop Environment, Aborting!'
    fi
}

main "$1"


