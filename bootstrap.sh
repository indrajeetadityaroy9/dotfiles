#!/bin/sh
# One-shot, idempotent, OS-detecting bootstrap for this machine.
# Run once AFTER `chezmoi init --apply` (or `chezmoi update`). Safe to re-run.
# No sudo here — everything is userspace. (Ubuntu apt prereqs are a separate manual step; see the plan §8.)
set -eu

SRC="$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"
OS="$(uname)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# 1. Install the pinned/locked toolchain (reads ~/.config/mise/config.toml + mise.lock).
if command -v mise >/dev/null 2>&1; then
    log "mise install (locked toolchain)"
    mise install
else
    log "mise not found on PATH — install it first (https://mise.run), then re-run."
    exit 1
fi

# 2. Activate the gitleaks pre-commit hook in the dotfiles repo (prek reads .pre-commit-config.yaml).
if command -v prek >/dev/null 2>&1; then
    log "prek install (git hooks in $SRC)"
    ( cd "$SRC" && prek install )
else
    log "prek not found yet (mise should provide it) — skipping hook install."
fi

case "$OS" in
Darwin)
    # 3. macOS package manifest (Homebrew >= 4.5: `bundle` is built-in, no tap needed).
    if command -v brew >/dev/null 2>&1 && [ -f "$SRC/Brewfile" ]; then
        log "brew bundle ($SRC/Brewfile)"
        brew bundle --file="$SRC/Brewfile"
    else
        log "brew or $SRC/Brewfile missing — skipping brew bundle."
    fi
    # 4. sheldon lock so the macOS zsh branch actually loads plugins.
    if command -v sheldon >/dev/null 2>&1; then
        log "sheldon lock"
        sheldon lock
    fi
    ;;
Linux)
    log "Linux: zsh plugins handled by run_once script; apt prereqs are a manual step (plan section 8)."
    ;;
esac

# 5. Reminders for machine-specific, out-of-repo steps.
cat <<'EOF'

--> Manual, machine-specific steps (not automated):
    * SSH key:      place ~/.ssh/id_ed25519 and ~/.ssh/id_ed25519.pub (commits are signed with it)
    * Tailnet host: create ~/.ssh/config.d/tailnet.conf (chmod 600) — see the plan section 8 for contents
    * Secrets:      chezmoi secret keyring set --service=<name> --user="$USER"
EOF

log "bootstrap complete."
