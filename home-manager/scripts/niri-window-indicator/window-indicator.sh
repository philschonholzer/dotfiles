#!/usr/bin/env bash
# Niri Window Indicator for Waybar
# Shows visual dots for windows on the focused workspace
# Format: ···O·· (6 windows, 4th focused)

set -euo pipefail

# Get all windows
windows=$(niri msg --json windows)
# Get focused workspace ID
focused_ws=$(niri msg --json workspaces | jq '.[] | select(.is_focused) | .id')

# Build the indicator string
indicator=$(echo "$windows" | jq -r --arg ws "$focused_ws" '
  [.[] | select(.workspace_id == ($ws | tonumber))] |
  sort_by(.layout.pos_in_scrolling_layout) |
  to_entries |
  map(if .value.is_focused then "⦿" else "·" end) |
  join("")
')

# Count windows
window_count=${#indicator}

# Output the indicator only if 2 or more windows
if [ "$window_count" -ge 2 ]; then
  echo "$indicator"
fi
