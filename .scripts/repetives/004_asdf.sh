ASDF_VERSION="0.16.7"

asdf_install(){
    install(){
        # Download the Go-based asdf binary
        curl -L -o /tmp/asdf.tar.gz "https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz"
        mkdir -p ~/.local/bin
        tar -xzf /tmp/asdf.tar.gz -C ~/.local/bin
        rm /tmp/asdf.tar.gz
        # Remove old bash-based asdf if present
        rm -rf ~/.asdf 2>/dev/null || true
    }

    if ! which asdf > /dev/null 2>&1; then
        echo "Installing asdf ${ASDF_VERSION}..."
        install
    else
        CURRENT_VERSION=$(asdf version 2>/dev/null | head -1 | grep -oP 'v?\K[0-9]+\.[0-9]+\.[0-9]+' || echo "0.0.0")
        if [[ "$CURRENT_VERSION" != "$ASDF_VERSION" ]]; then
            echo "Upgrading asdf from $CURRENT_VERSION to $ASDF_VERSION..."
            install
        fi
    fi
}

asdf_install

# Ensure asdf is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Install elixir plugin if not present
if ! asdf plugin list 2>/dev/null | grep -q "^elixir$"; then
    asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git >> $LOG_FILE
fi

# Install erlang plugin if not present (required for elixir)
if ! asdf plugin list 2>/dev/null | grep -q "^erlang$"; then
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git >> $LOG_FILE
fi

# Update plugins
asdf plugin update --all >> $LOG_FILE 2>&1 || true

# Install latest erlang if not installed
LATEST_ERLANG=$(asdf latest erlang)
if ! asdf list erlang 2>/dev/null | grep -q "$LATEST_ERLANG"; then
    echo "Installing erlang $LATEST_ERLANG..."
    asdf install erlang latest >> $LOG_FILE 2>&1
fi
asdf set --home erlang "$LATEST_ERLANG" >> $LOG_FILE 2>&1

# Install latest elixir if not installed
LATEST_ELIXIR=$(asdf latest elixir)
if ! asdf list elixir 2>/dev/null | grep -q "$LATEST_ELIXIR"; then
    echo "Installing elixir $LATEST_ELIXIR..."
    asdf install elixir latest >> $LOG_FILE 2>&1
fi
asdf set --home elixir "$LATEST_ELIXIR" >> $LOG_FILE 2>&1

echo "asdf setup complete with erlang $LATEST_ERLANG and elixir $LATEST_ELIXIR"
