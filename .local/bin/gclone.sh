#!/bin/bash

function main() {
  local LOCAL_DIR REMOTE_DIR RCLONE_CONFIG

  LOCAL_DIR="$HOME/playground/projects/second_brain/"
  REMOTE_DIR='second_brain:01 - Personal/second_brain'
  RCLONE_CONFIG="$HOME/.config/rclone/rclone.conf"

  [[ -s $RCLONE_CONFIG ]] || { echo 'No rclone config file found. Aborting...'; exit 1; }

  rclone -v sync "${LOCAL_DIR}" "${REMOTE_DIR}"
}

main
