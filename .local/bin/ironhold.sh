#!/usr/bin/env bash
#
# ██╗██████╗  ██████╗ ███╗   ██╗██╗  ██╗ ██████╗ ██╗     ██████╗
# ██║██╔══██╗██╔═══██╗████╗  ██║██║  ██║██╔═══██╗██║     ██╔══██╗
# ██║██████╔╝██║   ██║██╔██╗ ██║███████║██║   ██║██║     ██║  ██║
# ██║██╔══██╗██║   ██║██║╚██╗██║██╔══██║██║   ██║██║     ██║  ██║
# ██║██║  ██║╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝███████╗██████╔╝
# ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═════╝
#


set -Eeuo pipefail


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# shellcheck disable=SC2034
SCRIPT_DIR="${0%/*}"


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


usage() {
  local script="${0%%*/}"

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v] [-b <dir>] [-i <dir>]

DESCRIPTION
    Script to backup all data

OPTIONS
    -h   Print this [h]elp and exit
    -v   Print [v]erbose info
    -b   [B]ackup all services to directory
    -i   [I]mport all services from directory

EXAMPLES
    ${script} -h

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


backup_lab() {
  local backup_dir=$1
  local lab_script="${HOME}/playground/lab/lab.sh"
  [[ ! -x $lab_script ]] \
    && echo "Lab not found in path ${lab_script%/*}" \
    && return 0


  echo $'\nBacking up Lab...\n'
  "${lab_script}" -b "${backup_dir}"
}

backup_from_to() {
  local backup_dir=$1
  local target_dir=$2

  local name="${backup_dir##*/}"

  [[ ! -d $backup_dir ]] \
    && echo "ERROR: ${name} not found in path ${backup_dir}" \
    && return 0

  echo -e "\nBacking up ${name}...\n"
  tar -czf "${target_dir}/${name}.tar.gz" -C "${backup_dir%/*}" "${name}"
}

backup_others() {
  local target_dir=$1
  local -a backup_dirs=(
    "$HOME/playground/org_files"
    "$HOME/playground/second_brain"
    "$HOME/.password-store"
  )

  local backup_dir
  for backup_dir in "${backup_dirs[@]}"; do
    backup_from_to "${backup_dir}" "${target_dir}"
  done
}


backup_to() {
  local target_dir=$1

  [[ -d $target_dir ]] || bail "ERROR: ${target_dir} not a directory"

  local backup_dir
  backup_dir="${target_dir}/iron-hold-$(date +%F--%H-%M-%S)"

  mkdir -v "${backup_dir}"
  backup_lab "${backup_dir}"
  backup_others "${backup_dir}"
}

import_file() {
  local backup_dir=$1
  local import_file="${backup_dir}/$2"
  local import_to=$3

  [[ -s $import_file ]] || bail "ERROR: ${import_file} not a file"

  tar -xzf "{$import_file}" -C "${import_to}"
}

import_from() {
  local backup_dir=$1

  [[ -d $target_dir ]] || bail "ERROR: ${backup_dir} not a directory"

  import_file "${backup_dir}" "second_brain.tar.gz" "$HOME/playground"
  import_file "${backup_dir}" "org_files.tar.gz" "$HOME/playground"
  import_file "${backup_dir}" ".password.tar.gz" "$HOME"
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


[[ $# == 0 ]] && usage

while getopts ":hvb:i:" option; do
  case $option in
  h) usage ;;
  v) set -x ;;
  b) backup_to "${OPTARG}" ;;
  i) import_from "${OPTARG}" ;;
  *) bail "Error: Invalid option" ;;
  esac
done


