#!/usr/bin/env bash

# Function to get available monitors
get_monitors() {
    xrandr -q | grep " connected" | cut -d ' ' -f1
}

# Detect if we have multiple monitors
MONITORS=($(get_monitors))
NUM_MONITORS=${#MONITORS[@]}

# Reset bspwm configuration
bspc wm -r

# Display menu with options
if [ "$NUM_MONITORS" -gt 1 ]; then
    PRIMARY=${MONITORS[1]}
    SECONDARY=${MONITORS[0]}
    
    CHOICE=$(echo -e "Extend Right\nExtend Left\nExtend Above\nExtend Below\nMirror\nPrimary Only\nSecondary Only" | rofi -dmenu -p "Monitor Setup")
    
    xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --right-of $PRIMARY
#    case "$CHOICE" in
#        "Extend Right")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --right-of $PRIMARY
#            ;;
#        "Extend Left")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --left-of $PRIMARY
#            ;;
#        "Extend Above")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --above $PRIMARY
#            ;;
#        "Extend Below")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --below $PRIMARY
#            ;;
#        "Mirror")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --auto --same-as $PRIMARY
#            ;;
#        "Primary Only")
#            xrandr --output $PRIMARY --auto --primary --output $SECONDARY --off
#            ;;
#        "Secondary Only")
#            xrandr --output $PRIMARY --off --output $SECONDARY --auto --primary
#            ;;
#    esac
    
    # Restart bspwm
    bspc wm -r
else
    notify-send "Monitor Setup" "Only one monitor detected."
fi
