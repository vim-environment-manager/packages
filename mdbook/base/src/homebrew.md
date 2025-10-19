# Homebrew Tap

## 🍺 macOS Installation

VEM provides a Homebrew tap for macOS systems.

### Supported Systems
- macOS 10.15+ (Catalina and later)
- Intel (x86_64) and Apple Silicon (arm64)

## 🚀 Installation Methods

### Tap Installation (Recommended)
```bash
brew tap vim-environment-manager/tap https://vim-environment-manager.github.io/packages/homebrew
brew install vem
```

### One-liner Installation
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-homebrew.sh | bash
```

### Manual Installation
```bash
# Intel Mac
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-darwin-amd64.tar.gz
tar -xzf vem-darwin-amd64.tar.gz
sudo mv vem /usr/local/bin/

# Apple Silicon Mac
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-darwin-arm64.tar.gz
tar -xzf vem-darwin-arm64.tar.gz
sudo mv vem /usr/local/bin/
```

## 📚 Full Documentation

For detailed installation instructions, tap management, and troubleshooting:

[🔗 **Go to Homebrew Documentation**](../homebrew/docs/)

This will take you to the complete Homebrew tap documentation with step-by-step guides.