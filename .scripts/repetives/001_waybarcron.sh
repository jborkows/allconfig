sudo touch /etc/cron.allow

if ! grep -q $(whoami) /etc/cron.allow ; then
    echo $(whoami) | sudo tee /etc/cron.allow
fi

add_waybar_cleaning() {
    echo "Adding crontab"
    ( crontab -l 2>/dev/null; echo "5 * * * * pgrep waybar | sed '1d' | xargs -I {} kill {} || true" ) | crontab -
}

if ! crontab -l > /dev/null 2>&1; then
    add_waybar_cleaning
elif ! crontab -l | grep -q waybar; then
    add_waybar_cleaning
fi

