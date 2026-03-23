#!/usr/bin/env bash
# Cursor hook: after a Python file edit (Agent or Tab), run Ruff format + lint --fix on the whole repo.
# Trigger only when the edited path ends in .py; then format/check from project root (Cursor runs hooks there).
# Input JSON (stdin): includes "file_path" (absolute). See Cursor docs: Hooks -> afterFileEdit / afterTabFileEdit.
set -euo pipefail

input="$(cat || true)"
if [[ -z "${input//[$' \t\n']/}" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

file_path="$(printf '%s' "$input" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('file_path', '') or '', end='')
except Exception:
    pass
")"

if [[ -z "$file_path" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

if [[ "$file_path" != *.py ]]; then
  printf '%s\n' '{}'
  exit 0
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "ruff_fix_python.sh: uv not found. Install https://docs.astral.sh/uv/ and run uv sync." >&2
  exit 1
fi

uv run ruff format .
uv run ruff check . --fix

printf '%s\n' '{}'
exit 0
