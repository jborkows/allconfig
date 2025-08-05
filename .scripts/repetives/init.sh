#/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/versions.env

mkdir -p ~/.local/bin || true
mkdir -p ~/programs || true

if ! which rustup > /dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


mkdir -p ~/.local/share/fonts
if ! apt list --installed 2>/dev/null | grep fonts-noto-color-emoji > /dev/null 2>&1; then
    sudo apt install fonts-noto-color-emoji fonts-emojione
fi

exec_script() {
    name=$1
    cowsay -f dragon "executing $name" | lolcat
    bash ./$name
    cowsay -f dragon "done $name"| lolcat
}

pushd $SCRIPT_DIR
exec_script waybarcron.sh
exec_script golangcli.sh
exec_script nvm_install.sh
popd
