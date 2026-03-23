import shutil
from pathlib import Path


def remove(path: Path) -> None:
    if path.is_file() or path.is_symlink():
        path.unlink()
    elif path.is_dir():
        shutil.rmtree(path)


def as_bool(raw_value: str) -> bool:
    return raw_value.strip().lower() in {"1", "true", "yes", "y", "on"}


include_docs = as_bool("{{cookiecutter.include_docs}}")
include_codeowners = as_bool("{{cookiecutter.include_codeowners}}")
include_contributing_md = as_bool("{{cookiecutter.include_contributing_md}}")
include_code_quality_checks = as_bool("{{cookiecutter.include_code_quality_checks}}")
include_pr_title_checks = as_bool("{{cookiecutter.include_pr_title_checks}}")
include_release_workflow = as_bool("{{cookiecutter.include_release_workflow}}")
project_root = Path.cwd()

if not include_code_quality_checks:
    remove(project_root / ".github" / "workflows" / "code-quality.yml")

if not include_pr_title_checks:
    remove(project_root / ".github" / "workflows" / "pr-title.yml")
    remove(project_root / ".github" / "versionrc")

if not include_release_workflow:
    remove(project_root / ".github" / "workflows" / "release.yml")
    remove(project_root / ".github" / "semantic-release-templates")

if not include_docs:
    docs_dir = project_root / "docs"
    mkdocs_config = project_root / "mkdocs.yml"
    docs_workflow = project_root / ".github" / "workflows" / "docs.yml"
    workflows_dir = project_root / ".github" / "workflows"
    github_dir = project_root / ".github"

    remove(docs_dir)
    remove(mkdocs_config)
    remove(docs_workflow)

    if workflows_dir.is_dir() and not any(workflows_dir.iterdir()):
        remove(workflows_dir)
    if github_dir.is_dir() and not any(github_dir.iterdir()):
        remove(github_dir)

if not include_codeowners:
    codeowners_file = project_root / ".github" / "CODEOWNERS"
    github_dir = project_root / ".github"

    remove(codeowners_file)

    if github_dir.is_dir() and not any(github_dir.iterdir()):
        remove(github_dir)

if not include_contributing_md:
    remove(project_root / "CONTRIBUTING.md")

workflows_dir = project_root / ".github" / "workflows"
github_dir = project_root / ".github"

if workflows_dir.is_dir() and not any(workflows_dir.iterdir()):
    remove(workflows_dir)
if github_dir.is_dir() and not any(github_dir.iterdir()):
    remove(github_dir)
