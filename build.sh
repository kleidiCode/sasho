#!/bin/bash
# Build script for Sasho — macOS window manager
# Usage: ./build.sh

set -e

echo "🔨 Building Sasho..."

swiftc -O \
  -framework Cocoa \
  -framework Carbon \
  -framework ApplicationServices \
  Sources/Sasho/Utilities/AXExtensions.swift \
  Sources/Sasho/Utilities/PermissionsChecker.swift \
  Sources/Sasho/Utilities/SettingsManager.swift \
  Sources/Sasho/Utilities/LoginItemManager.swift \
  Sources/Sasho/Core/ScreenManager.swift \
  Sources/Sasho/Core/WindowHistory.swift \
  Sources/Sasho/Core/WindowAction.swift \
  Sources/Sasho/Core/WindowManager.swift \
  Sources/Sasho/Core/HotKeyManager.swift \
  Sources/Sasho/Core/GestureManager.swift \
  Sources/Sasho/Overlay/GridOverlayView.swift \
  Sources/Sasho/Overlay/GridOverlayController.swift \
  Sources/Sasho/UI/StatusBarController.swift \
  Sources/Sasho/main.swift \
  -o sasho

echo "✅ Build successful!"
echo ""
echo "To run:  ./sasho"
echo "To stop: Ctrl+C or use 'Quit Sasho' from the menu bar icon"
