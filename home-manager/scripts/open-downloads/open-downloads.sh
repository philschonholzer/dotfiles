#!/usr/bin/env bash
# List files in ~/Downloads/ and open the selected one with xdg-open
# Select "Copy path" action to copy the file path to clipboard instead

set -euo pipefail

DOWNLOADS_DIR="$HOME/Downloads"

# Check if Downloads directory exists
if [ ! -d "$DOWNLOADS_DIR" ]; then
    notify-send "Error" "Downloads directory not found: $DOWNLOADS_DIR"
    exit 1
fi

# List files (excluding directories) with fd, sort by modification time (newest first)
# Using fd for better performance and filtering
selected=$(fd --type f --max-depth 1 . "$DOWNLOADS_DIR" --exec-batch ls -t | \
    sed "s|$DOWNLOADS_DIR/||" | \
    fuzzel --dmenu --prompt "Downloads: ")

# Exit if no selection was made
if [ -z "$selected" ]; then
    exit 0
fi

# Get the full path
full_path="$DOWNLOADS_DIR/$selected"

# Ask user what action to take
action=$(printf "Open\nCopy path\nCopy file" | fuzzel --dmenu --prompt "Action: ")

# Exit if no action was selected
if [ -z "$action" ]; then
    exit 0
fi

case "$action" in
    "Open")
        xdg-open "$full_path" &
        ;;
    "Copy path")
        echo -n "$full_path" | wl-copy
        notify-send "Copied path to clipboard" "$full_path"
        ;;
    "Copy file")
        # Copy file in a format that file managers understand (GNOME/KDE style)
        # Use URI format with file:// prefix
        echo "file://$full_path" | wl-copy --type text/uri-list
        notify-send "Copied file to clipboard" "You can now paste it in a file manager"
        ;;
esac
