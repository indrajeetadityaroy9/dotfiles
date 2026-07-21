#!/bin/sh
set -eu
# Linux only — macOS loads these via sheldon. sheldon's libgit2 stalls on some
# networks' HTTPS reads, so we clone with the git CLI and source directly (see dot_zshrc.tmpl).
[ "$(uname)" = "Linux" ] || exit 0

DIR="$HOME/.local/share/zsh/plugins"
mkdir -p "$DIR"
for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions; do
    name="${repo#*/}"
    [ -d "$DIR/$name" ] || git clone -q --depth 1 "https://github.com/$repo.git" "$DIR/$name"
done
echo "zsh plugins ready in $DIR"
