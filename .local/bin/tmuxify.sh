#!/usr/bin/env bash
#
# ████████╗███╗   ███╗██╗   ██╗██╗  ██╗██╗███████╗██╗   ██╗
# ╚══██╔══╝████╗ ████║██║   ██║╚██╗██╔╝██║██╔════╝╚██╗ ██╔╝
#    ██║   ██╔████╔██║██║   ██║ ╚███╔╝ ██║█████╗   ╚████╔╝
#    ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗ ██║██╔══╝    ╚██╔╝
#    ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗██║██║        ██║
#    ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝        ╚═╝
#

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


usage() {
  local script

  script=$(basename "${BASH_SOURCE[0]}")

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-s] [-r <cmd>] [-k] [-w]

DESCRIPTION
    This script sets up tmux sessions and windows

OPTIONS
    -h, --help        Print this help and exit
    -v, --verbose     Print script debug info
    -s, --session     Start or switch sessions
    -w, --worktree    Start or switch worktrees
    -k, --kill        Kill a session
    -r, --run         Run command in window

EXAMPLES
    ${script} -s

EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "${RED}${msg}${NOFORMAT}"
  exit "$code"
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

get_session_name() {
  local session_name=$1
  session_name="${session_name##*/}"
  session_name="${session_name//./_}"
  session_name="${session_name//:/_}"
  session_name="${session_name//,/_}"

  echo -n "${session_name}"
}

attach_session() {
  local session_name=$1
  local target_dir=$2

  if ! tmux has-session -t "${session_name}" &> /dev/null; then
    tmux new-session -s "${session_name}" -c "${target_dir}" -n 'editor' -d
    local venv_activate='./.venv/bin/activate'
    tmux send-keys -t "${session_name}:0" "[[ -s $venv_activate ]] && . ${venv_activate}" Enter
    tmux send-keys -t "${session_name}:0" 'nvim' Enter
  fi

  if [[ -z ${TMUX-} ]]; then
    tmux attach -t "${session_name}"
  else
    tmux switch-client -t "${session_name}"
  fi
}

sessionizer() {
  local -a zoxide_dirs
  if command -v 'zoxide' &>/dev/null; then
    readarray -t zoxide_dirs < <(zoxide query -l)
  else
    zoxide_dirs=()
  fi

  local -a tmux_sessions projects
  readarray -t tmux_sessions < <(tmux list-sessions -F '#{session_name}')
  readarray -t projects < <(find "$HOME/playground/projects" -mindepth 1 -maxdepth 1 -type d)

  local selected_dir
  selected_dir="$(printf '%s\n' "${projects[@]}" "${tmux_sessions[@]}" "${zoxide_dirs[@]}" |
    sort -u |
    fzf --prompt='Select project: ' --height="${fzf_height}" --ansi)"

  [[ -z $selected_dir ]] && exit 1

  local session_name
  session_name=$(get_session_name "${selected_dir}")

  attach_session "${session_name}" "${selected_dir}"
}

run_cmd() {
  local cmd=$1

  [[ -z ${TMUX-} ]] && die "${0##*/} -w must be ran inside a tmux session"
  [[ -z $cmd ]] && die "ERROR: cmd not provided"
  local current_session
  current_session=$(tmux list-sessions -F '#{session_name} #{session_attached}' | awk '$2==1 {print $1}')
  current_window='run_me'
  target="${current_session}:${current_window}"

  if ! tmux has-session -t "${target}" &>/dev/null; then
    tmux new-window -n "${current_window}" -d
  fi

  tmux send-keys -t "${target}" "${cmd}" Enter
}

attach_worktree() {
  local current_pane_path worktree
  if [[ -n ${TMUX-} ]]; then
    current_pane_path=$(tmux display-message -p -F '#{pane_current_path}')
  else
    current_pane_path=$(pwd -P)
  fi

  local worktree
  worktree=$(git -C "${current_pane_path}" worktree list |
    sed '/(bare)/d' |
    fzf --no-multi --prompt 'Worktree: ' --height="${fzf_height}" |
    awk '{ print $1 }')
  local branch
  branch=$(get_session_name "${worktree}")

  local repo_name
  repo_name=$(get_session_name "$(git config remote.origin.url)")

  local target_session="${repo_name}--${branch}"
  attach_session "${target_session}" "${worktree}"
}

kill_session() {
  local -a sessions
  sessions=$(tmux list-sessions -F '#{?session_attached,yes,no} #{session_name}' \
    | awk '$1 == "no" { print $2 }' \
    | fzf --multi --height="${fzf_height}" --ansi) || return $?

  local session
  for session in "${sessions[@]}"; do
    tmux kill-session -t "${session}"
  done
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


parse_params() {
  # default values of variables set from params
  [[ -n ${TMUX-} ]] && fzf_height='100%' || fzf_height='50%'

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -s | --session) sessionizer ;;
    -w | --worktree) attach_worktree ;;
    -k | --kill) kill_session;;
    -r | --run) run_cmd "${2-}"; shift;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  (( ${#args[@]} != 0 )) && die "ERROR: Unknown positional arguments ${args[*]}"

  return 0
}

[[ $# == 0 ]] && usage
setup_colors
parse_params "$@"

