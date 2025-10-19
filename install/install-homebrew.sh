#!/bin/bash
set -e

echo "🍺 Installing VEM via Homebrew..."

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrew not found. Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Verify Homebrew is working
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrew installation failed or not in PATH."
    echo "Please install Homebrew manually: https://brew.sh"
    exit 1
fi

echo "✅ Homebrew found: $(brew --version | head -n1)"

# Add tap
echo "📦 Adding VEM tap..."
brew tap vim-environment-manager/packages

# Install VEM
echo "⬇️ Installing VEM..."
brew install vem

echo "✅ VEM has been installed successfully!"
echo "🚀 Run 'vem --help' to get started."

# Display version
echo "📋 Installed version:"
vem --version || echo "VEM version information not available"