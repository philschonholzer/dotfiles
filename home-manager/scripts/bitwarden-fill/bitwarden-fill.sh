#!/usr/bin/env bash
# Qutebrowser userscript to fill credentials from Bitwarden
# Automatically selects vault based on qutebrowser basedir:
# - qutebrowser-work -> work vault
# - qutebrowser-private -> private vault

set -euo pipefail

# Check required environment variables
if [[ -z "${QUTE_URL:-}" ]] || [[ -z "${QUTE_DATA_DIR:-}" ]] || [[ -z "${QUTE_FIFO:-}" ]]; then
  echo "message-error 'Missing required qutebrowser environment variables'" >> "$QUTE_FIFO"
  exit 1
fi

# Determine vault based on basedir
if [[ "$QUTE_DATA_DIR" == *"qutebrowser-work"* ]]; then
  export RBW_PROFILE="work"
elif [[ "$QUTE_DATA_DIR" == *"qutebrowser-private"* ]]; then
  export RBW_PROFILE="private"
else
  # Default to private vault
  export RBW_PROFILE="private"
fi

# Extract domain from URL
DOMAIN=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//')

if [[ -z "$DOMAIN" ]]; then
  echo "message-error 'Could not extract domain from URL'" >> "$QUTE_FIFO"
  exit 1
fi

# Check if rbw is unlocked
if ! rbw unlocked &>/dev/null; then
  echo "message-error 'Bitwarden is locked. Please unlock with: rbw unlock'" >> "$QUTE_FIFO"
  exit 1
fi

# Search for entries matching the domain
ENTRIES=$(rbw list --fields name,user 2>/dev/null | grep -i "$DOMAIN" || true)

if [[ -z "$ENTRIES" ]]; then
  echo "message-warning 'No Bitwarden entries found for $DOMAIN in $RBW_PROFILE vault'" >> "$QUTE_FIFO"
  exit 0
fi

# Count matches
MATCH_COUNT=$(echo "$ENTRIES" | wc -l)

if [[ $MATCH_COUNT -eq 1 ]]; then
  # Single match - auto-fill
  ENTRY_NAME=$(echo "$ENTRIES" | awk -F'\t' '{print $1}')
  USERNAME=$(echo "$ENTRIES" | awk -F'\t' '{print $2}')
else
  # Multiple matches - let user choose with fuzzel
  SELECTED=$(echo "$ENTRIES" | awk -F'\t' '{printf "%s [%s]\n", $1, $2}' | fuzzel -d)
  
  if [[ -z "$SELECTED" ]]; then
    echo "message-info 'No entry selected'" >> "$QUTE_FIFO"
    exit 0
  fi
  
  # Extract entry name from selection (format: "name [username]")
  ENTRY_NAME="${SELECTED% \[*\]}"
  USERNAME="${SELECTED##*\[}"
  USERNAME="${USERNAME%\]}"
fi

# Get password from rbw
PASSWORD=$(rbw get "$ENTRY_NAME" 2>/dev/null)

if [[ -z "$PASSWORD" ]]; then
  echo "message-error 'Failed to retrieve password for $ENTRY_NAME'" >> "$QUTE_FIFO"
  exit 1
fi

# Fill credentials into page
{
  echo "message-info 'Filling credentials for $USERNAME from $RBW_PROFILE vault'"
  echo "fake-key $USERNAME"
  echo "fake-key <Tab>"
  echo "fake-key $PASSWORD"
} >> "$QUTE_FIFO"
