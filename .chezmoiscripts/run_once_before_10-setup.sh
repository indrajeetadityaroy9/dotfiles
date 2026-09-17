#!/bin/sh
set -eu

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p \
    "$XDG_CACHE_HOME/zsh" \
    "$XDG_STATE_HOME/zsh" \
    "$HOME/.ssh/config.d" \
    "$HOME/.ssh/sockets"

chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d" "$HOME/.ssh/sockets"

if [ -f "$HOME/.zsh_history" ] && [ ! -f "$XDG_STATE_HOME/zsh/history" ]; then
    mv "$HOME/.zsh_history" "$XDG_STATE_HOME/zsh/history"
fi

if [ "$(uname)" = "Darwin" ]; then
    SRC="/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
    DEST="$HOME/Library/Fonts"
    if [ -d "$SRC" ]; then
        mkdir -p "$DEST"
        cp "$SRC"/SF-Mono-*.otf "$DEST"/
    fi
fi
