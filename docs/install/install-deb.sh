#!/bin/bash
set -e

echo "🐧 Installing VEM via DEB repository..."

# Add repository
echo "deb https://vim-environment-manager.github.io/packages/repo/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list

# Update and install
sudo apt update
sudo apt install -y vem

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
