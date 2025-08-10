kitty_install(){
    KITTY_VERSION_LATEST=$(curl -Ls -o /dev/null -w "%{url_effective}\n"  https://github.com/kovidgoyal/kitty/releases/latest)
    KITTY_VERSION=${KITTY_VERSION_LATEST##*/}
    KITTY_VERSION=${KITTY_VERSION:1}

    install(){
        curl -Lo /tmp/kitty https://sw.kovidgoyal.net/kitty/installer.sh 
        bash /tmp/kitty launch=n

    }
    if ! which kitty >> /dev/null; then
        install
        return
    fi
    current_version=$(kitty --version | head -n 1 | cut -f2 -d' ')
    if [[ $KITTY_VERSION != $current_version ]]; then
        echo installing due latest version ${KITTY_VERSION} current $current_version
        install
        return
    fi
}

kitty_install

if ! grep "kitty"  ~/.config/xdg-terminals.list -q ; then
    # from documentation
    # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
fi
