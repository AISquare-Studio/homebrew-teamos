cask "team-os" do
  version "0.4.5"
  sha256 "79a41da8fc02ac615354073214cda015f6e27dc62c26ffd0b500abfc10c945ca"

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
