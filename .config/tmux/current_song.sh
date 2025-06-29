#!/usr/bin/env bash

set -Eeuo pipefail

song=$(rmpc song | jq -r '.metadata.title')
limit=25

if (( ${#song} > limit )); then
  song="${song:0:$limit}..."
elif [[ $song == 'null' ]]; then
  song='Unknown Title'
fi

[[ -n $song ]] && echo "${song}"
