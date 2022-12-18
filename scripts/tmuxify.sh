#!/usr/bin/bash

set -euo pipefail

selected_dir="$(zoxide query -l | fzf)"

[[ -z $selected_dir ]] && exit 1

cd "$selected_dir"

session_name=$(basename "$PWD")

if ! tmux has-session -t "$session_name"; then
    tmux new-session -s "$session_name" -n editor -d 'nvim'
fi

tmux attach -t "$session_name"

