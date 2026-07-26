#!/bin/bash
# TeamSquare uninstaller (macOS).
# Usage: curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/uninstall.sh | bash
#
# NARROW BY DEFAULT, and deliberately so: this removes the APPLICATION and nothing else.
# Your brain database, your GitHub token and your identity live under Application Support,
# and a one-liner piped from the internet is the last thing that should delete them
# silently. It PRINTS those paths so you can remove them yourself, and only touches them
# if you explicitly pass --all.
#
# Mirrors the Homebrew cask's `zap` list, which is the authoritative set of paths this app
# creates. If the cask's zap changes, change this too - two lists that disagree is how an
# uninstaller leaves something behind and reports success.
set -euo pipefail

APP="TeamSquare"
APP_PATH="/Applications/${APP}.app"

# Same set as the cask's `zap trash:` block.
DATA_PATHS=(
  "$HOME/Library/Application Support/TeamOS"
  "$HOME/Library/Caches/studio.aisquare.teamos"
  "$HOME/Library/HTTPStorages/studio.aisquare.teamos"
  "$HOME/Library/Preferences/studio.aisquare.teamos.plist"
  "$HOME/Library/Saved Application State/studio.aisquare.teamos.savedState"
  "$HOME/Library/WebKit/studio.aisquare.teamos"
)

ALL=0
for arg in "$@"; do
  case "$arg" in
    --all) ALL=1 ;;
    -h|--help)
      echo "Usage: uninstall.sh [--all]"
      echo "  (default) remove ${APP}.app only, and print where your data lives"
      echo "  --all     also delete that data: the brain database, the GitHub token, settings"
      exit 0 ;;
    *) echo "Unknown option: $arg (try --help)" >&2; exit 1 ;;
  esac
done

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This uninstaller is for macOS. On Windows use Settings → Apps → Installed apps." >&2
  exit 1
fi

# If Homebrew installed it, say so rather than deleting underneath Homebrew's records and
# leaving it convinced the cask is still present.
if command -v brew >/dev/null 2>&1 && brew list --cask team-os >/dev/null 2>&1; then
  echo "TeamSquare was installed with Homebrew. Remove it that way so brew's records stay correct:"
  echo "    brew uninstall --cask team-os        # add --zap to remove your data too"
  exit 0
fi

if [ -d "$APP_PATH" ]; then
  echo "▸ Removing ${APP_PATH}…"
  rm -rf "$APP_PATH"
  echo "✓ Removed ${APP}.app"
else
  # Not an error: the app may already be gone, and saying so beats a silent success.
  echo "▸ ${APP_PATH} is not present, nothing to remove there."
fi

present=()
for p in "${DATA_PATHS[@]}"; do
  [ -e "$p" ] && present+=("$p")
done

if [ ${#present[@]} -eq 0 ]; then
  echo "✓ No TeamSquare data found on this machine."
  exit 0
fi

if [ "$ALL" -eq 1 ]; then
  echo "▸ Removing your TeamSquare data (--all)…"
  for p in "${present[@]}"; do
    echo "    $p"
    rm -rf "$p"
  done
  echo "✓ Data removed. This included the local brain database and the saved GitHub token."
  exit 0
fi

echo
echo "Your TeamSquare data is still on this machine, untouched:"
for p in "${present[@]}"; do echo "    $p"; done
echo
echo "That includes the local brain database and the saved GitHub token. To delete it too:"
echo "    curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/uninstall.sh | bash -s -- --all"
