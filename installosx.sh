#!/bin/zsh
# Mac developer setup script — idempotent, sectioned
# Run sections independently or all at once.
# Assumes Apple Silicon (arm64). Company baseline (browsers, Office, OneDrive) not included.
# See README.md for manual steps. See PRIVATE.md (gitignored) for secrets/tokens.

set -e

# ── helpers ──────────────────────────────────────────────────────────────────

has() { command -v "$1" &>/dev/null; }

brew_install()  { brew list "$1" &>/dev/null || brew install "$1"; }
brew_cask()     { brew list --cask "$1" &>/dev/null || brew install --cask "$1"; }
append_once()   { grep -qF "$1" "$2" 2>/dev/null || echo "$1" >> "$2"; }

# ── 1. xcode command line tools ───────────────────────────────────────────────

if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Xcode CLT install triggered — wait for it to complete, then re-run this script."
  exit 0
fi

# ── 2. homebrew ───────────────────────────────────────────────────────────────

if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for the rest of this script
eval "$(/opt/homebrew/bin/brew shellenv)"

# Persist brew shellenv to .zprofile (idempotent)
ZPROFILE="$HOME/.zprofile"
append_once 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$ZPROFILE"

# ── 3. terminal & shell ───────────────────────────────────────────────────────

brew_cask iterm2

# oh-my-zsh (non-interactive install)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ── 4. core cli tools ─────────────────────────────────────────────────────────

brew_install direnv      # per-directory env vars
brew_install fzf         # fuzzy finder — run `$(brew --prefix)/opt/fzf/install` after for shell bindings
brew_install ripgrep     # fast grep (binary: rg)
brew_install jq          # JSON processor
brew_install zellij      # terminal multiplexer
brew_install coreutils   # GNU core utilities
brew_install gnupg       # GPG

# ── 5. version managers & runtimes ────────────────────────────────────────────

# --- node (nvm) ---
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
# Load nvm for this script session
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*

# package managers
has pnpm || npm install -g pnpm
has bun  || curl -fsSL https://bun.sh/install | bash

# --- python (pyenv) ---
brew_install pyenv
brew_install pyenv-virtualenv
# install latest stable 3.x — update version as needed
PYTHON_VERSION="3.12.7"
pyenv versions | grep -q "$PYTHON_VERSION" || pyenv install "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

# uv — fast Python package/project manager
brew_install uv

# --- go (brew) ---
brew_install go

# --- rust (brew) ---
brew_install rust

# ── 6. containers ─────────────────────────────────────────────────────────────

brew_install colima
brew_install docker
brew_install docker-compose
brew_install docker-buildx
brew_install docker-credential-helper

# Start colima if not already running
colima status &>/dev/null || colima start

# ── 7. cloud & infra tooling ──────────────────────────────────────────────────

brew_install awscli
brew_cask session-manager-plugin
aws configure set cli_pager "" 2>/dev/null || true

brew_install tenv          # terraform/opentofu version manager (replaces tfswitch)
brew_install terraform-ls  # Terraform LSP

brew tap common-fate/granted 2>/dev/null || true
brew_install granted       # AWS SSO profile switcher

# ── 8. dev tools ──────────────────────────────────────────────────────────────

brew_install glab          # GitLab CLI
brew_install gh            # GitHub CLI
brew_install pgcli         # Postgres CLI with autocomplete
brew_install kcat          # Kafka CLI
brew_cask dbeaver-community

# ── 9. productivity & gui apps ────────────────────────────────────────────────

brew_cask dropbox
brew_cask visual-studio-code
brew_cask sublime-text

# AI / dev tooling
brew_cask claude-code
brew_cask copilot-cli
brew_cask kiro-cli    # Kiro CLI — installs kiro-cli binary + Kiro CLI.app, auto-updates

# local LLM
brew_cask ollama

# communication & productivity
brew_cask obsidian
brew_cask figma
brew_cask spotify
brew_cask chatgpt

# ── 10. vscode extensions ─────────────────────────────────────────────────────

# Core extensions — install if code is available (may need restart after cask install above)
if has code; then
  EXTENSIONS=(
    dbaeumer.vscode-eslint
    eamodio.gitlens
    esbenp.prettier-vscode
    gitlab.gitlab-workflow
    humao.rest-client
    redhat.vscode-yaml
    ms-python.python
    ms-python.vscode-pylance
    ms-python.debugpy
    ms-toolsai.jupyter
    ms-vscode-remote.remote-containers
    ms-azuretools.vscode-docker
    oxc.oxc-vscode
    ollama.ollama
    mquandalle.graphql
    mechatroner.rainbow-csv
  )
  for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force &>/dev/null && echo "  ✓ $ext" || echo "  ✗ $ext (failed)"
  done
fi

# ── 11. python tooling ────────────────────────────────────────────────────────

# poetry — Python dependency/project manager
has poetry || curl -sSL https://install.python-poetry.org | python3 -

# aider — AI pair programmer, installed via uv tool (isolated, no global pip pollution)
uv tool install aider-chat 2>/dev/null || uv tool upgrade aider-chat

# ── 12. rust tools ────────────────────────────────────────────────────────────

# mdr — Markdown renderer for the terminal
has mdr || cargo install mdr

# ── 13. finder & system tweaks ────────────────────────────────────────────────

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Dock: auto-hide, reasonable size
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48

# Expand save/print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable press-and-hold (enables key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Restart affected apps to pick up changes
killall Finder 2>/dev/null || true
killall Dock   2>/dev/null || true

# ── 14. git config ────────────────────────────────────────────────────────────

git config --global core.pager    cat
git config --global core.editor   "code --wait"
git config --global init.defaultBranch main

# Dual identity: work email for work repos, personal email for everything else.
# Uses git's includeIf to select identity based on repo path.
# Fill in your real emails — these are intentionally left blank here.
#
# Default (personal) identity:
# git config --global user.name  "Arto Santala"
# git config --global user.email "your.personal@gmail.com"
#
# Work identity auto-applied for repos under ~/code/work/ (or wherever you keep work repos):
# git config --global includeIf."gitdir:~/code/sok/".path "~/.gitconfig-work"
# git config --global includeIf."gitdir:~/code/work/".path "~/.gitconfig-work"
#
# Then create ~/.gitconfig-work with:
#   [user]
#     email = arto.santala@solita.fi
#     name  = Arto Santala
#
# Any repo outside those paths uses the global identity (personal).

# ── optional installs (uncomment as needed) ───────────────────────────────────

# Java via SDKMAN
# curl -s "https://get.sdkman.io" | bash
# source "$HOME/.sdkman/bin/sdkman-init.sh"
# sdk install java 21.0.4-tem

# Android development
# brew install --cask android-commandlinetools
# brew install --cask android-studio

# OrbStack — alternative to Colima (more polished UI, commercial license for professional use)
# brew install --cask orbstack

# Elgato Control Center — only if you use Elgato hardware
# brew_cask elgato-control-center

# ── manual installs ───────────────────────────────────────────────────────────
# These can't be automated. Do them after running this script.
#
# KiroCrew — download from https://github.com/kirodotdev/KiroCrew/releases
#   (no brew cask, place in /Applications)
#
# Goose (Block AI agent) — download from https://github.com/block/goose/releases
#   (no brew cask, place binary in ~/.local/bin/goose)
#
# Voicebox — download from voicebox app site, place in /Applications
#   (no brew cask)
#
# Say No to Notch — download from https://saynotonotch.com
#   (no brew cask, hides the MacBook notch with a black bar)

echo ""
echo "✓ Done. Next steps:"
echo "  1. Copy zshrc.template to ~/.zshrc and fill in your private tokens (see PRIVATE.md)"
echo "  2. Set git identity: git config --global user.name / user.email"
echo "  3. Run: source ~/.zshrc"
