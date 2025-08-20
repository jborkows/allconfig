copyq_install(){
    required(){
        sudo apt install \
          cmake \
          extra-cmake-modules \
          git \
          libqt5svg5 \
          libqt5svg5-dev \
          libqt5waylandclient5-dev \
          libqt5x11extras5-dev \
          libwayland-dev \
          libxfixes-dev \
          libxtst-dev \
          qtbase5-private-dev \
          qtdeclarative5-dev \
          qttools5-dev \
          qttools5-dev-tools \
          qtwayland5 \
          qtwayland5-dev-tools \
          libkf5notifications-dev
    }

    install(){
        required
        (
            cd /tmp
            git clone https://github.com/hluk/CopyQ.git || true
            cd CopyQ
            git fetch
            git pull
            cmake .
            make
            cp copyq ~/programs
            pkill copyq || true
            copyq --server 
        )
    }
    VERSION=$(curl -Ls -o /dev/null -w "%{url_effective}\n"  https://github.com/hluk/CopyQ/releases/latest)
    VERSION=${VERSION##*/}
    VERSION=${VERSION:1}

    if ! which copyq >> /dev/null; then
        install
        return
    fi
    current_version=$(copyq --version | head -n 1 | cut -f4 -d' ' | cut -f1 -d'-')
    if [[ $VERSION != "$current_version" ]]; then
        echo installing due latest version "${VERSION}" current "$current_version"
        install
        return
    fi


}

copyq_install


