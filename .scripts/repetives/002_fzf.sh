(
    cd ~/.local/bin
    if [[ ! -d fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git
    fi
    cd fzf
    git fetch  >> $LOG_FILE
    git pull >> $LOG_FILE
    ./install --all >> $LOG_FILE
)
