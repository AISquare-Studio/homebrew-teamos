cask "team-os" do
  version "0.4.6"
  sha256 "363cfc56de86fe5893cca376c4c58c3d33d41e175d3e2cf0a89928043443ad90"

  url "https://github.com/AISquare-Studio/homebrew-teamos/releases/download/app-v#{version}/Team-OS_#{version}_aarch64.dmg"
  name "TeamSquare"
  desc "AISquare TeamSquare desktop app"
  homepage "https://github.com/AISquare-Studio/homebrew-teamos"

  depends_on arch: :arm64

  app "TeamSquare.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/TeamSquare.app"]
  end

  zap trash: [
    "~/Library/Application Support/TeamOS",
    "~/Library/Caches/studio.aisquare.teamos",
    "~/Library/HTTPStorages/studio.aisquare.teamos",
    "~/Library/Preferences/studio.aisquare.teamos.plist",
    "~/Library/Saved Application State/studio.aisquare.teamos.savedState",
    "~/Library/WebKit/studio.aisquare.teamos",
  ]
end
