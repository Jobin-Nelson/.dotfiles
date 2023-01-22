#!/bin/bash 

set -euo pipefail

if ! [[ $1 =~ ^[+-]?[0-9]+$ ]]; then 
    echo "error: Not a number" >&2
    exit 1 
fi

function change_brightness() {
    local BRIGHTNESS_FILE 
    declare -i CURRENT_BRIGHTNESS NEW_BRIGHTNESS

    BRIGHTNESS_FILE='/sys/class/backlight/amdgpu_bl0/brightness'
    CURRENT_BRIGHTNESS=$(cat $BRIGHTNESS_FILE)
    NEW_BRIGHTNESS=$(( CURRENT_BRIGHTNESS + $1 ))

    echo "${NEW_BRIGHTNESS}" | sudo tee "${BRIGHTNESS_FILE}"
}

change_brightness "$1"
