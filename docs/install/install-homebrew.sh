#!/bin/bash
set -e

echo "🍺 Installing VEM via Homebrew..."

# Add tap and install
brew tap vim-environment-manager/tap https://vim-environment-manager.github.io/packages/repo/homebrew
brew install vem

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
