# Installation Guide

This guide covers multiple ways to install VEM on Debian-based systems.

## Method 1: Repository Installation (Recommended)

### Step 1: Add Repository

Add the VEM repository to your system:

```bash
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
```

### Step 2: Update Package List

```bash
sudo apt update
```

### Step 3: Install VEM

```bash
sudo apt install vem
```

## Method 2: One-liner Installation

For a quick installation, use our one-liner script:

```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-deb.sh | bash
```

## Method 3: Manual DEB Installation

Download and install the DEB package directly:

### For amd64 systems:
```bash
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_amd64.deb
sudo dpkg -i vem_0.1.0_amd64.deb
sudo apt-get install -f  # Fix dependencies if needed
```

### For arm64 systems:
```bash
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_arm64.deb
sudo dpkg -i vem_0.1.0_arm64.deb
sudo apt-get install -f  # Fix dependencies if needed
```

## Verification

After installation, verify VEM is working:

```bash
vem --version
vem --help
```

## Next Steps

- [Learn about available packages](./packages.md)
- [Set up your repository](./repository.md)
- [Troubleshooting common issues](./troubleshooting.md)