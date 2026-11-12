# Conditionally Load env variables if file exists
if [ -f $HOME/.config/zshrc/.env ]; then
  source $HOME/.config/zshrc/.env
fi
