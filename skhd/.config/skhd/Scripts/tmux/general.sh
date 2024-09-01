######
# Start New Session with Mets Project
tmux new-session -d -s "mar"

# Name first Window and move to mets dir
tmux rename-window -t 1 'mar'
# tmux send-keys -t 'mar' 'cd ~/work/mar/mar2-front-cli/' C-m 'clear' C-m 'ionic serve -p 8100'
tmux send-keys -t 'mar' 'cd ~/work/mar/mar2-front-cli/' C-m 'clear' C-m

# Split vertically
# tmux split-window -h
# tmux send-keys 'cd ~/work/mets' C-m 'clear' C-m

# Split horizontally
# tmux split-window -v

# Create and setup pane for mets project
# tmux new-window -n 'nvim'
# tmux send-keys -t 'nvim' 'cd ~/work/mets' C-m 'nvim .' C-m


# ######
# Start New Session with Mets Worktree
tmux new-session -d -s "tmp"
#
# # Name first Window and move to mets dir
tmux rename-window -t 1 'tmp'
tmux send-keys -t 'tmp' 'cd ~/tmp' C-m 'clear' C-m
#
# tmux split-window -v -p 50
# tmux send-keys 'cd ~/work/mets_wt/mets-master' C-m 'clear' C-m
#
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/mets_wt/mets-support' C-m 'clear' C-m
#
# tmux select-pane -t 0
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/mets_wt/mets-support' C-m 'clear' C-m 'ionic serve -p 8107'
#
# # Create and setup pane for mets project
# tmux new-window -n 'mets-master'
# tmux send-keys -t 'mets-master' 'cd ~/work/mets_wt/mets-master' C-m 'nvim .' C-m
#
# # Create and setup pane for appsalud project
# tmux new-window -n 'mets-support'
# tmux send-keys -t 'mets-support' 'cd ~/work/mets_wt/mets-support' C-m 'nvim .' C-m


# #########
# # Start New Session with SALUD project
# tmux new-session -d -s "salud"
#
# tmux rename-window -t 1 'serve'
#
# tmux send-keys -t 'serve' 'cd ~/work/appsalud' C-m 'clear' C-m 'ionic serve -p 8101'
#
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/appsalud' C-m 'clear' C-m
#
# # Create and setup pane for appsalud project
# tmux new-window -n 'salud'
# tmux send-keys -t 'salud' 'cd ~/work/appsalud' C-m 'nvim .' C-m
#
#
#
# #########
# # Start New Session with VEHICLE project
# tmux new-session -d -s "vehi"
#
# tmux rename-window -t 1 'serve'
#
# tmux send-keys -t 'serve' 'cd ~/work/vehicle-accidents' C-m 'clear' C-m 'ionic serve -p 8102'
#
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/vehicle-accidents' C-m 'clear' C-m
#
# # Create and setup pane for vehicle project
# tmux new-window -n 'vehi'
# tmux send-keys -t 'vehi' 'cd ~/work/vehicle-accidents' C-m 'nvim .' C-m
#
#
#
# #########
# # Start New Session with PFC project
# tmux new-session -d -s "pfc"
#
# tmux rename-window -t 1 'serve'
#
# tmux send-keys -t 'serve' 'cd ~/private/pfc/Nomo' C-m 'clear' C-m 'ionic serve -p 8105'
#
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/private/pfc/Nomo' C-m 'clear' C-m
#
# # Create and setup pane for pc project
# tmux new-window -n 'nomo'
# tmux send-keys -t 'nomo' 'cd ~/private/pfc/Nomo' C-m 'nvim .' C-m
#
#
# #########
# # Start New Session with METS-SALUD project
# tmux new-session -d -s "ms"
#
# # Name first Window and move to mets dir
# tmux rename-window -t 1 'serve'
# tmux send-keys -t 'serve' 'cd ~/work/mets' C-m 'clear' C-m 'ionic serve -p 8100'
#
# tmux split-window -v -p 50
# tmux send-keys 'cd ~/work/mets' C-m 'clear' C-m
#
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/appsalud' C-m 'clear' C-m
#
# tmux select-pane -t 0
# tmux split-window -h -p 50
# tmux send-keys 'cd ~/work/appsalud' C-m 'clear' C-m 'ionic serve -p 8101'
#
# # Create and setup pane for mets project
# tmux new-window -n 'mets'
# tmux send-keys -t 'mets' 'cd ~/work/mets' C-m 'nvim .' C-m
#
# # Create and setup pane for appsalud project
# tmux new-window -n 'salud'
# tmux send-keys -t 'salud' 'cd ~/work/appsalud' C-m 'nvim .' C-m



########################################
# Attach Session, on the first window
tmux attach-session -t mar:1
