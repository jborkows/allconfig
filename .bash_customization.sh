HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

source <(kubectl completion bash)
eval "$(gh completion -s bash)"
export PATH=$PATH:/usr/local/go/bin


if [ -f ~/.pnpm-completion.sh ]; then
    . ~/.pnpm-completion.sh
fi
# END ANSIBLE MANAGED BLOCK
export FZF_CTRL_T_OPTS="--preview 'batcat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"


if [[ ! "$PATH" == */$HOME/.config/ansible/migrations/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/$HOME/.config/ansible/migrations/fzf/bin"
fi

eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--preview 'batcat -n  {}' --bind 'f1:toggle-preview' --preview-window hidden --multi"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window hidden --multi"
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob "!.git/*""
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob "!.git/*" --glob "!.gitkeep""
export PATH="$HOME/programs:$PATH:$HOME/.scripts"

export SSH_AUTH_SOCK=~/.1password/agent.sock

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' 
}


set_prompt() {
    local last_exit_status="$?" 
    local red="\[\033[01;31m\]"
    local green="\[\033[01;32m\]"
    local orange="\[\033[38;2;255;165;0m\]"
    local reset="\[\033[00m\]"
    local directory_color="\[\033[1;94m\]"
    local prompt_symbol="$>"
    if [ $last_exit_status -eq 0 ]; then
        PS1="${directory_color}\w${orange}$(parse_git_branch)\n${prompt_symbol} ${reset}"
    else
        PS1="${red}\w${orange}$(parse_git_branch)\n${red}${prompt_symbol} ${reset}"
    fi
}
PROMPT_COMMAND=set_prompt

mkdir -p $HOME/.bashhistories
if [ -n "$TMUX" ]; then
    HISTFILE=~/.bashhistories/tmux_$(tmux display-message -p "#S")
fi

# Save and reload the history after each command
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
eval "$(zoxide init bash)"
export EDITOR=nvim
