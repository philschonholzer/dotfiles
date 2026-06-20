#!/usr/bin/env bash
# Qutebrowser userscript to fill credentials from Bitwarden
# Automatically selects vault based on qutebrowser basedir:
# - qutebrowser-work -> work vault
# - qutebrowser-private -> private vault
#
# Usage: bitwarden-fill [username|password]
#   username: Fill only username field
#   password: Fill only password field
#   (default): Fill both username and password

set -euo pipefail

# Get fill mode from argument
FILL_MODE="${1:-both}"

# Check required environment variables
if [[ -z "${QUTE_URL:-}" ]] || [[ -z "${QUTE_DATA_DIR:-}" ]] || [[ -z "${QUTE_FIFO:-}" ]]; then
  echo "message-error 'Missing required qutebrowser environment variables'" >>"$QUTE_FIFO"
  exit 1
fi

# Determine vault based on basedir
if [[ "$QUTE_DATA_DIR" == *"qutebrowser-work"* ]]; then
  export RBW_PROFILE="work"
elif [[ "$QUTE_DATA_DIR" == *"qutebrowser-private"* ]]; then
  export RBW_PROFILE="private"
else
  # Default to work vault
  export RBW_PROFILE="work"
fi

# Extract domain from URL and remove subdomains
# Examples:
#   https://www.github.com/user/repo -> github.com
#   https://api.github.com/endpoint -> github.com
#   https://login.microsoftonline.com -> microsoftonline.com
RAW_DOMAIN=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//')

if [[ -z "$RAW_DOMAIN" ]]; then
  echo "message-error 'Could not extract domain from URL'" >>"$QUTE_FIFO"
  exit 1
fi

# Extract main domain (last two or three parts for special TLDs)
# Handle special cases like co.uk, com.au, gov.uk, etc.
DOMAIN_PARTS=$(echo "$RAW_DOMAIN" | awk -F. '{print NF}')
LAST_TWO=$(echo "$RAW_DOMAIN" | awk -F. '{print $(NF-1)"."$NF}')

# Check if it's a known two-part TLD (co.uk, com.au, etc.)
if [[ "$LAST_TWO" =~ ^(co|com|gov|ac|org|net)\.[a-z]{2}$ ]] && [[ $DOMAIN_PARTS -ge 3 ]]; then
  # Three-part domain: example.co.uk
  FULL_DOMAIN=$(echo "$RAW_DOMAIN" | awk -F. '{print $(NF-2)"."$(NF-1)"."$NF}')
elif [[ $DOMAIN_PARTS -ge 2 ]]; then
  # Two-part domain: example.com
  FULL_DOMAIN="$LAST_TWO"
else
  # Single part (unlikely)
  FULL_DOMAIN="$RAW_DOMAIN"
fi

# Extract base domain (e.g., "example.com" -> "example")
BASE_DOMAIN="${FULL_DOMAIN%%.*}"

# Check if rbw is unlocked, unlock if needed
if ! rbw unlocked &>/dev/null; then
  echo "message-info 'Bitwarden is locked. Unlocking...'" >>"$QUTE_FIFO"
  if ! rbw unlock &>/dev/null; then
    echo "message-error 'Failed to unlock Bitwarden. Please unlock manually with: rbw unlock'" >>"$QUTE_FIFO"
    exit 1
  fi
  echo "message-info 'Bitwarden unlocked successfully'" >>"$QUTE_FIFO"
fi

# Search for entries - try full domain first, then base domain
ENTRIES=$(rbw search "$FULL_DOMAIN" 2>/dev/null || true)

if [[ -z "$ENTRIES" ]] && [[ "$FULL_DOMAIN" != "$BASE_DOMAIN" ]]; then
  # Fallback to base domain search (e.g., "9gag.com" -> "9gag")
  ENTRIES=$(rbw search "$BASE_DOMAIN" 2>/dev/null || true)
  SEARCH_TERM="$BASE_DOMAIN"
else
  SEARCH_TERM="$FULL_DOMAIN"
fi

if [[ -z "$ENTRIES" ]]; then
  # No automatic match - let user search all entries
  ALL_ENTRIES=$(rbw list 2>/dev/null || true)

  if [[ -z "$ALL_ENTRIES" ]]; then
    echo "message-error 'No entries found in $RBW_PROFILE vault'" >>"$QUTE_FIFO"
    exit 1
  fi

  SELECTED=$(echo "$ALL_ENTRIES" | fuzzel -d)

  if [[ -z "$SELECTED" ]]; then
    echo "message-info 'No entry selected'" >>"$QUTE_FIFO"
    exit 0
  fi

  ENTRY_NAME="$SELECTED"
  SEARCH_TERM="all entries"
  MANUAL_SELECTION=true
fi

# Only process entry selection if we haven't already done manual selection
if [[ -z "${MANUAL_SELECTION:-}" ]]; then
  # Count matches
  MATCH_COUNT=$(echo "$ENTRIES" | wc -l)

  if [[ $MATCH_COUNT -eq 1 ]]; then
    # Single match - auto-fill
    ENTRY_NAME="$ENTRIES"
  else
    # Multiple matches - let user choose with fuzzel
    SELECTED=$(echo "$ENTRIES" | fuzzel -d)

    if [[ -z "$SELECTED" ]]; then
      echo "message-info 'No entry selected'" >>"$QUTE_FIFO"
      exit 0
    fi

    ENTRY_NAME="$SELECTED"
  fi
fi

# Get credentials from rbw using JSON output
ENTRY_JSON=$(rbw get "$ENTRY_NAME" --raw 2>/dev/null)

if [[ -z "$ENTRY_JSON" ]]; then
  echo "message-error 'Failed to retrieve entry for $ENTRY_NAME'" >>"$QUTE_FIFO"
  exit 1
fi

# Parse JSON to extract username and password using jq
USERNAME=$(echo "$ENTRY_JSON" | jq -r '.data.username // empty')
PASSWORD=$(echo "$ENTRY_JSON" | jq -r '.data.password // empty')

if [[ -z "$PASSWORD" ]]; then
  echo "message-error 'Failed to retrieve password for $ENTRY_NAME'" >>"$QUTE_FIFO"
  exit 1
fi

# Fill credentials into page based on mode
{
  case "$FILL_MODE" in
  username)
    if [[ -n "$USERNAME" ]]; then
      echo "message-info 'Filling username: $USERNAME (matched: $SEARCH_TERM) from $RBW_PROFILE vault'"
      echo "fake-key $USERNAME"
    else
      echo "message-warning 'No username found for $ENTRY_NAME'"
    fi
    ;;
  password)
    echo "message-info 'Filling password (matched: $SEARCH_TERM) from $RBW_PROFILE vault'"
    echo "fake-key $PASSWORD"
    ;;
  both | *)
    if [[ -n "$USERNAME" ]]; then
      echo "message-info 'Filling $USERNAME (matched: $SEARCH_TERM) from $RBW_PROFILE vault'"
      echo "fake-key $USERNAME"
      echo "fake-key <Tab>"
      echo "fake-key $PASSWORD"
    else
      echo "message-info 'Filling password only (matched: $SEARCH_TERM) from $RBW_PROFILE vault'"
      echo "fake-key $PASSWORD"
    fi
    ;;
  esac
} >>"$QUTE_FIFO"
