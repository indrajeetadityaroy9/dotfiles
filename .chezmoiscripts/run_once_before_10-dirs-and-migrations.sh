#!/bin/sh
set -eu

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p \
    "$XDG_CACHE_HOME/zsh" \
    "$XDG_STATE_HOME/zsh" \
    "$XDG_DATA_HOME/zsh/plugins" \
    "$HOME/.ssh/config.d" \
    "$HOME/.ssh/sockets"

chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d" "$HOME/.ssh/sockets"

if [ -f "$HOME/.zsh_history" ] && [ ! -f "$XDG_STATE_HOME/zsh/history" ]; then
    mv "$HOME/.zsh_history" "$XDG_STATE_HOME/zsh/history"
    echo "migrated ~/.zsh_history -> \$XDG_STATE_HOME/zsh/history"
fi
