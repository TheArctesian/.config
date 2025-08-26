#!/usr/bin/env bash

TOGGLE_FILE="$HOME/.config/polybar/workspace_numbers_mode"
CONFIG_FILE="$HOME/.config/polybar/config.ini"

if [ -f "$TOGGLE_FILE" ]; then
    # Switch to names mode (with icons)
    rm "$TOGGLE_FILE"
    # Update the xworkspaces module to use names
    sed -i 's/label-active = %index%/label-active = %name%/g' "$CONFIG_FILE"
    sed -i 's/label-occupied = %index%/label-occupied = %name%/g' "$CONFIG_FILE"
    sed -i 's/label-urgent = %index%/label-urgent = %name%/g' "$CONFIG_FILE"
    sed -i 's/label-empty = %index%/label-empty = %name%/g' "$CONFIG_FILE"
else
    # Switch to numbers mode
    touch "$TOGGLE_FILE"
    # Update the xworkspaces module to use indexes
    sed -i 's/label-active = %name%/label-active = %index%/g' "$CONFIG_FILE"
    sed -i 's/label-occupied = %name%/label-occupied = %index%/g' "$CONFIG_FILE"
    sed -i 's/label-urgent = %name%/label-urgent = %index%/g' "$CONFIG_FILE"
    sed -i 's/label-empty = %name%/label-empty = %index%/g' "$CONFIG_FILE"
fi

# Restart polybar
