# dotfiles

Apple Silicon macOS. chezmoi owns files, mise owns CLIs and runtimes (locked),
Homebrew (`Brewfile`) owns native libraries, services, fonts, apps, and the
remaining CLIs.

## New Mac

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/indrajeetadityaroy9/dotfiles/main/bootstrap.sh)"
```

Installs Homebrew and mise, clones this repo to `~/.local/share/chezmoi`,
creates `~/.ssh/id_ed25519` if missing, installs the locked toolset, applies the
dotfiles (which runs `brew bundle`), and installs the repo's pre-commit hook.

## Day to day

```sh
chezmoi update         # pull + apply; re-runs brew bundle / mise install when Brewfile / mise.lock change
mise use -g tool@x.y   # edits .config/mise/{config.toml,mise.lock} here (symlinked into ~/.config/mise)
mise run lock          # resync mise.lock after editing config.toml by hand
mise run update        # advance the python/node/rust/java channels
mise run check         # lint, render templates, scan history for secrets
```

Machine-local, never committed: `~/.config/git/config.local`,
`~/.config/git/allowed_signers.local`, `~/.config/zsh/zshrc.local`,
`~/.ssh/config.d/*.conf`.
