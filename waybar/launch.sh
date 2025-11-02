#!/usr/bin/env bash

# Waybar launch script
# Kill existing instances and launch with dual bars config

# Terminate already running waybar instances
pkill -x waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 0.1; done

# Launch waybar with dual bar configuration
echo "---" | tee -a /tmp/waybar.log
waybar 2>&1 | tee -a /tmp/waybar.log & disown

echo "Waybar launched with top and bottom bars..."