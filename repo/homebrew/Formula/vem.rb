class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "0.1.0"
  
  # Use macOS compatible files (arm64 version should work on macOS)
  if Hardware::CPU.arm?
    url "https://github.com/ryo-arima/vem/releases/download/v0.1.0-202510191002/vem-0.1.0-202510191002-arm64.tar.gz"
    sha256 "345dfd717c8077ac6d120022bb26cd4f0490db2d863797cf3a0494c63e0ab0e3"
  else
    url "https://github.com/ryo-arima/vem/releases/download/v0.1.0-202510191002/vem-0.1.0-202510191002-x86_64.tar.gz"
    sha256 "607b32d78319db3827d20e9cf2c45b813d48df8593f5f482e69af59b3795f8f8"
  end

  def install
    # Check system architecture
    system_arch = `uname -m`.strip
    ohai "Detected system architecture: #{system_arch}"
    
    # Ensure the source binary exists and is readable
    unless File.exist?("vem")
      raise "Binary 'vem' not found in archive"
    end
    
    # Set executable permissions before installing
    chmod 0755, "vem"
    system "chmod", "+x", "vem"
    
    # Verify source binary is executable
    source_info = `file vem`.strip
    ohai "Source binary info: #{source_info}"
    
    # Install binary to Homebrew's bin directory
    bin.install "vem"
    
    # Force executable permissions after installation
    system "chmod", "755", bin/"vem"
    system "chmod", "+x", bin/"vem"
    
    # Final verification
    binary_info = `file #{bin}/vem`.strip
    ohai "Installed binary info: #{binary_info}"
    
    # Test execution permissions
    system "ls", "-la", bin/"vem"
  end

  def post_install
    # Final check and fix permissions after installation
    system "chmod", "755", bin/"vem"
    system "chmod", "+x", bin/"vem"
    ohai "Post-install: Set executable permissions on #{bin}/vem"
  end

  def caveats
    <<~EOS
      VEM has been installed to:
        #{bin}/vem

      To use VEM, make sure Homebrew's bin directory is in your PATH:
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc

      Or for bash users:
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile

      Test your installation:
        vem --version
    EOS
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
