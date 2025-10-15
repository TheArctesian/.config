#!/usr/bin/env bash

# Check if mullvad is installed
if ! command -v mullvad &> /dev/null; then
    echo "VPN N/A"
    exit 0
fi

# Get mullvad status in JSON format
mul_status=$(mullvad status -j 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "%{F#545862}󰌊%{F-} Error"
    exit 1
fi

# Parse JSON status using basic tools
state=$(echo "$mul_status" | grep -oP '"state"\s*:\s*"\K[^"]+' | head -1)

case "$state" in
    "connected")
        # Get location from JSON
        location=$(echo "$mul_status" | grep -oP '"location"\s*:\s*"\K[^"]+' | head -1)
        city=$(echo "$location" | cut -d',' -f1)
        country=$(echo "$location" | grep -oP ',\s*\K[^,]+$')
        
        # Shorten if needed
        if [ ${#city} -gt 10 ]; then
            city="${city:0:8}.."
        fi
        
        echo "%{F#98c379}󰌆%{F-} $city"
        ;;
    "connecting")
        echo "%{F#e5c07b}󰌆%{F-} Connecting"
        ;;
    "disconnected")
        echo "%{F#e06c75}󰌊%{F-} Off"
        ;;
    *)
        echo "%{F#545862}󰌊%{F-} Unknown"
        ;;
esac
