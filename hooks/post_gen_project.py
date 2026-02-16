import shutil
from pathlib import Path


def remove(path: Path) -> None:
    if path.is_file() or path.is_symlink():
        path.unlink()
    elif path.is_dir():
        shutil.rmtree(path)


def as_bool(raw_value: str) -> bool:
    return raw_value.strip().lower() in {"1", "true", "yes", "y", "on"}


include_github_workflows = as_bool("{{cookiecutter.include_github_workflows}}")
include_docs = as_bool("{{cookiecutter.include_docs}}")
project_root = Path.cwd()

if not include_github_workflows:
    workflows_dir = project_root / ".github" / "workflows"
    github_dir = project_root / ".github"

    remove(workflows_dir)

    if github_dir.is_dir() and not any(github_dir.iterdir()):
        remove(github_dir)

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
