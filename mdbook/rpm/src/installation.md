# Installation Guide

This guide covers multiple ways to install VEM on RPM-based systems.

## Method 1: Repository Installation (Recommended)

### Step 1: Add Repository

Add the VEM repository to your system:

```bash
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF
```

### Step 2: Install VEM

Choose the appropriate command for your distribution:

#### Fedora / CentOS Stream / RHEL 8+
```bash
sudo dnf install vem
```

#### CentOS 7 / RHEL 7
```bash
sudo yum install vem
```

#### openSUSE
```bash
sudo zypper refresh
sudo zypper install vem
```

## Method 2: One-liner Installation

For a quick installation, use our one-liner script:

```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-rpm.sh | bash
```

## Method 3: Manual RPM Installation

Download and install the RPM package directly:

### For x86_64 systems:
```bash
# Option 1: Standard RPM
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-0.1.0-1.x86_64.rpm
sudo rpm -ivh vem-0.1.0-1.x86_64.rpm

# Option 2: Alternative RPM
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-linux-x86_64.rpm
sudo rpm -ivh vem-linux-x86_64.rpm
```

### Using package managers with local files:

#### With dnf:
```bash
sudo dnf install ./vem-0.1.0-1.x86_64.rpm
```

#### With yum:
```bash
sudo yum localinstall ./vem-0.1.0-1.x86_64.rpm
```

#### With zypper:
```bash
sudo zypper install ./vem-0.1.0-1.x86_64.rpm
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