atuin-setup() {
  if ! which atuin &>/dev/null; then
    echo 'no atuin'
    return 1
  fi

  export ATUIN_NOBIND="true"
  # eval "$(atuin init zsh)"
  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
    # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
    local atuin_opts="--cmd-only"

    # --height=${FZF_TMUX_HEIGHT:-80%}
    local fzf_opts=(
      --info=right
      --height=50%
      --tac
      "-n2..,.."
      --tiebreak=index
      "--query=${LBUFFER}"
      "+m"
      '--preview=echo {}'
      "--preview-window=up:2:hidden:wrap"
      "--bind=?:toggle-preview"
      "--bind=ctrl-d:half-page-down,ctrl-u:half-page-up"
      "--bind=ctrl-s:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
    )

    selected=$(
      eval "atuin search ${atuin_opts}" |
        fzf "${fzf_opts[@]}"
    )
    local ret=$?
    if [ -n "$selected" ]; then
      # the += lets it insert at current pos instead of replacing
      LBUFFER+="${selected}"
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-atuin-history-widget
  # bindkey '^R' fzf-atuin-history-widget

  function my_keybindings() {
    bindkey '^R' fzf-atuin-history-widget
    # bindkey '^E' _atuin_search_widget
  }

  zvm_after_init_commands+=(my_keybindings)

  # autoload -Uz add-zsh-hook
  # add-zsh-hook precmd fzf-atuin-setup
  # fzf-atuin-setup() {
  #   bindkey '^R' fzf-atuin-history-widget
  # }
}

atuin-setup
