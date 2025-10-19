class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "0.1.0"
  
  if Hardware::CPU.arm?
    url "https://vim-environment-manager.github.io/packages/repo/homebrew/archives/vem-0.1.0-202510191002-aarch64.tar.gz"
    sha256 "7699f396ea0a5c79ac671c08bf37a3d922ca819facf70e7bbe6cad272bca8a65"
  else
    url "https://vim-environment-manager.github.io/packages/repo/homebrew/archives/vem-0.1.0-202510191002-x86_64.tar.gz"
    sha256 "607b32d78319db3827d20e9cf2c45b813d48df8593f5f482e69af59b3795f8f8"
  end

  def install
    bin.install "vem"
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
