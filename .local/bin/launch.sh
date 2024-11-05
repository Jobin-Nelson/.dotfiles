#!/bin/bash

# ~/scripts/slay.sh -l 2

function main() {
  local dest_dir session_name

  . /etc/os-release

  if [[ $ID == "arch" ]]; then
    flatpak run com.microsoft.Teams &>/dev/null & \
    flatpak run com.microsoft.Edge &>/dev/null & \
    /opt/cisco/secureclient/bin/vpnui >/dev/null & 
  fi

  dest_dir="$HOME/playground/dev/illumina"
  session_name='Illumina'

  if ! tmux has-session -t "${session_name}" &>/dev/null; then
    tmux new-session -s "${session_name}" -c "${dest_dir}" -n 'Editor' -d
    tmux send-keys -t "${session_name}:0" "nvim" Enter
  fi

  if [[ -z $TMUX ]]; then
    tmux attach -t "${session_name}"
  else
    tmux switch-client -t "${session_name}"
  fi
}

main
