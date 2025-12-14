sdkman_install(){
    install(){
        curl -s "https://get.sdkman.io" | bash
    }

    if ! which sdkman >> /dev/null; then
        install
        return
    fi
}

sdkman_install
