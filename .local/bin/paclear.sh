#!/usr/bin/bash

function pacman_cache_clear() {
    paccache -qrk2 && paccache -qruk0
}

function aur_cache_clear() {
    local AUR_CACHE_DIR caches

    AUR_CACHE_DIR="$HOME/.cache/$1"

    caches=$(find "${AUR_CACHE_DIR}" -mindepth 1  -maxdepth 1 -type d | awk '{ print "-c " $0 }')
    paccache -qrk2 $caches && paccache -qruk0 $caches
}

function main() {

    command -v paccache > /dev/null || { echo 'paccache is not installed. Aborting!'; exit 1; }

    pacman_cache_clear
    aur_cache_clear 'paru/clone'
}

main
