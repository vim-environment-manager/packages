#!/bin/bash
set -e

# Create repository metadata for DEB and RPM packages
echo "Creating repository metadata..."

# Note: DEB and RPM repository metadata are now created directly in the CI workflow
# This script now only creates configuration and installation files

echo "Creating repository configuration files and installation scripts..."

# Create repository configuration files
mkdir -p packages/config

# Create DEB sources.list
cat > packages/config/vem.list << EOF
# VEM DEB Repository
deb https://vim-environment-manager.github.io/packages/deb ./
EOF

# Create RPM repo file
cat > packages/config/vem.repo << EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# Create installation scripts
mkdir -p packages/install

# DEB installation script
cat > packages/install/install-deb.sh << 'EOF'
#!/bin/bash
set -e

echo "Installing VEM DEB repository..."

# Add repository
echo "deb https://vim-environment-manager.github.io/packages/deb ./" | sudo tee /etc/apt/sources.list.d/vem.list

# Update package list
sudo apt-get update

# Install VEM
sudo apt-get install -y vem

echo "VEM has been installed successfully!"
echo "Run 'vem --help' to get started."
EOF

# RPM installation script
cat > packages/install/install-rpm.sh << 'EOF'
#!/bin/bash
set -e

echo "Installing VEM RPM repository..."

# Add repository
sudo tee /etc/yum.repos.d/vem.repo << 'EOFYUM'
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOFYUM

# Install VEM
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y vem
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y vem
else
    echo "Neither dnf nor yum found. Please install manually."
    exit 1
fi

echo "VEM has been installed successfully!"
echo "Run 'vem --help' to get started."
EOF

# Homebrew installation script
cat > packages/install/install-homebrew.sh << 'EOF'
#!/bin/bash
set -e

echo "Installing VEM via Homebrew..."

# Add tap
brew tap vim-environment-manager/packages

# Install VEM
brew install vem

echo "VEM has been installed successfully!"
echo "Run 'vem --help' to get started."
EOF

# Make scripts executable
chmod +x packages/install/*.sh

echo "Repository metadata and installation scripts created successfully!"