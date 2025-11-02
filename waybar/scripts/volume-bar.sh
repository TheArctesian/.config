#!/usr/bin/env bash
# Volume progress bar for Waybar (pip-style)

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

# Create pip-style progress bar (8 characters for compact size)
bar_length=8
filled=$(( volume * bar_length / 100 ))
empty=$(( bar_length - filled ))

bar=""
for ((i=0; i<filled; i++)); do
    bar+="━"
done
for ((i=0; i<empty; i++)); do
    bar+="─"
done

# Output for Waybar
echo "{\"text\": \"$icon $bar $volume%\", \"tooltip\": \"Volume: $volume%\", \"class\": \"$([ "$muted" -eq 1 ] && echo muted || echo normal)\"}"
