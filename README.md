# VEM Package Repository

VEM (Vim Environment Manager) の公式パッケージ配布レポジトリです。GitHub Pages を使用して DEB、RPM、Homebrew パッケージを提供します。

## 🚀 インストール方法

### Homebrew (macOS)

```bash
brew tap vim-environment-manager/packages
brew install vem
```

### Debian/Ubuntu

```bash
# レポジトリを追加
echo "deb https://vim-environment-manager.github.io/packages/deb ./" | sudo tee /etc/apt/sources.list.d/vem.list

# パッケージリストを更新
sudo apt update

# VEMをインストール
sudo apt install vem
```

### RedHat/CentOS/Fedora

```bash
# レポジトリを追加
sudo tee /etc/yum.repos.d/vem.repo <<EOF
[vem]
name=VEM Repository
baseurl=https://vim-environment-manager.github.io/packages/rpm
enabled=1
gpgcheck=0
EOF

# VEMをインストール (dnf または yum を使用)
sudo dnf install vem
```

## 📦 利用可能なパッケージ

| パッケージ | アーキテクチャ | SHA256 | サイズ |
|------------|----------------|---------|---------|
| vem_0.1.0_amd64.deb | x86_64 | 98bb2b3d11d74ef1e51d8aa20a1eb3d6d9286a2be364ba4032fa880ee4174cf6 | 624 KB |
| vem_0.1.0_arm64.deb | ARM64 | - | - |
| vem-linux-x86_64.rpm | x86_64 | 817f55f7f0563d45f2c4f7a3bef5782e28f3633b1d826567b01ae8d172024d48 | 754 KB |
| vem-0.1.0-x86_64.tar.gz | x86_64 | f152d7c24bcf01872420c1982394be5da25f67331e376ea82675fd6906c77f1c | 757 KB |
| vem-0.1.0-aarch64.tar.gz | ARM64 | 3e0ae1238fb5348f7d1c13b39b38b7e086bd7c5deff063b581ded37613045fee | 717 KB |

## 🛠 ワンライナーインストール

### Debian/Ubuntu
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-deb.sh | bash
```

### RedHat/CentOS/Fedora
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-rpm.sh | bash
```

### macOS (Homebrew)
```bash
curl -fsSL https://vim-environment-manager.github.io/packages/install/install-homebrew.sh | bash
```

## 📋 レポジトリ構造

```
packages/
├── deb/                    # DEBパッケージとメタデータ
│   ├── *.deb
│   ├── Packages
│   ├── Packages.gz
│   └── Release
├── rpm/                    # RPMパッケージとメタデータ
│   ├── *.rpm
│   └── repodata/
├── homebrew/               # Homebrewタップ
│   └── Formula/
│       └── vem.rb
├── config/                 # レポジトリ設定ファイル
│   ├── vem.list           # DEB sources.list
│   └── vem.repo           # RPM repo file
├── install/               # インストールスクリプト
│   ├── install-deb.sh
│   ├── install-rpm.sh
│   └── install-homebrew.sh
└── index.html             # GitHub Pages ランディングページ
```

## 🔧 開発

このレポジトリは GitHub Actions を使用して自動的にパッケージを更新します。

### スクリプト

- `scripts/build-deb.sh` - DEBパッケージのビルド
- `scripts/build-rpm.sh` - RPMパッケージのビルド
- `scripts/generate-homebrew.sh` - Homebrewフォーミュラの生成
- `scripts/create-repo-metadata.sh` - レポジトリメタデータの作成
- `scripts/generate-index.sh` - ランディングページの生成

## 📖 関連リンク

- [VEM メインレポジトリ](https://github.com/ryo-arima/vem)
- [パッケージ配布ページ](https://vim-environment-manager.github.io/packages/)
- [最新リリース](https://github.com/ryo-arima/vem/releases/tag/v0.1.0-20251019)
