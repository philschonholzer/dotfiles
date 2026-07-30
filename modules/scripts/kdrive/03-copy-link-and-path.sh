#!/usr/bin/env bash
# Nautilus script: Copy internal kDrive link and local relative path
set -euo pipefail

# shellcheck source=kdrive-lib.sh
source "$KDRIVE_LIB"

# Take only the first selected file
filepath=$(head -n1 <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")
[[ -z "$filepath" ]] && exit 1

rel=$(kdrive_rel_path "$filepath")
file_id=$(kdrive_file_id "$rel")
url=$(kdrive_url "$file_id")

printf 'Link: %s\nPfad: /%s' "$url" "$rel" | wl-copy
notify-send "kDrive" "Link and path copied to clipboard"
