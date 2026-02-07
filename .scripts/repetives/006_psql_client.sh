#!/bin/bash

set -euo pipefail

# PostgreSQL Client Installation Script
# Installs psql client and related tools

install_psql_client() {
    echo "Installing PostgreSQL client..."
    
    # Update package lists
    sudo apt update
    
    # Install PostgreSQL client and common tools
    sudo apt install -y postgresql-client \
                       postgresql-client-common \
                       libpq-dev \
                       pgcli >> "$LOG_FILE"
    
    echo "PostgreSQL client installed successfully!"
}

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo "PostgreSQL client not found. Installing..."
    install_psql_client
else
    echo "PostgreSQL client is already installed: $(psql --version)"
fi

# Install pgcli for enhanced psql experience if not already installed
if ! command -v pgcli &> /dev/null; then
    echo "Installing pgcli (enhanced PostgreSQL CLI)..."
    pip install --user pgcli >> "$LOG_FILE" 2>&1 || true
fi

# Verify installation
echo "PostgreSQL tools installation complete!"
psql --version
