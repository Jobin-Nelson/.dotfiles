#!/usr/bin/bash

if ! tmux has-session -t Rooms; then
    cd ~/playground/projects/rooms/
    tmux new -s Rooms -d
    tmux new-window -t Rooms:1
    tmux rename-window -t Rooms:0 Editor
    tmux rename-window -t Rooms:1 Django
    tmux send-keys -t Rooms:0 '. venv/bin/activate' Enter
    tmux send-keys -t Rooms:1 '. venv/bin/activate' Enter
    tmux send-keys -t Rooms:0 'nvim' Enter
    tmux select-window -t Rooms:0
fi
tmux attach -t Rooms

