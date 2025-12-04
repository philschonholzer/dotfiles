#!/usr/bin/env bash
# Qutebrowser Profile Indicator for Waybar
# Shows the qutebrowser profile when a qutebrowser window is focused
# Format: "Work" | "Private" | "" (default profile shows nothing)

set -euo pipefail

# Get focused window info
focused=$(niri msg --json focused-window 2>/dev/null || echo "{}")

# Check if any window is focused
if [ "$focused" = "{}" ] || [ "$focused" = "null" ]; then
  exit 0
fi

# Extract app_id
app_id=$(echo "$focused" | jq -r '.app_id // ""')

# Check if it's a qutebrowser window
case "$app_id" in
  "qutebrowser-work")
    echo "Work"
    ;;
  "qutebrowser-private")
    echo "Private"
    ;;
  "qutebrowser")
    # Default profile - show nothing or uncomment below to show "Default"
    # echo "Default"
    ;;
  *)
    # Not qutebrowser - show nothing
    ;;
esac
