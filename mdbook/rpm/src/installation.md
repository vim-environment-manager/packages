# VEM RPM Repository Installation

## 🚀 Quick Installation

Add the repository and install VEM:

```bash
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# Fedora/CentOS Stream/RHEL 8+
sudo dnf install vem

# CentOS 7/RHEL 7
sudo yum install vem

# openSUSE
sudo zypper refresh && sudo zypper install vem
```

## 📦 One-liner Installation

```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-rpm.sh | bash
```

## 💾 Manual Installation

Download and install the RPM package directly:

```bash
# Standard RPM
wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-0.1.0-1.x86_64.rpm
sudo rpm -ivh vem-0.1.0-1.x86_64.rpm

# Alternative with dnf
sudo dnf install ./vem-0.1.0-1.x86_64.rpm
```

## ✅ Verify Installation

```bash
vem --version
vem --help
```