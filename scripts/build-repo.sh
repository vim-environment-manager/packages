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
mkdir -p "$REPO_ROOT/repo"/{deb,rpm,homebrew}
mkdir -p "$REPO_ROOT/repo/deb/pool/main/v/vem"
mkdir -p "$REPO_ROOT/repo/deb/dists/stable/main/binary-amd64"
mkdir -p "$REPO_ROOT/repo/deb/dists/stable/main/binary-arm64"
mkdir -p "$REPO_ROOT/repo/rpm/repodata"
mkdir -p "$REPO_ROOT/repo/homebrew/Formula"

# Clean mdbook files from package repositories (remove only common static site artifacts)
echo "🧹 Cleaning mdbook files from package repositories..."
for repo_dir in deb rpm homebrew; do
    DIR="$REPO_ROOT/repo/$repo_dir"
    if [ -d "$DIR" ]; then
        # remove site files that may have been copied accidentally
        rm -f "$DIR"/.nojekyll 2>/dev/null || true
        rm -f "$DIR"/404.html 2>/dev/null || true
        # Don't remove index.html as it contains redirect to /repo
        # rm -f "$DIR"/index.html 2>/dev/null || true
        rm -f "$DIR"/book.js 2>/dev/null || true
        rm -rf "$DIR"/css 2>/dev/null || true
        rm -rf "$DIR"/js 2>/dev/null || true
        rm -rf "$DIR"/fonts 2>/dev/null || true
        rm -rf "$DIR"/search_index.json 2>/dev/null || true
        # also remove any deep nested index files accidentally placed (but preserve top-level index.html)
        find "$DIR" -mindepth 2 -type f -name "index.html" -exec rm -f {} + 2>/dev/null || true
        echo "  ✅ Cleaned $repo_dir directory"
    fi
done

# Download packages for each version (force download of actual packages)
echo "📦 Downloading packages..."
for FULL_VER in ${VERSIONS}; do
    VER=$(echo ${FULL_VER} | cut -d'-' -f1)
    DATE_PART=$(echo ${FULL_VER} | cut -d'-' -f2)
    TAG="v${FULL_VER}"
    
    echo "🔽 Processing version: ${VER} (${FULL_VER})"
    
    # Remove existing placeholder files first
    rm -f "$REPO_ROOT/repo/deb/pool/vem_${FULL_VER}_*.deb" 2>/dev/null || true
    rm -f "$REPO_ROOT/repo/rpm/rpms/vem-${FULL_VER}.x86_64.rpm" 2>/dev/null || true
    rm -f "$REPO_ROOT/repo/homebrew/archives/vem-${FULL_VER}-*" 2>/dev/null || true
    
    # Download DEB packages (actual files found in GitHub releases)
    echo "  📥 Downloading DEB packages..."
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem_0.1.0-202510191003_amd64.deb" && echo "  ✅ Downloaded vem_0.1.0-202510191003_amd64.deb" || echo "  ⚠️  Failed to download vem_0.1.0-202510191003_amd64.deb"
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem_0.1.0-202510191003_arm64.deb" && echo "  ✅ Downloaded vem_0.1.0-202510191003_arm64.deb" || echo "  ⚠️  Failed to download vem_0.1.0-202510191003_arm64.deb"
    # Also download linux generic deb files
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.deb" && echo "  ✅ Downloaded vem-linux-x86_64.deb" || echo "  ⚠️  Failed to download vem-linux-x86_64.deb"
    wget -q -P "$REPO_ROOT/repo/deb/pool" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-aarch64.deb" && echo "  ✅ Downloaded vem-linux-aarch64.deb" || echo "  ⚠️  Failed to download vem-linux-aarch64.deb"
    
    # Download RPM packages
    echo "  📥 Downloading RPM packages..."
    wget -q -P "$REPO_ROOT/repo/rpm/rpms" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-0.1.0-202510191003.x86_64.rpm" && echo "  ✅ Downloaded vem-0.1.0-202510191003.x86_64.rpm" || echo "  ⚠️  Failed to download vem-0.1.0-202510191003.x86_64.rpm"
    wget -q -P "$REPO_ROOT/repo/rpm/rpms" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.rpm" && echo "  ✅ Downloaded vem-linux-x86_64.rpm" || echo "  ⚠️  Failed to download vem-linux-x86_64.rpm"
    
    # Download tar.gz files for Homebrew
    echo "  📥 Downloading Homebrew archives..."
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-0.1.0-202510191003-x86_64.tar.gz" && echo "  ✅ Downloaded vem-0.1.0-202510191003-x86_64.tar.gz" || echo "  ⚠️  Failed to download vem-0.1.0-202510191003-x86_64.tar.gz"
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-0.1.0-202510191003-aarch64.tar.gz" && echo "  ✅ Downloaded vem-0.1.0-202510191003-aarch64.tar.gz" || echo "  ⚠️  Failed to download vem-0.1.0-202510191003-aarch64.tar.gz"
    # Also download generic linux tar.gz files
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.tar.gz" && echo "  ✅ Downloaded vem-linux-x86_64.tar.gz" || echo "  ⚠️  Failed to download vem-linux-x86_64.tar.gz"
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-aarch64.tar.gz" && echo "  ✅ Downloaded vem-linux-aarch64.tar.gz" || echo "  ⚠️  Failed to download vem-linux-aarch64.tar.gz"
    
    # Download zip files for generic use
    echo "  📥 Downloading ZIP archives..."
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-0.1.0-202510191003-x86_64.zip" && echo "  ✅ Downloaded vem-0.1.0-202510191003-x86_64.zip" || echo "  ⚠️  Failed to download vem-0.1.0-202510191003-x86_64.zip"
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-0.1.0-202510191003-aarch64.zip" && echo "  ✅ Downloaded vem-0.1.0-202510191003-aarch64.zip" || echo "  ⚠️  Failed to download vem-0.1.0-202510191003-aarch64.zip"
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-x86_64.zip" && echo "  ✅ Downloaded vem-linux-x86_64.zip" || echo "  ⚠️  Failed to download vem-linux-x86_64.zip"
    wget -q -P "$REPO_ROOT/repo/homebrew/archives" "https://github.com/ryo-arima/vem/releases/download/${TAG}/vem-linux-aarch64.zip" && echo "  ✅ Downloaded vem-linux-aarch64.zip" || echo "  ⚠️  Failed to download vem-linux-aarch64.zip"
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

# Create Homebrew Formula
echo "🍺 Creating Homebrew Formula..."
mkdir -p "$REPO_ROOT/repo/homebrew/Formula"

# Calculate SHA256 for downloaded files
ARM64_SHA=""
X86_64_SHA=""

if [ -f "$REPO_ROOT/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-aarch64.tar.gz" ]; then
    ARM64_SHA=$(shasum -a 256 "$REPO_ROOT/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-aarch64.tar.gz" | cut -d' ' -f1)
fi

if [ -f "$REPO_ROOT/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-x86_64.tar.gz" ]; then
    X86_64_SHA=$(shasum -a 256 "$REPO_ROOT/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-x86_64.tar.gz" | cut -d' ' -f1)
fi

cat > "$REPO_ROOT/repo/homebrew/Formula/vem.rb" << EOF
class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "${VEM_VERSION}"
  
  if Hardware::CPU.arm?
    url "https://vim-environment-manager.github.io/packages/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-aarch64.tar.gz"
    sha256 "${ARM64_SHA:-PLACEHOLDER_ARM64_SHA}"
  else
    url "https://vim-environment-manager.github.io/packages/repo/homebrew/archives/vem-${VEM_FULL_VERSION}-x86_64.tar.gz"
    sha256 "${X86_64_SHA:-PLACEHOLDER_X86_64_SHA}"
  end

  def install
    bin.install "vem"
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
EOF
echo "✅ Homebrew Formula created"

# Create installation scripts for docs directory
echo "📜 Creating installation scripts..."
mkdir -p "$DOCS_DIR/install"

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

# Homebrew installation script
cat > "$DOCS_DIR/install/install-homebrew.sh" << 'EOF'
#!/bin/bash
set -e

echo "🍺 Installing VEM via Homebrew..."

# Add tap and install
brew tap vim-environment-manager/tap https://vim-environment-manager.github.io/packages/repo/homebrew
brew install vem

echo "✅ VEM installed successfully!"
echo "📖 Usage: vem --help"
EOF

# Make scripts executable
chmod +x "$DOCS_DIR/install"/*.sh

echo "🎉 Package repositories built successfully!"
echo "📂 Package directories: $REPO_ROOT/repo/{deb,rpm,homebrew}"
echo "📂 Docs directory: $DOCS_DIR"
echo "🌐 Ready for deployment to GitHub Pages"