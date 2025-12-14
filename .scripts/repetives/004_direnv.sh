direnv_install(){
    install(){
        sudo apt install direnv
    }

    if ! which direnv >> /dev/null; then
        install
        return
    fi
}

direnv_install
