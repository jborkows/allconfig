#/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/versions.env

exec_script() {
    name=$1
    cowsay -f dragon "executing $name" | lolcat
     bash ./$name
    cowsay -f dragon "done $name"| lolcat
}

pushd $SCRIPT_DIR
exec_script waybarcron.sh
exec_script golangcli.sh
popd
