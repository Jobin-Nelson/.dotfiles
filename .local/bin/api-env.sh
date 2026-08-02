#!/usr/bin/bash

set +o history
export API_ENV_ACTIVE=1

export API_KEY_OPENROUTER=$(pass show apikey/openrouter)
export API_KEY_GEMINI=$(pass show -c9 apikey/gemini)
export GOOGLE_WORKSPACE_CLI_CLIENT_ID=$(pass show oauth/google-cal-tui | jq -r '.installed.client_id')
export GOOGLE_WORKSPACE_CLI_CLIENT_SECRET=$(pass show oauth/google-cal-tui | jq -r '.installed.client_secret')
# echo $'API keys successfully exported:\n' "${!API_KEY@}" "${!GOOGLE_WORKSPACE@}"

set -o history
"${SHELL:-bash}"
