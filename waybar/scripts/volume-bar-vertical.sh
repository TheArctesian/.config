#!/usr/bin/env bash
# Vertical volume progress bar for Waybar

# Get volume and mute status
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

# Icon based on volume level
if [ "$muted" -eq 1 ]; then
    icon="󰝟"
else
    if [ "$volume" -ge 70 ]; then
        icon="󰕾"
    elif [ "$volume" -ge 30 ]; then
        icon="󰖀"
    else
        icon="󰕿"
    fi
fi

# Create vertical progress bar (8 blocks for visual clarity)
bar_length=8
filled=$(( volume * bar_length / 100 ))
empty=$(( bar_length - filled ))

# Build vertical bar from bottom to top using block characters
bar=""
for ((i=0; i<empty; i++)); do
    bar+="┄\n"  # Empty blocks at top
done
for ((i=0; i<filled; i++)); do
    bar+="┃\n"  # Filled blocks from middle to bottom
done

# Format output with icon on top, bar in middle, percentage at bottom
# Using newlines for vertical stacking
display="$icon\n$bar$volume%"

# Output for Waybar (plain text format for vertical display)
echo -e "$display"
