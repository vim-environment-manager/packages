#!/bin/bash
set -e

# Package Repository Builder
# This script downloads packages and creates repository metadata

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$REPO_ROOT/docs"

# Read version information
if [ -f "$REPO_ROOT/VERSION" ]; then
    VERSIONS=$(cat "$REPO_ROOT/VERSION" | grep -v '^$' | tr '\n' ' ')
    VEM_FULL_VERSION=$(cat "$REPO_ROOT/VERSION" | head -n1 | tr -d '\n')
    VEM_VERSION=$(echo ${VEM_FULL_VERSION} | cut -d'-' -f1)
    VEM_DATE=$(echo ${VEM_FULL_VERSION} | cut -d'-' -f2)
    VEM_VERSION_TAG="v${VEM_FULL_VERSION}"
else
    echo "❌ VERSION file not found"
    exit 1
fi

echo "🚀 Building package repositories..."
echo "📋 Versions: ${VERSIONS}"
echo "🏷️  Latest: ${VEM_FULL_VERSION}"

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$REPO_ROOT/repo"/{deb,rpm}
mkdir -p "$REPO_ROOT/repo/deb/pool/main/v/vem"
mkdir -p "$REPO_ROOT/repo/deb/dists/stable/main/binary-amd64"
mkdir -p "$REPO_ROOT/repo/deb/dists/stable/main/binary-arm64"
mkdir -p "$REPO_ROOT/repo/rpm/repodata"

# Backup index.html files (excluding docs and homebrew)
echo "💾 Backing up index.html files..."
mkdir -p "$REPO_ROOT/backups/index-files"
find "$REPO_ROOT" -name "index.html" -not -path "$REPO_ROOT/docs/*" -not -path "$REPO_ROOT/backups/*" -not -path "$REPO_ROOT/tmp/*" -not -path "$REPO_ROOT/repo/homebrew/*" | while read file; do
    backup_path="$REPO_ROOT/backups/index-files${file#$REPO_ROOT}"
    mkdir -p "$(dirname "$backup_path")"
    cp "$file" "$backup_path" 2>/dev/null || true
done
echo "✅ Index files backed up"

# Clean mdbook files from package repositories (remove only common static site artifacts)
echo "🧹 Cleaning mdbook files from package repositories..."
for repo_dir in deb rpm; do
    DIR="$REPO_ROOT/repo/$repo_dir"
    if [ -d "$DIR" ]; then
        # remove site files that may have been copied accidentally
        rm -f "$DIR"/.nojekyll 2>/dev/null || true
        rm -f "$DIR"/404.html 2>/dev/null || true
        # Don't remove index.html as it will be restored from backup
        # rm -f "$DIR"/index.html 2>/dev/null || true
        rm -f "$DIR"/book.js 2>/dev/null || true
        rm -rf "$DIR"/css 2>/dev/null || true
        rm -rf "$DIR"/js 2>/dev/null || true
        rm -rf "$DIR"/fonts 2>/dev/null || true
        rm -rf "$DIR"/search_index.json 2>/dev/null || true
        
        echo "  ✅ Cleaned $repo_dir directory"
    fi
done

# Clean all existing packages first
echo "🧹 Cleaning existing packages..."
rm -rf "$REPO_ROOT/repo/deb/pool"/*.deb 2>/dev/null || true  
rm -rf "$REPO_ROOT/repo/rpm/rpms"/*.rpm 2>/dev/null || true
echo "✅ Existing packages cleaned"

# Download packages for each version (based on VERSION file)
echo "📦 Downloading packages for all versions in VERSION file..."
for FULL_VER in ${VERSIONS}; do
    VER=$(echo ${FULL_VER} | cut -d'-' -f1)
    DATE_PART=$(echo ${FULL_VER} | cut -d'-' -f2)
    TAG="v${FULL_VER}"
    
    echo "🔽 Processing version: ${VER} (${FULL_VER})"
    
    # Download DEB packages (using available format)
    echo "  📥 Downloading DEB packages..."
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.deb" && echo "  ✅ Downloaded vem-linux-x86_64.deb" || echo "  ⚠️  Failed to download vem-linux-x86_64.deb"
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-aarch64.deb" && echo "  ✅ Downloaded vem-linux-aarch64.deb" || echo "  ⚠️  Failed to download vem-linux-aarch64.deb"
    # Download versioned DEB packages
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem_${FULL_VER}_amd64.deb" && echo "  ✅ Downloaded vem_${FULL_VER}_amd64.deb" || echo "  ⚠️  Failed to download vem_${FULL_VER}_amd64.deb"
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem_${FULL_VER}_arm64.deb" && echo "  ✅ Downloaded vem_${FULL_VER}_arm64.deb" || echo "  ⚠️  Failed to download vem_${FULL_VER}_arm64.deb"
    
    # Download RPM packages (using available format)
    echo "  📥 Downloading RPM packages..."
    wget -q -P "$REPO_ROOT/repo/rpm/rpms" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.rpm" && echo "  ✅ Downloaded vem-linux-x86_64.rpm" || echo "  ⚠️  Failed to download vem-linux-x86_64.rpm"
    # Download versioned RPM packages
    wget -q -P "$REPO_ROOT/repo/rpm/rpms" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-${FULL_VER}.x86_64.rpm" && echo "  ✅ Downloaded vem-${FULL_VER}.x86_64.rpm" || echo "  ⚠️  Failed to download vem-${FULL_VER}.x86_64.rpm"
    # ARM64 RPM not available in current release
    # wget -q -P "$REPO_ROOT/repo/rpm/rpms" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-aarch64.rpm" && echo "  ✅ Downloaded vem-linux-aarch64.rpm" || echo "  ⚠️  Failed to download vem-linux-aarch64.rpm"

done

# Create DEB repository metadata
echo "🏗️  Creating DEB repository metadata..."
if command -v docker >/dev/null 2>&1; then
    echo "  🐳 Using Docker for DEB repository creation..."
    cd "$REPO_ROOT"
    
    # Check if we have actual .deb files or placeholders
    DEB_COUNT=$(find "$REPO_ROOT/repo/deb/pool" -name "*.deb" -type f -exec file {} \; | grep -c "Debian binary package" || true)
    
    if [ "$DEB_COUNT" -gt 0 ]; then
        # We have real DEB files, scan them
        docker run --rm -v "$REPO_ROOT/repo/deb:/workspace" \
            debian:bookworm-slim bash -c "
            cd /workspace && \
            apt-get update && apt-get install -y dpkg-dev gzip && \
            dpkg-scanpackages pool/ > dists/stable/main/binary-amd64/Packages && \
            dpkg-scanpackages pool/ > dists/stable/main/binary-arm64/Packages && \
            gzip -f -k dists/stable/main/binary-amd64/Packages && \
            gzip -f -k dists/stable/main/binary-arm64/Packages && \
            cat > dists/stable/Release << 'RELEASE_EOF'
Origin: VEM Repository
Label: VEM
Suite: stable
Codename: stable
Architectures: amd64 arm64
Components: main
Description: Vim Environment Manager Package Repository
Date: \$(date -u +\"%a, %d %b %Y %H:%M:%S UTC\")
RELEASE_EOF
        "
    else
        # We have placeholder files, create minimal metadata
        echo "  📝 Creating minimal metadata for placeholder files..."
        docker run --rm -v "$REPO_ROOT/repo/deb:/workspace" \
            debian:bookworm-slim bash -c "
            cd /workspace && \
            apt-get update && apt-get install -y dpkg-dev gzip && \
            mkdir -p dists/stable/main/binary-amd64 dists/stable/main/binary-arm64 && \
            echo '' > dists/stable/main/binary-amd64/Packages && \
            echo '' > dists/stable/main/binary-arm64/Packages && \
            gzip -f -k dists/stable/main/binary-amd64/Packages && \
            gzip -f -k dists/stable/main/binary-arm64/Packages && \
            cat > dists/stable/Release << 'RELEASE_EOF'
Origin: VEM Repository
Label: VEM
Suite: stable
Codename: stable
Architectures: amd64 arm64
Components: main
Description: Vim Environment Manager Package Repository
Date: \$(date -u +\"%a, %d %b %Y %H:%M:%S UTC\")
RELEASE_EOF
        "
    fi
    echo "✅ DEB repository metadata created with Docker"
elif command -v dpkg-scanpackages >/dev/null 2>&1; then
    cd "$REPO_ROOT/repo/deb"
    dpkg-scanpackages pool/ > dists/stable/main/binary-amd64/Packages
    dpkg-scanpackages pool/ > dists/stable/main/binary-arm64/Packages
    gzip -f -k dists/stable/main/binary-amd64/Packages
    gzip -f -k dists/stable/main/binary-arm64/Packages
    
    # Create Release file
    cat > dists/stable/Release << EOF
Origin: VEM Repository
Label: VEM
Suite: stable
Codename: stable
Architectures: amd64 arm64
Components: main
Description: Vim Environment Manager Package Repository
Date: $(date -u +"%a, %d %b %Y %H:%M:%S UTC")
EOF
    echo "✅ DEB repository metadata created"
else
    echo "⚠️  Neither Docker nor dpkg-scanpackages found, skipping DEB metadata"
fi

# Create RPM repository metadata
echo "🏗️  Creating RPM repository metadata..."
if command -v docker >/dev/null 2>&1; then
    echo "  🐳 Using Docker for RPM repository creation..."
    
    # Check if we have actual .rpm files or placeholders
    RPM_COUNT=$(find "$REPO_ROOT/repo/rpm" -name "*.rpm" -type f -exec file {} \; | grep -c "RPM" || true)
    
    if [ "$RPM_COUNT" -gt 0 ]; then
        # We have real RPM files, create repo
        docker run --rm -v "$REPO_ROOT/repo/rpm:/workspace" \
            rockylinux:9-minimal bash -c "
            cd /workspace && \
            microdnf install -y createrepo_c && \
            createrepo_c .
        "
    else
        # We have placeholder files, create minimal metadata
        echo "  📝 Creating minimal RPM repository metadata for placeholder files..."
        docker run --rm -v "$REPO_ROOT/repo/rpm:/workspace" \
            rockylinux:9-minimal bash -c "
            cd /workspace && \
            microdnf install -y createrepo_c && \
            mkdir -p repodata && \
            createrepo_c --update .
        "
    fi
    echo "✅ RPM repository metadata created with Docker"
elif command -v createrepo_c >/dev/null 2>&1; then
    createrepo_c "$REPO_ROOT/repo/rpm"
    echo "✅ RPM repository metadata created"
elif command -v createrepo >/dev/null 2>&1; then
    createrepo "$REPO_ROOT/repo/rpm"
    echo "✅ RPM repository metadata created"
else
    echo "⚠️  Neither Docker nor createrepo found, skipping RPM metadata"
fi

# Generate documentation
echo "📚 Generating documentation..."
# The documentation generation will be handled separately

# DEB installation script
cat > "$DOCS_DIR/install/install-deb.sh" << 'EOF'
#!/bin/bash
set -e

echo "🐧 Installing VEM via DEB repository..."

# Add repository
echo "deb https://vim-environment-manager.github.io/packages/repo/deb stable main" | sudo tee /etc/apt/sources.list.d/vem.list

# Update and install
sudo apt update
sudo apt install -y vem

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
EOF

# RPM installation script
cat > "$DOCS_DIR/install/install-rpm.sh" << 'RPMEOFMARKER'
#!/bin/bash
set -e

echo "🎩 Installing VEM via RPM repository..."

# Add repository
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/repo/rpm
enabled=1
gpgcheck=0
EOF

# Install based on package manager
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y vem
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y vem
elif command -v zypper >/dev/null 2>&1; then
    sudo zypper refresh
    sudo zypper install -y vem
else
    echo "❌ No supported package manager found (dnf/yum/zypper)"
    echo "💡 This script is for RPM-based Linux distributions"
    exit 1
fi

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
RPMEOFMARKER

# Make scripts executable
chmod +x "$DOCS_DIR/install"/*.sh

# Create directory index files for repository browsing
echo "📝 Creating directory index files..."

# Function to create directory index
create_directory_index() {
    local dir_path="$1"
    local dir_name="$2"
    local parent_path="$3"
    local description="$4"
    
    cat > "$dir_path/index.html" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$dir_name - VEM Repository</title>
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            padding: 2rem; 
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
        }
        .header { 
            text-align: center; 
            margin-bottom: 2rem; 
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .file-list {
            margin: 1.5rem 0;
        }
        .file-item {
            padding: 0.75rem;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .file-item:last-child {
            border-bottom: none;
        }
        .file-item:hover {
            background-color: #f8f9fa;
        }
        .file-name {
            font-family: 'Monaco', 'Menlo', monospace;
        }
        .file-name a {
            color: #007bff;
            text-decoration: none;
        }
        .file-name a:hover {
            text-decoration: underline;
        }
        .file-size {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .back-link {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📁 $dir_name</h1>
        <p>$description</p>
    </div>

    <div class="file-list">
        <h3>📦 Files</h3>
EOF

    # List files in directory
    if [ -d "$dir_path" ]; then
        for file in "$dir_path"/*; do
            if [ -f "$file" ] && [ "$(basename "$file")" != "index.html" ]; then
                filename=$(basename "$file")
                filesize=$(ls -lh "$file" | awk '{print $5}')
                echo "        <div class=\"file-item\">" >> "$dir_path/index.html"
                echo "            <span class=\"file-name\"><a href=\"$filename\">$filename</a></span>" >> "$dir_path/index.html"
                echo "            <span class=\"file-size\">$filesize</span>" >> "$dir_path/index.html"
                echo "        </div>" >> "$dir_path/index.html"
            elif [ -d "$file" ] && [ "$(basename "$file")" != "." ] && [ "$(basename "$file")" != ".." ]; then
                dirname=$(basename "$file")
                echo "        <div class=\"file-item\">" >> "$dir_path/index.html"
                echo "            <span class=\"file-name\"><a href=\"$dirname/\">$dirname/</a></span>" >> "$dir_path/index.html"
                echo "            <span class=\"file-size\">Directory</span>" >> "$dir_path/index.html"
                echo "        </div>" >> "$dir_path/index.html"
            fi
        done
    fi

    cat >> "$dir_path/index.html" << EOF
    </div>

    <div class="back-link">
        <p><a href="$parent_path">⬅️ Back to Parent Directory</a></p>
    </div>
</body>
</html>
EOF
}

# Create directory indexes for RPM repository
create_directory_index "$REPO_ROOT/repo/rpm/rpms" "RPM Packages" "../" "RPM package files for VEM"
create_directory_index "$REPO_ROOT/repo/rpm/repodata" "Repository Metadata" "../" "RPM repository metadata files"

# Create directory indexes for DEB repository  
create_directory_index "$REPO_ROOT/repo/deb/pool" "DEB Packages" "../" "DEB package files for VEM"
create_directory_index "$REPO_ROOT/repo/deb/dists" "Distribution Metadata" "../" "DEB repository distribution metadata"
if [ -d "$REPO_ROOT/repo/deb/pool/main" ]; then
    create_directory_index "$REPO_ROOT/repo/deb/pool/main" "Main Packages" "../" "Main DEB packages"
fi
if [ -d "$REPO_ROOT/repo/deb/dists/stable" ]; then
    create_directory_index "$REPO_ROOT/repo/deb/dists/stable" "Stable Distribution" "../" "Stable distribution metadata"
fi

echo "✅ Directory index files created"

# Restore index.html files from backup (excluding homebrew)
echo "🔄 Restoring index.html files..."
if [ -d "$REPO_ROOT/backups/index-files" ]; then
    find "$REPO_ROOT/backups/index-files" -name "index.html" | while read backup_file; do
        original_path="$REPO_ROOT${backup_file#$REPO_ROOT/backups/index-files}"
        # Skip homebrew paths since homebrew is managed separately
        if [[ "$original_path" == *"/repo/homebrew/"* ]]; then
            continue
        fi
        if [ -f "$backup_file" ]; then
            mkdir -p "$(dirname "$original_path")"
            cp "$backup_file" "$original_path"
            echo "  ✅ Restored: $original_path"
        fi
    done
    echo "✅ Index files restored from backup"
else
    echo "⚠️  No backup directory found, skipping restore"
fi

fi

echo ""
echo "🎉 Package repository build complete!"
echo "📁 Repository structure:"
echo "  📦 DEB packages: repo/deb/"
echo "  📦 RPM packages: repo/rpm/"
echo "  📚 Documentation: docs/"

echo "🎉 Package repositories built successfully!"
echo "📂 Package directories: $REPO_ROOT/repo/{deb,rpm}"
echo "📂 Docs directory: $DOCS_DIR"
echo "🌐 Ready for deployment to GitHub Pages"