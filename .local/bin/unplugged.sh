#!/usr/bin/env bash

set -Eeuo pipefail

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

declare -a SERVICES=(
  syncthing-pod
  mpd
)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

usage() {
  local script="${0%%*/}"

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v]

DESCRIPTION
    This script manages services to save power while on battery

OPTIONS
    -h   Print this [h]elp and exit
    -v   Print [v]erbose info
    -a   Update all to save power
    -A   Update all to previous state
    -t   Toggle state
    -s   Stop services
    -S   Start services

EXAMPLES
    ${script}

EOF
  exit 0
}

bail() {
  echo "$1"
  echo $'Aborting...\n'
  exit "${2-1}"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

manage_services() {
  local action=$1
  local service
  for service in "${SERVICES[@]}"; do
    systemctl --user "${action}" "${service}" || {
      echo "WARN: Failed to ${action} ${service}"
      continue
    }
  done

  echo "INFO: Completed ${action} services"
}

stop_services() {
  manage_services stop
}

start_services() {
  manage_services start
}

update_powerprofile() {
  local profile=$1
  powerprofilesctl set "${profile}"

  echo "INFO: Updated power profile to ${profile}"
}

power_saver_mode() {
  update_powerprofile "power-saver"
}

balanced_mode() {
  update_powerprofile "balanced"
}

is_unplugged() {
  local current_state
  current_state=$(powerprofilesctl get)
  if [[ ${current_state} == 'power-saver' ]]; then
    return 0
  else
    return 1
  fi
}

stop_kde_connect() {
  qdbus org.kde.kdeconnect.daemon /MainApplication exit
}

main() {
    stop_services
    power_saver_mode
    stop_kde_connect
}

reverse_main() {
    start_services
    balanced_mode
}

toggle_state() {
  if is_unplugged; then
    reverse_main
  else
    main
  fi
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

[[ $# == 0 ]] && usage

while getopts ":hvsStaA" option; do
  case $option in
  h) usage ;;
  v) set -x ;;
  s) stop_services ;;
  S) start_services ;;
  a) main ;;
  A) reverse_main ;;
  t) toggle_state ;;
  *) bail "Error: Invalid option" ;;
  esac
done
