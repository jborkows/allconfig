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

set +euo pipefail
nvm install --lts     >> $LOG_FILE  #                Install the latest LTS version
nvm use --lts         >> $LOG_FILE #                Use the latest LTS version
npm install -g neovim >> $LOG_FILE
npm install -g @playwright/mcp >> $LOG_FILE
set -euo pipefail
