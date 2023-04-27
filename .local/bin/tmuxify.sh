#!/usr/bin/bash

function main() {
    local selected_dir session_name

    selected_dir="$(zoxide query -l |
        fzf --prompt='Select project: ' --layout=reverse --height=50% --border --ansi)"

    [[ -z $selected_dir ]] && exit 1

    # session_name=$(basename "$PWD")
    read -rp "Session Name: " session_name

    if ! tmux has-session -t "${session_name}" &> /dev/null; then
        tmux new-session -s "${session_name}" -c "${selected_dir}" -n editor -d
        tmux send-keys -t "${session_name}:0" 'nvim' Enter
    fi

    tmux attach -t "${session_name}"
}

main
