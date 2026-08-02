#!/bin/bash
# TeamSquare (Team OS) uninstaller for macOS.
# Remove the app (keeps your local data):
#   curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/uninstall.sh | bash
# Remove the app AND all local data (brain database, chat history, local repo):
#   curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/uninstall.sh | bash -s -- --purge
#
# Name-agnostic: finds the installed app by its bundle id, so a product rename
# (e.g. "Team OS" -> "TeamSquare") never leaves an orphan behind.
set -euo pipefail

BUNDLE_ID="studio.aisquare.teamos"
DATA_DIR="$HOME/Library/Application Support/TeamOS"
PURGE=0
[ "${1:-}" = "--purge" ] && PURGE=1

# Collect app bundles to remove: by bundle id (Spotlight), plus any known names.
APPS=()
while IFS= read -r p; do
  [ -n "$p" ] && APPS+=("$p")
done < <(mdfind "kMDItemCFBundleIdentifier == '$BUNDLE_ID'" 2>/dev/null | grep '^/Applications/' || true)
for n in "TeamSquare.app" "Team OS.app"; do
  [ -d "/Applications/$n" ] && APPS+=("/Applications/$n")
done

if [ "${#APPS[@]}" -eq 0 ]; then
  echo "No installed app found in /Applications (already removed?)."
else
  for app in "${APPS[@]}"; do
    osascript -e "quit app \"$(basename "$app" .app)\"" 2>/dev/null || true
  done
  sleep 1
  for app in "${APPS[@]}"; do
    echo "▸ Removing $app"
    rm -rf "$app"
  done
fi

echo "▸ Removing caches, saved state, and preferences…"
rm -rf "$HOME/Library/Caches/$BUNDLE_ID" \
       "$HOME/Library/Saved Application State/$BUNDLE_ID.savedState" \
       "$HOME/Library/Preferences/$BUNDLE_ID.plist" \
       "$HOME/Library/HTTPStorages/$BUNDLE_ID" \
       "$HOME/Library/HTTPStorages/$BUNDLE_ID.binarycookies" \
       "$HOME/Library/WebKit/$BUNDLE_ID"

if [ "$PURGE" = "1" ]; then
  echo "▸ Purging local data (brain database, chat history, local repo)…"
  rm -rf "$DATA_DIR"
elif [ -d "$DATA_DIR" ]; then
  echo ""
  echo "Kept your local data (brain database, chat history, local repo) at:"
  echo "  $DATA_DIR"
  echo "To remove it too, re-run with --purge, or delete it manually:"
  echo "  rm -rf \"$DATA_DIR\""
fi

# Note: your Claude sign-in (~/.claude) is shared with Claude Code and is left untouched.
echo "✓ Uninstalled."
