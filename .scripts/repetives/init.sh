#/usr/bin/env bash
mode=${1:-ALL}
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm /tmp/update_*.log
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

exec_script() {
    name=$1
    if ! can_exec $name; then
        return 0
    fi
    echo "#########" >> $LOG_FILE
    echo "Executing $name" >> $LOG_FILE
    echo "#########" >> $LOG_FILE

    cowsay -f dragon "executing $name" | lolcat
    . ./$name
    cowsay -f dragon "done $name"| lolcat
    echo "#########" >> $LOG_FILE
    echo "Done $name" >> $LOG_FILE
    echo "#########" >> $LOG_FILE
}

if can_exec upgrade; then
    sudo apt update >> $LOG_FILE   
    sudo apt upgrade -y >> $LOG_FILE   
    sudo apt autoremove -y >> $LOG_FILE
    sudo apt install -y lolcat cowsay git >> $LOG_FILE 
fi

pushd $SCRIPT_DIR
for script in $(ls *.sh | grep -v init.sh | sort ); do
    exec_script $script
done;
popd

# pushd "$HOME/.config/ansible/migrations" || exit
# ansible-playbook  playbook.yml  --extra-vars "docker_data_dir=/datadisk/dockerdir"
#
# cowsay -f dragon "Ansible playbook executed successfully"
#
# popd || exit
#

