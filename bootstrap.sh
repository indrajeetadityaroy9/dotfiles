#!/bin/sh

set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

command -v brew >/dev/null || { echo "install Homebrew first: https://brew.sh" >&2; exit 1; }
brew bundle install --no-upgrade --file "$ROOT/Brewfile"

command -v mise >/dev/null || { echo "mise installation failed" >&2; exit 1; }

cd "$ROOT"
mise install --locked

# init, not apply: the config template prompts for git identity on first run,
# and plain `apply` would leave those template variables undefined.
mise exec -- chezmoi --source "$ROOT" init --apply

mise exec -- prek install

echo "bootstrap complete"
