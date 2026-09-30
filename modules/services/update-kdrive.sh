#!/usr/bin/env bash
set -euo pipefail

repo=$(git rev-parse --show-toplevel)
target="$repo/modules/services/kdrive.nix"

if ! git -C "$repo" diff --quiet -- "$target" || ! git -C "$repo" diff --cached --quiet -- "$target"; then
  printf 'Refusing to update %s because it has uncommitted changes.\n' "$target" >&2
  exit 1
fi

# Use the production Linux AMD64 release, including its build number.
url=$(curl --fail --silent --show-error --get \
  --data-urlencode 'channel=production' \
  --data-urlencode 'platform=linux-amd' \
  --data-urlencode 'store=kStore' \
  --data-urlencode 'name=com.infomaniak.drive' \
  'https://api.infomaniak.com/1/app-information/applications/version/no-auth' \
  | jq --exit-status --raw-output 'select(.result == "success") | .data.download_link')

if ! [[ "$url" =~ ^https://download\.storage\.infomaniak\.com/drive/desktopclient/kDrive-[0-9]+(\.[0-9]+)*-amd64\.AppImage$ ]]; then
  printf 'Could not determine a valid kDrive AppImage URL.\n' >&2
  exit 1
fi

hash=$(nix-prefetch-url "$url")

if ! [[ "$hash" =~ ^[0-9abcdfghijklmnpqrsvwxyz]{52}$ ]]; then
  printf 'Could not determine a valid Nix hash.\n' >&2
  exit 1
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Write to a temporary file rather than relying on platform-specific sed -i.
sed \
  -e 's|url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-[^"]*";|url = "'"$url"'";|' \
  -e 's/sha256 = "[^"]*";/sha256 = "'"$hash"'";/' \
  "$target" >"$tmpdir/kdrive.nix"
nixfmt "$tmpdir/kdrive.nix"
cp "$tmpdir/kdrive.nix" "$target"
git -C "$repo" add "$target"
nix flake check "$repo"

printf 'Updated kDrive AppImage to %s with hash %s.\n' "$url" "$hash"
printf 'Review the staged change with: git diff --cached -- %s\n' "$target"
