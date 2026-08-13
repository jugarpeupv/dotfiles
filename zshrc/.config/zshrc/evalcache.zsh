_evalcache direnv hook zsh
# _evalcache zoxide init zsh
_evalcache starship init zsh
_evalcache rbenv init -
_evalcache atuin init zsh
# _evalcache fnm env --use-on-cd --shell zsh
# _evalcache pyenv init --path

eval "$(fnm env --use-on-cd --corepack-enabled --version-file-strategy=recursive --shell zsh)"
