# {{cookiecutter.project_name}}

> **Bootstrap:** The sections below help you finish setup after generating this repo. **Remove or replace the "Bootstrap setup" and "Agent & Claude setup" sections** once the project is yours—then use `docs/` (if included) for long-form documentation.

## Requirements

- [uv](https://docs.astral.sh/uv/) (see `pyproject.toml` for minimum uv version)

## Bootstrap setup

1. **Install dependencies**
   ```bash
   uv sync
   ```
{%- if cookiecutter.include_docs %}
2. **Docs tooling** (optional until you edit docs)
   ```bash
   uv sync --group docs
   ```
{%- endif %}
3. **Package layout** — library code lives under `src/{{cookiecutter.package_name}}/`. The template includes `__init__.py`; add modules alongside it.
4. **Project metadata** — edit `pyproject.toml`: `description`, classifiers, URLs, license, and dependency lists as needed.
{%- if cookiecutter.include_release_workflow %}
5. **Versioning** — this template keeps the checked-in version at `0.0.0`; published versions are computed by semantic-release from conventional commits.
{%- endif %}
6. **Tests** — replace the smoke test in `tests/` with real tests as you add behavior.
{%- if cookiecutter.include_code_quality_checks or cookiecutter.include_pr_title_checks or cookiecutter.include_release_workflow or cookiecutter.include_docs %}
7. **CI** — workflows live in `.github/workflows/`. Ensure the default branch matches your repo (template assumes `main`).
{%- endif %}
{%- if cookiecutter.include_pr_title_checks %}
8. **PR titles** — `.github/workflows/pr-title.yml` validates PR titles against `.github/versionrc`. Update that file if your team wants different allowed types or scopes.
{%- endif %}
{%- if cookiecutter.include_release_workflow %}
9. **Release setup** — this template publishes to PyPI via GitHub Actions trusted publishing.

   To enable it:
   1. Create the project on PyPI.
   2. In PyPI, add a trusted publisher for this GitHub repository and the workflow `.github/workflows/release.yml`.
   3. Keep using conventional commits so semantic-release can calculate the next version.

   After setup, trigger `.github/workflows/release.yml` manually from GitHub Actions to build, publish, and create a GitHub release.
{%- endif %}
{%- if cookiecutter.include_codeowners %}
10. **Code owners** — fill in `.github/CODEOWNERS` with the GitHub usernames or teams that should own the repo.
{%- endif %}
{%- if cookiecutter.include_contributing_md %}
11. **Contributing guide** — tailor `CONTRIBUTING.md` to your team’s review, testing, and release expectations.
{%- endif %}

## Agent & Claude setup (optional)

This repo includes **Cursor-oriented** agent helpers:

| Item | Purpose |
|------|---------|
| `AGENTS.md` | Short map for coding agents (layout, verification pointers). |
| `.cursor/hooks.json` + `.cursor/hooks/ruff_fix_python.sh` | After a Python file edit (Agent or Tab), runs `ruff format .` and `ruff check . --fix` on the **entire repo**. |
| `.cursor/skills/verify-python-code/` | Skill with the full verification command sequence for this template. |
{%- if cookiecutter.include_pr_title_checks %}
| `.github/versionrc` | Source of truth for allowed conventional PR title types and scope pattern. |
{%- endif %}

**Make the hook script executable** (once per clone):

```bash
chmod +x .cursor/hooks/ruff_fix_python.sh
```

### Claude Code (symlinks only)

To reuse the same content in **Claude Code** without duplicating files:

```bash
# From the repository root — use the same instructions on Windows via an elevated shell or your preferred link tool.

ln -sf AGENTS.md CLAUDE.md

mkdir -p .claude
ln -snf ../.cursor/skills .claude/skills
```

Alternatively, symlink a single skill folder if you prefer not to link the whole directory.

Remove this subsection when you no longer need copy-paste setup instructions.

---

## Development

### Formatting and linting

[Ruff](https://docs.astral.sh/ruff/) handles format and lint. Configuration is in `pyproject.toml`.

```bash
uv run ruff format .
uv run ruff check .
uv run ruff check --fix .
```

### Testing

```bash
uv run pytest
```

{%- if cookiecutter.use_ty %}

### Type checking

[ty](https://github.com/astral-sh/ty):

```bash
uv run ty check
```

{%- endif %}
{%- if cookiecutter.include_docs %}

### Documentation

MkDocs with the Material theme:

```bash
uv run mkdocs serve
uv run mkdocs build --strict
```

Documentation is validated and deployed by `.github/workflows/docs.yml`.
{%- endif %}

{%- if cookiecutter.include_release_workflow %}
### Releases

Semantic-release configuration lives in `pyproject.toml`, while `.github/workflows/release.yml` handles build, publish, and GitHub release creation.

Useful local checks:

```bash
uv run semantic-release version --print
uv run semantic-release version --print-last-released
```

{%- if cookiecutter.include_pr_title_checks %}
PR titles are checked against `.github/versionrc`, so keep that file aligned with the commit/PR conventions you want to enforce.
{%- endif %}
{%- endif %}
{%- if not cookiecutter.include_release_workflow and cookiecutter.include_pr_title_checks %}
### PR titles

PR titles are checked against `.github/versionrc`, so keep that file aligned with the commit/PR conventions you want to enforce.
{%- endif %}

## Full verification

Use the **verify-python-code** skill in Cursor (see `.cursor/skills/verify-python-code/SKILL.md`) or run the same commands manually in the order given there.
