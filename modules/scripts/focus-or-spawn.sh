#!/usr/bin/env bash
# Focus existing window on current workspace or spawn new instance
# Usage: focus-or-spawn <app-id> <spawn-command>
# Example: focus-or-spawn firefox firefox
# Example: focus-or-spawn "chrome-chatgpt.com.*" chromium-chatgpt

if [ $# -lt 2 ]; then
  echo "Usage: focus-or-spawn <app-id-pattern> <spawn-command>"
  exit 1
fi

app_id_pattern="$1"
spawn_command="$2"

# Get current workspace
current_workspace=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .id')

# Get all matching windows on current workspace
matching_windows=$(niri msg --json windows | jq -r --arg ws "$current_workspace" --arg pattern "$app_id_pattern" \
  '.[] | select(.workspace_id == ( $ws | tonumber) and (.app_id | test($pattern))) | .id')

if [ -n "$matching_windows" ]; then
  # Window exists on current workspace - focus it
  window_id=$(echo "$matching_windows" | head -n1)
  niri msg action focus-window --id "$window_id"
else
  # No matching window on current workspace - spawn new instance
  $spawn_command &
fi
