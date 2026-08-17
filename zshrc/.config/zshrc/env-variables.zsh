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
#
