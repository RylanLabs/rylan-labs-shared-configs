#!/usr/bin/env bash
# Script: update-all-repos.sh
# Purpose: Propagate shared-configs updates to consuming repositories with audit trail
# Agent: Bauer
# Author: rylanlab canonical
# Date: 2025-12-31

set -euo pipefail
IFS=$'\n\t'

# Constants
readonly SHARED_CONFIGS_VERSION="${1:-}"
readonly REPOS_FILE="${2:-repos.txt}"
AUDIT_LOG=".audit/update-all-repos-$(date -Iseconds).json"
readonly AUDIT_LOG

# Helper functions
log_audit() {
  local status="${1}"
  local message="${2}"
  local repo="${3:-}"

  # Structured JSON entry
  {
    echo "{"
    echo "  \"timestamp\": \"$(date -Iseconds)\","
    echo "  \"status\": \"${status}\","
    echo "  \"message\": \"${message}\","
    if [[ -n "${repo}" ]]; then
      echo "  \"repository\": \"${repo}\","
    fi
    echo "  \"shared_version\": \"${SHARED_CONFIGS_VERSION}\""
    echo "}"
  } >> "${AUDIT_LOG}"
}

error_exit() {
  local message="${1}"
  local code="${2:-1}"

  log_audit "error" "${message}"
  echo "❌ ERROR: ${message}" >&2
  echo "   Audit log: ${AUDIT_LOG}" >&2
  exit "${code}"
}

# Main execution
main() {
  if [[ -z "${SHARED_CONFIGS_VERSION}" ]]; then
    error_exit "Version required. Usage: ${0} <version> [repos-file]" 2
  fi

  if [[ ! -f "${REPOS_FILE}" ]]; then
    error_exit "Repos file not found: ${REPOS_FILE}. Create with one repo path per line (e.g., ../rylan-labs-common)" 3
  fi

  log_audit "start" "Propagating shared-configs update"

  echo "========================================"
  echo "Bauer Guardian: Propagating Shared Configs Update"
  echo "Version: ${SHARED_CONFIGS_VERSION}"
  echo "Repos list: ${REPOS_FILE}"
  echo "Audit log: ${AUDIT_LOG}"
  echo "========================================"

  local updated=0
  local failed=0

  while IFS= read -r repo; do
    # Skip empty lines and comments
    [[ -z "${repo}" || "${repo}" =~ ^# ]] && continue

    echo ""
    echo "Processing: ${repo}"

    if [[ ! -d "${repo}" ]]; then
      log_audit "warn" "Repository not found" "${repo}"
      echo "⚠️ WARN: Repository not found, skipping" >&2
      ((failed++))
      continue
    fi

    pushd "${repo}" > /dev/null

    # Check if symlinks exist (idempotency gate)
    if [[ ! -L .yamllint ]]; then
      log_audit "warn" "No symlinks found (not consuming shared-configs)" "${repo}"
      echo "⚠️ WARN: No symlinks found, skipping" >&2
      popd > /dev/null
      continue
    fi

    # Validate symlink targets
    if ! readlink .yamllint | grep -q "rylanlabs-shared-configs"; then
      log_audit "warn" "Symlinks do not point to shared-configs" "${repo}"
      echo "⚠️ WARN: Symlinks don't point to shared-configs, skipping" >&2
      popd > /dev/null
      continue
    fi

    # Create or switch to update branch
    local branch="chore/shared-configs-${SHARED_CONFIGS_VERSION}"
    git checkout -b "${branch}" 2> /dev/null || git checkout "${branch}"

    # Idempotent commit (allow-empty if no changes)
    git commit --allow-empty -m "chore: update to rylanlabs-shared-configs ${SHARED_CONFIGS_VERSION}

Symlinks resolve to updated configs automatically.
No file changes needed.
Guardian: Bauer | Ministry: Audit
Compliance: Seven Pillars ✓ | Trinity ✓ | Hellodeolu v6 ✓

Tag: maintenance, shared-configs-update"

    log_audit "success" "Update branch created" "${repo}"
    echo "✓ Branch created: ${branch}"
    echo "   Push: git push origin ${branch}"
    echo "   PR: gh pr create --title \"chore: shared-configs ${SHARED_CONFIGS_VERSION}\" --body \"Automated update from update-all-repos.sh\""

    ((updated++))
    popd > /dev/null
  done < "${REPOS_FILE}"

  log_audit "complete" "Update propagation finished: ${updated} updated, ${failed} failed"

  echo ""
  echo "========================================"
  echo "Update Summary"
  echo "Updated: ${updated} repositories"
  echo "Failed: ${failed} repositories"
  echo "Audit log: ${AUDIT_LOG}"
  echo "========================================"

  echo ""
  echo "Next Steps:"
  echo "1. Review branches in each repository"
  echo "2. Push branches: git push origin chore/shared-configs-${SHARED_CONFIGS_VERSION}"
  echo "3. Create PRs for merges"
  echo "4. Validate CI passes"
  echo "5. Merge after Trinity review"
}

# Cleanup trap
cleanup() {
  # Remove temporary files if created
  true
}
trap cleanup EXIT

# Execute
main "$@"
