# TeamSquare downloads and Homebrew tap

Public distribution point for the **TeamSquare** desktop app (macOS and Windows). This repo holds only the built app
(DMG releases), the Homebrew cask, and the installer script. The app source lives in the
private `AISquare-Studio/team-os` repo; the DMG here is just the app shell and contains no
team data. Every release is built automatically on GitHub Actions.

## Install (macOS · Apple Silicon)

### Homebrew

```sh
brew tap AISquare-Studio/teamos
brew install --cask team-os
```

Update later with `brew upgrade --cask team-os`.

### One-line install

```sh
curl -fsSL https://raw.githubusercontent.com/AISquare-Studio/homebrew-teamos/main/install.sh | bash
```

### Download the DMG

[![Download Team OS](https://img.shields.io/badge/Download-Team%20OS%20(.dmg)-2563eb?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/AISquare-Studio/homebrew-teamos/releases/latest/download/Team-OS-macos-arm64.dmg)

Drag **TeamSquare** to Applications.

The build is ad-hoc signed and not notarized, so macOS quarantines it on download. Opening
it by hand shows **"TeamSquare is damaged and can't be opened"** - that message is the
quarantine flag, not a corrupted download. Clear it once:

```sh
xattr -dr com.apple.quarantine "/Applications/TeamSquare.app"
```

Homebrew and the one-line installer both do this for you, so this only applies if you
dragged the app across from the DMG yourself.

> macOS builds are Apple Silicon (M-series) only for now. Intel support is a planned
> follow-up.

## Install (Windows · x64)

[![Download TeamSquare for Windows](https://img.shields.io/badge/Download-TeamSquare%20(.exe)-2563eb?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/AISquare-Studio/homebrew-teamos/releases/latest/download/Team-OS-windows-x64-setup.exe)

Run the installer. The build is **not code-signed yet**, so Windows SmartScreen shows
**"Windows protected your PC"**. Choose **More info → Run anyway** to continue. Signing is
in progress and this step will go away in a later release.

There is no package manager or auto-update on Windows yet: to update, download the latest
installer and run it again. To remove it, use **Settings → Apps → Installed apps**.

> Windows x64 only. There is no ARM64 Windows build.
