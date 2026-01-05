kerl_install(){
    install(){
        curl -L -o "${HOME}/programs/kerl" https://raw.githubusercontent.com/kerl/kerl/master/kerl 
        chmod u+x "${HOME}/programs/kerl" 
    }

    if ! which kerl >> /dev/null; then
        install
        return
    fi



}

kerl_install
kerl upgrade
