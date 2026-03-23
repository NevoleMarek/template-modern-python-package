# Cookiecutter: Python + uv + ruff + pytest + ty (Python 3.14)

This repository is a **Cookiecutter template** for a modern Python project:

- **Python**: 3.14 (selected by you)
- **Dependency manager / runner**: `uv`
- **Lint + format**: `ruff` (rules selected by you)
- **Tests**: `pytest` (dev dependency group)
- **Type checking**: `ty` (dev dependency group) (selected by you)
- **Release automation**: `python-semantic-release` + GitHub Actions + PyPI trusted publishing

## Prerequisites

- [uv](https://docs.astral.sh/uv/)

## Usage

Generate a new project from this template:

```bash
uvx cookiecutter https://github.com/NevoleMarek/template-modern-python-package.git --checkout main -o /path/to/your/project
```

Generated projects include **Cursor agent scaffolding** (`AGENTS.md`, `.cursor/hooks/` for Ruff on Python edits, and a **verify** skill under `.cursor/skills/`) plus optional GitHub Actions for code quality checks, PR-title validation via `.github/versionrc`, release publishing to PyPI, and optional `CODEOWNERS` / `CONTRIBUTING.md`. See the generated `README.md` for bootstrap and release setup steps.
