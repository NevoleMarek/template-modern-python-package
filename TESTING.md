# Testing the Cookiecutter Template

## Quick test

From the template repository root:

```bash
cd /path/to/uv-template

# Default interactive values
cookiecutter . -o /tmp/test-output

# Non-interactive with defaults from cookiecutter.json
cookiecutter . --no-input -o /tmp/test-output
```

## Automated script

```bash
./test_template.sh
```

The script uses `cookiecutter` when it is on your `PATH`, otherwise **`uvx cookiecutter`** (install [uv](https://docs.astral.sh/uv/) first).

Set `CLEANUP=false` in the script (or comment the trap) to keep generated projects under `/tmp/cookiecutter-test-*`.

After generating a project, run `chmod +x .cursor/hooks/ruff_fix_python.sh` once if the executable bit is not preserved (e.g. some archive or copy flows).

## Manual scenarios

### 1. Full options (ty, docs, all workflow toggles, all Ruff groups)

```bash
cookiecutter . --no-input \
  -o /tmp/test-output \
  project_name="Test Project" \
  python_version="3.13" \
  linter_rules_core="y" \
  linter_rules_imports="y" \
  linter_rules_typing="y" \
  linter_rules_modernization="y" \
  linter_rules_testing="y" \
  linter_rules_cleanup="y" \
  linter_rules_practices="y" \
  use_ty="y" \
  include_codeowners="y" \
  include_contributing_md="y" \
  include_docs="y" \
  include_code_quality_checks="y" \
  include_pr_title_checks="y" \
  include_release_workflow="y"
```

Verify:

- `src/<package_name>/__init__.py` exists (`package_name` is `project_slug` with `-` replaced by `_`).
- `src/<package_name>/__init__.py` exposes `__version__` via `importlib.metadata.version(...)`.
- `AGENTS.md`, `.cursor/hooks.json`, `.cursor/hooks/ruff_fix_python.sh`, and `.cursor/skills/verify-python-code/SKILL.md` exist.
- `.github/workflows/code-quality.yml`, `.github/workflows/pr-title.yml`, `.github/workflows/release.yml`, `.github/versionrc`, and `.github/semantic-release-templates/.release_notes.md.j2` exist.
- `.github/CODEOWNERS` exists when `include_codeowners=y`; `CONTRIBUTING.md` exists when enabled.
- `pyproject.toml` includes `ty` in `dev` when `use_ty=y`, and `[tool.ty.src]` when enabled.
- `pyproject.toml` includes `python-semantic-release` in `dev` and `[tool.semantic_release]` when `include_release_workflow=y`.
- `docs/` and `mkdocs.yml` exist when `include_docs=y`.
- `.github/workflows/code-quality.yml` exists when `include_code_quality_checks=y`.
- `.github/workflows/pr-title.yml` and `.github/versionrc` exist when `include_pr_title_checks=y`.
- `.github/workflows/release.yml` and `.github/semantic-release-templates/` exist when `include_release_workflow=y`.

### 2. Minimal (no ty, no docs, all workflow toggles off)

```bash
cookiecutter . --no-input \
  -o /tmp/test-output \
  project_name="Minimal" \
  python_version="3.12" \
  linter_rules_core="y" \
  linter_rules_imports="n" \
  linter_rules_typing="n" \
  linter_rules_modernization="n" \
  linter_rules_testing="n" \
  linter_rules_cleanup="n" \
  linter_rules_practices="n" \
  use_ty="n" \
  include_codeowners="n" \
  include_contributing_md="n" \
  include_docs="n" \
  include_code_quality_checks="n" \
  include_pr_title_checks="n" \
  include_release_workflow="n"
```

Verify:

- No `ty` dev dependency and no `[tool.ty]` section.
- No `python-semantic-release` dev dependency and no `[tool.semantic_release]` section.
- `docs/` and `mkdocs.yml` are removed by the post-generation hook.
- `.github/` is removed when docs, workflow toggles, and CODEOWNERS are disabled.
- `CONTRIBUTING.md` is removed when disabled.
- Agent files still exist; `AGENTS.md` and the verify skill should not tell you to run `ty` or MkDocs when those options were off.

### 3. Python version

### 3. Workflow split (code quality + PR title, no release)

```bash
cookiecutter . --no-input \
  -o /tmp/test-output \
  project_name="Workflow Split" \
  python_version="3.12" \
  linter_rules_core="y" \
  linter_rules_imports="y" \
  linter_rules_typing="n" \
  linter_rules_modernization="n" \
  linter_rules_testing="n" \
  linter_rules_cleanup="n" \
  linter_rules_practices="n" \
  use_ty="n" \
  include_codeowners="y" \
  include_contributing_md="y" \
  include_docs="n" \
  include_code_quality_checks="y" \
  include_pr_title_checks="y" \
  include_release_workflow="n"
```

Verify:

- `.github/workflows/code-quality.yml`, `.github/workflows/pr-title.yml`, and `.github/versionrc` exist.
- `.github/workflows/release.yml` and `.github/semantic-release-templates/` are removed.
- `pyproject.toml` does not include `python-semantic-release` or `[tool.semantic_release]`.
- `.github/CODEOWNERS` still exists when `include_codeowners=y`, even if release is disabled.

### 4. Python version

Use `python_version` as **major.minor** only (e.g. `3.13`), matching `requires-python` and Ruff `target-version` in `pyproject.toml`.

## Inspect generated `pyproject.toml`

```bash
cd /tmp/test-output/<project_slug>
grep -A 30 'lint.select' pyproject.toml
```
