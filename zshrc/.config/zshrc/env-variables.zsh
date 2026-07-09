# Conditionally Load env variables if file exists
if [ -f $HOME/.config/zshrc/.env ]; then
  export $(grep -v '^#' $HOME/.config/zshrc/.env | xargs)
fi


export AZURE_ARTIFACTS_TOKEN=$(az account get-access-token \
  --scope https://app.vssps.visualstudio.com/.default \
  --query accessToken -o tsv 2>/dev/null)
export GH_ACTIONS_PAT=$(gh auth token 2>/dev/null)
