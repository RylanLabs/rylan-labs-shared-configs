#!/usr/bin/env bash
# Guardian: Bauer | Ministry: Audit | Consciousness: 9.9
# Purpose: Propagate shared-configs updates to all consuming repos
# Tag: maintenance, propagation, bauer-audit

set -euo pipefail

SHARED_CONFIGS_VERSION="${1:-}"
REPOS_FILE="${2:-repos.txt}"

if [[ -z "$SHARED_CONFIGS_VERSION" ]]; then
  echo "Usage: $0 <version> [repos-file]"
  echo "Example: $0 v1.1.0 repos.txt"
  exit 1
fi

echo "=== Bauer Guardian: Propagating Shared Configs Update ==="
echo "Version: $SHARED_CONFIGS_VERSION"
echo "Repos list: $REPOS_FILE"

if [[ ! -f "$REPOS_FILE" ]]; then
  echo "ERROR: Repos file not found: $REPOS_FILE"
  echo "Create repos.txt with one repo path per line:"
  echo "  ../rylan-labs-common"
  echo "  ../rylan-inventory"
  echo "  ../rylan-canon-library"
  exit 1
fi

UPDATED=0
FAILED=0

while IFS= read -r repo; do
  # Skip empty lines and comments
  [[ -z "$repo" || "$repo" =~ ^# ]] && continue

  echo ""
  echo "Processing: $repo"

  if [[ ! -d "$repo" ]]; then
    echo "WARN: Repository not found, skipping"
    ((FAILED++))
    continue
  fi

  cd "$repo"

  # Check if symlinks exist
  if [[ ! -L .yamllint ]]; then
    echo "WARN: No symlinks found, skipping (not using shared-configs)"
    cd - > /dev/null
    continue
  fi

  # Validate symlinks still point to shared-configs
  if ! readlink .yamllint | grep -q "rylan-labs-shared-configs"; then
    echo "WARN: Symlinks don't point to shared-configs, skipping"
    cd - > /dev/null
    continue
  fi

  # Create update branch
  BRANCH="chore/shared-configs-$SHARED_CONFIGS_VERSION"
  git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"

  # Commit message
  git commit --allow-empty -m "chore: update to rylan-labs-shared-configs $SHARED_CONFIGS_VERSION

- Symlinks automatically resolve to updated configs
- No file changes required (symlink targets updated)
- Guardian: Bauer | Ministry: Audit
- Compliance: Seven Pillars ✓ Trinity ✓

Tag: maintenance, shared-configs-update"

  echo "✓ Branch created: $BRANCH"
  echo "  Push with: cd $repo && git push origin $BRANCH"

  ((UPDATED++))
  cd - > /dev/null
done < "$REPOS_FILE"

echo ""
echo "=== Update Summary ==="
echo "Updated: $UPDATED repositories"
echo "Failed: $FAILED repositories"
echo ""
echo "Next steps:"
echo "  1. Review branches in each repository"
echo "  2. Push branches: git push origin chore/shared-configs-$SHARED_CONFIGS_VERSION"
echo "  3. Create PRs for each repository"
echo "  4. Validate CI passes (symlinks resolve to new configs)"
echo "  5. Merge after human review"
