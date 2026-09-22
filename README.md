# osxinstall

Mac developer setup script. Idempotent — safe to re-run, installs only what's missing.

Assumes:
- Apple Silicon (arm64)
- Company baseline already installed: browsers, OneDrive/Office, managed apps
- You own everything in this repo — your developer and power-user layer on top

## Quick start

```sh
chmod +x installosx.sh
./installosx.sh
```

If Xcode CLT isn't installed, the script triggers it and exits — wait for it to finish, then re-run.

## What it installs

| Section | Contents |
|---|---|
| Terminal | iTerm2, oh-my-zsh |
| CLI tools | direnv, fzf, ripgrep, jq, zellij, coreutils, gnupg |
| Node | nvm → LTS, pnpm, bun |
| Python | pyenv, pyenv-virtualenv, Python 3.12, uv, poetry, aider |
| Go | via brew |
| Rust | via brew, mdr |
| Containers | Colima, Docker, docker-compose, docker-buildx |
| Cloud/infra | AWS CLI, session-manager-plugin, tenv, terraform-ls, granted |
| Dev tools | glab, gh, pgcli, kcat, DBeaver |
| GUI apps | Dropbox, VSCode, Sublime Text, Claude Code, Copilot CLI, Kiro CLI, Ollama, Obsidian, Figma, Spotify, ChatGPT |
| macOS tweaks | hidden files, Finder path/status bar, Dock autohide, key repeat, no auto-correct |

## Manual installs

These can't be automated (no brew cask):

| App | Download |
|---|---|
| KiroCrew | https://github.com/kirodotdev/KiroCrew/releases |
| Goose (Block AI agent) | https://github.com/block/goose/releases |
| Voicebox | voicebox app site |
| Say No to Notch | https://saynotonotch.com |

## Shell config

Copy `zshrc.template` to `~/.zshrc`:

```sh
cp zshrc.template ~/.zshrc
```

The template sources `~/.zshrc.private` at the end — put all tokens, credentials, and project-specific config there. See `PRIVATE.md` for the template (gitignored, never committed).

## Optional installs

Commented out in `installosx.sh`, uncomment as needed:

- **Java** via SDKMAN (21 LTS)
- **Android** dev tools
- **OrbStack** — alternative to Colima, more polished UI (commercial license for professional use)

## Manual steps

Some things can't be automated:

1. **SSH keys** — copy `~/.ssh/` from old machine or generate new and register with GitHub/GitLab
2. **Sign in to Dropbox** — Obsidian vault and screenshots live there
3. **AWS SSO** — configure `granted` profiles for your accounts
4. **VSCode settings sync** — sign in and sync extensions/settings
5. **Git identity** — uncomment and fill in the lines at the bottom of `installosx.sh`
6. **Private tokens** — fill `~/.zshrc.private` from the template in `PRIVATE.md`

Full checklist in `PRIVATE.md`.

## Keeping brew up to date

```sh
brewski
```

Alias defined in `zshrc.template` — runs `brew update && brew upgrade && brew cleanup && brew doctor`.

## Before wiping the old machine

Do these before handing back or wiping:

- Export iTerm2 profile: `Preferences → General → Preferences → Export All Profiles` → save to Dropbox
- Back up `~/.kiro/` to Dropbox: `cp -r ~/.kiro ~/Library/CloudStorage/Dropbox/kiro-backup`
- Back up SSH keys to secure storage (`~/.ssh/`)
- Back up `~/.aws/config` if you have custom granted profile config
- Snapshot all installed brew packages: `brew bundle dump --force > Brewfile.snapshot` — useful reference, not committed

## Potential future improvements

Not implemented yet, in priority order:

- **Brewfile** — replace hand-rolled `brew_install`/`brew_cask` helpers with `brew bundle`. Run `brew bundle dump > Brewfile` on current machine to capture exact state. `brew bundle check` for drift detection.
- **Colima config** — commit a `colima.yaml` to the repo so `colima start` picks up preferred CPU/memory/disk automatically
- **nvm version** — `v0.40.1` is hardcoded; could resolve latest at install time
- **Python version** — `3.12.7` will age; bump to latest 3.13.x before running on new machine
