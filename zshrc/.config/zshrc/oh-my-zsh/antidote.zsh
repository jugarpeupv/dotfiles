# Antidote: zsh plugin manager (https://antidote.sh)
# Loaded from init.zsh BEFORE any plugin depends on it.
if ! (( $+functions[antidote] )); then
  source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
fi

# Static, declarative plugin list (mirrors the old omz `plugins=(...)`).
# Must go through `_omzsource`-equivalent eager load so that widget wrappers
# (autosuggestions/syntax-highlighting) and vi-mode hooks exist at prompt time.
antidote load ${0:A:h}/.zsh_plugins.txt