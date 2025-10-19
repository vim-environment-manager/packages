# VEM Package Repository Makefile
.PHONY: help build docs clean test serve install deps

# Default target
help: ## Show help message
	@echo "VEM Package Repository Build System"
	@echo "====================================="
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Dependencies check
deps: ## Check and install dependencies
	@echo "🔍 Checking dependencies..."
	@command -v mdbook >/dev/null 2>&1 || { echo "❌ mdbook not found. Install from https://github.com/rust-lang/mdBook/releases"; exit 1; }
	@command -v wget >/dev/null 2>&1 || { echo "❌ wget not found. Please install wget"; exit 1; }
	@echo "✅ All dependencies available"

# Build documentation
docs: deps ## Build mdbook documentation
	@echo "📚 Building documentation..."
	@echo "  📖 Building base documentation..."
	@cd mdbook/base && mdbook build
	@echo "  🐧 Building DEB documentation..."
	@cd mdbook/deb && mdbook build
	@echo "  🎩 Building RPM documentation..."
	@cd mdbook/rpm && mdbook build
	@echo "  🍺 Building Homebrew documentation..."
	@cd mdbook/homebrew && mdbook build
	@echo "✅ Documentation built successfully"

# Build package repositories and docs
build: docs ## Build complete package repository
	@echo "🚀 Building package repositories..."
	@./scripts/build-repo.sh
	@./scripts/create-root-redirect.sh
	@echo "✅ Build completed successfully"

# Build repositories only (no docs copy to deb/rpm/homebrew)
repo-only: deps ## Build package repositories without copying docs
	@echo "📦 Building package repositories only..."
	@./scripts/build-repo.sh
	@echo "✅ Repository build completed"

# Clean build artifacts
clean: ## Clean all build artifacts
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf docs/
	@rm -rf mdbook/*/book/
	@rm -f index.html
	@echo "✅ Clean completed"

# Test the build
test: build ## Test the built repository
	@echo "🧪 Testing build output..."
	@echo "  📚 Testing documentation..."
	@test -f docs/index.html || { echo "❌ Root index.html missing"; exit 1; }
	@test -f docs/base/index.html || { echo "❌ Base documentation missing"; exit 1; }
	@test -f docs/deb/index.html || { echo "❌ DEB documentation missing"; exit 1; }
	@test -f docs/rpm/index.html || { echo "❌ RPM documentation missing"; exit 1; }
	@test -f docs/homebrew/index.html || { echo "❌ Homebrew documentation missing"; exit 1; }
	@echo "  📦 Testing package repositories..."
	@test -d deb/pool || { echo "❌ DEB packages missing"; exit 1; }
	@test -d deb/dists || { echo "❌ DEB metadata missing"; exit 1; }
	@test -f deb/dists/stable/main/binary-amd64/Packages || { echo "❌ DEB Packages file missing"; exit 1; }
	@test -d rpm/repodata || { echo "❌ RPM metadata missing"; exit 1; }
	@test -f homebrew/Formula/vem.rb || { echo "❌ Homebrew formula missing"; exit 1; }
	@echo "  📜 Testing installation scripts..."
	@test -f docs/install/install-deb.sh || { echo "❌ DEB install script missing"; exit 1; }
	@test -f docs/install/install-rpm.sh || { echo "❌ RPM install script missing"; exit 1; }
	@test -f docs/install/install-homebrew.sh || { echo "❌ Homebrew install script missing"; exit 1; }
	@echo "✅ All tests passed"

# Serve locally for testing
serve: build ## Serve the repository locally (requires Python)
	@echo "🌐 Starting local server at http://localhost:8000"
	@echo "📝 Press Ctrl+C to stop"
	@cd docs && python3 -m http.server 8000

# Install dependencies (macOS specific)
install: ## Install dependencies on macOS
	@echo "📦 Installing dependencies..."
	@if ! command -v mdbook >/dev/null 2>&1; then \
		echo "  📚 Installing mdbook..."; \
		curl -L https://github.com/rust-lang/mdBook/releases/download/v0.4.36/mdbook-v0.4.36-x86_64-apple-darwin.tar.gz | tar xz; \
		sudo mv mdbook /usr/local/bin/; \
	fi
	@if ! command -v wget >/dev/null 2>&1; then \
		echo "  🌐 Installing wget..."; \
		brew install wget || { echo "❌ Please install Homebrew first"; exit 1; }; \
	fi
	@echo "✅ Dependencies installed"

# Development targets
dev-docs: ## Build and serve documentation for development
	@echo "📚 Building documentation for development..."
	@make docs
	@echo "🌐 Starting documentation server..."
	@cd docs/base && python3 -m http.server 8001 &
	@echo "📖 Base docs: http://localhost:8001"
	@echo "📝 Press Ctrl+C to stop"

# CI/CD targets
ci-build: deps build test ## Build and test (for CI)
	@echo "🎉 CI build completed successfully"

ci-deploy: ci-build ## Deploy to GitHub Pages (for CI)
	@echo "🚀 Ready for GitHub Pages deployment"
	@echo "📂 Deploy directory: docs/"

# Quick development cycle
quick: clean docs ## Quick build without downloading packages
	@echo "⚡ Quick build (docs only)..."
	@mkdir -p docs
	@cp -r base docs/
	@cp -r deb docs/
	@cp -r rpm docs/
	@cp -r homebrew docs/
	@./scripts/create-root-redirect.sh
	@echo "✅ Quick build completed"

# Package-only build (without docs)
packages: deps ## Download packages and create repositories only
	@echo "📦 Building package repositories only..."
	@./scripts/build-repo.sh
	@echo "✅ Package repositories built"
