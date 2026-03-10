sudo apt install -y cowsay python3 git \
    tar jq bat   xclip sqlite3 libfuse2 \
    libsqlite3-dev lolcat lynis auditd debsums \
    obs-studio  ffmpeg  pipewire stow sox fonts-noto-color-emoji clamav \
    tmux ntfs-3g ufw texlive parallel \
    libheif-examples tidy build-essential  avr-libc  gcc-avr avrdude  clangd bear lldb libjemalloc-dev \
    autoconf  libtool waybar network-manager swaylock zstd git-lfs  grim slurp wl-clipboard chromium-browser \
    libwxgtk3.2-dev  build-essential autoconf libncurses-dev libssl-dev | sudo tee -a "$LOG_FILE" || true

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true 
fi

(
    cd ~/.tmux/plugins/tpm
    git fetch 
    git pull

    tmux kill-session -t temp_session || true
    tmux new-session -d -s temp_session || true
    tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins || true
    tmux kill-session -t temp_session || true
)



