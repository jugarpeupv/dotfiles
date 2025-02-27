source $HOME/.config/zshrc/oh-my-zsh/install.zsh

export ZSH="$HOME/.oh-my-zsh"
source $HOME/.config/zshrc/oh-my-zsh/nvm.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-syntax-highlighting.zsh
plugins=(nvm evalcache git-open fzf-tab zsh-syntax-highlighting zsh-vi-mode zsh-autosuggestions ohmyzsh-full-autoupdate)

source $HOME/.config/zshrc/ls-colors.zsh
source $ZSH/oh-my-zsh.sh
_comp_options+=(globdots)
source $HOME/.config/zshrc/oh-my-zsh/fzf-tab.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-vi-mode.zsh

