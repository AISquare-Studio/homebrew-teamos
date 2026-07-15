#!/bin/bash
# Team OS installer (macOS, Apple Silicon).
# Usage: curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/install.sh | bash
set -euo pipefail

APP="Team OS"
REPO="AISquare-Studio/homebrew-teamos"
URL="https://github.com/${REPO}/releases/latest/download/Team-OS-macos-arm64.dmg"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Team OS runs on macOS only." >&2; exit 1
fi
if [ "$(uname -m)" != "arm64" ]; then
  echo "Team OS currently supports Apple Silicon (M-series) Macs only." >&2; exit 1
fi

TMP="$(mktemp -d)"
DMG="$TMP/TeamOS.dmg"
MNT=""
cleanup() {
  [ -n "$MNT" ] && hdiutil detach "$MNT" -quiet 2>/dev/null || true
  rm -rf "$TMP"
}
trap cleanup EXIT

echo "▸ Downloading Team OS…"
curl -fL --progress-bar "$URL" -o "$DMG"

echo "▸ Mounting…"
MNT="$(hdiutil attach "$DMG" -nobrowse -readonly | grep -Eo '/Volumes/[^[:cntrl:]]+' | tail -1)"
if [ -z "$MNT" ] || [ ! -d "$MNT/$APP.app" ]; then
  echo "Could not find '$APP.app' in the downloaded disk image." >&2; exit 1
fi

echo "▸ Installing to /Applications…"
rm -rf "/Applications/$APP.app"
cp -R "$MNT/$APP.app" /Applications/

# Ad-hoc signed build → clear the quarantine flag so Gatekeeper opens it without a prompt.
xattr -dr com.apple.quarantine "/Applications/$APP.app" 2>/dev/null || true

echo "✓ Installed. Opening $APP…"
open "/Applications/$APP.app"
