#!/usr/bin/env bash
# Opens a URL in mpv with a desktop notification

URL="$1"

notify-send "Opening in mpv" "$URL" || true
exec mpv --script-opts=ytdl_hook-ytdl_path="$(command -v yt-dlp)" "$URL"
