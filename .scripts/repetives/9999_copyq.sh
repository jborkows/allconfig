copyq_install(){
    required(){
        sudo apt install -y \
          cmake \
          extra-cmake-modules \
          git \
          libwayland-dev \
          libxfixes-dev \
          libxtst-dev \
          qt6-base-private-dev \
          qt6-base-dev \
          qt6-declarative-dev \
          qt6-tools-dev \
          qt6-wayland-dev \
          libqt6svg6-dev \
          libqt6opengl6-dev \
          libqt6openglwidgets6 
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
            pkill copyq || true
            cp copyq ~/programs
            copyq --start-server 
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


