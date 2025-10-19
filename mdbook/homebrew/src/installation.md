# VEM Homebrew Installation

## 🚀 Quick Installation

Add the tap and install VEM:

```bash
brew tap vim-environment-manager/tap https://vim-environment-manager.github.io/packages/homebrew
brew install vem
```

## 📦 One-liner Installation

```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-homebrew.sh | bash
```

## 💾 Manual Installation

Download and install manually:

```bash
# Download TAR.GZ
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-darwin-amd64.tar.gz
tar -xzf vem-darwin-amd64.tar.gz
sudo mv vem /usr/local/bin/

# For ARM64 (Apple Silicon)
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-darwin-arm64.tar.gz
tar -xzf vem-darwin-arm64.tar.gz
sudo mv vem /usr/local/bin/
```

## ✅ Verify Installation

```bash
vem --version
vem --help
```
