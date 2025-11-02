#!/usr/bin/env bash
# Screenshot that copies FILE PATH to clipboard (for CLI apps like Claude Code)

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${OMARCHY_SCREENSHOT_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}}/Screenshots"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  notify-send "Screenshot directory does not exist: $OUTPUT_DIR" -u critical -t 3000
  exit 1
fi

FILENAME="$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

pkill slurp || hyprshot -m ${1:-region} --raw |
  satty --filename - \
    --output-filename "$FILENAME" \
    --early-exit \
    --save-after-copy

# Copy the FILE PATH as text (for pasting into terminal apps)
echo -n "$FILENAME" | wl-copy

notify-send "Screenshot saved for CLI" "Path copied: $FILENAME" -t 3000
