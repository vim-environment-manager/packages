#!/bin/bash
set -e

echo "Setting up VEM package repository..."

# Make all scripts executable
chmod +x scripts/*.sh

echo "✅ Scripts made executable"
echo "✅ Repository structure created"
echo ""
echo "🚀 Next steps:"
echo "1. Push this repository to GitHub"
echo "2. Enable GitHub Pages in repository settings"
echo "3. Set source to 'GitHub Actions'"
echo "4. The workflow will automatically build and deploy packages"
echo ""
echo "📦 Repository will be available at:"
echo "   https://vim-environment-manager.github.io/packages/"
echo ""
echo "🍺 Homebrew tap will be available as:"
echo "   vim-environment-manager/packages"