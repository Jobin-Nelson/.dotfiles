#!/usr/bin/env bash

SCRIPTS_DIR="$HOME/.config/hypr/bin"

[[ -d "$SCRIPTS_DIR" ]] || {
    notify-send "Hypr Scripts" "Directory not found"
    exit 1
}

cd "${SCRIPTS_DIR}" || exit 1

find . -maxdepth 1 -type f -executable \
    -printf "%f\n" 2>/dev/null |
sort |
fzf \
    --style=full \
    --prompt="Hypr Scripts ❯ " \
    --height=40% \
    --preview='bat --style=numbers --color=always {} || less {}' \
    --preview-window=right:60% \
    --bind "enter:become($SCRIPTS_DIR/{})"
