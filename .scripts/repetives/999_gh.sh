github_install(){
    VERSION_LATEST=$(curl -Ls -o /dev/null -w "%{url_effective}\n" https://github.com/cli/cli/releases/latest)
    APP_VERSION=${VERSION_LATEST##*/}
    APP_VERSION=${APP_VERSION:1}

    install(){

        to_fetch=https://github.com/cli/cli/releases/download/v${APP_VERSION}/gh_${APP_VERSION}_linux_amd64.deb 
        curl -Ls -o /tmp/gh.deb  $to_fetch
        sudo dpkg -i /tmp/gh.deb
    }

    if ! which gh >> /dev/null; then
        install
        return
    fi
    current_version=$(gh --version | head -n 1 | cut -f3 -d' ')
    if [[ $APP_VERSION != $current_version ]]; then
        install
        return
    fi
}
github_install

