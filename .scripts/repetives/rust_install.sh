if ! which cargo > /dev/null; then 
    echo 'Rust cli'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


rustup update
cargo install stylua
cargo install ripgrep
