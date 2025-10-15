atuin-setup() {
  if ! which atuin &>/dev/null; then
    echo 'no atuin'
    return 1
  fi

  export ATUIN_NOBIND="true"
  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
    local atuin_cmd='atuin history list'
    # local atuin_opts='--print0 --format="[{time}] ({relativetime}) {command}"'
    local atuin_opts='--print0 --cmd-only'

    local fzf_opts=(
      --info=right
      --height=50%
      --tac
      "-n2..,.."
      --tiebreak=index
      "--query='${LBUFFER}"
      "+m"
      '--preview=echo {}'
      "--preview-window=up:2:hidden:wrap"
      "--bind=?:toggle-preview"
      "--bind=ctrl-d:half-page-down,ctrl-u:half-page-up"
      "--bind=ctrl-w:reload($atuin_cmd $atuin_opts --cwd),ctrl-r:reload($atuin_cmd $atuin_opts)"
      "--bind=ctrl-s:reload($atuin_cmd $atuin_opts --session)"
    )

    selected=$(
      # eval "${atuin_cmd} ${atuin_opts}" | fzf "${fzf_opts[@]}" --ansi --read0 | awk '{for (i=4; i<NF; i++) printf $i " "; print $NF}'
      eval "${atuin_cmd} ${atuin_opts}" | fzf "${fzf_opts[@]}" --ansi --read0
    )
    local ret=$?
    if [ -n "$selected" ]; then
      # the += lets it insert at current pos instead of replacing
      # LBUFFER+="${selected}"
      LBUFFER="${selected}"
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-atuin-history-widget

  function set_keybindings() {
    bindkey '^R' fzf-atuin-history-widget
    # autoload -U edit-command-line
    zle -N edit-command-line
    bindkey '^X^E' edit-command-line
    # bindkey '^p' history-search-backward
    # bindkey '^n' history-search-forward
    # bindkey '^E' _atuin_search_widget

    autoload -U add-zsh-hook # Only for zsh, skip for bash
    load-nvmrc() {
      if [ -f .nvmrc ]; then
        nvm use
      fi
    }
    # For zsh
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
  }

  zvm_after_init_commands+=(set_keybindings)
}

atuin-setup
