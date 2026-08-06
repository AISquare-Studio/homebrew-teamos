#!/bin/bash
# TeamSquare (Team OS) installer for macOS, Apple Silicon.
#
# Latest stable:
#   curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/install.sh | bash
#
# A specific build, including a release candidate:
#   curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/install.sh | bash -s -- app-v0.4.0-rc10
#
# WHY THE ARGUMENT EXISTS. `releases/latest` resolves to the newest NON-prerelease, and
# every RC is published as a prerelease on purpose so nobody is auto-upgraded onto one.
# So during an RC cycle this script silently installs the last STABLE build. Someone asked
# to test rc10, ran the documented one-liner, and got 0.3.2 from three weeks earlier:
# older app, older icon, none of the fixes, and no indication anything was wrong. It then
# reported success. A wrong version installed silently is worse than a failure, so the
# script now prints the tag it is installing and the version it landed.
#
# Name-agnostic on purpose: it installs whatever .app is inside the DMG, so a
# product rename (e.g. "Team OS" -> "TeamSquare") never breaks the installer.
set -euo pipefail

REPO="AISquare-Studio/homebrew-teamos"
TAG="${1:-latest}"
if [ "$TAG" = "latest" ]; then
  URL="https://github.com/${REPO}/releases/latest/download/Team-OS-macos-arm64.dmg"
else
  URL="https://github.com/${REPO}/releases/download/${TAG}/Team-OS-macos-arm64.dmg"
fi

[ "$(uname -s)" = "Darwin" ] || { echo "This app runs on macOS only." >&2; exit 1; }
[ "$(uname -m)" = "arm64" ]  || { echo "Apple Silicon (M-series) Macs only for now." >&2; exit 1; }

TMP="$(mktemp -d)"
DMG="$TMP/app.dmg"
MNT=""
cleanup() { [ -n "$MNT" ] && hdiutil detach "$MNT" -quiet 2>/dev/null || true; rm -rf "$TMP"; }
trap cleanup EXIT

echo "▸ Downloading ${TAG}…"
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

# Say WHICH version landed. The failure this closes was silent success: the script
# reported "Installed" after putting an old build in /Applications.
INSTALLED_VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "/Applications/${APP_NAME}/Contents/Info.plist" 2>/dev/null || echo "unknown")"
echo "✓ Installed ${APP_NAME%.app} ${INSTALLED_VERSION} (from ${TAG}). Opening…"
open "/Applications/${APP_NAME}"
