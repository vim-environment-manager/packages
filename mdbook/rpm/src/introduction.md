# VEM RPM Repository

Welcome to the VEM (Vim Environment Manager) RPM Repository! This repository provides RPM packages for RedHat, CentOS, Fedora, openSUSE, and other RPM-based distributions.

## 🎩 What is VEM?

VEM (Vim Environment Manager) is a powerful tool for managing Vim environments, allowing you to easily switch between different Vim configurations and plugins.

## 🚀 Quick Start

To get started with VEM on your RPM-based system:

1. **Add the repository**:
   ```bash
   sudo tee /etc/yum.repos.d/vem.repo <<EOF
   [vem]
   name=VEM Repository
   baseurl=https://vim-environment-manager.github.io/packages/rpm
   enabled=1
   gpgcheck=0
   EOF
   ```

2. **Install VEM**:
   ```bash
   # For Fedora/CentOS Stream/RHEL 8+
   sudo dnf install vem
   
   # For CentOS 7/RHEL 7
   sudo yum install vem
   
   # For openSUSE
   sudo zypper install vem
   ```

## 🎯 Supported Distributions

- **Fedora** (all supported versions)
- **CentOS Stream** (8, 9)
- **RHEL** (7, 8, 9)
- **Rocky Linux** (8, 9)
- **AlmaLinux** (8, 9)
- **openSUSE Leap** (15.x)
- **openSUSE Tumbleweed**

## 📋 Repository Information

- **Repository URL**: `https://vim-environment-manager.github.io/packages/rpm`
- **Package Format**: RPM
- **Architecture Support**: x86_64

## 🔗 Links

- [GitHub Repository](https://github.com/ryo-arima/vem)
- [Main Package Repository](https://vim-environment-manager.github.io/packages/)
- [Installation Scripts](../install/)