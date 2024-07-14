#!/bin/bash

# ~/scripts/slay.sh -l 2

. /etc/os-release

if [[ $ID = "arch" ]]; then
  /usr/bin/google-chrome-stable &>/dev/null & \
      flatpak run com.github.IsmaelMartinez.teams_for_linux &>/dev/null & \
      /opt/cisco/anyconnect/bin/vpnui &>/dev/null & 
fi

DEST_DIR="$HOME/playground/dev/illumina"
SESSION_NAME='Illumina'

if ! tmux has-session -t "${SESSION_NAME}" &>/dev/null; then
    tmux new-session -s "${SESSION_NAME}" -c "${DEST_DIR}" -n 'Editor' -d
    tmux send-keys -t "${SESSION_NAME}:0" "nvim" Enter
fi

tmux attach-session -t "${SESSION_NAME}"
