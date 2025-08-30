#!/usr/bin/env bash

# Function to get VPN status
get_vpn_status() {
    # Check if mullvad CLI is available
    if command -v mullvad &> /dev/null; then
        status=$(mullvad status 2>/dev/null | head -n1)
        if echo "$status" | grep -q "Connected"; then
            # Extract location from status
            location=$(echo "$status" | sed -n 's/.*Connected to \([^,]*\).*/\1/p')
            echo "connected:$location"
        elif echo "$status" | grep -q "Connecting"; then
            echo "connecting"
        else
            echo "disconnected"
        fi
    else
        echo "error:No VPN client found"
    fi
}

# Function to toggle VPN connection
toggle_vpn() {
    status=$(get_vpn_status)
    
    if command -v mullvad &> /dev/null; then
        if [[ "$status" == connected* ]]; then
            mullvad disconnect
        else
            mullvad connect
        fi
    else
        notify-send "Mullvad VPN" "No VPN client found. Please install mullvad-vpn."
    fi
}

# Main script logic
case "$1" in
    --toggle)
        toggle_vpn
        ;;
    --status)
        status=$(get_vpn_status)
        case "$status" in
            connected:*)
                location="${status#connected:}"
                echo "󰌾 $location"
                ;;
            connecting)
                echo "󰌿 Connecting..."
                ;;
            disconnected)
                echo "󰿆 Disconnected"
                ;;
            error:*)
                echo "󰿆 Error"
                ;;
        esac
        ;;
    *)
        # Default: show status for polybar
        status=$(get_vpn_status)
        case "$status" in
            connected:*)
                location="${status#connected:}"
                echo "%{F#98c379}󰌾%{F-} $location"
                ;;
            connecting)
                echo "%{F#e5c07b}󰌿%{F-} Connecting"
                ;;
            disconnected)
                echo "%{F#e06c75}󰿆%{F-} Off"
                ;;
            error:*)
                echo "%{F#e06c75}󰿆%{F-} Error"
                ;;
        esac
        ;;
esac