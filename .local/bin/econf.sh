#!/bin/bash

function main() {
    local choice
    declare -a FILES

    FILES=(
    "alacritty - $HOME/.config/alacritty/alacritty.yml"
    "i3 - $HOME/.config/i3/config"
    "i3-status - $HOME/.config/i3/i3status.conf"
    "i3-layouts - $HOME/.config/i3/layouts"
    "polybar - $HOME/.config/polybar/config"
    "compton - $HOME/.config/compton/compton.conf"
    "bash - $HOME/.bashrc"
    "econf - $HOME/.local/bin/econf.sh"
    "cheatsheet - $HOME/.local/bin/cheatsheet.py"
    "change_brightness - $HOME/.local/bin/change_brightness.sh"
    "dev - $HOME/.local/bin/dev.sh"
    "chfont - $HOME/.local/bin/chfont.sh"
    "slay - $HOME/.local/bin/slay.sh"
    "tmuxify - $HOME/.local/bin/tmuxify.sh"
    "tpb3 - $HOME/.local/bin/tpb3.sh"
    "waldl - $HOME/.local/bin/waldl.py"
    "paclear - $HOME/.local/bin/paclear.sh"
    "make_life_easy - $HOME/playground/post_install/make_life_easy.sh"
    "tmux - $HOME/.config/tmux/tmux.conf"
    "nsxiv-keyhandler - $HOME/.config/nsxiv/exec/key-handler"
    "nvim - $HOME/.config/nvim/init.lua"
    "vim - $HOME/.vimrc"
    "starship - $HOME/.config/starship.toml"
    "arch_post_install - $HOME/playground/post_install/arch_post_install.sh"
    )


    choice=$(printf '%s\n' "${FILES[@]}" \
        | fzf --prompt "Edit config: " \
        | cut -d ' ' -f3)

    [[ -z $choice ]] && { echo 'Nothing selected. Aborting'; exit 1; }

    /usr/bin/nvim "${choice}"
}

main

