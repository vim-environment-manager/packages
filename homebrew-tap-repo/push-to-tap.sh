#!/bin/bash
# Script to push this directory to vim-environment-manager/homebrew-tap repository
set -e

echo "🚀 Pushing to Homebrew tap repository..."

# Initialize git if not already done
if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

# Configure git
git config user.name "VEM Package Bot" || true
git config user.email "packages@vim-environment-manager.github.io" || true

# Add files
git add .
git commit -m "Update VEM Homebrew Formula" || echo "No changes to commit"

# Add remote if not exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Please add the remote repository:"
    echo "git remote add origin https://github.com/vim-environment-manager/homebrew-tap.git"
    echo "Then run: git push -u origin main"
else
    git push origin main
fi

echo "✅ Tap repository updated"
echo "🍺 Users can now run: brew tap vim-environment-manager/tap"
