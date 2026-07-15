#!/bin/sh
# Install Apple's SF Mono into the user font library.
# Used by dot_config/ghostty/config (font-family = SF Mono, 11pt, to match
# Terminal.app's Basic profile). Apple ships SF Mono only inside Terminal.app and
# does not register it system-wide, so Ghostty can't resolve "SF Mono" until these
# faces are installed. run_once = chezmoi runs this a single time per machine
# (re-runs only if this script's contents change). Idempotent: a plain re-copy.
set -eu

SRC="/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
DEST="$HOME/Library/Fonts"

# Skip gracefully on non-macOS or if Apple relocates the fonts (don't fail apply).
[ -d "$SRC" ] || { echo "SF Mono source not found ($SRC); skipping."; exit 0; }

mkdir -p "$DEST"
cp "$SRC"/SF-Mono-*.otf "$DEST"/
echo "Installed SF Mono faces into $DEST"
