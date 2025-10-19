#!/bin/bash
# Restore .git directory from archive for Homebrew tap functionality
set -e
echo "🔧 Restoring .git directory for Homebrew tap..."
if [ -f ".git-repo.tar.gz" ]; then
    tar -xzf .git-repo.tar.gz
    echo "✅ .git directory restored"
    echo "🍺 Homebrew tap is now ready"
else
    echo "❌ .git-repo.tar.gz not found"
    exit 1
fi
