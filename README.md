# Sasho

A native macOS window manager. Zero dependencies, instant snapping, runs silently in your menu bar. Always free, no ads, no upsell.

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

## Features

- **Instant window snapping** — halves, quarters, maximize, center
- **Grid Overlay (Master Mode)** — press `⌃⌥ Space` for a visual zone picker
- **Trackpad gestures** — hold `⌃⌥` and swipe to snap (8 directions)
- **Multi-monitor** — move windows between screens with proportional scaling
- **Smart Revert** — undo the last snap with `⌃⌥ Z`
- **Launch at Login** — toggle from the menu bar
- **Menu-bar only** — no dock icon, no clutter
- **Zero dependencies** — pure Swift, single binary (~1MB)

## Install

### Quick Install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/install.sh | bash
```

This downloads, installs, starts Sasho in the background, and sets it to **launch automatically on login** — no further setup needed.

### Homebrew

```bash
brew tap kleidiCode/sasho
brew install sasho
nohup sasho &
```

### Build from Source

Requires macOS 13+ and Swift 5.9+ (included with Xcode Command Line Tools).

```bash
git clone https://github.com/kleidiCode/sasho.git
cd sasho
./build.sh
nohup ./sasho &
```

## Keyboard Shortcuts

All shortcuts use **⌃⌥** (Control + Option) as the base modifier.

| Shortcut | Action |
|---|---|
| `⌃⌥ Return` | Maximize |
| `⌃⌥ ←` | Left Half |
| `⌃⌥ →` | Right Half |
| `⌃⌥ ↑` | Top Half |
| `⌃⌥ ↓` | Bottom Half |
| `⌃⌥ U` | Top-Left Quarter |
| `⌃⌥ I` | Top-Right Quarter |
| `⌃⌥ J` | Bottom-Left Quarter |
| `⌃⌥ K` | Bottom-Right Quarter |
| `⌃⌥ C` | Center (70%) |
| `⌃⌥ Z` | Revert |
| `⌃⌥ Space` | Grid Overlay |
| `⌃⌥⌘ →` | Next Monitor |
| `⌃⌥⌘ ←` | Previous Monitor |
| `⌃⌥ + swipe` | Trackpad snap (8 dirs) |

## Grid Overlay

Press `⌃⌥ Space` to show a full-screen grid. Press a key to snap to that zone, or press two keys in sequence to span multiple zones.

```
┌───────┬───────┬───────┐
│   Q   │   W   │   E   │
├───────┼───────┼───────┤
│   A   │   S   │   D   │
└───────┴───────┴───────┘
```

Examples: `Q` = top-left third, `Q → E` = full top row, `Q → D` = full screen.

## Permissions

Sasho requires **Accessibility** access to control other applications' windows.

On first launch, macOS will prompt you to grant access in:
**System Settings → Privacy & Security → Accessibility**

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/kleidiCode/sasho/master/uninstall.sh | bash
```

## License

Apache License 2.0 — see [LICENSE](LICENSE).
