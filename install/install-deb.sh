#!/bin/bash
set -e

echo "🐧 Installing VEM DEB repository..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root. Please run without sudo."
   exit 1
fi

# Check if apt is available
if ! command -v apt >/dev/null 2>&1; then
    echo "❌ apt package manager not found. This script is for Debian/Ubuntu systems."
    exit 1
fi

# Add repository
echo "📦 Adding VEM repository..."
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list

# Update package list
echo "🔄 Updating package list..."
sudo apt-get update

# Install VEM
echo "⬇️ Installing VEM..."
sudo apt-get install -y vem

echo "✅ VEM has been installed successfully!"
echo "🚀 Run 'vem --help' to get started."

# Display version
echo "📋 Installed version:"
vem --version || echo "VEM version information not available"