[[ -x $HOME/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/ohmyzsh-full-autoupdate ]] || sh -c "$(git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/fzf-tab ]] || sh -c "$(git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode ]] || sh -c "$(git clone https://github.com/jeffreytse/zsh-vi-mode \ $ZSH_CUSTOM/plugins/zsh-vi-mode)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]] || sh -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/evalcache ]] || sh -c "$(git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache)"

export ZSH="$HOME/.oh-my-zsh"
source $HOME/.config/zshrc/oh-my-zsh/nvm.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-vi-mode.zsh
source $HOME/.config/zshrc/oh-my-zsh/zsh-syntax-highlighting.zsh
source $HOME/.config/zshrc/oh-my-zsh/fzf-tab.zsh
plugins=(nvm evalcache git-open fzf-tab zsh-syntax-highlighting zsh-vi-mode zsh-autosuggestions ohmyzsh-full-autoupdate)

source $HOME/.config/zshrc/ls-colors.zsh
source $ZSH/oh-my-zsh.sh
_comp_options+=(globdots)

# Load env variables
[[ -x $HOME/.config/zshrc/.env ]] || source $HOME/.config/zshrc/.env



