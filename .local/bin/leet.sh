#!/bin/bash

PROBLEMSET_ALL_URL='https://leetcode.com/problemset/all/'
PROBLEMSET_DAILY_URL='https://leetcode.com/problems'
LEET_DIR="${HOME}/playground/projects/learn/competitive_programming/$(date +%Y)/$(date +%B | tr '[:upper:]' '[:lower:]')"


function main() {
  local daily_qn_link daily_qn_file daily_qn_dir daily_qn 

  firefox "${PROBLEMSET_ALL_URL}"
  read -r -p 'Enter daily question link: ' daily_qn_link 

  daily_qn="${daily_qn_link#"${PROBLEMSET_DAILY_URL}/"}"
  daily_qn="${daily_qn%%/*}"
  daily_qn_file="${LEET_DIR}/${daily_qn}.py"
  [[ -z $daily_qn ]] && { echo 'No daily question found. Aborting'; exit 1; }

  daily_qn_dir="${daily_qn_file%/*}"

  mkdir -p "${daily_qn_dir}"
  cd "${daily_qn_dir}" || { echo "No ${daily_qn_dir} directory found. Aborting"; exit 1; }
  [[ -s $daily_qn_file ]] || cat <<EOF > "${daily_qn_file}"
'''
Created Date: $(date +%Y-%m-%d)
Qn: 
Link: ${daily_qn_file}
Notes:
'''
def main():
    pass

if __name__ == '__main__':
EOF

  nvim "${daily_qn_file}"
  echo "Successfully created today's leetcode file at ${daily_qn_file}"
}

main
