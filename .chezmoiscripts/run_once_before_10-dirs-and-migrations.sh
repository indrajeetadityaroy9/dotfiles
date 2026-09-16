#!/bin/sh
# Create directories the configs assume exist, and migrate state out of $HOME.
# Scripts live in .chezmoiscripts/ so chezmoi runs them WITHOUT also deploying
# them into $HOME (the old top-level run_once_* scripts left stray files there).
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

# Preserve existing shell history when HISTFILE moves to its XDG location.
if [ -f "$HOME/.zsh_history" ] && [ ! -f "$XDG_STATE_HOME/zsh/history" ]; then
    mv "$HOME/.zsh_history" "$XDG_STATE_HOME/zsh/history"
    echo "migrated ~/.zsh_history -> \$XDG_STATE_HOME/zsh/history"
fi
