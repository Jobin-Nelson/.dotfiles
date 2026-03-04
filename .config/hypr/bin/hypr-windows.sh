#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Functions
# -----------------------------

list_windows() {
  hyprctl clients -j | jq -r '
    sort_by(.workspace.id)[]
    | [
        .address,
        "WS:" + .workspace.name,
        .class,
        (.title // "")
      ]
    | @tsv
  ' | column -t -s $'\t'
}

preview_window() {
  local addr="$1"

  hyprctl clients -j | jq --arg a "$addr" -r '
    .[] | select(.address == $a) |
    "
Class:       \(.class)
Title:       \(.title)
Workspace:   \(.workspace.name)
Monitor:     \(.monitor)

Floating:    \(.floating)
Fullscreen:  \(.fullscreen)
Pinned:      \(.pinned)
Grouped:     \(.grouped)
    "
  '
}

kill_window() {
  local addr="$1"
  hyprctl dispatch closewindow "address:$addr"
}

focus_window() {
  local addr="$1"
  hyprctl dispatch focuswindow "address:$addr"
}

# -----------------------------
# Capture function definitions
# -----------------------------

PREVIEW_DEF="$(declare -f preview_window)"
LIST_DEF="$(declare -f list_windows)"
KILL_DEF="$(declare -f kill_window)"

# -----------------------------
# fzf UI
# -----------------------------

selection=$(
  list_windows | fzf \
    --style='full' \
    --prompt="Select Window > " \
    --header="Enter: Focus  |  Ctrl-k: Kill" \
    --preview "$PREVIEW_DEF
addr=\$(echo {} | awk '{print \$1}')
preview_window \"\$addr\"" \
    --preview-window=right:60% \
    --bind "ctrl-k:execute-silent(
$KILL_DEF
addr=\$(echo {} | awk '{print \$1}')
kill_window \"\$addr\"
)+reload(
$LIST_DEF
list_windows
)"
)

[[ -z "$selection" ]] && exit 0

address="${selection%% *}"
focus_window "$address"
