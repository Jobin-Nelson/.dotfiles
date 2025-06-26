#!/usr/bin/env bash

song=$(rmpc song | jq -r '.metadata.title')
limit=30

if (( ${#song} > limit )); then
  song="${song:0:$limit}..."
fi

echo "${song}"
