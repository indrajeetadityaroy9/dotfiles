#!/bin/sh

set -eu

command -v mise >/dev/null || { echo "install mise first: https://mise.run" >&2; exit 1; }

mise install

if command -v prek >/dev/null; then
    ( cd "$(chezmoi source-path)" && prek install )
else
    echo "prek not on PATH yet — open a new shell and re-run for git hooks." >&2
fi

echo "bootstrap done. Machine-specific steps are listed in the README."
