#!/usr/bin/env bash
# Nautilus script: Share kDrive link
set -euo pipefail

DRIVE_ID=1799915
TOKEN=$(cat "$HOME/.config/kDrive/api-token")
API="https://api.infomaniak.com"

# Take only the first selected file
filepath=$(head -n1 <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")
[[ -z "$filepath" ]] && exit 1

# Strip local kDrive prefix to get relative path
rel="${filepath#"$HOME/kDrive/"}"

# Traverse path segments to find the file ID, starting at root (id=1)
parent_id=1
IFS='/' read -ra parts <<< "$rel"
for part in "${parts[@]}"; do
  [[ -z "$part" ]] && continue

  response=$(curl -sf -G \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data-urlencode "name=$part" \
    "$API/3/drive/$DRIVE_ID/files/$parent_id/name")

  parent_id=$(jq -r '.data.id' <<< "$response")

  if [[ -z "$parent_id" || "$parent_id" == "null" ]]; then
    notify-send "kDrive" "File not found: $part"
    exit 1
  fi
done

url="https://kdrive.infomaniak.com/app/drive/$DRIVE_ID/redirect/$parent_id"

printf '%s' "$url" | wl-copy
notify-send "kDrive" "Share link copied to clipboard"
