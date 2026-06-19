#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

if [ -z "${TRELLO_API_KEY:-}" ]; then
  echo "Error: TRELLO_API_KEY not set" >&2
  echo "Create a .env file in $SCRIPT_DIR with your credentials" >&2
  echo "Get your API key from: https://trello.com/app-key" >&2
  exit 1
fi

if [ -z "${TRELLO_TOKEN:-}" ]; then
  echo "Error: TRELLO_TOKEN not set" >&2
  echo "Create a .env file in $SCRIPT_DIR with your credentials" >&2
  echo "Get your token from: https://trello.com/app-key (click 'Token' link)" >&2
  exit 1
fi

boards=$(curl -s "https://api.trello.com/1/members/me/boards?key=${TRELLO_API_KEY}&token=${TRELLO_TOKEN}&filter=open&fields=name,url" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$boards" ]; then
  echo "Error: Failed to fetch Trello boards" >&2
  exit 1
fi

echo "$boards" | jq -r '.[] | "\(.name)\t\(.url)"' | sort
