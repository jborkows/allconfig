go_install(){
    sudo rm -rf /usr/bin/go
    install(){
        # shellcheck disable=SC2153 
        echo "$GO_VERSION"
        curl -Lo "/tmp/go${GO_VERSION}.linux-amd64.tar.gz" "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" >> "$LOG_FILE"
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

    }
    if ! which go > /dev/null; then 
        install
        return
    fi
    go_version=$(go version | cut -d' ' -f3 | cut -c3-)
    if [[ $go_version != "$GO_VERSION" ]]; then
        install
        return
    fi
    if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
        # shellcheck disable=SC2016
        echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc
        # shellcheck disable=SC1090
        source ~/.bashrc
    fi

}

go_lang_cli(){
    install(){
        curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b "$(go env GOPATH)/bin" "v${GOLANG_CLI_VERSION}"
    }
    if ! which golangci-lint > /dev/null; then 
        echo 'No golang cli'
        install
    fi

    if ! golangci-lint --version | grep -q "version ${GOLANG_CLI_VERSION}"; then
        echo "Versions does not match"
        install
    fi
}

go_install
go_lang_cli

{
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest ;
go install -tags 'sqlite3' github.com/golang-migrate/migrate/v4/cmd/migrate@latest ;
go install github.com/air-verse/air@latest ;
} >> "$LOG_FILE"
