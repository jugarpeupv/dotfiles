# Session Name
session="ms"

# Start New Session with our name
tmux new-session -d -s $session

# Name first Window and move to mets dir
tmux rename-window -t 1 'serve'
tmux send-keys -t 'serve' 'cd ~/work/mets' C-m 'clear' C-m 'ionic serve -p 8100' C-m

tmux split-window -v -p 50
tmux send-keys 'cd ~/work/mets' C-m 'clear' C-m

tmux split-window -h -p 50
tmux send-keys 'cd ~/work/appsalud' C-m 'clear' C-m

tmux select-pane -t 0
tmux split-window -h -p 50
tmux send-keys 'cd ~/work/appsalud' C-m 'clear' C-m 'ionic serve -p 8101' C-m

# Create and setup pane for mets project
tmux new-window -n 'mets'
tmux send-keys -t 'mets' 'cd ~/work/mets' C-m 'nvim .' C-m

# Create and setup pane for appsalud project
tmux new-window -n 'salud'
tmux send-keys -t 'salud' 'cd ~/work/appsalud' C-m 'nvim .' C-m


# Attach Session, on the second window
tmux attach-session -t $SESSION:2
