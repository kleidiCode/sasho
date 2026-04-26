#!/bin/bash
# Sasho — Uninstaller
# Usage: curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/uninstall.sh | bash
set -e

APP="sasho"
INSTALL_DIR="/usr/local/bin"
AGENT_LABEL="com.sasho.windowmanager"
AGENT_PLIST="$HOME/Library/LaunchAgents/$AGENT_LABEL.plist"

echo ""
echo "  Uninstalling Sasho..."
echo ""

# Stop running process
if pgrep -x "$APP" > /dev/null 2>&1; then
    echo "⏹  Stopping sasho..."
    killall "$APP" 2>/dev/null || true
fi

# Remove LaunchAgent
if [[ -f "$AGENT_PLIST" ]]; then
    launchctl bootout "gui/$(id -u)/$AGENT_LABEL" 2>/dev/null || true
    rm -f "$AGENT_PLIST"
    echo "🗑  Removed LaunchAgent"
fi

# Remove binary
if [[ -f "$INSTALL_DIR/$APP" ]]; then
    if [[ -w "$INSTALL_DIR/$APP" ]]; then
        rm -f "$INSTALL_DIR/$APP"
    else
        sudo rm -f "$INSTALL_DIR/$APP"
    fi
    echo "🗑  Removed $INSTALL_DIR/$APP"
fi

# Remove settings
PREFS="$HOME/Library/Preferences/com.sasho.windowmanager.plist"
if [[ -f "$PREFS" ]]; then
    rm -f "$PREFS"
    echo "🗑  Removed preferences"
fi

echo ""
echo "  ✅ Sasho has been uninstalled."
echo ""
