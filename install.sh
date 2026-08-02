#!/bin/bash
# TeamSquare (Team OS) installer for macOS, Apple Silicon.
# Usage: curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/install.sh | bash
#
# Name-agnostic on purpose: it installs whatever .app is inside the DMG, so a
# product rename (e.g. "Team OS" -> "TeamSquare") never breaks the installer.
set -euo pipefail

REPO="AISquare-Studio/homebrew-teamos"
URL="https://github.com/${REPO}/releases/latest/download/Team-OS-macos-arm64.dmg"

[ "$(uname -s)" = "Darwin" ] || { echo "This app runs on macOS only." >&2; exit 1; }
[ "$(uname -m)" = "arm64" ]  || { echo "Apple Silicon (M-series) Macs only for now." >&2; exit 1; }

TMP="$(mktemp -d)"
DMG="$TMP/app.dmg"
MNT=""
cleanup() { [ -n "$MNT" ] && hdiutil detach "$MNT" -quiet 2>/dev/null || true; rm -rf "$TMP"; }
trap cleanup EXIT

echo "▸ Downloading…"
curl -fL --progress-bar "$URL" -o "$DMG"

echo "▸ Mounting…"
MNT="$(hdiutil attach "$DMG" -nobrowse -readonly | grep -o '/Volumes/.*' | tail -1 | sed 's/[[:space:]]*$//')"
[ -n "$MNT" ] && [ -d "$MNT" ] || { echo "Could not mount the disk image." >&2; exit 1; }

# Install whatever .app the DMG ships (no hardcoded product name).
APP_SRC="$(find "$MNT" -maxdepth 1 -name '*.app' | head -1)"
[ -n "$APP_SRC" ] || { echo "No .app found in the disk image." >&2; exit 1; }
APP_NAME="$(basename "$APP_SRC")"

echo "▸ Installing ${APP_NAME} to /Applications…"
rm -rf "/Applications/${APP_NAME}"
cp -R "$APP_SRC" /Applications/

# Ad-hoc signed build → clear the quarantine flag so Gatekeeper opens it without a prompt.
xattr -dr com.apple.quarantine "/Applications/${APP_NAME}" 2>/dev/null || true

echo "✓ Installed. Opening ${APP_NAME%.app}…"
open "/Applications/${APP_NAME}"
