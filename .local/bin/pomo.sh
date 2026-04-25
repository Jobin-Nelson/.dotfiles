#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# shellcheck disable=SC2034
SCRIPT_DIR="${0%/*}"
POMO_STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/pomo/status.txt"
FOCUS_MINS="45"
BREAK_MINS="15"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

usage() {
  local script="${0%%*/}"

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v]

DESCRIPTION
    Pomo - study 25/45 min, break 5/15 min

OPTIONS
    -h   Print this [h]elp and exit
    -v   Print [v]erbose info
    -s   [S]tart pomo
    -f   Set [F]ocus mins (default=45)
    -b   Set [b]reak mins (default=15)

EXAMPLES
    ${script} -h

EOF
  exit 0
}

bail() {
  echo "$1" >2
  echo $'Aborting...\n' >2
  exit "${2-1}"
}

cleanup() {
  tput cnorm
  rm -f "${POMO_STATE_FILE}"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

status() {
  if [[ -f $POMO_STATE_FILE ]]; then
    cat "${POMO_STATE_FILE}"
  else
    echo $'No pomo currently running'
  fi
}

display_summary() {
  echo "╔════════════════╦════════╗"
  echo "║ FOCUS          ║   $(printf "%02d\n" "${FOCUS_MINS}")   ║"
  echo "║ BREAK          ║   $(printf "%02d\n" "${BREAK_MINS}")   ║"
  echo "╚════════════════╩════════╝"
}

start() {
  [[ -f $POMO_STATE_FILE ]] && bail 'ERROR: another pomo instance is already running'
  mkdir -p "${POMO_STATE_FILE%/*}"

  validate_mins "${FOCUS_MINS}"
  display_summary

  while true; do
    notify-send -u critical -t 0 -a pomo "START FOCUS: ${FOCUS_MINS} mins"
    countdown "FOCUS" "${FOCUS_MINS}"
    notify-send -u critical -t 0 -a pomo "START BREAK: ${BREAK_MINS} mins"
    countdown "BREAK" "${BREAK_MINS}"
  done
}

validate_mins() {
  local number=$1
  [[ $number =~ ^[0-9]+$ ]] || bail "ERROR: '$number' is not a valid integer"
  [[ $number -gt 0 ]] || bail "Error: Time must be greater than 0."
}

countdown() {
  local state="$1"

  # Timer and Progress Bar Variables
  local -i total_mins=$2
  local -i bar_length=40 # Width of the progress bar in characters

  # Hide the cursor to make it look cleaner (optional but recommended)
  tput civis

  # The Countdown Loop
  local -i i mins elapsed percent filled_len empty_len
  for ((i = $total_mins; i >= 0; i--)); do

    # Calculate minutes remaining
    mins=$i

    # Calculate progress percentage and bar lengths
    elapsed=$((total_mins - i))
    percent=$((elapsed * 100 / total_mins))

    # Calculate how many "filled" blocks to show
    filled_len=$(((percent * bar_length) / 100))
    empty_len=$((bar_length - filled_len))

    # Generate the bar strings using block characters
    # '█' for filled, '░' for empty
    filled_bar=$(printf "%${filled_len}s" | tr ' ' '#')
    empty_bar=$(printf "%${empty_len}s")

    # Print the line
    # \r resets to the start of the line. %02d ensures leading zeros (e.g., 09:05)
    printf "\r[%s%s] %d%% | Time left: %02d " "$filled_bar" "$empty_bar" "$percent" "$mins"

    echo "${state}: ${mins} mins" >"${POMO_STATE_FILE}"

    # Wait one minute
    sleep 1m
  done

  # Restore the cursor and print a final newline
  tput cnorm
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

[[ $# == 0 ]] && status

while getopts ":hvsf:b:" option; do
  case $option in
  h) usage ;;
  v) set -x ;;
  s) start ;;
  f) FOCUS_MINS="${OPTARG}" ;;
  b) BREAK_MINS="${OPTARG}" ;;
  *) bail "Error: Invalid option" ;;
  esac
done
