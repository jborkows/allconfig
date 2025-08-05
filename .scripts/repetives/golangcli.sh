install(){
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v${GOLANG_CLI_VERSION}
    exit 0
}

if ! which golangci-lint > /dev/null; then 
    echo 'No golang cli'
    install
fi

if ! golangci-lint --version | grep -q "version ${GOLANG_CLI_VERSION}"; then
    echo "Versions does not match"
    install
fi

