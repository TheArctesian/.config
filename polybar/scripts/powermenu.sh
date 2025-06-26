#!/usr/bin/env bash

# Define the theme path - make sure this is correct
THEME_PATH="$HOME/.config/rofi/powermenu.rasi"

# Check if the theme file exists
if [ ! -f "$THEME_PATH" ]; then
    echo "Theme file not found: $THEME_PATH"
    # Fall back to default styling if theme doesn't exist
    THEME_ARG=""
else
    THEME_ARG="-theme $THEME_PATH"
fi

# Power menu options with enhanced Nerd Font icons
shutdown="⏻  Shutdown"
reboot="󰜉  Restart"
lock="󰌾  Lock"
suspend="󰤄  Sleep"
logout="󰍃  Logout"
cancel="󰕍  Cancel"

# Show rofi with options (using eval to properly handle the theme argument)
choice=$(echo -e "$shutdown\n$reboot\n$lock\n$suspend\n$logout\n$cancel" | \
        eval "rofi -dmenu $THEME_ARG -p 'Power' -i")

# Execute the chosen option
case "$choice" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
#    "$lock")
        # Lock the screen with GDM
#        dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        loginctl lock-session
        ;;
    "$cancel" | *)
        # Do nothing
        dunstify "Cancel"
        ;;
esac
