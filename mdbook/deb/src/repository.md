# Repository Setup & Usage

## 🔧 Repository URL
```
https://vim-environment-manager.github.io/packages/deb
```

## 📝 Add Repository
```bash
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
sudo apt update
```

## 🏗️ Supported Platforms
- **Architectures**: amd64, arm64
- **Distributions**: Ubuntu 20.04+, Debian 11+

## 🔄 Package Updates
```bash
sudo apt update
sudo apt upgrade vem
```

## 📋 Package Information
```bash
apt-cache policy vem
apt-cache show vem
```

## 🗑️ Remove Repository
```bash
sudo rm /etc/apt/sources.list.d/vem.list
sudo apt update
```