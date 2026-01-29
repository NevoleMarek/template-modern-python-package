# {{cookiecutter.project_name}}

## Requirements

- [uv](https://docs.astral.sh/uv/)

## Setup

1. Install dependencies:
    ```bash
    uv sync
    ```

## Development

### Formatting and Linting

This project uses [ruff](https://docs.astral.sh/ruff/) for both code formatting and linting.

**Format code:**
```bash
uv run ruff format .
```

**Check linting issues:**
```bash
uv run ruff check .
```

**Auto-fix linting issues:**
```bash
uv run ruff check --fix .
```

### Testing

This project uses [pytest](https://docs.pytest.org/) for testing.

**Run all tests:**
```bash
uv run pytest
```

{%- if cookiecutter.use_ty %}
### Type Checking

This project uses [ty](https://github.com/astral-sh/ty) for type checking.

**Run type checker:**
```bash
uv run ty check
```
{%- endif %}

