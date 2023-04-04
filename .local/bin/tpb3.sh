#!/bin/bash

CACHE_DIR="${HOME}/.cache/tpb3"
SEARCH_RESULTS="${CACHE_DIR}/search_results.html"
PARSED_RESULTS="${CACHE_DIR}/parsed_results.csv"

function help() {
    echo
    echo "This script downloads torrent files"
    echo 
    echo 'Syntax: tpb3.sh [-h|c] movie name'
    echo 'options:'
    echo 'h   Print this help'
    echo 'c   Download from the cached results'
    echo
}

function download_html() {
    local BASE_URL IS_VIDEO

    # https://www1.thepiratebay3.to/s/?q=batman&video=on
    # https://thepiratebayone.com/search.php?q=robot+season+3&cat=200
    # https://tpbworking.net/search.php?q=arcane&video=on
    BASE_URL='https://tpbworking.net/search.php?q'
    IS_VIDEO='cat=200'

    echo -e "\nFetching results for ${query}\n"
    curl -sSfL "${BASE_URL}=${query// /+}&${IS_VIDEO}" --create-dirs -o "${SEARCH_RESULTS}"
}

function parse_html() {
    awk '
    BEGIN { 
        RS = "</tr>"
        FS="</td>" 
        OFS=","
        print "MagnetLink,Title,Date,Size,Seeders,Leechers"
    }

    NR > 1 { 
        title = gensub(/.*title="Details for ([^"]*)".*/, "\\1", 1, $2)
        date = substr($3, 6, 10)
        magnet = gensub(/.*<a href="(magnet:\?xt=urn:btih:[^&]*).*/, "\\1", 1, $4)
        size = substr($5, 20)
        seeders = substr($6, 20)
        leechers = substr($7, 20)
        print magnet, title, date, size, seeders, leechers
    }

    END {}
    ' "${SEARCH_RESULTS}" > "${PARSED_RESULTS}"
}

function get_movie() {
    local choices

    choices=$(column -t -s ',' "${PARSED_RESULTS}" |
        fzf --with-nth '2..' --tac --no-sort --multi |
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
