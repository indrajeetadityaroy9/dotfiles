#!/bin/sh

set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if [ "$(uname)" = "Darwin" ]; then
    command -v brew >/dev/null || { echo "install Homebrew first: https://brew.sh" >&2; exit 1; }
    brew bundle install --no-upgrade --file "$ROOT/Brewfile"
elif ! command -v mise >/dev/null; then
    command -v curl >/dev/null || { echo "curl is required to install mise" >&2; exit 1; }
    curl -fsSL https://mise.run | sh
    PATH="$HOME/.local/bin:$PATH"
    export PATH
fi

command -v mise >/dev/null || { echo "mise installation failed" >&2; exit 1; }
command -v chezmoi >/dev/null || { echo "chezmoi is required" >&2; exit 1; }

chezmoi --source "$ROOT" apply
(
    cd "$ROOT"
    mise install
    mise exec -- prek install
)

echo "bootstrap complete"
