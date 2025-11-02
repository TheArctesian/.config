#!/usr/bin/env bash

# Check if mullvad is installed
if ! command -v mullvad &> /dev/null; then
    notify-send "Mullvad" "Mullvad CLI not installed" -i network-vpn
    exit 1
fi

# Get current status
STATUS=$(mullvad status 2>/dev/null | head -1)

if echo "$STATUS" | grep -q "Connected"; then
    # Disconnect if connected
    mullvad disconnect
    notify-send "Mullvad VPN" "Disconnecting..." -i network-vpn-disconnected
elif echo "$STATUS" | grep -q "Disconnected"; then
    # Connect if disconnected
    mullvad connect
    notify-send "Mullvad VPN" "Connecting..." -i network-vpn
else
    # Show current status if in another state
    notify-send "Mullvad VPN" "$STATUS" -i network-vpn
fi