#!/usr/bin/bash

set -euo pipefail

cd "$(zoxide query -l | fzf)"

session_name=$(basename "$PWD")

if ! tmux has-session -t "$session_name"; then
    tmux new-session -s "$session_name" -n editor -d
    tmux send-keys -t "${session_name}":0 'nvim' Enter
fi

tmux attach -t "$session_name"

