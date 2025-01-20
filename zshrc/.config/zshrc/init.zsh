[[ -x $HOME/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/ohmyzsh-full-autoupdate ]] || sh -c "$(git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate)"


export ZSH="$HOME/.oh-my-zsh"
source $HOME/.config/zshrc/oh-my-zsh/nvm.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-vi-mode.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-syntax-highlighting.zsh
source $HOME/.config/zshrc/oh-my-zsh/fzf-tab.zsh
plugins=(nvm evalcache git-open fzf-tab zsh-syntax-highlighting zsh-vi-mode zsh-autosuggestions ohmyzsh-full-autoupdate)

source $HOME/.config/zshrc/ls-colors.zsh
source $ZSH/oh-my-zsh.sh
_comp_options+=(globdots)
