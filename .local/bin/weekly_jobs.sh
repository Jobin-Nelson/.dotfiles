#!/bin/bash

function git_push() {
  local git_dir

  git_dir=$1

  cd "${git_dir}" \
    && git add -A \
    && git commit -m "cron job push $(date '+%Y-%m-%d')" \
    && git push
}

function main() {
  local PROJECT_DIR
  local -a projects

  PROJECT_DIR="$HOME/playground/projects"

  projects=(
    'learn'
    'org_files'
    'second_brain'
  )

  for project in "${projects[@]}"; do
    git_push "${PROJECT_DIR}/${project}"
  done
}

main
