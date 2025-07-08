choice=$(printf "⏻ Shutdown\n Reboot\n Suspend\n Hibernate" | rofi -dmenu -p "Power Menu")

case "$choice" in
    "⏻ Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Suspend") systemctl suspend ;;
    " Hibernate") systemctl hibernate ;;
esac
