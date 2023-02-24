#!/usr/bin/bash

function main() {
    local BASE_URL query

    BASE_URL='https://cht.sh'
    query=$1

    [[ -z $query ]] && { echo 'No query received, Aborting!'; exit 1; }

    curl "${BASE_URL}/${query}"
}

main "$*"
