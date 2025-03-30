function gu() {
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(fd . $HOME --exclude .git --exclude node_modules --max-depth 3 --type d --hidden | fzf --bind=ctrl-k:up,ctrl-j:down)
  fi

  if [[ -z $selected ]]; then
    return 0
  fi

  cd $selected
}

function mcd () {
  mkdir "$1" && cd "$1"
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
