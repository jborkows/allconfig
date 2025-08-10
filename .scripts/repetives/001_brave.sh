if ! which brave-browser >> /dev/null ; then
    curl -fsS https://dl.brave.com/install.sh | sh
    xdg-settings set default-web-browser brave-browser.desktop
fi

