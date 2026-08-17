# zsh-syntax-highlighting styles must be seeded BEFORE the plugin loads
# (the plugin only OVERWRITES styles that are already set unless they're
#  in the styles array already).
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

# This line is needed for fzf-tab to pick right colors
source $HOME/.config/zshrc/ls-colors.zsh

# Load plugins via antidote (replaces oh-my-zsh).
# Load order matters (preserved from the old omz plugins=(...) array):
#   evalcache, git-open, fzf-tab, zsh-syntax-highlighting, zsh-vi-mode,
#   zsh-autosuggestions
# fzf-tab must load BEFORE syntax-highlighting/autosuggestions so it can
# snapshot the completion widget before those wrap it.
source $HOME/.config/zshrc/oh-my-zsh/antidote.zsh

# Completion. omz used to run compinit after the plugins; fzf-tab's
# enable-fzf-tab explicitly handles being initialized before compinit,
# so keep the same relative order.
autoload -Uz compinit add-zsh-hook
# Key the completion dump on the zsh version: /bin/zsh (5.9) and Homebrew zsh
# (5.9.2) must not share one .zcompdump, or compinit rebuilds its whole
# ~1k-entry cache every time the other binary runs (a ~0.25s first-run hit).
compinit -i -d "$HOME/.zcompdump${ZSH_VERSION:+.$ZSH_VERSION}"
_comp_options+=(globdots)

# fzf-tab zstyles (must come after LS_COLORS is set)
source $HOME/.config/zshrc/oh-my-zsh/fzf-tab.zsh

# zsh-vi-mode user config: zvm_after_init / zvm_vi_yank are read lazily
# by the plugin on its zvm_init, so sourcing this after the plugin is fine.
source $HOME/.config/zshrc/oh-my-zsh/zsh-vi-mode.zsh