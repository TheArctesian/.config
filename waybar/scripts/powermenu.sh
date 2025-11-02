#!/usr/bin/env bash

# Power menu for Hyprland using rofi
# Adapted for Waybar

# Define the theme path
THEME_PATH="$HOME/.config/rofi/powermenu.rasi"

# Check if the theme file exists
if [ ! -f "$THEME_PATH" ]; then
    echo "Theme file not found: $THEME_PATH"
    # Fall back to default styling if theme doesn't exist
    THEME_ARG=""
else
    THEME_ARG="-theme $THEME_PATH"
fi

# Power menu options with Nerd Font icons
shutdown="⏻  Shutdown"
reboot="󰜉  Restart"
lock="󰌾  Lock"
suspend="󰤄  Sleep"
logout="󰍃  Logout"
cancel="󰕍  Cancel"

# Show rofi with options
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
    "$lock")
        # Use Hyprland's lock command or hyprlock if installed
        if command -v hyprlock &> /dev/null; then
            hyprlock
        else
            # Fallback to swaylock if available
            if command -v swaylock &> /dev/null; then
                swaylock
            else
                notify-send "Lock" "No lock program found" -u critical
            fi
        fi
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        # Hyprland logout
        hyprctl dispatch exit
        ;;
    "$cancel" | *)
        # Do nothing
        exit 0
        ;;
esac