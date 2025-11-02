#!/usr/bin/env bash

# Wayland clipboard menu using cliphist and rofi
# Adapted from Polybar version for Waybar

# Define clipboard actions
copy_action="󰆏 Copy"
clear_action="󰃢 Clear History"
delete_action="󰆴 Delete"

# Get clipboard history from cliphist
clip_data=$(cliphist list | head -50)

# If clipboard is empty, show a message
if [ -z "$clip_data" ]; then
    echo "Clipboard is empty" | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi -p "󰅍 Clipboard" -mesg "No items in clipboard history"
    exit 0
fi

# Format clipboard data for display
formatted_data=""
while IFS=$'\t' read -r id content; do
    # Truncate long content
    if [ ${#content} -gt 60 ]; then
        display_content="${content:0:57}..."
    else
        display_content="$content"
    fi
    
    # Escape rofi control characters
    display_content=$(echo "$display_content" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')
    
    # Store with ID for later retrieval
    formatted_data+="$id\t$display_content\n"
done <<< "$clip_data"

# Add action at the top
menu_items="$clear_action\n$formatted_data"

# Show rofi with clipboard items
selected=$(echo -e "$menu_items" | rofi -dmenu -markup-rows -theme ~/.config/rofi/clipboard.rasi -p "󰅍 Clipboard" -format 'i:s')

# Parse selection
selected_index=$(echo "$selected" | cut -d':' -f1)
selected_text=$(echo "$selected" | cut -d':' -f2-)

# Handle selection
if [ "$selected_text" = "$clear_action" ]; then
    # Clear clipboard history
    cliphist wipe
    notify-send "Clipboard" "History cleared" -i edit-clear
elif [ -n "$selected_text" ] && [ "$selected_index" -gt 0 ]; then
    # Adjust index because "Clear History" is at position 0
    actual_index=$((selected_index - 1))

    # Get the actual item from cliphist and copy to wl-clipboard
    item=$(cliphist list | sed -n "$((actual_index + 1))p")
    if [ -n "$item" ]; then
        # Use cliphist decode to get the exact content and pipe to wl-copy
        echo "$item" | cliphist decode | wl-copy
        notify-send "Clipboard" "Copied to clipboard" -i edit-copy
    fi
fi