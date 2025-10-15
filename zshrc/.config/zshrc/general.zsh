ulimit -S -n 65535
export BAT_THEME="ansi"
## This is needed for csi mode to work, alacritty allows csi mode by default
export TERM='alacritty'
export EDITOR=nvim
# export PAGER='nvim -R'
export MANPAGER='nvim +Man!'
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export XDG_CONFIG_HOME="$HOME/.config"
export GPG_TTY=$(tty)
