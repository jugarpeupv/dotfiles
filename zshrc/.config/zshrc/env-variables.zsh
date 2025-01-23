# Conditionally Load env variables if file exists
if [ -f $HOME/.config/zshrc/.env ]; then
  export $(cat $HOME/.config/zshrc/.env | xargs)
fi
