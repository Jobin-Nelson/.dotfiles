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

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

[[ $# == 0 ]] && usage

while getopts ":hvsS" option; do
  case $option in
  h) usage ;;
  v) set -x ;;
  s) stop_services ;;
  S) start_services ;;
  *) bail "Error: Invalid option" ;;
  esac
done
