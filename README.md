# Team OS — Downloads & Homebrew tap

Public distribution point for the **Team OS** Mac app. This repo holds only the built app
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

Drag **Team OS** to Applications. The build is ad-hoc signed (not yet notarized), so the
first launch needs a **right-click → Open** once. (Homebrew and the one-liner clear this for
you automatically.)

> Apple Silicon (M-series) only for now. Intel support is a planned follow-up.
