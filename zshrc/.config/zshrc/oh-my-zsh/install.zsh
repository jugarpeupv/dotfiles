[[ -x $HOME/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/ohmyzsh-full-autoupdate ]] || sh -c "$(git clone https://github.com/Pilaton/OhMyZsh-full-autoupdate.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ohmyzsh-full-autoupdate)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/fzf-tab ]] || sh -c "$(git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode ]] || sh -c "$(git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]] || sh -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]] || sh -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/git-open ]] || sh -c "$(git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open)"

[[ -x $HOME/.oh-my-zsh/custom/plugins/evalcache ]] || sh -c "$(git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache)"
