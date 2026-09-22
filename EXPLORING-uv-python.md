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

## Migration path (if you want to try it)

You don't have to migrate all at once. Incremental:

**Step 1 — new projects:** Use `uv venv` instead of `pyenv virtualenv` for any
new project. Keep pyenv for existing named virtualenvs.

**Step 2 — Python versions:** Stop using `pyenv install`. Use `uv python install`
instead. They coexist fine.

**Step 3 (optional) — zshrc cleanup:** Once no project needs pyenv shims,
remove the pyenv block from `~/.zshrc`. Saves ~100ms of shell startup time.

**Step 4 (optional) — named virtualenv migration:** For each pyenv virtualenv,
recreate it as a `.venv` in the project directory:
```sh
cd myproject
uv venv --python 3.12
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

## Bottom line

uv is already installed. Using it for Python version management costs you nothing
new to learn — the commands are obvious (`uv python install`, `uv python list`).
The pyenv block in your zshrc is the only friction point, and it's optional to
remove. Lowest-effort improvement in the whole benchmark.
