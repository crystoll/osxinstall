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

## Security

mise has had 9 security advisories in 2026 alone, including one Critical.
This is the most important thing to know before adopting it.

| Severity | Issue | Date |
|---|---|---|
| **Critical** | Arbitrary code execution via Tera templates in `.tool-versions` (trust bypass) | Jun 2026 |
| **High** | Implicit project trust enables code execution via `history.describe_command` | Sep 2026 |
| **High** | `shell_args` settings bypass trust denylist → arbitrary code execution | Jul 2026 |
| **High** | Arbitrary code execution via task-include files in untrusted repos | Jun 2026 |
| **High** | Local settings bypass config trust checks | Apr 2026 |
| Moderate | GitLab/Forgejo tokens exposed on third-party hosts | Aug 2026 |
| Moderate | HTTP backend path traversal on symlink creation | Jun 2026 |
| Moderate | `credential_command` executes untrusted config | Jun 2026 |
| Moderate | Incorrect file ownership when installed as root | Jul 2026 |

**The pattern matters more than the count.** These aren't about installing malicious
packages — they're about `cd`-ing into a directory with a crafted config file
triggering arbitrary code execution. The trust bypass has appeared 4 times at
High or Critical across 2026 — the same architectural problem recurring after
each fix. The maintainer is responsive and fixes are fast, but the class of
vulnerability keeps coming back.

**The Sep 2026 High is 8 days old at time of writing.** It's broader than the
others: implicit trust via `history.describe_command` means past interaction
with a directory could trigger execution without a `.mise.toml` present at all.

**Practical risk for your use case:**
- If you only `cd` into repos you own: low. You won't have crafted configs.
- If you `cd` into client codebases, shared repos, or clone things to inspect:
  higher. Exactly the scenario a consultant faces regularly.

**Mitigation if you do adopt it:**
```sh
mise settings set paranoid true
```
Paranoid mode requires explicit `mise trust` for every non-global config before
anything executes. Adds one manual step per new repo, eliminates the auto-execute
surface.

**Recommendation:** hold off until the trust architecture stabilises. Revisit
in 3-6 months. The Sep 2026 Critical being this fresh is reason to wait.
Compare: uv has zero code-execution CVEs from normal use.

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


## If you want to try it (revisit in ~Q1 2027)

Given the Sep 2026 High CVE being 8 days old, the recommendation is to wait
for the trust architecture to stabilise before adopting mise on a work machine.
Revisit around Q1 2027 and check whether the High/Critical class of vulnerability
has recurred.

When you do try it:

1. `brew install mise`
2. Test without touching zshrc — `mise exec` works standalone:
   ```sh
   mise exec node@22 -- node --version
   mise exec python@3.13 -- python --version
   ```
3. Enable paranoid mode before activating in your shell:
   ```sh
   mise settings set paranoid true
   ```
4. Replace the nvm + pyenv blocks in `~/.zshrc`:
   ```sh
   eval "$(mise activate zsh --no-env)"   # --no-env if keeping direnv
   ```
5. Run `mise doctor` if anything looks off

Reversible: nvm and pyenv stay installed until you explicitly remove them.
You can run both in parallel while evaluating.
