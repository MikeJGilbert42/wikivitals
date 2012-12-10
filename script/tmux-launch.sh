#!/bin/bash
tmux new-session -d -s wikivitals
tmux rename-window 'Wikivitals'
tmux split-window -v 'bundle exec guard'
tmux split-window -h 'rails s'
tmux select-pane -t 0
tmux -2 attach-session -t wikivitals

