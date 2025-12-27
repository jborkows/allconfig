#!/usr/bin/env bash

set -euo pipefail

if [[ -n "${TMUX-}" ]]; then 
	export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS-} --tmux center,50% --reverse"
fi
if [[ $# -eq 1 ]]; then
    selected=$1
else
	list_candidates() {
		find "$HOME/projects" "$HOME/Dokumenty" -mindepth 1 -maxdepth 1 -type d 2>/dev/null || true

		find "$HOME/projects" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r repo; do
			if [[ -d "$repo/.git" || -f "$repo/.git" ]]; then
				git -C "$repo" worktree list --porcelain 2>/dev/null \
					| awk '$1=="worktree"{sub(/^worktree /,""); print}' \
					| while IFS= read -r wt; do
						[[ -d "$wt" ]] && printf '%s\n' "$wt"
					done
			fi
		done || true
	}

    selected=$(list_candidates | sort -u | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux || true)
    
function prepare_session(   ) {
TMUX_SESSION_NAME=$1	
DIRECTORY=$2
while ! tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null; do
        sleep 0.1
done

sleep 0.1
if ! tmux has-window -t "$TMUX_SESSION_NAME":nvim 2>/dev/null; then
	tmux new-window -t "$TMUX_SESSION_NAME" -n "nvim" -c "$DIRECTORY"
fi

tmux send-keys -t "$TMUX_SESSION_NAME":nvim "pwd" C-m
tmux send-keys -t "$TMUX_SESSION_NAME":nvim "source $HOME/.bashrc" C-m
tmux send-keys -t "$TMUX_SESSION_NAME":nvim "nvim ." C-m

if ! tmux has-window -t "$TMUX_SESSION_NAME":commands 2>/dev/null; then
	tmux new-window -t "$TMUX_SESSION_NAME" -n "commands"  -c "$DIRECTORY"
fi
	

tmux send-keys -t "$TMUX_SESSION_NAME":commands "cowsay -f dragon I am ready | lolcat" C-m
tmux select-window -t "$TMUX_SESSION_NAME":nvim
tmux list-windows -t "$TMUX_SESSION_NAME" \
	| grep -v nvim \
	| grep -v commands \
	| grep bash \
	| cut -f1 -d":" \
	| xargs -I {} tmux kill-window -t "$TMUX_SESSION_NAME":{} \
	|| true
}

if [[ -z "${TMUX-}" ]] && [[ -z $tmux_running ]]; then
    tmux new-session -ds "$selected_name" -c "$selected"
    prepare_session "$selected_name" "$selected"
    tmux attach-session -t "$selected_name"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    prepare_session "$selected_name" "$selected"
fi

tmux switch-client -t "$selected_name"
