# Session Name
session="pfc"

# Start New Session with our name
tmux new-session -d -s $session

# Name first Window and move to mets dir
tmux rename-window -t 1 'serve'
tmux send-keys -t 'serve' 'cd ~/private/pfc/Nomo' C-m 'clear' C-m 'ionic serve -p 8105' C-m

# Split vertically
tmux split-window -h
tmux send-keys 'cd ~/private/pfc/Nomo' C-m 'clear' C-m

# Split horizontally
# tmux split-window -v

# Create and setup pane for mets project
tmux new-window -n 'nvim'
tmux send-keys -t 'nvim' 'cd ~/private/pfc/Nomo' C-m 'nvim .' C-m

tmux new-window -n 'mets'
tmux send-keys -t 'mets' 'cd ~/work/mets' C-m 'nvim .' C-m

# Attach Session, on the second window
tmux attach-session -t $SESSION:2
