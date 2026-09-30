#!/usr/bin/env bash
set -euo pipefail

printf 'Which clients should be updated?\n\n'
printf '  1) kDrive\n  2) Meow\n  3) Both\n  4) None\n\n'

while true; do
  if ! read -r -p 'Choose [1-4, default: 4]: ' choice; then
    printf '\nNo updates selected.\n'
    exit 0
  fi

  case "$choice" in
    1) clients=(kdrive); break ;;
    2) clients=(meow); break ;;
    3) clients=(kdrive meow); break ;;
    4|'') printf 'No updates selected.\n'; exit 0 ;;
    *) printf 'Please choose 1, 2, 3, or 4.\n' ;;
  esac
done

# Run from any directory. Override this for a checkout at another location.
repo=$(git -C "${NIXOS_CONFIG_DIR:-$HOME/nixos-config}" rev-parse --show-toplevel)
status=0

for client in "${clients[@]}"; do
  case "$client" in
    kdrive) updater="$repo/modules/services/update-kdrive.sh" ;;
    meow) updater="$repo/modules/programs/update-meow.sh" ;;
  esac

  printf '\nUpdating %s...\n' "$client"
  if (cd "$repo" && bash "$updater"); then
    printf '%s update complete.\n' "$client"
  else
    printf '%s update failed.\n' "$client" >&2
    status=1
  fi
done

if [[ "$status" == 0 ]]; then
  printf '\nReview the staged changes, commit them, then rebuild/switch to apply the updates.\n'
fi
exit "$status"
