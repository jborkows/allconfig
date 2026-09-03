fetch(){
    (
        cd /tmp
        rm tree-sitter-cli-linux-x64.zip || true
        curl -L -o tree-sitter-cli-linux-x64.zip https://github.com/tree-sitter/tree-sitter/releases/download/v$1/tree-sitter-cli-linux-x64.zip
        rm tree-sitter || true
        unzip tree-sitter-cli-linux-x64.zip
        install  -t $HOME/programs tree-sitter
    )
}
VERSION_LATEST=$(curl -Ls -o /dev/null -w "%{url_effective}\n"  https://github.com/tree-sitter/tree-sitter/releases/latest)
VERSION_LATEST=${VERSION_LATEST##*/}
VERSION_LATEST=${VERSION_LATEST:1}

echo $VERSION_LATEST

if ! which tree-sitter >> /dev/null; then
    fetch $VERSION_LATEST
    return 
fi

current_version=$(tree-sitter --version | head -n 1 | cut -f2 -d' ')
if [[ $VERSION_LATEST != $current_version ]]; then
    echo installing due latest version ${VERSION_LATEST} current $current_version
    fetch $VERSION_LATEST
    return
fi





