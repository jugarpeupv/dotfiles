# Source fzf after zvm is loaded
function zvm_after_init() {
  # source <(fzf --zsh)
  bindkey "ç" fzf-cd-widget
}


function zvm_vi_yank() {
  zvm_yank
  echo ${CUTBUFFER} | pbcopy
  zvm_exit_visual_mode
}

export ZVM_VI_HIGHLIGHT_BACKGROUND=#264F78
# Do not highlight the pasted text
zle_highlight=('paste:none')
