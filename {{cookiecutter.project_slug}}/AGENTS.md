# Agent guide ({{cookiecutter.project_name}})

This acts as a progressive disclosure of this repository. Short map only—read linked paths when you need detail.

## Layout


| Area                                            | Path                                 |
| ----------------------------------------------- | ------------------------------------ |
| Library code                                    | `src/{{cookiecutter.package_name}}/` |
| Tests                                           | `tests/`                             |
{%- if cookiecutter.include_docs %}
| Docs (MkDocs)                                   | `docs/`, `mkdocs.yml`                |
{%- endif %}
{%- if cookiecutter.include_code_quality_checks or cookiecutter.include_pr_title_checks or cookiecutter.include_release_workflow or cookiecutter.include_docs %}
| CI / automation                                 | `.github/workflows/`                 |
{%- endif %}

## Dependencies and commands

- Use **uv** only.  
{%- if cookiecutter.include_docs %}
- Docs tooling: `uv sync --group docs` before building or serving docs.
{%- endif %}
- Tool versions and Ruff rules live in `pyproject.toml`.
{%- if cookiecutter.include_release_workflow %}
- Semantic-release config also lives in `pyproject.toml`.
{%- endif %}

## Verification

- Run the full check sequence via the **verify** skill: `.cursor/skills/verify-python-code/SKILL.md`
- Do not treat changes as done until that sequence passes for this repo’s options.



{%- if cookiecutter.use_ty %}

## Type checking

- **ty** when enabled: `uv run ty check` (see `pyproject.toml` `[tool.ty.src]`).
{%- endif %}
{%- if cookiecutter.include_docs %}

## Documentation

- Local: `uv run mkdocs serve` / `uv run mkdocs build --strict`.
- Publishing is wired in `.github/workflows/docs.yml` when docs were included at generation time.
{%- endif %}
{%- if cookiecutter.include_code_quality_checks or cookiecutter.include_pr_title_checks %}

## CI

{%- if cookiecutter.include_code_quality_checks %}
- Pull requests run `.github/workflows/code-quality.yml` (install, Ruff, pytest{%- if cookiecutter.use_ty %}, ty{%- endif %}).
{%- endif %}
{%- if cookiecutter.include_pr_title_checks %}
- PR titles are validated by `.github/workflows/pr-title.yml` using rules in `.github/versionrc`.
- Before proposing or renaming a PR, inspect `.github/versionrc` to see the allowed conventional types and scope pattern.
{%- endif %}
{%- endif %}

{%- if cookiecutter.include_release_workflow %}
## Release

- Releases are orchestrated by `.github/workflows/release.yml`.
- Semantic-release settings live in `pyproject.toml` under `[tool.semantic_release]`.
- Release note formatting lives in `.github/semantic-release-templates/.release_notes.md.j2`.
- The template keeps the source tree at version `0.0.0`; release builds compute the next version from conventional commits and publish tagged artifacts.
{%- endif %}

## Conventions

- Prefer patterns already in `src/{{cookiecutter.package_name}}/` and `tests/`.
- Keep public API and packaging aligned with `pyproject.toml` (`[tool.hatch.build.targets.wheel]`).
{%- if cookiecutter.include_contributing_md %}
- Contributor workflow and PR expectations are documented in `CONTRIBUTING.md`.
{%- endif %}
{%- if cookiecutter.include_codeowners %}
- Code ownership lives in `.github/CODEOWNERS`; fill it in after generation if you enable that option.
{%- endif %}

