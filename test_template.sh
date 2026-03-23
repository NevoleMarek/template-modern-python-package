#!/bin/bash
# Test script for cookiecutter template

set -e

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_OUTPUT_DIR="/tmp/cookiecutter-test-$$"
CLEANUP=true

# Prefer uvx so CI/local runs match README (uv is the documented prerequisite).
if command -v cookiecutter >/dev/null 2>&1; then
  COOKIECUTTER=(cookiecutter)
elif command -v uvx >/dev/null 2>&1; then
  COOKIECUTTER=(uvx cookiecutter)
else
  echo "FAIL: Install cookiecutter or uv (for uvx cookiecutter)."
  exit 127
fi

cleanup() {
  if [ "$CLEANUP" = true ]; then
    echo "Cleaning up test directory: $TEST_OUTPUT_DIR"
    rm -rf "$TEST_OUTPUT_DIR"
  fi
}
trap cleanup EXIT

echo "Testing Cookiecutter Template"
echo "=============================="
echo ""

# Test 1: Full options (all linter groups, ty, docs, workflows)
echo "Test 1: Full template (all options enabled)"
echo "--------------------------------------------"
"${COOKIECUTTER[@]}" "$TEMPLATE_DIR" --no-input \
  -o "$TEST_OUTPUT_DIR" \
  project_name="Test All Rules" \
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
  include_release_workflow="y" >/dev/null 2>&1

PROJECT_DIR="$TEST_OUTPUT_DIR/test-all-rules"
if [ ! -f "$PROJECT_DIR/pyproject.toml" ]; then
  echo "FAIL: Project generation failed (Test 1)"
  exit 1
fi
echo "OK: Project generated"

if ! grep -q 'target-version = "py313"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: target-version should be py313"
  exit 1
fi
echo "OK: target-version py313"

if ! grep -q '"E"' "$PROJECT_DIR/pyproject.toml" || \
   ! grep -q '"PLE"' "$PROJECT_DIR/pyproject.toml" || \
   ! grep -q '"PLC"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Core Ruff rules missing"
  exit 1
fi
echo "OK: Core Ruff rules present"

if ! grep -q '"ANN"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Typing rules (ANN) missing"
  exit 1
fi
echo "OK: Typing rules present"

if ! grep -q '"ty"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: ty dev dependency missing"
  exit 1
fi
echo "OK: ty in pyproject"

if [ ! -f "$PROJECT_DIR/src/test_all_rules/__init__.py" ]; then
  echo "FAIL: Package skeleton missing (src/test_all_rules/__init__.py)"
  exit 1
fi
echo "OK: Package skeleton present"

if ! grep -q "__version__ = version('test-all-rules')" "$PROJECT_DIR/src/test_all_rules/__init__.py"; then
  echo "FAIL: Package __init__ should expose importlib-based __version__"
  exit 1
fi
echo "OK: Package version export present"

for f in AGENTS.md .cursor/hooks.json .cursor/hooks/ruff_fix_python.sh \
  .cursor/skills/verify-python-code/SKILL.md; do
  if [ ! -f "$PROJECT_DIR/$f" ]; then
    echo "FAIL: Missing agent file: $f"
    exit 1
  fi
done
echo "OK: Agent scaffolding present"

if [ ! -d "$PROJECT_DIR/docs" ] || [ ! -f "$PROJECT_DIR/mkdocs.yml" ]; then
  echo "FAIL: Docs should exist when include_docs=y"
  exit 1
fi
echo "OK: Docs present"

for f in .github/workflows/code-quality.yml \
  .github/workflows/pr-title.yml \
  .github/workflows/release.yml \
  .github/versionrc \
  .github/semantic-release-templates/.release_notes.md.j2; do
  if [ ! -f "$PROJECT_DIR/$f" ]; then
    echo "FAIL: Missing workflow/release file: $f"
    exit 1
  fi
done
echo "OK: GitHub workflow and release files present"

if [ ! -f "$PROJECT_DIR/.github/CODEOWNERS" ]; then
  echo "FAIL: CODEOWNERS should exist when include_codeowners=y"
  exit 1
fi
echo "OK: CODEOWNERS present"

if [ ! -f "$PROJECT_DIR/CONTRIBUTING.md" ]; then
  echo "FAIL: CONTRIBUTING.md should exist when include_contributing_md=y"
  exit 1
fi
echo "OK: CONTRIBUTING.md present"

if ! grep -q 'python-semantic-release' "$PROJECT_DIR/pyproject.toml" || \
   ! grep -q '\[tool\.semantic_release\]' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Semantic release should be configured when release workflow is enabled"
  exit 1
fi
echo "OK: Semantic release configured"

echo ""

# Test 2: Minimal (core lint only, no ty, no docs, no workflows)
echo "Test 2: Minimal (no ty, docs, or workflows)"
echo "-------------------------------------------"
rm -rf "$TEST_OUTPUT_DIR"
"${COOKIECUTTER[@]}" "$TEMPLATE_DIR" --no-input \
  -o "$TEST_OUTPUT_DIR" \
  project_name="Minimal Project" \
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
  include_release_workflow="n" >/dev/null 2>&1

PROJECT_DIR="$TEST_OUTPUT_DIR/minimal-project"
if [ ! -f "$PROJECT_DIR/pyproject.toml" ]; then
  echo "FAIL: Project generation failed (Test 2)"
  exit 1
fi
echo "OK: Project generated"

if ! grep -q 'target-version = "py312"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: target-version should be py312"
  exit 1
fi
echo "OK: target-version py312"

if grep -q '"ANN"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Typing rules should be excluded"
  exit 1
fi
echo "OK: Typing rules excluded"

if grep -q '"RET"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Practices rules (RET) should be excluded"
  exit 1
fi
echo "OK: Practices rules excluded"

if grep -qE '^\s*"ty"' "$PROJECT_DIR/pyproject.toml" || grep -q '\[tool\.ty' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: ty should not appear when use_ty=n"
  exit 1
fi
echo "OK: ty absent from pyproject"

if [ -d "$PROJECT_DIR/docs" ] || [ -f "$PROJECT_DIR/mkdocs.yml" ]; then
  echo "FAIL: Docs should be removed when include_docs=n"
  exit 1
fi
echo "OK: Docs removed"

if [ -d "$PROJECT_DIR/.github" ]; then
  echo "FAIL: .github should be removed when all workflow toggles are disabled"
  exit 1
fi
echo "OK: .github removed"

if [ ! -f "$PROJECT_DIR/AGENTS.md" ]; then
  echo "FAIL: AGENTS.md should always exist"
  exit 1
fi
if grep -qi 'uv run ty check' "$PROJECT_DIR/AGENTS.md" "$PROJECT_DIR/.cursor/skills/verify-python-code/SKILL.md" 2>/dev/null; then
  echo "FAIL: ty commands should not appear in agent docs when use_ty=n"
  exit 1
fi
echo "OK: Agent docs omit ty when disabled"

if [ -f "$PROJECT_DIR/CONTRIBUTING.md" ]; then
  echo "FAIL: CONTRIBUTING.md should be removed when include_contributing_md=n"
  exit 1
fi
echo "OK: CONTRIBUTING.md removed"

echo ""

# Test 3: Workflow split (code quality + PR title, no release)
echo "Test 3: Workflow split (no release)"
echo "-----------------------------------"
rm -rf "$TEST_OUTPUT_DIR"
"${COOKIECUTTER[@]}" "$TEMPLATE_DIR" --no-input \
  -o "$TEST_OUTPUT_DIR" \
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
  include_release_workflow="n" >/dev/null 2>&1

PROJECT_DIR="$TEST_OUTPUT_DIR/workflow-split"
if [ ! -f "$PROJECT_DIR/.github/workflows/code-quality.yml" ] || \
   [ ! -f "$PROJECT_DIR/.github/workflows/pr-title.yml" ] || \
   [ ! -f "$PROJECT_DIR/.github/versionrc" ]; then
  echo "FAIL: Code quality and PR title files should exist when enabled"
  exit 1
fi
if [ -f "$PROJECT_DIR/.github/workflows/release.yml" ] || \
   [ -d "$PROJECT_DIR/.github/semantic-release-templates" ]; then
  echo "FAIL: Release files should be absent when include_release_workflow=n"
  exit 1
fi
if grep -q 'python-semantic-release' "$PROJECT_DIR/pyproject.toml" || \
   grep -q '\[tool\.semantic_release\]' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: Semantic release should be absent when include_release_workflow=n"
  exit 1
fi
if [ ! -f "$PROJECT_DIR/.github/CODEOWNERS" ]; then
  echo "FAIL: CODEOWNERS should exist when include_codeowners=y"
  exit 1
fi
echo "OK: Workflow toggles are independent"

echo ""

# Test 4: Python 3.11 with defaults
echo "Test 4: Python 3.11"
echo "-------------------"
rm -rf "$TEST_OUTPUT_DIR"
"${COOKIECUTTER[@]}" "$TEMPLATE_DIR" --no-input \
  -o "$TEST_OUTPUT_DIR" \
  project_name="Python 311" \
  python_version="3.11" \
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
  include_release_workflow="y" >/dev/null 2>&1

PROJECT_DIR="$TEST_OUTPUT_DIR/python-311"
if [ ! -f "$PROJECT_DIR/pyproject.toml" ]; then
  echo "FAIL: Project generation failed (Test 3)"
  exit 1
fi
if ! grep -q 'target-version = "py311"' "$PROJECT_DIR/pyproject.toml"; then
  echo "FAIL: target-version should be py311"
  exit 1
fi
echo "OK: target-version py311"

echo ""
echo "All tests passed."
echo "Inspect output: $TEST_OUTPUT_DIR (set CLEANUP=false to keep)"
