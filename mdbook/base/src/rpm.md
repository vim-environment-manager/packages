# RPM Packages

## 🎩 RedHat/CentOS/Fedora Installation

VEM provides native RPM packages for RedHat-based distributions.

### Supported Distributions
- Fedora (latest)
- CentOS 7+
- RHEL 8+
- CentOS Stream
- openSUSE Leap/Tumbleweed

### Supported Architectures
- x86_64

## 🚀 Installation Methods

### Repository Installation (Recommended)
```bash
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# Fedora/CentOS 8+
sudo dnf install vem

# CentOS 7/RHEL 7
sudo yum install vem

# openSUSE
sudo zypper refresh && sudo zypper install vem
```

### One-liner Installation
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-rpm.sh | bash
```

## 📚 Full Documentation

For detailed installation instructions, repository setup, and troubleshooting:

[🔗 **Go to RPM Documentation**](../rpm/docs/)

This will take you to the complete RPM package documentation with step-by-step guides.