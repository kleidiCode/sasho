#!/bin/bash
# Sasho — One-command installer
# Usage: curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/install.sh | bash
set -e

APP="sasho"
VERSION="v0.1.0"
INSTALL_DIR="/usr/local/bin"
TARBALL="${APP}-${VERSION}-macos-arm64.tar.gz"
DOWNLOAD_URL="https://github.com/kleidiCode/sasho/releases/download/${VERSION}/${TARBALL}"
TMPDIR_INSTALL=$(mktemp -d)

echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║         Sasho Installer ${VERSION}         ║"
echo "  ║   macOS Window Manager — Free & Open  ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Sasho only runs on macOS."
    exit 1
fi

# Check architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo "⚠️  This binary is built for Apple Silicon (arm64)."
    echo "   Your architecture: $ARCH"
    echo "   Use 'brew tap kleidiCode/sasho && brew install sasho' to build from source."
    exit 1
fi

# Stop any running instance
if pgrep -x "$APP" > /dev/null 2>&1; then
    echo "⏹  Stopping existing sasho process..."
    killall "$APP" 2>/dev/null || true
    sleep 1
fi

# Download
echo "⬇️  Downloading Sasho ${VERSION}..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR_INSTALL/$TARBALL"

# Extract
echo "📦 Extracting..."
tar -xzf "$TMPDIR_INSTALL/$TARBALL" -C "$TMPDIR_INSTALL"

# Remove quarantine attribute (prevents Gatekeeper warning)
xattr -dr com.apple.quarantine "$TMPDIR_INSTALL" 2>/dev/null || true

# Install binary
echo "📁 Installing to ${INSTALL_DIR}/sasho..."
if [[ -w "$INSTALL_DIR" ]]; then
    cp "$TMPDIR_INSTALL/$APP" "$INSTALL_DIR/$APP"
    chmod 755 "$INSTALL_DIR/$APP"
else
    sudo cp "$TMPDIR_INSTALL/$APP" "$INSTALL_DIR/$APP"
    sudo chmod 755 "$INSTALL_DIR/$APP"
fi

# Cleanup
rm -rf "$TMPDIR_INSTALL"

# Verify installation
if ! command -v sasho &> /dev/null; then
    echo ""
    echo "⚠️  'sasho' is not in your PATH."
    echo "   Add this to your shell profile:"
    echo "   export PATH=\"/usr/local/bin:\$PATH\""
    echo ""
fi

# Start sasho
echo "🚀 Starting Sasho..."
nohup "$INSTALL_DIR/$APP" > /dev/null 2>&1 &
sleep 1

# Check if it's running
if pgrep -x "$APP" > /dev/null 2>&1; then
    echo ""
    echo "  ✅ Sasho is running! Look for the icon in your menu bar."
    echo ""
    echo "  📋 Quick start:"
    echo "     • ⌃⌥ ←/→/↑/↓  — Snap to half"
    echo "     • ⌃⌥ Return    — Maximize"
    echo "     • ⌃⌥ Space     — Grid Overlay"
    echo "     • ⌃⌥ Z         — Revert"
    echo ""
    echo "  🔧 Enable 'Launch at Login' from the menu bar icon"
    echo "     to start Sasho automatically on boot."
    echo ""
    echo "  📖 Full docs: https://github.com/kleidiCode/sasho"
    echo ""
else
    echo ""
    echo "  ⚠️  Sasho may need Accessibility permissions."
    echo "     Go to: System Settings → Privacy & Security → Accessibility"
    echo "     Then run: sasho"
    echo ""
fi
