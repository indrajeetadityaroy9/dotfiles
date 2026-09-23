#!/bin/sh
# Fresh Apple Silicon Mac (safe to re-run):
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/indrajeetadityaroy9/dotfiles/main/bootstrap.sh)"
set -eu

REPO=https://github.com/indrajeetadityaroy9/dotfiles.git
SRC="$HOME/.local/share/chezmoi"
KEY="$HOME/.ssh/id_ed25519"

[ "$(uname -sm)" = "Darwin arm64" ] || { echo "bootstrap: Apple Silicon macOS only" >&2; exit 1; }

# Homebrew's installer also provides the Xcode Command Line Tools (git).
[ -x /opt/homebrew/bin/brew ] ||
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
command -v mise >/dev/null || brew install mise

[ -d "$SRC/.git" ] || git clone "$REPO" "$SRC"

# Git commit signing and GitHub SSH both use this key.
new_key=
if [ ! -f "$KEY" ]; then
    ssh-keygen -t ed25519 -f "$KEY" -C "$(id -un)@$(hostname -s)"
    new_key=1
fi

cd "$SRC"
export MISE_LOCKED=1
mise install                          # locked toolset from .config/mise (includes chezmoi)
mise exec -- chezmoi init --apply     # dotfiles; runs brew bundle and mise install
grep -qs 'mise run pre-commit' .git/hooks/pre-commit ||
    mise generate git-pre-commit --write  # repo hook -> `mise run pre-commit`

echo "bootstrap complete; open a new terminal"
if [ -n "$new_key" ]; then
    echo "add $KEY.pub to GitHub as an authentication and a signing key:"
    echo "  gh auth login -s admin:public_key,admin:ssh_signing_key"
    echo "  gh ssh-key add $KEY.pub --type authentication && gh ssh-key add $KEY.pub --type signing"
fi
