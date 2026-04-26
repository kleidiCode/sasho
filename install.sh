#!/bin/bash
# Sasho — One-command installer
# Usage: curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/install.sh | bash
set -e

APP="sasho"
VERSION="v0.1.0"
INSTALL_DIR="/usr/local/bin"
TARBALL="${APP}-${VERSION}-macos-arm64.tar.gz"
DOWNLOAD_URL="https://github.com/kleidiCode/sasho/releases/download/${VERSION}/${TARBALL}"
AGENT_LABEL="com.sasho.windowmanager"
AGENT_DIR="$HOME/Library/LaunchAgents"
AGENT_PLIST="$AGENT_DIR/$AGENT_LABEL.plist"
TMPDIR_INSTALL=$(mktemp -d)

echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║         Sasho Installer ${VERSION}         ║"
echo "  ║   macOS Window Manager — Free & Open  ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

# ── Preflight checks ────────────────────────────────────────

if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ Sasho only runs on macOS."
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo "⚠️  This binary is built for Apple Silicon (arm64)."
    echo "   Your architecture: $ARCH"
    echo "   Use 'brew tap kleidiCode/sasho && brew install sasho' to build from source."
    exit 1
fi

# ── Stop existing instance ──────────────────────────────────

if pgrep -x "$APP" > /dev/null 2>&1; then
    echo "⏹  Stopping existing sasho process..."
    killall "$APP" 2>/dev/null || true
    sleep 1
fi

# ── Download & extract ──────────────────────────────────────

echo "⬇️  Downloading Sasho ${VERSION}..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR_INSTALL/$TARBALL"

echo "📦 Extracting..."
tar -xzf "$TMPDIR_INSTALL/$TARBALL" -C "$TMPDIR_INSTALL"

# Remove quarantine (prevents Gatekeeper warning)
xattr -dr com.apple.quarantine "$TMPDIR_INSTALL" 2>/dev/null || true

# ── Install binary ──────────────────────────────────────────

echo "📁 Installing to ${INSTALL_DIR}/sasho..."
if [[ ! -d "$INSTALL_DIR" ]]; then
    sudo mkdir -p "$INSTALL_DIR"
fi
if [[ -w "$INSTALL_DIR" ]]; then
    cp "$TMPDIR_INSTALL/$APP" "$INSTALL_DIR/$APP"
    chmod 755 "$INSTALL_DIR/$APP"
else
    sudo cp "$TMPDIR_INSTALL/$APP" "$INSTALL_DIR/$APP"
    sudo chmod 755 "$INSTALL_DIR/$APP"
fi

# Cleanup temp files
rm -rf "$TMPDIR_INSTALL"

# Verify binary is in PATH
if ! command -v sasho &> /dev/null; then
    echo ""
    echo "⚠️  'sasho' is not in your PATH."
    echo "   Add this to your ~/.zshrc:"
    echo "   export PATH=\"/usr/local/bin:\$PATH\""
    echo ""
fi

# ── Set up Launch at Login ──────────────────────────────────

echo "🔄 Setting up Launch at Login..."

mkdir -p "$AGENT_DIR"

# Remove existing agent if present
if [[ -f "$AGENT_PLIST" ]]; then
    launchctl bootout "gui/$(id -u)/$AGENT_LABEL" 2>/dev/null || true
    rm -f "$AGENT_PLIST"
fi

# Create LaunchAgent plist
cat > "$AGENT_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${AGENT_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${INSTALL_DIR}/${APP}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>ProcessType</key>
    <string>Interactive</string>
</dict>
</plist>
EOF

chmod 600 "$AGENT_PLIST"

# ── Start sasho now ─────────────────────────────────────────

echo "🚀 Starting Sasho..."
launchctl bootstrap "gui/$(id -u)" "$AGENT_PLIST" 2>/dev/null || true

sleep 2

# ── Verify ──────────────────────────────────────────────────

if pgrep -x "$APP" > /dev/null 2>&1; then
    echo ""
    echo "  ✅ Sasho is installed and running!"
    echo ""
    echo "  It will start automatically on every login."
    echo "  Look for the Sasho icon in your menu bar."
    echo ""
    echo "  ┌─────────────────────────────────────┐"
    echo "  │  ⌃⌥ ←/→/↑/↓    Snap to half        │"
    echo "  │  ⌃⌥ Return      Maximize             │"
    echo "  │  ⌃⌥ Space       Grid Overlay          │"
    echo "  │  ⌃⌥ Z           Revert                │"
    echo "  │  ⌃⌥⌘ ←/→       Move to next monitor  │"
    echo "  └─────────────────────────────────────┘"
    echo ""
    echo "  ⚙️  Manage from the menu bar icon."
    echo "  📖 Docs: https://github.com/kleidiCode/sasho"
    echo ""
else
    echo ""
    echo "  ⚠️  Sasho needs Accessibility permissions to work."
    echo ""
    echo "  1. Open System Settings → Privacy & Security → Accessibility"
    echo "  2. Enable 'sasho' in the list"
    echo "  3. Sasho will start working immediately"
    echo ""
    echo "  It's already set to launch on login — no further setup needed."
    echo ""
fi

# ── Uninstall instructions ──────────────────────────────────

echo "  To uninstall: curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/uninstall.sh | bash"
echo ""
