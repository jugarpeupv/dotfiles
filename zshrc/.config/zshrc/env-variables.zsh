# Conditionally Load env variables if file exists
[[ -f $HOME/.config/zshrc/.env ]] && source $HOME/.config/zshrc/.env 2>/dev/null
