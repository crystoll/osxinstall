# uv — Already installed, underused

> **Status:** Already in `installosx.sh` and active on this machine (v0.11.15).
> Currently used for: `uv tool install aider-chat`, `pip` replacement.
> Opportunity: also replace pyenv for Python version management.

## What it is

`uv` is a Rust-based Python toolchain by Astral (the Ruff people). It is the
fastest Python package manager available and also manages Python versions —
making pyenv largely redundant for most workflows.

- GitHub: https://github.com/astral-sh/uv — ~60k stars, extremely active
- Docs: https://docs.astral.sh/uv
- Version (Sept 2026): v0.11.15 (your current version)

## What you have now vs uv for Python versions

| What | Current (pyenv) | With uv |
|---|---|---|
| Install Python | `pyenv install 3.12.7` | `uv python install 3.12` |
| Set global default | `pyenv global 3.12.7` | `uv python install --default 3.12` |
| Pin per project | `.python-version` file | `.python-version` file (same format) |
| List installed | `pyenv versions` | `uv python list` |
| Create virtualenv | `pyenv virtualenv 3.12.7 myenv` | `uv venv --python 3.12` |
| zshrc lines needed | ~6 lines (pyenv init + virtualenv init) | 0 — uv needs no shell hook |
| Shell startup cost | medium (pyenv shims) | none |

## What uv already does that you may not be using

```sh
# install a specific Python version
uv python install 3.13

# list all available and installed versions
uv python list

# pin Python version for current project (writes .python-version)
uv python pin 3.12

# create a virtualenv using a managed Python
uv venv --python 3.12 .venv

# run a script with a specific Python without installing anything
uv run --python 3.11 script.py

# install a CLI tool in isolation (you already use this for aider)
uv tool install aider-chat
uv tool install poetry

# upgrade all tools
uv tool upgrade --all
```

## The pyenv overlap

pyenv is still useful if you need:
- Named virtualenvs (`pyenv virtualenv 3.12.7 projectname`) — you have several
  of these: `apitest`, `awstools`, `excelizer`, `list`, `python-tools`, `soktools`
- The `pyenv activate myenv` workflow

uv's approach is different: virtualenvs live in the project directory (`.venv`)
rather than a central `~/.pyenv/versions/` store. More modern, less global state.

## The activation problem — and how to solve it

A common complaint with local virtualenvs: you forget to `source .venv/bin/activate`
and accidentally install packages into global Python instead.

pyenv avoids this entirely — `.python-version` in the project directory auto-activates
the named virtualenv when you `cd` in. No manual step.

uv has two answers:

**Option A — uv commands are activation-aware (partial fix)**

`uv run`, `uv pip install`, and `uv sync` automatically find and use `.venv` in
the current directory without you activating it. So `uv pip install requests`
installs into `.venv`, not global Python, even without `source activate`.

The gap: bare `pip install` or `python` still hit global Python. If your muscle
memory is `pip install`, this doesn't fully protect you.

**Option B — direnv + uv (full fix, matches pyenv ergonomics)**

You already have `direnv` installed and in your oh-my-zsh plugins. Add a `.envrc`
to any project and direnv auto-activates `.venv` on `cd`, deactivates on `cd` out.
Same behaviour as your nvm `.nvmrc` hook — you never think about it.

One-time setup in `~/.config/direnv/direnvrc`:

```sh
layout_uv() {
  if [[ -d .venv ]]; then
    VIRTUAL_ENV="$(pwd)/.venv"
  else
    uv venv --python ${PYTHON_VERSION:-3.12}
    VIRTUAL_ENV="$(pwd)/.venv"
  fi
  export VIRTUAL_ENV
  PATH_add "$VIRTUAL_ENV/bin"
}
```

Then per project:

```sh
echo "layout uv" > .envrc
direnv allow
```

From that point, entering the directory activates the env automatically. Leaving
deactivates it. Works with bare `pip` and `python` too since the env is on PATH.

**Honest comparison:**

If auto-activation without per-project config files matters to you, pyenv +
`.python-version` already solves it and you're already using it. That's a real
advantage of the pyenv model — less per-project ceremony.

The direnv + uv combo matches pyenv ergonomics but requires a `.envrc` in each
project (one-time, committable). Whether that tradeoff is worth it depends on
how much the speed and ecosystem direction of uv matters to you.

## Migration path (if you want to try it)

You don't have to migrate all at once. Incremental:

**Step 1 — new projects:** Use `uv venv` + direnv instead of `pyenv virtualenv`
for any new project. Keep pyenv for existing named virtualenvs.

**Step 2 — Python versions:** Stop using `pyenv install`. Use `uv python install`
instead. They coexist fine.

**Step 3 (optional) — zshrc cleanup:** Once no project needs pyenv shims,
remove the pyenv block from `~/.zshrc`. Saves ~100ms of shell startup time.

**Step 4 (optional) — named virtualenv migration:** For each pyenv virtualenv,
recreate it as a `.venv` in the project directory:
```sh
cd myproject
echo "layout uv" > .envrc
direnv allow
uv pip install -r requirements.txt   # or: uv sync
```

## poetry + uv

You currently use both. The overlap:
- `poetry` manages dependencies + virtualenvs for projects with `pyproject.toml`
- `uv` can replace poetry's dependency management with `uv add`, `uv sync`, `uv lock`

uv's poetry compatibility is not complete for every workflow, so keep poetry for
existing projects. For new projects, `uv` is the simpler default.

## What changes in installosx.sh if you go this route

Current:
```sh
brew_install pyenv
brew_install pyenv-virtualenv
pyenv install 3.12.7
pyenv global 3.12.7
```

Replaced by:
```sh
brew_install uv   # already there
uv python install 3.13   # or whatever current version
```

And in `zshrc.template`, the pyenv block (~6 lines) drops to nothing —
uv needs no shell activation hook.

## Security

uv has 6 advisories, all disclosed and fixed. All are triggered by installing
a malicious package — not by normal use.

| Severity | Issue | Date |
|---|---|---|
| Moderate | Arbitrary file write via entry point names | May 2026 |
| Low | Arbitrary file deletion via RECORD entries | Apr 2026 |
| Moderate | ZIP payload obfuscation via parsing differentials | Oct 2025 |
| Low | Tar extraction differential with PAX headers | Oct 2025 |
| Low | Path traversal in tar extraction | Sep 2025 |
| Moderate | ZIP payload obfuscation | Aug 2025 |

The pattern: all require you to install a malicious package from PyPI. This is
the same risk vector as pip, npm, or any other package manager — if the package
is malicious, bad things can happen. Not a uv-specific attack surface.

No arbitrary code execution from normal use. No trust-bypass class of vulnerability.
The record is clean for a tool of this size (90k stars, extremely active).

**Compared to mise:** uv's CVE profile is significantly better. mise has a
recurring High/Critical class of vulnerability around config trust bypass that
can be triggered just by `cd`-ing into a directory. uv has no equivalent.

## Bottom line

uv is already installed. Using it for Python version management costs you nothing
new to learn — the commands are obvious (`uv python install`, `uv python list`).
The pyenv block in your zshrc is the only friction point, and it's optional to
remove. Lowest-effort improvement in the whole benchmark with the cleanest
security record of any tool evaluated here.
