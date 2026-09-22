# mise — Exploring as a replacement for nvm + pyenv

> **Status:** Candidate for evaluation. Not yet in `installosx.sh`.
> Current setup uses nvm (Node) + pyenv + pyenv-virtualenv (Python) separately.
> mise would replace all of them with a single tool.

## What it is

`mise` (pronounced "MIZ", as in mise en place) is a Rust-based polyglot runtime
manager. One tool manages Node, Python, Go, Rust, Java, and 200+ others. It reads
`.nvmrc` and `.python-version` files so existing projects need no changes.

- GitHub: https://github.com/jdx/mise — ~18k stars, very actively maintained
- Docs: https://mise.jdx.dev
- Version (Sept 2026): v2026.9.12

## What you have now vs mise

| What | Current | With mise |
|---|---|---|
| Node versions | nvm, `~/.nvm/`, `.nvmrc` per project | mise, `.mise.toml` or `.nvmrc` |
| Python versions | pyenv, `~/.pyenv/`, `.python-version` | mise, `.mise.toml` or `.python-version` |
| Java (optional) | SDKMAN | mise |
| Go, Rust | brew (global only) | mise (per-project versions possible) |
| zshrc lines | ~20 lines (nvm + pyenv + SDKMAN blocks) | 1 line: `eval "$(mise activate zsh)"` |
| Shell startup | slower (nvm is noticeably slow) | faster (Rust binary) |

## Install

```sh
# via brew (recommended — fits your existing workflow)
brew install mise

# add to ~/.zshrc (replaces the nvm + pyenv blocks):
eval "$(mise activate zsh)"
```

## Daily workflow

```sh
# install a runtime globally (your default)
mise use --global node@lts
mise use --global python@3.13

# check what's active
mise ls --current

# for a specific project — cd into it, then:
mise use node@22          # writes .mise.toml in that dir
mise use python@3.11      # same

# install everything declared in .mise.toml
mise install

# temporary one-off (doesn't change config)
mise exec node@18 -- node script.js

# update all tools
mise upgrade
```

## Per-project config (.mise.toml)

Replaces `.nvmrc` + `.python-version` in one file:

```toml
[tools]
node = "22"
python = "3.12"

[env]
NODE_ENV = "development"
```

mise auto-switches when you `cd` into the directory — same as your current
nvm `.nvmrc` hook, but for all runtimes at once.

## Compatibility with your existing setup

- **`.nvmrc` files** — mise reads them natively, no migration needed
- **`.python-version` files** — mise reads them natively
- **pyenv virtualenvs** — not migrated automatically; recreate with `uv venv`
  or `python -m venv` inside the project instead

## Security notes

Three CVEs disclosed and fixed in early 2026, all in edge cases:
- Malicious `.mise.toml` in an untrusted foreign repo executing commands on `cd`
- HTTP backend path traversal on symlink creation
- Tera template injection via `.tool-versions`

All require you to `cd` into a repo you don't own with a crafted config.
Mitigated by `mise trust` — mise now prompts before executing untrusted configs.
For personal machine use with your own repos: low real-world risk.

If concerned: `mise settings set paranoid true` requires explicit trust for every
non-global config before it executes anything.

## What it does NOT replace

- `uv` — still the right tool for Python package management and virtualenvs
- `brew` — still needed for GUI apps, CLI tools, containers etc.
- `colima`, `docker`, `awscli` and everything else in `installosx.sh`

## Using only the runtime manager part

mise is designed to be used in parts. You can use it purely as a runtime switcher
and ignore everything else — the env management and task runner are opt-in features
that only activate if you use them. Nothing turns on by default.

A minimal `.mise.toml` that only manages runtimes:

```toml
[tools]
node = "22"
python = "3.12"
```

No `[env]` section = mise never touches environment variables.
No `[tasks]` section = mise task runner doesn't exist for this project.
Your existing `package.json` scripts, turbo, pnpm, Makefile targets — untouched.

## Coexisting with direnv

You already use direnv for per-directory env vars. mise and direnv overlap on that
layer but don't conflict. The recommended setup if you use both:

```zsh
# ~/.zshrc — mise handles tools/PATH only, direnv handles env vars as today
eval "$(mise activate zsh --no-env)"
eval "$(direnv hook zsh)"
```

`--no-env` tells mise: activate tool shims and PATH management, but leave
environment variables to direnv. Your existing `.envrc` files are completely
untouched. This is the documented coexistence pattern.

Alternatively: just never add `[env]` sections to `.mise.toml`. If the section
isn't there, mise doesn't set env vars. No flag needed, no conflict possible.

## Coexisting with turbo / pnpm task runners

`mise run` only runs when you explicitly call it. Having a `[tasks]` section in
`.mise.toml` doesn't interfere with `pnpm run`, `turbo`, or any other task runner.
They operate completely independently.

In practice: if you already have turbo/pnpm for task running in your projects,
there's no reason to add `[tasks]` to `.mise.toml`. Just leave that section out.


## If you want to try it

1. `brew install mise`
2. Replace the nvm + pyenv blocks in `~/.zshrc` with `eval "$(mise activate zsh)"`
3. Run `mise use --global node@lts python@3.13`
4. Test in one project: `cd myproject && mise install`
5. Run `mise doctor` if anything looks off

Reversible: nvm and pyenv stay installed until you explicitly remove them.
You can run both in parallel while evaluating.
