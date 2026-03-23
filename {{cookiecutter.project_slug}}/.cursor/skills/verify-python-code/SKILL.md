name: verify-python-code
description: Run full project verification for this uv + Ruff + pytest template (and ty/MkDocs when enabled). Use when the user asks to verify, validate, run checks, run tests, or confirm the repo is healthy before finishing work.
---

# Verify Python project

Follow this order. Skip steps that do not apply to how this repo was generated.

## 1. Install dependencies

```bash
uv sync
```

{%- if cookiecutter.include_docs %}

If you changed documentation or MkDocs config:

```bash
uv sync --group docs
```

{%- endif %}

## 2. Format and lint (Ruff)

```bash
uv run ruff format .
uv run ruff check . --fix
```

Ruff configuration (including which rule groups are enabled) is in `pyproject.toml`.

## 3. Tests

```bash
uv run pytest
```

{%- if cookiecutter.use_ty %}

## 4. Type check (ty)

```bash
uv run ty check
```

{%- endif %}
{%- if cookiecutter.include_docs %}

## 5. Docs build (strict)

Only when docs are part of this project:

```bash
uv run mkdocs build --strict
```

{%- endif %}

## Done when

- Ruff format and check pass.
- Pytest passes.
{%- if cookiecutter.use_ty %}
- `ty check` passes.  
{%- endif %}  
{%- if cookiecutter.include_docs %}
- MkDocs strict build passes when doc changes are in scope.
{%- endif %}

For a quick map of layout and CI, see `AGENTS.md`.