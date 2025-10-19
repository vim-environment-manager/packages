class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "0.1.0"
  
  if Hardware::CPU.arm?
    url "https://vim-environment-manager.github.io/packages/homebrew/vem-darwin-arm64.tar.gz"
    sha256 ""
  else
    url "https://vim-environment-manager.github.io/packages/homebrew/vem-darwin-amd64.tar.gz"
    sha256 ""
  end

  def install
    bin.install "vem"
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
