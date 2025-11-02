#!/usr/bin/env bash
# Copy image data to clipboard

if [[ -z "$1" ]]; then
    # Read from stdin and save to file
    temp_file=$(mktemp --suffix=.png)
    cat > "$temp_file"
    file_path="$temp_file"
else
    # Use provided file path
    file_path="$1"
fi

# Copy image data to clipboard
wl-copy --type image/png < "$file_path"

# Also store image in cliphist for clipboard history
if command -v cliphist &> /dev/null; then
    cat "$file_path" | cliphist store
fi
