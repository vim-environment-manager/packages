# DEB Packages

## 🐧 Debian/Ubuntu Installation

VEM provides native DEB packages for Debian and Ubuntu based systems.

### Supported Distributions
- Ubuntu 20.04+ (Focal, Jammy, Noble)
- Debian 11+ (Bullseye, Bookworm)

### Supported Architectures
- amd64 (x86_64)
- arm64 (aarch64)

## 🚀 Installation Methods

### Repository Installation (Recommended)
```bash
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
sudo apt update
sudo apt install vem
```

### One-liner Installation
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-deb.sh | bash
```

## 📚 Full Documentation

For detailed installation instructions, repository setup, and troubleshooting:

[🔗 **Go to DEB Documentation**](../deb/docs/)

This will take you to the complete DEB package documentation with step-by-step guides.