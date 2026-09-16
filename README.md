# dotfiles

macOS + Linux (both arm64), managed with [chezmoi](https://chezmoi.io) on a
[mise](https://mise.jdx.dev)-locked toolchain.

```sh
sh <(curl -fsSL https://mise.run)
chezmoi init --apply indrajeetadityaroy9/dotfiles
~/.local/share/chezmoi/bootstrap.sh
```

## Secrets policy

This repo is public. No keys, credentials, hostnames or IPs are committed.
Everything machine-specific lives in gitignored local files that the tracked
configs already reference:

| File | For |
|---|---|
| `~/.ssh/config.d/*.conf` | Real hosts (tailnet, LAN). `chmod 600`. |
| `~/.config/git/config.local` | Alternate identity, per-host git options. |
| `~/.config/git/allowed_signers.local` | Other machines' signing public keys. |
| `~/.config/zsh/zshrc.local` | Host-specific shell bits. |
| `~/.config/mise/conf.d/local.toml` | Ad-hoc tools. |

Runtime secrets go in the OS keyring, never a file:

```sh
chezmoi secret keyring set --service=<name> --user="$USER"
secret <name>        # helper defined in .zshrc
```

After adding `~/.ssh/id_ed25519`, re-run `chezmoi apply` — `allowed_signers`
is generated from it, so commit-signature verification works with nothing
machine-identifying in the repo.

`.gitleaks.toml` extends the default rules with the metadata class credential
scanners miss: tailnet names, SSH `HostName` entries, RFC1918 IPs, absolute
`/Users/...` paths. It runs on staged changes via prek, over full history in
CI, and for every repo on the machine via `init.templateDir`.

The default rules found nothing in this history. These four found a published
tailnet hostname in `9a7c4af`, allowlisted by SHA so CI fails on *new* leaks.

## Regenerating mise.lock

`mise lock` only works on project-local configs, so the global lockfile is
built from a throwaway local copy:

```sh
cd "$(mktemp -d)"
cat ~/.local/share/chezmoi/dot_config/mise/config.toml > mise.toml
grep -hv '^\[tools\]\|^#' ~/.local/share/chezmoi/dot_config/mise/conf.d/darwin.toml >> mise.toml
cp ~/.local/share/chezmoi/dot_config/mise/private_mise.lock mise.lock
mise trust . && mise lock
cp mise.lock ~/.local/share/chezmoi/dot_config/mise/private_mise.lock
```
