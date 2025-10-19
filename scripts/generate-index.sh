#!/bin/bash
set -e

# Generate index page for GitHub Pages
echo "Generating index page..."

VERSION="0.1.0"
PACKAGE_NAME="vem"
HOMEPAGE="https://github.com/ryo-arima/vem"

# Check if --redirects-only flag is passed
REDIRECTS_ONLY=false
if [ "$1" = "--redirects-only" ]; then
    REDIRECTS_ONLY=true
    echo "Only generating redirect pages for package directories..."
fi

# Create main index page (only if not redirects-only mode)
if [ "$REDIRECTS_ONLY" = false ]; then
cat > packages/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VEM Package Repository</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            line-height: 1.6;
            color: #333;
        }
        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
        }
        .section {
            margin: 2rem 0;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        .package-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        .package-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .package-card:hover {
            transform: translateY(-2px);
        }
        .package-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
            color: #2c3e50;
        }
        .install-command {
            background: #2d3748;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 5px;
            font-family: 'Monaco', 'Consolas', monospace;
            margin: 1rem 0;
            overflow-x: auto;
        }
        .file-list {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            overflow: hidden;
        }
        .file-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #e1e5e9;
        }
        .file-item:last-child {
            border-bottom: none;
        }
        .file-item:hover {
            background: #f8f9fa;
        }
        .file-name {
            font-weight: 500;
            color: #0366d6;
        }
        .file-meta {
            font-size: 0.875rem;
            color: #586069;
        }
        .download-btn {
            background: #28a745;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.2s;
        }
        .download-btn:hover {
            background: #218838;
            text-decoration: none;
            color: white;
        }
        .footer {
            text-align: center;
            margin-top: 3rem;
            padding: 2rem;
            color: #666;
        }
        .badge {
            background: #007bff;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>VEM Package Repository</h1>
        <p>Vim Environment Manager - Official Package Distribution</p>
        <div class="badge">Version 0.1.0</div>
    </div>

    <div class="section">
        <h2>📦 Available Installation Methods</h2>
        <div class="package-grid">
            <div class="package-card">
                <div class="package-title">🍺 Homebrew (macOS)</div>
                <p>For macOS users, install via Homebrew tap:</p>
                <div class="install-command">
brew tap vim-environment-manager/packages<br>
brew install vem
                </div>
            </div>

            <div class="package-card">
                <div class="package-title">📦 Debian/Ubuntu</div>
                <p>For Debian-based distributions:</p>
                <div class="install-command">
# Add repository<br>
echo "deb https://vim-environment-manager.github.io/packages/deb ./" | sudo tee /etc/apt/sources.list.d/vem.list<br>
sudo apt update<br>
sudo apt install vem
                </div>
            </div>

            <div class="package-card">
                <div class="package-title">🎩 RedHat/CentOS/Fedora</div>
                <p>For RPM-based distributions:</p>
                <div class="install-command">
# Add repository<br>
sudo tee /etc/yum.repos.d/vem.repo &lt;&lt;EOF<br>
[vem]<br>
name=VEM Repository<br>
baseurl=https://vim-environment-manager.github.io/packages/rpm<br>
enabled=1<br>
gpgcheck=0<br>
EOF<br>
<br>
# Install (use dnf or yum)<br>
sudo dnf install vem
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <h2>📥 Direct Downloads</h2>
        <p>Download packages directly for manual installation:</p>
        
        <h3>🐧 Linux Packages</h3>
        <div class="file-list">
            <div class="file-item">
                <div>
                    <div class="file-name">vem_0.1.0_amd64.deb</div>
                    <div class="file-meta">SHA256: 98bb2b3d11d74ef1e51d8aa20a1eb3d6d9286a2be364ba4032fa880ee4174cf6 | 624 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_amd64.deb" class="download-btn">Download</a>
            </div>
            <div class="file-item">
                <div>
                    <div class="file-name">vem_0.1.0_arm64.deb</div>
                    <div class="file-meta">SHA256: [hash] | [size]</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem_0.1.0_arm64.deb" class="download-btn">Download</a>
            </div>
            <div class="file-item">
                <div>
                    <div class="file-name">vem-linux-x86_64.rpm</div>
                    <div class="file-meta">SHA256: 817f55f7f0563d45f2c4f7a3bef5782e28f3633b1d826567b01ae8d172024d48 | 754 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-linux-x86_64.rpm" class="download-btn">Download</a>
            </div>
            <div class="file-item">
                <div>
                    <div class="file-name">vem-linux-aarch64.deb</div>
                    <div class="file-meta">SHA256: 4ee2ffebbd1d6eb0611673c8b44e43e1e372f69e5e789b338d983da2146516f7 | 596 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-linux-aarch64.deb" class="download-btn">Download</a>
            </div>
        </div>

        <h3>📁 Archive Files</h3>
        <div class="file-list">
            <div class="file-item">
                <div>
                    <div class="file-name">vem-0.1.0-x86_64.tar.gz</div>
                    <div class="file-meta">SHA256: f152d7c24bcf01872420c1982394be5da25f67331e376ea82675fd6906c77f1c | 757 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-0.1.0-x86_64.tar.gz" class="download-btn">Download</a>
            </div>
            <div class="file-item">
                <div>
                    <div class="file-name">vem-0.1.0-aarch64.tar.gz</div>
                    <div class="file-meta">SHA256: 3e0ae1238fb5348f7d1c13b39b38b7e086bd7c5deff063b581ded37613045fee | 717 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-0.1.0-aarch64.tar.gz" class="download-btn">Download</a>
            </div>
            <div class="file-item">
                <div>
                    <div class="file-name">vem-0.1.0-arm64.tar.gz</div>
                    <div class="file-meta">SHA256: df8849cdc964bc618585abaee73fbb35c85e3d30106bbf7ad1661ff2afbe72d5 | 680 KB</div>
                </div>
                <a href="https://github.com/ryo-arima/vem/releases/download/v0.1.0-20251019/vem-0.1.0-arm64.tar.gz" class="download-btn">Download</a>
            </div>
        </div>
    </div>

    <div class="section">
        <h2>📖 Quick Installation Scripts</h2>
        <p>One-liner installation scripts for different platforms:</p>
        
        <h3>Debian/Ubuntu</h3>
        <div class="install-command">
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-deb.sh | bash
        </div>

        <h3>RedHat/CentOS/Fedora</h3>
        <div class="install-command">
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-rpm.sh | bash
        </div>

        <h3>macOS (Homebrew)</h3>
        <div class="install-command">
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-homebrew.sh | bash
        </div>
    </div>

    <div class="section">
        <h2>📋 Repository Information</h2>
        <div class="package-grid">
            <div class="package-card">
                <div class="package-title">DEB Repository</div>
                <div class="install-command">
deb https://vim-environment-manager.github.io/packages/deb ./
                </div>
            </div>
            <div class="package-card">
                <div class="package-title">RPM Repository</div>
                <div class="install-command">
[vem]<br>
name=VEM Repository<br>
baseurl=https://vim-environment-manager.github.io/packages/rpm<br>
enabled=1<br>
gpgcheck=0
                </div>
            </div>
            <div class="package-card">
                <div class="package-title">Homebrew Tap</div>
                <div class="install-command">
vim-environment-manager/packages
                </div>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>VEM (Vim Environment Manager) | <a href="https://github.com/ryo-arima/vem">GitHub Repository</a></p>
        <p>Built with ❤️ for the Vim community</p>
    </div>
</body>
</html>
EOF

echo "Index page generated successfully: packages/index.html"
fi

# Create redirect index.html files for package directories
echo "Creating redirect index.html files..."

# DEB Repository redirect
cat > packages/deb/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>VEM DEB Repository</title>
    <meta http-equiv="refresh" content="0; url=docs/">
    <link rel="canonical" href="docs/">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 2rem; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
        ul { list-style: none; padding: 0; }
        li { margin: 1rem 0; padding: 1rem; background: #f8f9fa; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐧 VEM DEB Repository</h1>
        <p>Redirecting to <a href="docs/">documentation</a>...</p>
        <ul>
            <li><a href="docs/">📖 Documentation</a></li>
            <li><a href="dists/">📦 Repository Metadata</a></li>
            <li><a href="pool/">💾 Package Pool</a></li>
        </ul>
    </div>
</body>
</html>
EOF

# RPM Repository redirect
cat > packages/rpm/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>VEM RPM Repository</title>
    <meta http-equiv="refresh" content="0; url=docs/">
    <link rel="canonical" href="docs/">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 2rem; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
        ul { list-style: none; padding: 0; }
        li { margin: 1rem 0; padding: 1rem; background: #f8f9fa; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎩 VEM RPM Repository</h1>
        <p>Redirecting to <a href="docs/">documentation</a>...</p>
        <ul>
            <li><a href="docs/">📖 Documentation</a></li>
            <li><a href="repodata/">📦 Repository Metadata</a></li>
        </ul>
    </div>
</body>
</html>
EOF

# Homebrew Tap redirect
cat > packages/homebrew/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>VEM Homebrew Tap</title>
    <meta http-equiv="refresh" content="0; url=docs/">
    <link rel="canonical" href="docs/">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 2rem; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
        ul { list-style: none; padding: 0; }
        li { margin: 1rem 0; padding: 1rem; background: #f8f9fa; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🍺 VEM Homebrew Tap</h1>
        <p>Redirecting to <a href="docs/">documentation</a>...</p>
        <ul>
            <li><a href="docs/">📖 Documentation</a></li>
            <li><a href="Formula/">🍺 Formula Files</a></li>
        </ul>
    </div>
</body>
</html>
EOF

echo "Redirect index.html files created for deb, rpm, and homebrew directories"