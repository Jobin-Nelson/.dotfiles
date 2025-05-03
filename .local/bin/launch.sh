#!/bin/bash

# ~/scripts/slay.sh -l 2


function launch_applications() {
  . /etc/os-release

  if [[ $ID == "arch" ]]; then
    pgrep -i edge || setsid -f microsoft-edge-stable &>/dev/null &
    pgrep -i msedge || setsid -f /opt/microsoft/msedge/microsoft-edge --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo "--app-url=https://teams.microsoft.com/v2/?clientType=pwa" &>/dev/null &
    pgrep -i vpnui || setsid -f /opt/cisco/secureclient/bin/vpnui &>/dev/null &
  fi
}

function launch_tmux() {
  local dest_dir session_name

  dest_dir="$HOME/playground/dev/illumina/ticket_notes"
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


function main() {
  launch_applications
  launch_tmux
}

main
