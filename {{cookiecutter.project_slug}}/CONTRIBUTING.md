# Contributing

## Local setup

1. Install [uv](https://docs.astral.sh/uv/).
2. Sync dependencies:

   ```bash
   uv sync
   ```

{%- if cookiecutter.include_docs %}
3. If you are working on docs, sync the docs group too:

   ```bash
   uv sync --group docs
   ```

{%- endif %}
## Before opening a PR

Run the same checks the template expects locally:

```bash
uv run ruff format .
uv run ruff check . --fix
uv run pytest
```

{%- if cookiecutter.use_ty %}
Also run:

```bash
uv run ty check
```

{%- endif %}
{%- if cookiecutter.include_docs %}
If your change touches docs or doc configuration, also run:

```bash
uv run mkdocs build --strict
```

{%- endif %}
## PR titles

{%- if cookiecutter.include_pr_title_checks %}
PR titles must follow the conventional format enforced by `.github/versionrc`.

Examples:

- `feat: add project configuration loader`
- `fix(api): handle missing credentials`
- `docs: clarify release setup`

If you need different allowed types or scopes, update `.github/versionrc`.
{%- else %}
This template does not enforce PR titles by default. If your team wants that policy later, add a PR title workflow and a `.github/versionrc` file.
{%- endif %}

{%- if cookiecutter.include_release_workflow %}
## Release process

This template uses python-semantic-release to calculate the next version from conventional commits.

The checked-in source tree stays at `0.0.0`. The release workflow computes the next version, builds the package, publishes it, and creates a GitHub release.

GitHub Actions release entrypoint:

- `.github/workflows/release.yml`

PyPI setup:

1. Create the project on PyPI.
2. Configure a trusted publisher for this repository and `.github/workflows/release.yml`.
3. Trigger the release workflow manually when you want to publish.
{%- endif %}
