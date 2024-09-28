#wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
wget -P ~/.local/share/fonts  https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono*.zip \
&& rm JetBrainsMono*.zip \
&& fc-cache -fv
