#!/usr/bin/env bash

# Get the current desktop names and numbers
DESKTOPS=$(xprop -root _NET_DESKTOP_NAMES | cut -d "=" -f 2 | tr -d '", ')

# Check if we're in numbers mode
if [ -f "$HOME/.config/polybar/workspace_numbers_mode" ]; then
    # In numbers mode, just return index numbers
    echo "%index%"
else
    # In names mode, return the usual names
    echo "%name%"
fi
