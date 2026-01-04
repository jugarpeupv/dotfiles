##########    FZF    ###############
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--reverse \
  --no-info \
  --prompt=' ' \
  --pointer='' \
  --marker=' ' \
  --height=50% \
  --no-bold \
  --ansi \
  --bind='ctrl-k:up,ctrl-j:down,ctrl-y:accept' \
  --color='pointer:#1abc9c:bold,bg+:#264F78,hl:#569CD6,hl+:#569CD6,gutter:-1,border:#394b70',header:#89ddff,spinner:#89ddff,info:#89ddff"

export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--height 50%
--header 'Recent used commands'"

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules
--preview '/Users/jgarcia/.local/share/nvim/lazy/fzf/bin/fzf-preview.sh {}'
--height 50%
--bind='ctrl-y:become:nvim {} >/dev/tty'
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
--bind='ctrl-y:become:nvim {} >/dev/tty'
--walker-skip .git,node_modules,target
--preview 'tree -C {}'"
