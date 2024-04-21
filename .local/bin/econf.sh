#!/bin/bash

function main() {
    declare -a FILES
    local choice

    FILES=(
        "alacritty - $HOME/.config/alacritty/alacritty.toml"
        "i3 - $HOME/.config/i3/config"
        "i3-status - $HOME/.config/i3/i3status.conf"
        "i3-layouts - $HOME/.config/i3/layouts"
        "polybar - $HOME/.config/polybar/config"
        "bash - $HOME/.bashrc"
        "econf - $HOME/.local/bin/econf.sh"
        "change_brightness - $HOME/.local/bin/change_brightness.sh"
        "dev - $HOME/.local/bin/dev.sh"
        "chfont - $HOME/.local/bin/chfont.sh"
        "chnvim - $HOME/.local/bin/chnvim.sh"
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
        "arch_notes - $HOME/playground/post_install/arch_notes.md"
        "arch_post_install - $HOME/playground/post_install/arch_post_install.sh"
        "hyprland - $HOME/.config/hypr/hyprland.conf"
        "hypridle - $HOME/.config/hypr/hypridle.conf"
        "hyprpaper - $HOME/.config/hypr/hyprpaper.conf"
        "hyprlock - $HOME/.config/hypr/hyprlock.conf"
        "hyprstart - $HOME/.local/bin/hyprstart"
        "waybar - $HOME/.config/waybar/config"
        "waybar_style - $HOME/.config/waybar/style.css"
        "deconf - $HOME/.local/bin/deconf.sh"
        "git - $HOME/.config/git/config"
        "torz2 - $HOME/.local/bin/torz2.sh"
        "emacs - $HOME/.config/doom/config.org"
        "weekly_jobs - $HOME/.local/bin/weekly_jobs.sh"
        "gclone - $HOME/.local/bin/gclone.sh"
        "ssh - $HOME/.ssh/config"
        "helix - $HOME/.config/helix/config.toml"
        "leet - $HOME/.local/bin/leet.py"
        "zdate - $HOME/.local/bin/zdate.sh"
        "git-github-fork - $HOME/.local/bin/git-github-fork"
        "git-github-url - $HOME/.local/bin/git-github-url"
        "git-happy-merge - $HOME/.local/bin/git-happy-merge"
        "bbw - $HOME/.local/bin/bbw.py"
        "kitty - $HOME/.config/kitty/kitty.conf"
        "wofi - $HOME/.config/wofi/config"
        "wofi_style - $HOME/.config/wofi/style.css"
        "reload - $HOME/.local/bin/reload.sh"
        "chde - $HOME/.local/bin/chde.sh"
    )

    choice=$(printf '%s\n' "${FILES[@]}" \
        | fzf --prompt 'Edit config: ' --layout=reverse --height='50%' --border --ansi \
        | cut -d ' ' -f3)

    [[ -z $choice ]] && { echo 'Nothing selected. Aborting'; exit 1; }

    "${EDITOR:-nvim}" "${choice}"
}

main

