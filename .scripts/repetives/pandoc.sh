pandoc_install(){
    PANDOC_VERSION_LATEST=$(curl -Ls -o /dev/null -w "%{url_effective}\n" https://github.com/jgm/pandoc/releases/latest)
    PANDOC_VERSION=${PANDOC_VERSION_LATEST##*/}

    install(){
        to_fetch=https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb
        curl -Ls -o /tmp/pandoc.deb  $to_fetch
        sudo dpkg -i /tmp/pandoc.deb
    }

    if ! which pandoc >> /dev/null; then
        install
        return
    fi
    current_pandoc=$(pandoc --version | head -n 1 | cut -f2 -d' ')
    if [[ $PANDOC_VERSION != $current_pandoc ]]; then
        install
        return
    fi
}
pandoc_install

