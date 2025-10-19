# Troubleshooting

## Common Issues and Solutions

### Repository Access Issues

#### Issue: "Repository not found" or 404 errors

**Solution:**
1. Verify the repository URL is correct:
   ```bash
   curl -I https://vim-environment-manager.github.io/packages/deb/dists/stable/Release
   ```

2. Check your sources.list entry:
   ```bash
   cat /etc/apt/sources.list.d/vem.list
   ```

3. Update package lists:
   ```bash
   sudo apt update
   ```

#### Issue: "Release file signed" warnings

**Solution:**
This is expected as the repository is not currently GPG signed. You can safely ignore this warning or suppress it:

```bash
sudo apt update 2>/dev/null || sudo apt update
```

### Package Installation Issues

#### Issue: "Package vem not found"

**Troubleshooting steps:**

1. Verify repository is added:
   ```bash
   grep -r "vim-environment-manager" /etc/apt/sources.list.d/
   ```

2. Update package cache:
   ```bash
   sudo apt update
   ```

3. Search for the package:
   ```bash
   apt-cache search vem
   ```

4. Check available versions:
   ```bash
   apt-cache policy vem
   ```

#### Issue: Dependency conflicts

**Solution:**
1. Try installing with dependency resolution:
   ```bash
   sudo apt install -f vem
   ```

2. If conflicts persist, install dependencies manually:
   ```bash
   sudo apt install vim
   sudo apt install vem
   ```

### Architecture Issues

#### Issue: "No package available for your architecture"

**Solution:**
1. Check your system architecture:
   ```bash
   dpkg --print-architecture
   ```

2. Verify supported architectures:
   - amd64 (Intel/AMD 64-bit)
   - arm64 (ARM 64-bit)

3. For unsupported architectures, try manual compilation from source.

### Network Issues

#### Issue: Download timeouts or slow downloads

**Solutions:**

1. Use a different mirror or CDN if available
2. Check your internet connection
3. Try downloading manually:
   ```bash
   wget https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_amd64.deb
   sudo dpkg -i vem_0.1.0_amd64.deb
   ```

### Permission Issues

#### Issue: "Permission denied" during installation

**Solution:**
Ensure you're using sudo for installation commands:

```bash
sudo apt install vem
```

### Post-Installation Issues

#### Issue: "Command not found: vem"

**Solutions:**

1. Reload your shell:
   ```bash
   source ~/.bashrc
   # or
   hash -r
   ```

2. Check if VEM is installed:
   ```bash
   which vem
   dpkg -l | grep vem
   ```

3. Verify PATH includes `/usr/local/bin`:
   ```bash
   echo $PATH
   ```

## Getting Help

If you continue to experience issues:

1. **Check the logs**: Look at `/var/log/apt/` for detailed error messages
2. **GitHub Issues**: Report bugs at [VEM GitHub Repository](https://github.com/ryo-arima/vem/issues)
3. **Documentation**: Visit the [main documentation](https://vim-environment-manager.github.io/packages/)

## Diagnostic Commands

Run these commands to gather system information for bug reports:

```bash
# System info
uname -a
lsb_release -a

# APT configuration
apt-config dump | grep -i vem

# Repository status
apt-cache policy vem

# Package information
dpkg -l | grep vem
```