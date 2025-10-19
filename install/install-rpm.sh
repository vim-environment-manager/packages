#!/bin/bash
set -e

echo "🎩 Installing VEM RPM repository..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root. Please run without sudo."
   exit 1
fi

# Check for available package managers
if command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="yum"
elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="zypper"
else
    echo "❌ No supported package manager found (dnf, yum, or zypper required)."
    exit 1
fi

echo "📦 Using package manager: $PKG_MANAGER"

# Add repository
echo "📦 Adding VEM repository..."
sudo tee /etc/yum.repos.d/vem.repo << 'EOF'
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# Install VEM based on package manager
echo "⬇️ Installing VEM..."
case "$PKG_MANAGER" in
    "dnf")
        sudo dnf install -y vem
        ;;
    "yum")
        sudo yum install -y vem
        ;;
    "zypper")
        sudo zypper refresh
        sudo zypper install -y vem
        ;;
esac

echo "✅ VEM has been installed successfully!"
echo "🚀 Run 'vem --help' to get started."

# Display version
echo "📋 Installed version:"
vem --version || echo "VEM version information not available"