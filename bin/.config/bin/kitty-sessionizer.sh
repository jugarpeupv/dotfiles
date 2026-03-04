#!/usr/bin/env bash

selected=$(find ~/work ~/work/tmp ~/private ~/work/Okode ~/dotfiles \
  ~/.local/share/nvim/lazy ~/projects ~/Downloads ~ \
  -mindepth 1 -maxdepth 1 -type d | \
  fzf --header 'Switch to project' --bind=ctrl-k:up,ctrl-j:down)

if [[ -z "$selected" ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _ | sed 's/ //g' | tr '[:upper:]' '[:lower:]')
session_dir="$HOME/.config/kitty/sessions"
session_file="${session_dir}/${selected_name}.kitty-session"

# # Create the session file if it doesn't exist
# mkdir -p "$session_dir"
# if [[ ! -f "$session_file" ]]; then
#   cat > "$session_file" <<EOF
# layout tall
# cd ${selected}
# launch --title "${selected_name}" 
# EOF
# fi
#
# # Switch to the session (creates it if not loaded)
# kitten @ action goto_session "$session_file"


selected_name=$(basename "$selected" | tr . _ | sed 's/ //g' | tr '[:upper:]' '[:lower:]')

# Send cd to the currently active window (the one behind the overlay)
kitten @ send-text --match recent:1 "cd ${selected} && clear\n"
kitten @ set-tab-title --match recent:1 "$selected_name"
