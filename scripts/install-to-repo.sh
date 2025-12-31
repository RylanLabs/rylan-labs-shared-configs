#!/usr/bin/env bash
# Script: install-to-repo.sh
# Purpose: Install and validate symlinks from shared-configs to a consuming repository
# Agent: Carter
# Author: rylanlab canonical
# Date: 2025-12-31

set -euo pipefail
IFS=$'\n\t'

# Constants
readonly SHARED_CONFIGS_PATH="${1:-../rylanlabs-shared-configs}"
readonly TARGET_REPO="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
AUDIT_LOG="$TARGET_REPO/.audit/install-to-repo-$(date -Iseconds).json"
readonly AUDIT_LOG

# Helper functions
log_audit() {
  local status="$1"
  local message="$2"
  local link="${3:-}"

  # Structured JSON entry
  {
    echo "{"
    echo "  \"timestamp\": \"$(date -Iseconds)\","
    echo "  \"status\": \"$status\","
    echo "  \"message\": \"$message\","
    if [[ -n "$link" ]]; then
      echo "  \"link\": \"$link\","
    fi
    echo "  \"shared_path\": \"$SHARED_CONFIGS_PATH\","
    echo "  \"target_repo\": \"$TARGET_REPO\""
    echo "}"
  } >> "$AUDIT_LOG"
}

error_exit() {
  local message="$1"
  local code="${2:-1}"

  log_audit "error" "$message"
  echo "❌ ERROR: $message" >&2
  echo "   Audit log: $AUDIT_LOG" >&2
  exit "$code"
}

install_symlink() {
  local link="$1"
  local target="$2"

  local full_target="$SHARED_CONFIGS_PATH/$target"

  if [[ ! -e "$full_target" ]]; then
    error_exit "Target file not found: $full_target" 3
  fi

  if [[ -e "$TARGET_REPO/$link" && ! -L "$TARGET_REPO/$link" ]]; then
    log_audit "warn" "Existing non-symlink file blocks installation" "$link"
    echo "⚠️ WARN: Existing non-symlink $link blocks installation" >&2
    echo "   Fix: Manually remove or backup $TARGET_REPO/$link" >&2
    return 1
  fi

  if [[ -L "$TARGET_REPO/$link" ]]; then
    local current_target
    current_target=$(readlink "$TARGET_REPO/$link")
    if [[ "$current_target" == "$full_target" ]]; then
      log_audit "success" "Symlink already exists and correct (idempotent)" "$link"
      echo "✓ $link already installed correctly (idempotent)"
      return 0
    else
      log_audit "warn" "Existing symlink points to incorrect target: $current_target" "$link"
      echo "⚠️ WARN: Existing $link points to $current_target" >&2
      echo "   Replacing with $full_target" >&2
      rm "$TARGET_REPO/$link"
    fi
  fi

  ln -s "$full_target" "$TARGET_REPO/$link"
  log_audit "success" "Symlink installed" "$link"
  echo "✓ Installed $link → $target"
  return 0
}

# Main execution
main() {
  if [[ ! -d "$SHARED_CONFIGS_PATH" ]]; then
    error_exit "Shared configs path not found: $SHARED_CONFIGS_PATH" 3
  fi

  if [[ ! -d "$TARGET_REPO" ]]; then
    error_exit "Target repository not found: $TARGET_REPO" 3
  fi

  log_audit "start" "Installing symlinks to repository"

  echo "========================================"
  echo "Carter Guardian: Installing Symlinks"
  echo "Shared configs path: $SHARED_CONFIGS_PATH"
  echo "Target repository: $TARGET_REPO"
  echo "Audit log: $AUDIT_LOG"
  echo "========================================"

  local errors=0

  # Required symlinks
  declare -A required_symlinks=(
    [".yamllint"]="linting/.yamllint"
    ["pyproject.toml"]="linting/pyproject.toml"
    [".pre-commit-config.yaml"]="pre-commit/.pre-commit-config.yaml"
    [".shellcheckrc"]="linting/.shellcheckrc"
  )

  for link in "${!required_symlinks[@]}"; do
    if ! install_symlink "$link" "${required_symlinks[$link]}"; then
      ((errors++))
    fi
  done

  if [[ $errors -gt 0 ]]; then
    log_audit "failed" "Installation failed with $errors errors"
    echo "========================================"
    echo "❌ Installation Failed: $errors errors"
    echo "   Review $AUDIT_LOG for details"
    echo "========================================"
    exit 1
  fi

  log_audit "success" "All symlinks installed successfully"
  echo "========================================"
  echo "✓ Installation Passed: All symlinks installed"
  echo "   Audit log: $AUDIT_LOG"
  echo "========================================"

  echo ""
  echo "Next Steps:"
  echo "1. Commit changes: git add . && git commit -m \"chore: install shared-configs symlinks\""
  echo "2. Validate: ./scripts/validate-symlinks.sh"
  echo "3. Run pre-commit: pre-commit run --all-files"
  echo "4. Merge after Trinity review"
}

# Cleanup trap
cleanup() {
  # Remove temporary files if created
  true
}
trap cleanup EXIT

# Execute
main "$@"
