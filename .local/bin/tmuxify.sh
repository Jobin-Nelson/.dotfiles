#!/usr/bin/bash
#
# ████████╗███╗   ███╗██╗   ██╗██╗  ██╗██╗███████╗██╗   ██╗
# ╚══██╔══╝████╗ ████║██║   ██║╚██╗██╔╝██║██╔════╝╚██╗ ██╔╝
#    ██║   ██╔████╔██║██║   ██║ ╚███╔╝ ██║█████╗   ╚████╔╝ 
#    ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗ ██║██╔══╝    ╚██╔╝  
#    ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗██║██║        ██║   
#    ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   
#                                                          

function sessionizer() {
  local selected_dir session_name fzf_height venv_activate
  local -a tmux_sessions projects zoxide_dirs

  if command -v 'zoxide' &>/dev/null; then
    readarray -t zoxide_dirs < <(zoxide query -l)
  else
    zoxide_dirs=()
  fi

  fzf_height='50%'
  [[ -n $TMUX ]] && fzf_height='100%'
 
  readarray -t tmux_sessions < <(tmux list-sessions -F '#{session_name}')
  readarray -t projects < <(find "$HOME/playground/projects" -mindepth 1 -maxdepth 1 -type d)

  selected_dir="$(printf '%s\n' "${projects[@]}" "${tmux_sessions[@]}" "${zoxide_dirs[@]}" | sort -u |
    fzf --prompt='Select project: ' --layout=reverse --height="${fzf_height}" --border=none --ansi)"

  [[ -z $selected_dir ]] && exit 1

  session_name="${selected_dir##*/}"
  session_name="${session_name//./_}"
  session_name="${session_name//:/_}"
  session_name="${session_name//,/_}"

  if ! tmux has-session -t "${session_name}" &> /dev/null; then
    tmux new-session -s "${session_name}" -c "${selected_dir}" -n 'editor' -d
    venv_activate='./.venv/bin/activate'
    tmux send-keys -t "${session_name}:0" "[[ -s $venv_activate ]] && . ${venv_activate}" Enter
    tmux send-keys -t "${session_name}:0" 'nvim' Enter
  fi

  if [[ -z $TMUX ]]; then
    tmux attach -t "${session_name}"
  else
    tmux switch-client -t "${session_name}"
  fi
}

function windowizer() {
  local cmd current_session

  [[ -z $TMUX ]] && { echo "${0##*/} -w must be ran inside a tmux session"; exit 1; }
  cmd=$1
  current_session=$(tmux list-sessions -F '#{session_name} #{session_attached}' | awk '$2==1 {print $1}')
  current_window='run_me'
  target="${current_session}:${current_window}"
  
  if ! tmux has-session -t "${target}" &>/dev/null; then
    tmux new-window -n "${current_window}" -d
  fi

  tmux send-keys -t "${target}" "${cmd}" Enter
}

function kill_session() {
  local session
  local -a sessions

  sessions=$(tmux list-sessions -F '#{?session_attached,yes,no} #{session_name}' \
    | awk '$1 == "no" { print $2 }' \
    | fzf --exit-0 --multi) || return $?

  for session in "${sessions[@]}"; do
    tmux kill-session -t "${session}"
  done
}


function help() {
  echo
  echo "This script sets up tmux sessions and windows"
  echo 
  echo "Syntax: ${0##*/} [-h|s|w <cmd>]"
  echo 'options:'
  echo 'h   Print this [h]elp'
  echo 's   Start or switch [s]essions'
  echo 'w   Send command to [w]indows'
  echo 'k   [K]ill sessions'
  echo
}

while getopts 'hsw:k' option; do
  case $option in
    h)
      help
      exit 0;;
    s) sessionizer ;;
    w) windowizer "${OPTARG}" ;;
    k) kill_session ;;
    *)
      echo "Invalid flag"
      help
      break;;
  esac
done

[[ $# == 0 ]] && help
