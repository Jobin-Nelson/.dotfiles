#!/usr/bin/bash

set -euo pipefail

DEST_DIR="$HOME/playground/projects/todo"

if ! tmux has-session -t Rooms; then
    tmux new-session -s Rooms -c "$DEST_DIR" -n Editor -d
    tmux new-window -t Rooms -n Django -d
    tmux send-keys -t Rooms:0 '. venv/bin/activate' Enter
    tmux send-keys -t Rooms:1 '. venv/bin/activate' Enter
    tmux send-keys -t Rooms:0 'nvim' Enter
    tmux select-window -t Rooms:0
fi
tmux attach -t Rooms

