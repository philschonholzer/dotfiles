#!/usr/bin/env bash
# Nautilus script: Copy local relative path(s)
set -euo pipefail

while IFS= read -r filepath; do
  [[ -z "$filepath" ]] && continue
  rel="${filepath#"$HOME/kDrive"}"
  printf '%s\n' "$rel"
done <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" \
  | head -c -1 \
  | wl-copy

notify-send "kDrive" "Local path copied to clipboard"
