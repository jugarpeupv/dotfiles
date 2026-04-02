alias vf='vifm .'
alias remote='~/.config/bin/remote.sh'
alias neomutt='(TERM=xterm-direct neomutt) 2>/dev/null'
alias js='jira issue'
alias gl='git checkout . | git clean -fd'
alias lsa='lsd -la'
alias md='mkdir -p'
alias gcc='git checkout . && git clean -fd'
alias mets-tmux='source ~/.config/skhd/Scripts/tmux/mets-tmux.sh'
alias ms-tmux='source ~/.config/skhd/Scripts/tmux/ms-tmux.sh'
alias ohmyzsh='nvim ~/.oh-my-zsh'
alias pa='git clean -fxd && npm ci && ionic cordova platform add android --nosave && ionic cordova prepare android'
alias pca='git clean -fxd && npm install && ionic cordova platform add android --nosave && ionic cordova prepare android'
alias pfc-tmux='source ~/.config/skhd/Scripts/tmux/pfc-tmux.sh'
alias pi='git clean -fxd && npm ci && ionic cordova platform add ios --nosave && ionic cordova prepare ios'
alias rd=rmdir
alias rn='cd ~/work/Okode/Projects/Mejora\ continua/Release_notes/octokit && ts-node main.ts && cd ~/work/mets'
alias run-help=man
alias tks='tmux kill-server'
alias tm='source ~/.config/skhd/Scripts/tmux/general.sh'
alias tms=tmux-sessionizer
alias tn='tmux new -s (pwd | sed '\''s/.*\///g'\'')'
alias tt='~/.config/bin/tt.sh'
alias gc='~/.config/bin/gcbare.sh'
alias npmconfig='nvim ~/.npmrc'
alias zshconfig='nvim ~/.zshrc'
alias awsconfig='nvim ~/.aws'
alias clear=''
alias gop='git open'
alias cat='bat --paging=never'
alias k='kubectl'
alias dc='docker-compose'

# chrome-dev: opens Chrome with CDP enabled for devtools.nvim.
# Chrome blocks --remote-debugging-port on the default user-data-dir (security
# restriction since Chrome ~115), so a separate data dir is required.
# Data is stored in ~/.chrome-dev so it persists across reboots. Sign into your
# Google account once and Chrome Sync will pull down your extensions/bookmarks.
alias chrome-dev='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--remote-debugging-port=9222 \
--user-data-dir="$HOME/.chrome-dev" \
--no-first-run \
--no-default-browser-check \
"http://localhost:4200" \
&>/dev/null & disown'
