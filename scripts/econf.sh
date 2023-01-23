#!/bin/bash

function main() {
    local choice
    declare -a CONFIGS

    CONFIGS=(
    "alacritty - $HOME/.config/alacritty/alacritty.yml"
    "i3 - $HOME/.config/i3/config"
    "i3-status - $HOME/.config/i3/i3status.conf"
    "i3-layouts - $HOME/.config/i3/layouts"
    "polybar - $HOME/.config/polybar/config"
    "compton - $HOME/.config/compton/compton.conf"
    "bash - $HOME/.bashrc"
    "econf - $HOME/scripts/econf.sh"
    "cheatsheet - $HOME/scripts/cheatsheet.py"
    "change_brightness - $HOME/scripts/change_brightness.sh"
    "dev - $HOME/scripts/dev.sh"
    "econf - $HOME/scripts/econf.sh"
    "slay - $HOME/scripts/slay.sh"
    "tmuxify - $HOME/scripts/tmuxify.sh"
    "tpb - $HOME/scripts/tpb.sh"
    "waldl - $HOME/scripts/waldl.py"
    "make_life_easy - $HOME/make_life_easy.sh"
    "tmux - $HOME/.tmux.conf"
    "nsxiv-keyhandler - $HOME/.config/nsxiv/exec/key-handler"
    "nvim - $HOME/.config/nvim/init.lua"
    "vim - $HOME/.vimrc"
    "starship - $HOME/.config/starship.toml"
    )


    choice=$(printf '%s\n' "${CONFIGS[@]}" \
        | fzf --prompt "Edit config: " \
        | cut -d ' ' -f3)

    [[ -z $choice ]] && { echo 'Nothing selected. Aborting'; exit 1; }

    /usr/bin/nvim "${choice}"
}

main

