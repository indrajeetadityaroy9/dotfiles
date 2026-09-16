#!/bin/sh
# Idempotent machine setup. Safe to re-run. Manual steps: see README.
set -eu

command -v mise >/dev/null || { echo "install mise first: https://mise.run" >&2; exit 1; }

# NB: `mise lock` only operates on project-local configs, never the global
# one, so it cannot be run here. mise still *verifies* against mise.lock on
# install. To regenerate the lock, see "Regenerating mise.lock" in the README.
mise install

if command -v prek >/dev/null; then
    ( cd "$(chezmoi source-path)" && prek install )
else
    echo "prek not on PATH yet — open a new shell and re-run for git hooks." >&2
fi

echo "bootstrap done. Machine-specific steps are listed in the README."
