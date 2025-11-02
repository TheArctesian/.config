#!/usr/bin/env bash
# Random Wallpaper Selector for Hyprland
# Selects a random wallpaper from ~/Pictures/wallpaper/nord/ and sets it using hyprpaper

WALLPAPER_DIR="$HOME/Pictures/wallpaper/nord"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist"
    exit 1
fi

# Get a random wallpaper from the directory
# Supports common image formats: jpg, jpeg, png, webp
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Check if we found any wallpapers
if [ -z "$WALLPAPER" ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'"
    exit 1
fi

# Preload the new wallpaper
hyprctl hyprpaper preload "$WALLPAPER" &> /dev/null

# Set the wallpaper for all monitors
# The comma before the path means "all monitors"
hyprctl hyprpaper wallpaper ",$WALLPAPER" &> /dev/null

# Optional: Unload all other wallpapers to save memory
# Note: We skip this to avoid delays, but you can uncomment if needed
# hyprctl hyprpaper unload all 2>/dev/null

# Success - print the wallpaper name (optional, can be removed for silent operation)
# echo "Wallpaper set to: $(basename "$WALLPAPER")"
