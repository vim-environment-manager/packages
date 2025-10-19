class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "0.1.0"
  
  if Hardware::CPU.arm?
    url "https://vim-environment-manager.github.io/packages/homebrew/archives/vem-0.1.0-202510191002-aarch64.tar.gz"
    sha256 "PLACEHOLDER_ARM64_SHA"
  else
    url "https://vim-environment-manager.github.io/packages/homebrew/archives/vem-0.1.0-202510191002-x86_64.tar.gz"
    sha256 "PLACEHOLDER_X86_64_SHA"
  end

  def install
    bin.install "vem"
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
