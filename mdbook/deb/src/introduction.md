# VEM DEB Repository

Welcome to the VEM (Vim Environment Manager) DEB Repository! This repository provides DEB packages for Debian, Ubuntu, and other Debian-based distributions.

## 📦 What is VEM?

VEM (Vim Environment Manager) is a powerful tool for managing Vim environments, allowing you to easily switch between different Vim configurations and plugins.

## 🚀 Quick Start

To get started with VEM on your Debian/Ubuntu system:

1. **Add the repository**:
   ```bash
   echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
   ```

2. **Update package list**:
   ```bash
   sudo apt update
   ```

3. **Install VEM**:
   ```bash
   sudo apt install vem
   ```

## 🎯 Supported Architectures

- **amd64** (x86_64)
- **arm64** (aarch64)

## 📋 Repository Information

- **Repository URL**: `https://vim-environment-manager.github.io/packages/deb`
- **Distribution**: `stable`
- **Component**: `main`
- **Package Format**: DEB

## 🔗 Links

- [GitHub Repository](https://github.com/ryo-arima/vem)
- [Main Package Repository](https://vim-environment-manager.github.io/packages/)
- [Installation Scripts](../install/)