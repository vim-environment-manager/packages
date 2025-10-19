# Package Details

## Available Packages

### VEM Core Package

| Package | Architecture | Version | Size | Description |
|---------|--------------|---------|------|-------------|
| `vem_0.1.0_amd64.deb` | amd64 | 0.1.0 | ~624 KB | VEM for 64-bit Intel/AMD systems |
| `vem_0.1.0_arm64.deb` | arm64 | 0.1.0 | ~596 KB | VEM for 64-bit ARM systems |

## Package Information

### Dependencies

VEM requires the following packages:

- `vim` - The Vim text editor
- Standard system libraries (automatically resolved)

### Files Installed

When you install VEM, the following files are added to your system:

```
/usr/local/bin/vem                    # Main VEM executable
/usr/local/share/man/man1/vem.1       # Manual page
/usr/local/share/doc/vem/README.md    # Documentation
/usr/local/share/doc/vem/LICENSE      # License file
```

### Post-installation

After installation, VEM is immediately available in your PATH. You can run:

```bash
# Show version
vem --version

# Show help
vem --help

# Start using VEM
vem init
```

## Package Checksums

For security verification:

### vem_0.1.0_amd64.deb
- **SHA256**: `98bb2b3d11d74ef1e51d8aa20a1eb3d6d9286a2be364ba4032fa880ee4174cf6`

### vem_0.1.0_arm64.deb  
- **SHA256**: `4ee2ffebbd1d6eb0611673c8b44e43e1e372f69e5e789b338d983da2146516f7`

## Maintenance

### Updates

VEM will automatically check for updates when installed via the repository. Update with:

```bash
sudo apt update && sudo apt upgrade vem
```

### Removal

To remove VEM:

```bash
sudo apt remove vem
```

To remove VEM and its configuration:

```bash
sudo apt purge vem
```