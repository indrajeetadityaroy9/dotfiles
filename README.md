# dotfiles

macOS development environment managed by chezmoi, mise, and Homebrew.

## Architecture

- **chezmoi** owns files, templates, one-time migration, and the small amount of
  machine-dependent rendering.
- **mise** owns language runtimes, versioned developer CLIs, lockfiles, and the
  repository task graph.
- **Homebrew** owns native libraries, system services, macOS applications, and
  CLIs that lack a suitable locked mise artifact for Apple Silicon.
- **zsh** uses the standard startup split: `.zshenv` for XDG and process-wide
  environment, `.zprofile` for login PATH setup and mise shims, and `.zshrc` for
  interactive behavior.

The generated `dot_config/mise/private_locks/` files are native dependency
sidecars required by mise lockfile v2. They are intentionally committed for
checksum and dependency-graph reproducibility rather than hand-maintained.
Tools with trustworthy upstream binaries use native `aqua:` or `github:`
backends instead, avoiding unnecessary package-manager sidecars.

## Bootstrap

Install Homebrew, then run:

```sh
./bootstrap.sh
```

The script installs host packages and repository tools, applies chezmoi, then
installs the locked global mise toolset and the prek hook.

## Daily workflow

```sh
mise run check       # lint, secret scan, template rendering, static validation
mise run diff        # preview target-state changes
mise run apply       # apply this checkout
mise run update      # re-resolve fuzzy project and global mise locks
```

Use the real command names for enhanced tools (`eza`, `bat`, and `btop`). Only
non-shadowing convenience aliases remain (`ll`, `lt`, and `dui`), so native
`ls`, `cat`, and `top` retain their normal semantics.

## Design decisions

- Shell plugins are direct chezmoi externals pinned to immutable revisions with
  SHA-256 verification. There is no plugin-manager startup layer.
- mise PATH activation remains in interactive zsh because it supports project
  environment changes. Login shells also receive mise shims, matching mise's
  2026 shell guidance.
- direnv is not activated because current mise documentation explicitly treats
  mixed mise and direnv shell hooks as unsupported. Project variables, dotenv
  files, PATH entries, and Python environments should use mise `[env]` instead.
- Portable, versioned CLIs prefer mise and its lockfile. Homebrew remains the
  fallback when a mise backend has no reliable locked macOS artifact.
- Local overrides are limited to `.config/zsh/zshrc.local`,
  `.config/git/config.local`, and `.ssh/config.d/*.conf`; all are ignored by
  chezmoi and Git.
- The repository stays on mature chezmoi rather than migrating to mise's new
  2026.9 dotfile history feature. mise bootstrap is promising, but it is newer
  than the existing declarative chezmoi workflow and does not yet justify a
  high-risk rewrite.

## Research basis

- [mise shell activation and shims](https://mise.jdx.dev/dev-tools/shims.html)
- [mise lockfiles](https://mise.jdx.dev/dev-tools/mise-lock.html)
- [mise tasks](https://mise.jdx.dev/tasks/)
- [mise bootstrap](https://mise.jdx.dev/bootstrap.html)
- [chezmoi scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
- [chezmoi externals](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/)
- [2026 Hacker News chezmoi discussion](https://news.ycombinator.com/item?id=48588413)
