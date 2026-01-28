# Cookiecutter: Python + uv + ruff + pytest + ty (Python 3.14)

This repository is a **Cookiecutter template** for a modern Python project:

- **Python**: 3.14 (selected by you)
- **Dependency manager / runner**: `uv`
- **Lint + format**: `ruff` (rules selected by you)
- **Tests**: `pytest` (dev dependency group)
- **Type checking**: `ty` (dev dependency group) (selected by you)

## Prerequisites

- [uv](https://docs.astral.sh/uv/)

## Usage

Generate a new project from this template:

```bash
uvx cookiecutter https://github.com/NevoleMarek/template-modern-python-package.git --checkout main -o /path/to/your/project
```
