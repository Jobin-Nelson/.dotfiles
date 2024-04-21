#!/bin/bash

BASHRC="$HOME/.bashrc"
NSXIV_KEY_HANDLER="$HOME/.config/nsxiv/exec/key-handler"

function set_gnome() {
  sed -i "
  s/.*\(alias rwl=\)/# \1/
  s/.*\(alias rwl='gsettings\)/\1/
  " "$BASHRC"
}

function set_hyprland() {
  sed -i "
  s/.*\(alias rwl=\)/# \1/
  s/.*\(alias rwl='w=\)/\1/
  " "$BASHRC"
}

function main() {
  case "$1" in
    'gnome')    set_gnome ;;
    'hyprland') set_hyprland ;;
    *)          echo 'Invalid Desktop Environment, Aborting!' ;;
  esac
}

main "$1"

