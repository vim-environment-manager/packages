#!/bin/bash
set -e

echo "🎩 Installing VEM via RPM repository..."

# Add repository
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# Install based on package manager
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y vem
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y vem
elif command -v zypper >/dev/null 2>&1; then
    sudo zypper refresh
    sudo zypper install -y vem
else
    echo "❌ No supported package manager found (dnf/yum/zypper)"
    echo "💡 This script is for RPM-based Linux distributions"
    exit 1
fi

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
