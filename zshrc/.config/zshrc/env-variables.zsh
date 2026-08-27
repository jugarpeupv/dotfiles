# Conditionally Load env variables if file exists
if [ -f $HOME/.config/zshrc/.env ]; then
  export $(grep -v '^#' $HOME/.config/zshrc/.env | xargs)
fi

# Lazy-load tokens: fetch once, cache for 50 min, refresh only when stale
# _fnm_cred_lazy () {
#   local var="$1" cache="$HOME/.cache/zsh-cred-${var}.txt"
#   if [[ -s "$cache" ]] && [[ $(($(date +%s) - $(stat -f %m "$cache"))) -lt 3000 ]]; then
#     export "$var=$(<$cache)"
#   else
#     case "$var" in
#       AZURE_ARTIFACTS_TOKEN)
#         local tok; tok=$(az account get-access-token \
#           --scope https://app.vssps.visualstudio.com/.default \
#           --query accessToken -o tsv 2>/dev/null)
#         [[ -n "$tok" ]] && export "$var=$tok" && printf '%s' "$tok" >"$cache" ;;
#       GH_ACTIONS_PAT)
#         local tok; tok=$(gh auth token 2>/dev/null)
#         [[ -n "$tok" ]] && export "$var=$tok" && printf '%s' "$tok" >"$cache" ;;
#     esac
#   fi
# }

# export AZURE_ARTIFACTS_TOKEN=$(az account get-access-token \
#   --scope https://app.vssps.visualstudio.com/.default \
#   --query accessToken -o tsv 2>/dev/null)
# export GH_ACTIONS_PAT=$(gh auth token 2>/dev/null)

# Gmail OAuth token path - single source of truth for isync/mbsync and msmtp
# Used by:
#  - isync/.config/isyncrc:42           PassCmd "mutt_oauth2.py $GMAIL_OAUTH_TOKENS_FILE ..."
#  - msmtp/.config/msmtp/config:28      passwordeval "mutt_oauth2.py $GMAIL_OAUTH_TOKENS_FILE ..."
# Davmail token path is NOT here - single source is davmail/.davmail.properties:73 davmail.oauth.tokenFilePath
#   read by parsing that file (davmail.properties does NOT expand env vars - Settings.java:getProperty raw)
#   e.g. nvim/.config/nvim/lua/plugins/snacks.lua parses it
# isync/msmtp PassCmd are executed via sh -c, so $VAR is expanded if exported here.
# Keep fallback ${VAR:-~/.config/...} in configs so mbsync still works from launchd/cron where zshrc isn't sourced.
export GMAIL_OAUTH_TOKENS_FILE="$HOME/.config/personal.gmail.com.tokens.env"
#
