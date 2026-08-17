###########      PNPM      ###############
export PNPM_HOME="$HOME/.pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# export PATH="$PNPM_HOME:$PATH"


# fnm
export FNM_PATH="/opt/homebrew/opt/fnm/bin"
# if [ -d "$FNM_PATH" ]; then
#   eval "$(fnm env --shell zsh)"
# fi



###########      BUN      ###############
export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
# [ -s "/Users/jgarcia/.bun/_bun" ] && source "/Users/jgarcia/.bun/_bun"

