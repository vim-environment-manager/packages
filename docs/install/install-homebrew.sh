#!/bin/bash
set -e

echo "🍺 Installing VEM via Homebrew..."

# Try tap installation first
if brew tap vim-environment-manager/tap 2>/dev/null; then
    echo "✅ Tap added successfully"
    brew install vem
else
    echo "⚠️  Tap not available, installing directly from Formula URL..."
    brew install https://vim-environment-manager.github.io/packages/repo/homebrew/Formula/vem.rb
fi

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
