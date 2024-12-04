#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find  ~/projects  ~/Dokumenty/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)
    
function prepare_session(   ) {
TMUX_SESSION_NAME=$1	
DIRECTORY=$2
while ! tmux has-session -t $TMUX_SESSION_NAME 2>/dev/null; do
        sleep 0.1
done

sleep 0.1
tmux has-window -t $TMUX_SESSION_NAME:nvim 2>/dev/null
if [ $? != 0 ]; then
	tmux new-window -t $TMUX_SESSION_NAME -n "nvim" -c $DIRECTORY
fi

tmux send-keys -t $TMUX_SESSION_NAME:nvim "pwd" C-m
tmux send-keys -t $TMUX_SESSION_NAME:nvim "source $HOME/.bashrc" C-m
tmux send-keys -t $TMUX_SESSION_NAME:nvim "nvim ." C-m

tmux has-window -t $TMUX_SESSION_NAME:commands 2>/dev/null
if [ $? != 0 ]; then
	tmux new-window -t $TMUX_SESSION_NAME -n "commands"  -c $DIRECTORY
fi
	

tmux send-keys -t $TMUX_SESSION_NAME:commands "cowsay -f dragon I am ready | lolcat" C-m
tmux select-window -t $TMUX_SESSION_NAME:nvim
tmux list-windows -t $TMUX_SESSION_NAME | grep -v nvim | grep -v commands | grep bash | cut -f1 -d":" | xargs -I {} tmux kill-window -t $TMUX_SESSION_NAME:{}
}

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -ds $selected_name -c $selected  
    prepare_session $selected_name $selected
    tmux attach-session -t $selected_name
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi


prepare_session $selected_name $selected
tmux switch-client -t $selected_name
