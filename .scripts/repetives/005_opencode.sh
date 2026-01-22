opencode_install(){
    install(){
        curl -fsSL https://opencode.ai/install | bash
    }

    if ! which opencode >> /dev/null; then
        install
        return
    fi
}

opencode_install
opencode upgrade
