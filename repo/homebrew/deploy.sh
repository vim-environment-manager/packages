#!/bin/bash
set -e

echo "🚀 Deploying to homebrew repository..."

# Check if we're in the right directory
if [ ! -d "Formula" ]; then
    echo "❌ Formula directory not found. Run this from the homebrew directory."
    exit 1
fi

# Initialize or update git repository
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "📝 Git repository initialized"
else
    echo "📝 Using existing git repository"
fi

# Configure git user
git config user.name "VEM Package Bot" || true
git config user.email "packages@vim-environment-manager.github.io" || true

# Add all files
git add .

# Commit changes
if git diff --cached --quiet; then
    echo "📝 No changes to commit"
else
    git commit -m "Update VEM Homebrew Formula v${VEM_VERSION} (${VEM_FULL_VERSION})"
    echo "✅ Changes committed"
fi

# Check for remote
if ! git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "🔧 Setup required:"
    echo "1. Create repository: https://github.com/vim-environment-manager/homebrew-tap"
    echo "2. Add remote: git remote add origin https://github.com/vim-environment-manager/homebrew-tap.git"
    echo "3. Push: git push -u origin main"
    echo ""
    echo "After setup, users can install with:"
    echo "  brew tap vim-environment-manager/tap"
    echo "  brew install vem"
else
    echo "🚀 Pushing to remote repository..."
    git push origin main
    echo "✅ Successfully pushed to homebrew-tap repository"
    echo ""
    echo "Users can now install with:"
    echo "  brew tap vim-environment-manager/tap"
    echo "  brew install vem"
fi
