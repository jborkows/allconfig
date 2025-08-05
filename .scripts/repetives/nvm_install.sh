export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

install(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
    nvm install --lts
    exit 0
}
if ! type nvm > /dev/null 2>&1; then 
    echo 'No nvm '
    install
fi

if [[ "$(nvm --version)" != "${NVM_VERSION}"  ]] ; then
    echo "Versions does not match $(nvm --version) expecting ${NVM_VERSION}"
    install
fi

