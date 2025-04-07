#!/bin/bash

function git_push() {
  local -r git_dir=$1

  cd "${git_dir}" \
    && git add -A \
    && git commit --no-gpg-sign -m "cron job push $(date '+%Y-%m-%d')" \
    && git push
}

function main() {
  local -a projects=(
    "$HOME/playground/projects/learn"
    "$HOME/playground/org_files"
    "$HOME/playground/second_brain"
    "$HOME/.password-store"
  )

  for project in "${projects[@]}"; do
    git_push "${project}"
  done
}

main
