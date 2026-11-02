#!/usr/bin/env bash
# Focus a matching window on the current workspace, or launch the application.
if [ "$#" -lt 2 ]; then
  echo "Usage: umbriel-focus-or-spawn <app-id-pattern> <command> [args...]" >&2
  exit 1
fi

app_id_pattern="$1"
shift

current_workspace=$(umbriel workspaces --json | jq -er '.[] | select(.focused) | .id')
window_id=$(umbriel windows --json | jq -r \
  --arg workspace "$current_workspace" \
  --arg pattern "$app_id_pattern" \
  '[.[] | select(.workspace == $workspace and ((.app_id // "") | test($pattern)))] | first | .id // empty')

if [ -n "$window_id" ]; then
  umbriel msg window-focus "$window_id"
else
  exec "$@"
fi
