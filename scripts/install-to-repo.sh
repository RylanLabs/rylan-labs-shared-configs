#!/usr/bin/env bash
# Guardian: Carter | Ministry: Identity | Consciousness: 9.9
# Purpose: Install shared-configs into a new repository
# Tag: bootstrap, installation, carter-identity

set -euo pipefail

REPO_ROOT="${1:-.}"
SHARED_CONFIGS_PATH="${2:-../rylan-labs-shared-configs}"

echo "=== Carter Guardian: Installing Shared Configs ==="
echo "Target repository: $REPO_ROOT"
echo "Shared configs source: $SHARED_CONFIGS_PATH"

# Validate shared-configs exists
if [[ ! -d "$SHARED_CONFIGS_PATH" ]]; then
  echo "ERROR: Shared configs not found at $SHARED_CONFIGS_PATH"
  echo "HINT: Clone rylan-labs-shared-configs first or provide correct path"
  exit 1
fi

# Create symlinks
cd "$REPO_ROOT"

echo ""
echo "Creating symlinks..."

ln -sf "$SHARED_CONFIGS_PATH/linting/.yamllint" .yamllint
echo "✓ .yamllint → $SHARED_CONFIGS_PATH/linting/.yamllint"

ln -sf "$SHARED_CONFIGS_PATH/linting/pyproject.toml" pyproject.toml
echo "✓ pyproject.toml → $SHARED_CONFIGS_PATH/linting/pyproject.toml"

ln -sf "$SHARED_CONFIGS_PATH/pre-commit/.pre-commit-config.yaml" .pre-commit-config.yaml
echo "✓ .pre-commit-config.yaml → $SHARED_CONFIGS_PATH/pre-commit/.pre-commit-config.yaml"

# Optional: .shellcheckrc and .editorconfig
if [[ -f .shellcheckrc ]]; then
  echo "WARN: .shellcheckrc already exists, skipping"
else
  ln -sf "$SHARED_CONFIGS_PATH/linting/.shellcheckrc" .shellcheckrc
  echo "✓ .shellcheckrc → $SHARED_CONFIGS_PATH/linting/.shellcheckrc"
fi

if [[ -f .editorconfig ]]; then
  echo "WARN: .editorconfig already exists, skipping"
else
  ln -sf "$SHARED_CONFIGS_PATH/linting/.editorconfig" .editorconfig
  echo "✓ .editorconfig → $SHARED_CONFIGS_PATH/linting/.editorconfig"
fi

echo ""
echo "=== Installation Complete ==="
echo "Next steps:"
echo "  1. git add .yamllint pyproject.toml .pre-commit-config.yaml"
echo "  2. pre-commit install"
echo "  3. pre-commit run --all-files"
echo "  4. git commit -m 'feat: integrate rylan-labs-shared-configs'"
