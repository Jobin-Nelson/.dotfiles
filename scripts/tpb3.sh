#!/bin/bash

function download_html() {
    local BASE_URL IS_VIDEO

    BASE_URL='https://www1.thepiratebay3.to/s/?q'
    IS_VIDEO='video=on'

    echo -e "\nFetching results for ${query//+/ }\n"
    curl -sSfL "${BASE_URL}=${query}&${IS_VIDEO}" --create-dirs -o "${SEARCH_RESULTS}"
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

    choices=$(fzf -d ',' --with-nth '2..' --tac --no-sort --multi < "${PARSED_RESULTS}" | cut -d ',' -f 1)
    echo "${choices}"
}

function download_movie() {
    echo -e '\nDownloading file\n'
    while read -r link; do
        aria2c --seed-ratio=0.0 -d "${DOWNLOAD_DIR}" "${link}"
    done <<< "${magnet_links}"
}

function main() {
    local CACHE_DIR SEARCH_RESULTS PARSED_RESULTS DOWNLOAD_DIR
    local query magnet_links can_download

    query=$1
    [[ -z $query ]] && read -rp 'Enter a search term: ' query
    [[ -z $query ]] && { echo 'No input. Aborting!'; exit 1; }
    query=${query// /+}

    CACHE_DIR="${HOME}/.cache/tpb3"
    SEARCH_RESULTS="${CACHE_DIR}/search_results.html"
    PARSED_RESULTS="${CACHE_DIR}/parsed_results.csv"
    DOWNLOAD_DIR="${HOME}/Videos"

    download_html
    parse_html

    magnet_links=$(get_movie)
    read -rp 'Do you wish to download the file (y/N): ' can_download

    if [[ $can_download == 'y' ]]; then
        [[ -z $magnet_links ]] && { echo 'None selected. Aborting'; exit 1; }
        download_movie
    fi
}

main "$*"
