#!/usr/bin/env bash
mode=${1:-ALL}
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm /tmp/update_*.log || true
export LOG_FILE=/tmp/update_$(date +"%Y%m%d_%H%M%S").log
date >> $LOG_FILE
echo "Executing for $mode"
echo "Created log file ${LOG_FILE}"


source $SCRIPT_DIR/versions.env

mkdir -p ~/.local/bin || true
mkdir -p ~/programs || true

mkdir -p ~/.local/share/fonts
if ! apt list --installed 2>/dev/null | grep fonts-noto-color-emoji > /dev/null 2>&1; then
    sudo apt install fonts-noto-color-emoji fonts-emojione
fi

can_exec(){
    if [[ "$mode" == "ALL" ]]; then
        return 0
    elif  [[ "${1,,}" == *"${mode,,}"* ]]; then
        return 0
    else 
        return 1
    fi
}

log_message(){
    echo "$@" >> "$LOG_FILE"
}


exec_script() {
    name=$1
    if ! can_exec "$name"; then
        return 0
    fi
    log_message "#########" 
    log_message "Executing $name" 
    log_message "#########" 

    cowsay -f dragon "executing $name" | lolcat
    . "./$name"
    cowsay -f dragon "done $name"| lolcat
    log_message "#########" 
    log_message "Done $name" 
    log_message "#########" 
}

exec_apt(){
 sudo apt "$@" | tee -a "$LOG_FILE"
}

if can_exec upgrade; then
    exec_apt update 
    exec_apt upgrade -y
    exec_apt autoremove -y
    exec_apt install -y lolcat cowsay git
fi

pushd "$SCRIPT_DIR"
shopt -s nullglob
while IFS= read -r script; do
    [[ "$script" != "init.sh" ]] || continue
    exec_script "$script"
done < <(printf '%s\n' *.sh | sort)
popd


