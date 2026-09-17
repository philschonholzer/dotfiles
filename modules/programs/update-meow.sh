#!/usr/bin/env bash
set -euo pipefail

repo=$(git rev-parse --show-toplevel)
target="$repo/modules/programs/meow.nix"

if ! git -C "$repo" diff --quiet -- "$target" || ! git -C "$repo" diff --cached --quiet -- "$target"; then
  printf 'Refusing to update %s because it has uncommitted changes.\n' "$target" >&2
  exit 1
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cookie="$tmpdir/cookie"
appimage="$tmpdir/meow.AppImage"

curl --fail --silent --show-error --cookie-jar "$cookie" \
  --header 'Content-Type: application/json' \
  --data '{"accepted":true}' \
  'https://meow.qfiber.co.il/api/v1/download/consent' >/dev/null

curl --fail --location --silent --show-error --cookie "$cookie" \
  --output "$appimage" \
  'https://meow.qfiber.co.il/api/v1/download/meow.AppImage'

hash=$(nix-prefetch-url "file://$appimage" | sed -n '$p')

if ! [[ "$hash" =~ ^[0-9a-z]{52}$ ]]; then
  printf 'Could not determine a valid Nix hash.\n' >&2
  exit 1
fi

sed -i 's/sha256 = "[^"]*";/sha256 = "'"$hash"'";/' "$target"
nixfmt "$target"
git -C "$repo" add "$target"
nix flake check "$repo"

printf 'Updated Meow AppImage hash to %s.\n' "$hash"
printf 'Review the staged change with: git diff --cached -- %s\n' "$target"
