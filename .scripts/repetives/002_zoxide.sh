
zoxide_install(){
    install(){
        (
            cd /tmp
            curl -L -o zoxide.sh https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
            bash zoxide.sh
        )
    }
    ZOXIDE_VERSION_LATEST=$(curl -Ls -o /dev/null -w "%{url_effective}\n"  https://github.com/ajeetdsouza/zoxide/releases/latest)
    ZOXIDE_VERSION=${ZOXIDE_VERSION_LATEST##*/}
    ZOXIDE_VERSION=${ZOXIDE_VERSION:1}

    if ! which zoxide >> /dev/null; then
        install
        return
    fi
    current_version=$(zoxide --version | head -n 1 | cut -f2 -d' ')
    if [[ $ZOXIDE_VERSION != $current_version ]]; then
        echo installing due latest version ${ZOXIDE_VERSION} current $current_version
        install
        return
    fi


}

zoxide_install


