#!/bin/sh
set -eu

SRC="$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"
OS="$(uname)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

if command -v mise >/dev/null 2>&1; then
    log "mise install (locked toolchain)"
    mise install
else
    log "mise not found on PATH — install it first (https://mise.run), then re-run."
    exit 1
fi

if command -v prek >/dev/null 2>&1; then
    log "prek install (git hooks in $SRC)"
    ( cd "$SRC" && prek install )
else
    log "prek not found yet (mise should provide it) — skipping hook install."
fi

case "$OS" in
Darwin)
    if command -v brew >/dev/null 2>&1 && [ -f "$SRC/Brewfile" ]; then
        log "brew bundle ($SRC/Brewfile)"
        brew bundle --file="$SRC/Brewfile"
    else
        log "brew or $SRC/Brewfile missing — skipping brew bundle."
    fi
    if command -v sheldon >/dev/null 2>&1; then
        log "sheldon lock"
        sheldon lock
    fi
    ;;
Linux)
    log "Linux: zsh plugins handled by run_once script; apt prereqs are a manual step."
    ;;
esac

cat <<'EOF'

--> Manual, machine-specific steps (not automated):
    * SSH key:      place ~/.ssh/id_ed25519 and ~/.ssh/id_ed25519.pub (commits are signed with it)
    * Tailnet host: create ~/.ssh/config.d/tailnet.conf (chmod 600)
    * Secrets:      chezmoi secret keyring set --service=<name> --user="$USER"
EOF

log "bootstrap complete."
