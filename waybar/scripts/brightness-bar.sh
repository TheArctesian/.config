#!/usr/bin/env bash
# Brightness progress bar for Waybar (pip-style)

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$(( brightness * 100 / max_brightness ))

# Icon based on brightness level
if [ "$percent" -ge 80 ]; then
    icon="󰃠"
elif [ "$percent" -ge 40 ]; then
    icon="󰃟"
else
    icon="󰃞"
fi

# Create pip-style progress bar (8 characters for compact size)
bar_length=8
filled=$(( percent * bar_length / 100 ))
empty=$(( bar_length - filled ))

bar=""
for ((i=0; i<filled; i++)); do
    bar+="━"
done
for ((i=0; i<empty; i++)); do
    bar+="─"
done

# Determine color class based on percentage
if [ "$percent" -le 15 ]; then
    class="low"
elif [ "$percent" -le 30 ]; then
    class="medium-low"
elif [ "$percent" -le 45 ]; then
    class="medium"
elif [ "$percent" -le 60 ]; then
    class="medium-high"
elif [ "$percent" -le 75 ]; then
    class="high"
else
    class="very-high"
fi

# Output for Waybar
echo "{\"text\": \"$icon $bar $percent%\", \"tooltip\": \"Brightness: $percent%\", \"class\": \"$class\"}"
