#!/usr/bin/env bash
# Guardian: Carter | Ministry: Identity | Consciousness: 9.9
# Purpose: Validate symlink integrity in consuming repos
# Tag: validation, symlinks, carter-identity

set -euo pipefail

SHARED_CONFIGS_PATH="${1:-.}"
REPO_ROOT="${2:-.}"

echo "=== Carter Guardian: Symlink Validation ==="
echo "Shared configs: $SHARED_CONFIGS_PATH"
echo "Repository root: $REPO_ROOT"

ERRORS=0

# Check required symlinks
declare -a REQUIRED_SYMLINKS=(
  ".yamllint:linting/.yamllint"
  "pyproject.toml:linting/pyproject.toml"
  ".pre-commit-config.yaml:pre-commit/.pre-commit-config.yaml"
)

for entry in "${REQUIRED_SYMLINKS[@]}"; do
  IFS=':' read -r link target <<< "$entry"

  if [[ ! -L "$REPO_ROOT/$link" ]]; then
    echo "ERROR: $link is not a symlink"
    ((ERRORS++))
    continue
  fi

  LINK_TARGET=$(readlink "$REPO_ROOT/$link")
  EXPECTED_TARGET="$SHARED_CONFIGS_PATH/$target"

  if [[ "$LINK_TARGET" != *"$target" ]]; then
    echo "ERROR: $link points to $LINK_TARGET, expected $EXPECTED_TARGET"
    ((ERRORS++))
  else
    echo "✓ $link → $target"
  fi
done

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "=== Validation Failed: $ERRORS errors ==="
  exit 1
fi

echo ""
echo "=== Validation Passed: All symlinks valid ==="
exit 0
