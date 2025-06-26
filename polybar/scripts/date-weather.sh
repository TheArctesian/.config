#!/usr/bin/env bash

# Format the date and time
DATE=$(date "+%d %b %Y")
TIME=$(date "+%H:%M:%S")

# Get weather information (assuming your weather script works)
# WEATHER=$(~/.config/polybar/scripts/weather.sh)

# Combine the information
# echo " $DATE 󰥔 $TIME 󰖐 $WEATHER"
echo "  $DATE  󰥔  $TIME"
