#!/usr/bin/env bash
# Lid Switch Handler for Hyprland
# Manages screen state when laptop lid is opened/closed

# Configuration
LOG_FILE="$HOME/.config/hypr/logs/lid-switch.log"
LOG_DIR="$(dirname "$LOG_FILE")"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Get action from argument
ACTION="${1:-unknown}"

log "Lid switch event: $ACTION"

case "$ACTION" in
    close)
        log "Lid closed - locking session and turning off display"

        # Lock the session (this will trigger hyprlock via hypridle)
        loginctl lock-session

        # Wait a moment for lock to engage
        sleep 0.2

        # Turn off display
        hyprctl dispatch dpms off

        log "Display off, ready for suspend"
        ;;

    open)
        log "Lid opened - turning on display"

        # Turn on display
        hyprctl dispatch dpms on

        # Wait for display to power on
        sleep 0.3

        # Force monitor re-detection and refresh
        hyprctl reload

        log "Display on, monitors refreshed"
        ;;

    *)
        log "Unknown action: $ACTION"
        echo "Usage: $0 {close|open}"
        exit 1
        ;;
esac

log "Lid switch event handled successfully"
exit 0
