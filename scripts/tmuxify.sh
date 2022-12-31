#!/usr/bin/bash

set -euo pipefail

selected_dir="$(zoxide query -l | fzf)"

[[ -z $selected_dir ]] && exit 1

# session_name=$(basename "$PWD")
read -p "Session Name: " session_name

if ! tmux has-session -t "$session_name" &> /dev/null; then
    tmux new-session -s "$session_name" -c "$selected_dir" -n editor -d 'nvim'
fi

tmux attach -t "$session_name"

