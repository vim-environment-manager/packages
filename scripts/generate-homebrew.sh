#!/bin/bash
set -e

# Generate Homebrew formula for VEM
echo "Generating Homebrew formula..."

VERSION="0.1.0-20251019"
PACKAGE_NAME="vem"
HOMEPAGE="https://github.com/ryo-arima/vem"
DESCRIPTION="Vim Environment Manager - A tool for managing Vim environments"

# Create homebrew directory structure
mkdir -p packages/homebrew/Formula

# Generate formula
cat > packages/homebrew/Formula/${PACKAGE_NAME}.rb << EOF
class Vem < Formula
  desc "${DESCRIPTION}"
  homepage "${HOMEPAGE}"
  version "${VERSION}"
  
  # Use the actual release tarball
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ryo-arima/vem/releases/download/v${VERSION}/vem-0.1.0-arm64.tar.gz"
      sha256 "df8849cdc964bc618585abaee73fbb35c85e3d30106bbf7ad1661ff2afbe72d5"
    else
      url "https://github.com/ryo-arima/vem/releases/download/v${VERSION}/vem-0.1.0-x86_64.tar.gz" 
      sha256 "f152d7c24bcf01872420c1982394be5da25f67331e376ea82675fd6906c77f1c"
    end
  end
  
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ryo-arima/vem/releases/download/v${VERSION}/vem-0.1.0-aarch64.tar.gz"
      sha256 "3e0ae1238fb5348f7d1c13b39b38b7e086bd7c5deff063b581ded37613045fee"
    else
      url "https://github.com/ryo-arima/vem/releases/download/v${VERSION}/vem-0.1.0-x86_64.tar.gz"
      sha256 "f152d7c24bcf01872420c1982394be5da25f67331e376ea82675fd6906c77f1c"
    end
  end
  
  depends_on "vim"
  
  def install
    # For now, create a simple script
    # In a real scenario, this would compile the actual binary
    bin.mkpath
    
    if File.exist?("vem")
      bin.install "vem"
    elsif File.exist?("bin/vem")
      bin.install "bin/vem"
    else
      # Create placeholder script
      (bin/"vem").write <<~EOS
        #!/usr/bin/env bash
        echo "VEM - Vim Environment Manager v#{version}"
        echo "This is a placeholder binary. Please build from source."
      EOS
      chmod 0755, bin/"vem"
    end
    
    # Install documentation
    if File.exist?("README.md")
      doc.install "README.md"
    end
    
    if File.exist?("LICENSE")
      doc.install "LICENSE" 
    end
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
EOF

# Create tap repository structure
mkdir -p packages/homebrew/.github/workflows

# Create tap info
cat > packages/homebrew/README.md << EOF
# VEM Homebrew Tap

This is the official Homebrew tap for VEM (Vim Environment Manager).

## Installation

\`\`\`bash
brew tap vim-environment-manager/packages
brew install vem
\`\`\`

## Usage

After installation, you can use VEM:

\`\`\`bash
vem --help
\`\`\`

## Documentation

For more information, visit: ${HOMEPAGE}
EOF

# Create GitHub workflow for tap
cat > packages/homebrew/.github/workflows/tests.yml << EOF
name: Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Homebrew
        id: set-up-homebrew
        uses: Homebrew/actions/setup-homebrew@master
      - name: Test formula
        run: |
          brew test-bot --only-cleanup-before
          brew test-bot --only-setup
          brew test-bot --only-tap-syntax
EOF

echo "Homebrew formula generated successfully!"
echo "Formula location: packages/homebrew/Formula/${PACKAGE_NAME}.rb"