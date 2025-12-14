asyncprofiler_install(){

    APP_VERSION=$(curl -Ls -o /dev/null -w "%{url_effective}\n"  https://github.com/async-profiler/async-profiler/releases/latest)
    APP_VERSION=${APP_VERSION##*/}
    APP_VERSION=${APP_VERSION:1}
    APPLICATTION="$HOME/programs/asyncprofiler"
    install(){
        rm -rf /tmp/async-profiler*
        curl -Lo /tmp/asyncprofiler.tar.gz  "https://github.com/async-profiler/async-profiler/releases/download/v${APP_VERSION}/async-profiler-${APP_VERSION}-linux-x64.tar.gz"  
        rm -rf "$APPLICATTION" || true 

        tar -C /tmp -xzf /tmp/asyncprofiler.tar.gz 
        mv  "/tmp/async-profiler-${APP_VERSION}-linux-x64" "$APPLICATTION"
    }
    if [ ! -f "${APPLICATTION}" ]; then
        install 
    fi
    if ! which nvim >> /dev/null ; then 
        install
        return
    fi

    current_version=$("$HOME/programs/asyncprofiler/bin/asprof" --version | head -n 1 |cut -f2 -d" ")
    if [[ "$current_version" != "$APP_VERSION" ]]; then
        install
        return
    else
        echo "async profiler is already at ${APP_VERSION}"
    fi
}

asyncprofiler_install

