zstyle ':completion:*' special-dirs false
# zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
