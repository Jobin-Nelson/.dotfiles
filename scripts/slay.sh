#!/bin/bash

function help() {
    echo
    echo 'This script saves and loads workspace layouts of i3wm'
    echo
    echo 'Syntax: layout.sh [-s|l|h]'
    echo 'Options:'
    echo '-h  Print this help'
    echo '-s  Save a workspace'
    echo '-l  Load a workspace'
    echo
}

function save() {
    local layout_file workspace

    workspace=$(i3-msg -t get_workspaces | jq -r '.[].name' | dmenu -l 10 -p 'Save Workspace: ')
    [[ -z $workspace ]] && { echo 'No workspace selected, aborting'; exit 1; }

    layout_file="${LAYOUT_DIR}/workspace_${workspace}.json"
    mkdir -p "${LAYOUT_DIR}"

    i3-save-tree --workspace "${workspace}" > "${layout_file}"
    
    sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' "${layout_file}"
}

function get_workspace() {
    local workspace

    workspace=$(find ~/.config/i3/layouts/ -type f -name '*.json' \
        | sed  -E 's|.*([0-9]).json|\1|' \
        | dmenu -l 10 -p 'Load Workspace: ')

    echo "${workspace}"
}


function load() {
    local layout_file workspace

    [[ -z $1 ]] && workspace=$(get_workspace) || workspace=$1

    [[ -z $workspace ]] && { echo 'Specify a workspace to load'; exit 1; }

    layout_file="${LAYOUT_DIR}/workspace_${workspace}.json"

    [[ -s $layout_file ]] || { echo "workspace_${workspace}.json file doesn't exist"; exit 1; }

    i3-msg "workspace ${workspace}; append_layout ${layout_file}"
}

function main() {
    local LAYOUT_DIR

    LAYOUT_DIR="${HOME}/.config/i3/layouts"

    while getopts "hsl:" option; do
        case $option in
            s)
                save;;
            l)
                load "$OPTARG";;
            h)
                help;;
            *)
                echo -e "\nInvalid argument ${option}\n"
                help;;
        esac
    done
}

if [[ -z $1 ]]; then
    help
    exit 1
fi

main "$@"

