# Repository Setup & Usage

## 🔧 Repository URL
```
https://vim-environment-manager.github.io/packages/rpm
```

## 📝 Add Repository
```bash
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF
```

## 🏗️ Supported Platforms
- **Architecture**: x86_64
- **Distributions**: Fedora, CentOS, RHEL, openSUSE

## 🔄 Package Updates
```bash
# Fedora/CentOS 8+
sudo dnf update vem

# CentOS 7/RHEL 7
sudo yum update vem

# openSUSE
sudo zypper update vem
```

## 📋 Package Information
```bash
# Fedora/CentOS 8+
dnf info vem

# CentOS 7/RHEL 7
yum info vem

# openSUSE
zypper info vem
```

## 🗑️ Remove Repository
```bash
sudo rm /etc/yum.repos.d/vem.repo
```
