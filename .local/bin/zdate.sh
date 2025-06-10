#!/usr/bin/env bash

query="${*:-now}"

main() {
  local print_format='+%a %b %d %I:%M %P %Z %Y'
  local -a timezones=(
    'America/Los_Angeles'
    'America/Chicago'
    'Europe/London'
    'Asia/Kolkata'
  )

  local tz
  for tz in "${timezones[@]}"; do
    TZ=":${tz}" date -d "${query}" "${print_format}"
  done
}

main
