# VEM DEB Repository Installation

## 🚀 Quick Installation

Add the repository and install VEM:

```bash
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
sudo apt update
sudo apt install vem
```

## 📦 One-liner Installation

```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-deb.sh | bash
```

## 💾 Manual Installation

Download and install the DEB package directly:

```bash
# For amd64 systems
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_amd64.deb
sudo dpkg -i vem_0.1.0_amd64.deb

# For arm64 systems  
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_arm64.deb
sudo dpkg -i vem_0.1.0_arm64.deb
```

## ✅ Verify Installation

```bash
vem --version
vem --help
```