#/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm /tmp/update_*.log
export LOG_FILE=/tmp/update_$(date +"%Y%m%d_%H%M%S").log
date >> $LOG_FILE
echo "Created log file ${LOG_FILE}"


source $SCRIPT_DIR/versions.env

mkdir -p ~/.local/bin || true
mkdir -p ~/programs || true

mkdir -p ~/.local/share/fonts
if ! apt list --installed 2>/dev/null | grep fonts-noto-color-emoji > /dev/null 2>&1; then
    sudo apt install fonts-noto-color-emoji fonts-emojione
fi

exec_script() {
    name=$1
    cowsay -f dragon "executing $name" | lolcat
    . ./$name
    cowsay -f dragon "done $name"| lolcat
}

sudo apt update >> $LOG_FILE   
sudo apt upgrade -y >> $LOG_FILE   
sudo apt autoremove -y >> $LOG_FILE
sudo apt install -y lolcat cowsay git >> $LOG_FILE 


pushd $SCRIPT_DIR
exec_script apt_packages.sh
exec_script git_config.sh
exec_script brave.sh
exec_script rust_install.sh
exec_script go_install.sh
exec_script waybarcron.sh
exec_script nvm_install.sh
exec_script nvim.sh
exec_script pandoc.sh
popd

# pushd "$HOME/.config/ansible/migrations" || exit
# ansible-playbook  playbook.yml  --extra-vars "docker_data_dir=/datadisk/dockerdir"
#
# cowsay -f dragon "Ansible playbook executed successfully"
#
# popd || exit
#

