# Session Name
session="mets"

# Start New Session with our name
tmux new-session -d -s $session

# Name first Window and move to mets dir
tmux rename-window -t 1 'serve'
tmux send-keys -t 'serve' 'cd ~/work/mets' C-m 'clear' C-m 'ionic serve -p 8100' C-m

# Split vertically
tmux split-window -h
tmux send-keys 'cd ~/work/mets' C-m 'clear' C-m

# Split horizontally
# tmux split-window -v

# Create and setup pane for mets project
tmux new-window -n 'nvim'
tmux send-keys -t 'nvim' 'cd ~/work/mets' C-m 'nvim .' C-m

# Attach Session, on the second window
tmux attach-session -t $SESSION:2
