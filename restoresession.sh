#!/bin/bash
TMUX_SESSION_NAME="dotfiles"
tmux has-session -t $TMUX_SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
	tmux new-session -s $TMUX_SESSION_NAME -n "nvim" 
	tmux new-window -t $TMUX_SESSION_NAME -n "commands" 
fi
	
tmux send-keys -t $TMUX_SESSION_NAME:nvim "nvim ." C-m
tmux send-keys -t $TMUX_SESSION_NAME:commands "cowsay -f dragon I am ready" C-m
