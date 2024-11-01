#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
pushd "$DIR" &> /dev/null || return
export FZF_DEFAULT_OPTS="--preview 'script {}' --bind 'f1:toggle-preview' --preview-window=hidden --ansi --reverse"
cat <(ls ./*.sh | grep -v scriptchooser) <(ls ./github/githubchoser.sh) |\
    sed 's/^.\///' |\
awk 'NR % 2 == 1 {print "\033[33m" $0 "\033[0m"} NR % 2 == 0 {print "\033[36m" $0 "\033[0m"}' \
    | fzf --bind "enter:become(bash ./{})" 
popd &> /dev/null || return
