#!/bin/sh
set -eu

SRC="/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
DEST="$HOME/Library/Fonts"

[ -d "$SRC" ] || { echo "SF Mono source not found ($SRC); skipping."; exit 0; }

mkdir -p "$DEST"
cp "$SRC"/SF-Mono-*.otf "$DEST"/
echo "Installed SF Mono faces into $DEST"
