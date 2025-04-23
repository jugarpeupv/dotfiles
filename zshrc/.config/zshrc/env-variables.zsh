# Conditionally Load env variables if file exists
if [ -f $HOME/.config/zshrc/.env ]; then
  export $(grep -v '^#' $HOME/.config/zshrc/.env | xargs)
fi
