# kDrive shared library — source this file, do not execute directly
# Requires: curl, jq, TOKEN, DRIVE_ID, API to be set or sourced beforehand.

DRIVE_ID=1799915
API="https://api.infomaniak.com"
TOKEN=$(cat "$HOME/.config/kDrive/api-token")

# Usage: kdrive_file_id <relative_path>
# Prints the kDrive file ID for the given relative path (e.g. "foo/bar/baz.txt")
kdrive_file_id() {
  local rel="$1"
  local parent_id=1
  local part response

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
      return 1
    fi
  done

  printf '%s' "$parent_id"
}

# Usage: kdrive_url <file_id>
kdrive_url() {
  printf 'https://kdrive.infomaniak.com/app/drive/%s/redirect/%s' "$DRIVE_ID" "$1"
}

# Usage: kdrive_rel_path <absolute_path>
# Strips the local kDrive prefix to get the relative path
kdrive_rel_path() {
  printf '%s' "${1#"$HOME/kDrive/"}"
}
