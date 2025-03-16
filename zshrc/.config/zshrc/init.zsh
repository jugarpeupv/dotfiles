source $HOME/.config/zshrc/oh-my-zsh/install.zsh

export ZSH="$HOME/.oh-my-zsh"
source $HOME/.config/zshrc/oh-my-zsh/nvm.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-syntax-highlighting.zsh
plugins=(nvm evalcache git-open fzf-tab zsh-syntax-highlighting zsh-vi-mode zsh-autosuggestions ohmyzsh-full-autoupdate)

# This line is needed for fzf-tab to pick right colors
source $HOME/.config/zshrc/ls-colors.zsh

source $ZSH/oh-my-zsh.sh
_comp_options+=(globdots)
source $HOME/.config/zshrc/oh-my-zsh/fzf-tab.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-vi-mode.zsh



# HISTFILE="$HOME/.zsh_history"
# HISTSIZE=70000
# SAVEHIST=10000
# # setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# # setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
# # setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# # setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# # setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
# # setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# # setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
# setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
# # setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# # setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# export HISTFILE=$HOME/.zsh_history
# export HISTFILESIZE=1000000000
# export HISTSIZE=1000000000
# setopt INC_APPEND_HISTORY
# export HISTTIMEFORMAT="[%F %T] "
# setopt EXTENDED_HISTORY
# setopt HIST_FIND_NO_DUPS
# setopt HIST_IGNORE_ALL_DUPS
# setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
