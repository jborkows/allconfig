nvim_install(){
    install(){
        curl -Lo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz 
        sudo rm -rf /opt/nvim-linux64 || true 
        sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz 
        sudo mv /opt/nvim-linux-x86_64 /opt/nvim-linux64
    }
    if ! which nvim >> /dev/null ; then 
        install
        return
    fi
    current_nvim_version=$(nvim --version | head -n 1 |cut -f2 -d" " | cut -c2-)
    if [[ "$current_nvim_version" != "$NVIM_VERSION" ]]; then
        install
        return
    fi
}

nvim_install
nvim --headless "+Lazy! sync" +qa >> $LOG_FILE
nvim --headless "+MasonUpdate" +qa >> $LOG_FILE

