#!/usr/bin/env bash

# Custom clipboard menu using rofi and greenclip
# Uses a custom theme for a more polished look

# Define clipboard actions
copy_action="󰆏 Copy"
paste_action="󰆒 Paste"
clear_action="󰃢 Clear History"
edit_action="󰏫 Edit"
delete_action="󰆴 Delete"

# Get clipboard history from greenclip
clip_data=$(greenclip print | grep -v '^$')

# If clipboard is empty, show a message
if [ -z "$clip_data" ]; then
    echo "Clipboard is empty" | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi -p "󰅍 Clipboard" -mesg "No items in clipboard history"
    exit 0
fi

# Format each clipboard item (truncate long lines)
formatted_data=""
while IFS= read -r line; do
    # Truncate line if too long (over 60 chars)
    if [ ${#line} -gt 60 ]; then
        formatted_line="${line:0:57}..."
    else
        formatted_line="$line"
    fi
    
    # Escape potential rofi control characters
    formatted_line=$(echo "$formatted_line" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')
    
    formatted_data+="$formatted_line\n"
done <<< "$clip_data"

# Add actions at the top
formatted_data="$clear_action\n$formatted_data"

# Show rofi with clipboard items
selected=$(echo -e "$formatted_data" | rofi -dmenu -markup-rows -theme ~/.config/rofi/clipboard.rasi -p "󰅍 Clipboard")

# Handle selection
if [ "$selected" = "$clear_action" ]; then
    # Clear clipboard history
    greenclip clear
    notify-send "Clipboard" "History cleared" -i edit-clear
elif [ -n "$selected" ]; then
    # If it's not an action and not empty, copy to clipboard
    if [ "$selected" != "$copy_action" ] && [ "$selected" != "$paste_action" ] && [ "$selected" != "$edit_action" ] && [ "$selected" != "$delete_action" ]; then
        # If truncated, find the original
        if [[ "$selected" == *"..."* ]]; then
            prefix="${selected:0:57}"
            original=$(echo "$clip_data" | grep "^$prefix")
            echo "$original" | greenclip copy
        else
            echo "$selected" | greenclip copy
        fi
        
        # Notify the user
        notify-send "Clipboard" "Copied to clipboard" -i edit-copy
    fi
fi
