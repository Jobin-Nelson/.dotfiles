#!/usr/bin/bash

function main() {
  local device_amount is_connected selection

  device_amount=$(bluetoothctl devices | wc -l)

  if (( device_amount == 1 )); then
    selection=$(bluetoothctl devices)
  else
    selection=$(bluetoothctl devices \
      | fzf --prompt 'Select device: ' --with-nth '3..')
  fi

  MAC=$(echo "${selection}" | cut -d ' ' -f 2)
  device=$(echo "${selection}" | cut -d ' ' -f '3-')

  [[ -z $MAC ]] && { echo 'No device selected. Aborting...'; exit 1; }

  is_connected=$(bluetoothctl info "${MAC}" | grep Connected: | awk '{print $NF}')

  if [[ $is_connected == 'no' ]]; then
    notify-send "Attempting to connect to ${device}"
    bluetoothctl connect "${MAC}" || notify-send 'Failed to connect'
  elif [[ $is_connected == 'yes' ]]; then
    notify-send "Attempting to disconnect from ${device}"
    bluetoothctl disconnect "${MAC}" || notify-send 'Failed to disconnect'
  fi

}

main
