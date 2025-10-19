# Repository Setup

## Repository Structure

The VEM DEB repository follows standard Debian repository conventions:

```
deb/
├── dists/
│   └── stable/
│       ├── Release
│       └── main/
│           ├── binary-amd64/
│           │   ├── Packages
│           │   └── Packages.gz
│           └── binary-arm64/
│               ├── Packages
│               └── Packages.gz
└── pool/
    └── main/
        └── v/
            └── vem/
                ├── vem_0.1.0_amd64.deb
                └── vem_0.1.0_arm64.deb
```

## Adding the Repository

### Method 1: Manual Addition

Add the repository to your sources list:

```bash
echo "deb https://vim-environment-manager.github.io/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list
```

### Method 2: Using add-apt-repository

```bash
sudo add-apt-repository "deb https://vim-environment-manager.github.io/packages/deb stable main"
```

## Repository Configuration

### Sources List Entry

The complete sources.list entry is:

```
deb https://vim-environment-manager.github.io/packages/deb stable main
```

Where:
- **deb**: Package type
- **https://vim-environment-manager.github.io/packages/deb**: Repository URL
- **stable**: Distribution name
- **main**: Component name

### Repository Metadata

The repository includes:

- **Release file**: Contains repository metadata and checksums
- **Packages files**: List all available packages with metadata
- **Compressed packages**: Gzipped versions for faster downloads

## GPG Signing

Currently, the repository is not GPG signed. This is indicated by:

```bash
sudo apt update
# You may see: "Repository does not have a Release file signed"
```

For production use, we recommend implementing GPG signing for enhanced security.

## Advanced Configuration

### Pin Priority

To prefer VEM packages from this repository:

Create `/etc/apt/preferences.d/vem`:

```
Package: vem
Pin: origin vim-environment-manager.github.io
Pin-Priority: 1000
```

### Repository Testing

Verify the repository is working:

```bash
# List available packages from VEM repository
apt-cache policy vem

# Show package information
apt-cache show vem
```