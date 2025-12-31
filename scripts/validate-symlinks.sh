#!/usr/bin/env bash
# Script: validate-symlinks.sh
# Purpose: Validate symlink integrity and compliance in consuming repositories
# Agent: Carter
# Author: rylanlab canonical
# Date: 2025-12-31

set -euo pipefail
IFS=$'\n\t'

# Failure recovery (Pillar 5)
trap 'echo "❌ INTERRUPTED" >&2; exit 130' INT TERM

# Constants
readonly SHARED_CONFIGS_PATH="${1:-../rylanlabs-shared-configs}"
readonly REPO_ROOT="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
readonly AUDIT_LOG="$REPO_ROOT/.audit/symlink-validation-$(date -Iseconds).json"

# Helper functions
log_audit() {
  local status="$1"
  local message="$2"
  
  # Structured JSON audit entry
  cat << EOF >> "$AUDIT_LOG"
{
  "timestamp": "$(date -Iseconds)",
  "status": "$status",
  "message": "$message",
  "shared_path": "$SHARED_CONFIGS_PATH",
  "repo_root": "$REPO_ROOT"
}
EOF
}

validate_symlink() {
  local link="$1"
  local target="$2"
  
  if [[ ! -L "$REPO_ROOT/$link" ]]; then
    log_audit "error" "$link is not a symlink"
    echo "❌ ERROR: $link is not a symlink" >&2
    echo "   Fix: ln -s $SHARED_CONFIGS_PATH/$target $REPO_ROOT/$link" >&2
    return 1
  fi
  
  local link_target
  link_target=$(readlink "$REPO_ROOT/$link")
  local expected_target="$SHARED_CONFIGS_PATH/$target"
  
  if [[ "$link_target" != "$expected_target" ]]; then
    log_audit "error" "$link points to incorrect target: $link_target (expected $expected_target)"
    echo "❌ ERROR: $link points to $link_target" >&2
    echo "   Expected: $expected_target" >&2
    echo "   Fix: rm $REPO_ROOT/$link && ln -s $expected_target $REPO_ROOT/$link" >&2
    return 1
  fi
  
  log_audit "success" "$link → $target validated"
  echo "✓ $link → $target"
  return 0
}

# Main execution
main() {
  local errors=0
  
  echo "========================================"
  echo "Carter Guardian: Symlink Validation"
  echo "Shared configs path: $SHARED_CONFIGS_PATH"
  echo "Repository root: $REPO_ROOT"
  echo "========================================"
  
  # Required symlinks (updated for 160-char line length configs)
  declare -A required_symlinks=(
    [".yamllint"]="linting/.yamllint"
    ["pyproject.toml"]="linting/pyproject.toml"
    [".pre-commit-config.yaml"]="pre-commit/.pre-commit-config.yaml"
    [".shellcheckrc"]="linting/.shellcheckrc"
  )
  
  for link in "${!required_symlinks[@]}"; do
    if ! validate_symlink "$link" "${required_symlinks[$link]}"; then
      ((errors++))
    fi
  done
  
  if [[ $errors -gt 0 ]]; then
    log_audit "failed" "Validation failed with $errors errors"
    echo "========================================"
    echo "❌ Validation Failed: $errors errors"
    echo "   Review $AUDIT_LOG for details"
    echo "========================================"
    exit 1
  fi
  
  log_audit "success" "All symlinks validated successfully"
  echo "========================================"
  echo "✓ Validation Passed: All symlinks valid"
  echo "   Audit log: $AUDIT_LOG"
  echo "========================================"
  exit 0
}

# Cleanup trap (reversibility)
cleanup() {
  # Optional: Remove temporary files if any
  true
}
trap cleanup EXIT

# Execute
main "$@"