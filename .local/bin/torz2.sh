#!/bin/bash

CACHE_DIR="${HOME}/.cache/torz2"
SEARCH_RESULTS="${CACHE_DIR}/search_results.html"
PARSED_RESULTS="${CACHE_DIR}/parsed_results.html"

function help() {
  echo
  echo "This script downloads torrent files"
  echo 
  echo 'Syntax: torz2.sh [-h|c] movie name'
  echo 'options:'
  echo 'h   Print this help'
  echo 'c   Download from the cached results'
  echo
}

function download_html() {
  local BASE_URL

  BASE_URL='https://torrentz2.nz'

  echo -e "\nFetching results for ${query}\n"
  curl -sSfL "${BASE_URL}/search?q=${query// /+}" --create-dirs -o "${SEARCH_RESULTS}"
}

function parse_html() {
  awk '
  BEGIN {
    RS = "<dl>"
    FS = "</span>"
    OFS = ","
    print "MagnetLink,Title,Date,Size,Seeders,Leechers"
  }

  NR > 1 {
    magnet = gensub(/.*<a href="(magnet:\?xt=urn:btih:[^&]*).*/, "\\1", 1, $1)
    title = gensub(/.*target="_blank">([^<]*).*/, "\\1", 1, $1)
    gsub(",", " ", title)
    date = gensub(/.*<span title=".*">([^<]*).*/, "\\1", 1, $2)
    size = substr($3, 7)
    seeders = substr($4, 7)
    leechers = substr($5, 7)

    print magnet, title, date, size, seeders, leechers
  }

  END {}
  ' "${SEARCH_RESULTS}" > "${PARSED_RESULTS}"
}

function get_movie() {
  local choices

  choices=$(column -t -s ',' "${PARSED_RESULTS}" |
    fzf --with-nth='2..' --layout=reverse --height=50% --border --ansi --multi |
    cut -d ' ' -f 1)

  echo "${choices}"
}

function download_movie() {
  local DOWNLOAD_DIR can_download
  declare -a magnet_links

  DOWNLOAD_DIR="${HOME}/Videos"

  readarray -t magnet_links < <(get_movie)

  (( ${#magnet_links} == 0 )) && { echo 'None selected. Aborting'; exit 1; }

  read -rp 'Do you wish to download the file (y/N): ' can_download

  [[ $can_download == 'y' ]] || exit 1

  for link in "${magnet_links[@]}"; do
      aria2c --seed-time=0 -d "${DOWNLOAD_DIR}" "${link}"
  done
}

function main() {
  local query

  query=$*
  [[ -z $query ]] && { echo 'No input. Aborting!'; exit 1; }

  download_html
  parse_html
  download_movie
}

while getopts 'hc' option; do
  case $option in
    h)
      help
      exit 0;;
    c)
      download_movie
      exit 0;;
    *)
      break;;
  esac
done

main "$*"
