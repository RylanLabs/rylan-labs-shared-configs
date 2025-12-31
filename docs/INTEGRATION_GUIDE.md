# Integration Guide

## Adding rylan-labs-shared-configs to Your Repository

This guide walks you through integrating shared-configs into a new or existing RylanLabs repository.

---

## Prerequisites

- Git installed and configured
- Access to the RylanLabs organization on GitHub
- Bash shell (Linux/macOS) or WSL (Windows)
- Python 3.11+ (for pre-commit hooks)

---

## Installation Methods

### Method 1: New Repository (Recommended)

Use this if you're creating a brand new repository.

```bash
# 1. Navigate to your repositories directory
cd ~/RylanLabs

# 2. Clone shared-configs
git clone https://github.com/RylanLabs/rylan-labs-shared-configs.git

# 3. Initialize your new repository
mkdir my-new-repo
cd my-new-repo
git init
git branch -M main

# 4. Run the installation script
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# 5. Initialize pre-commit
pip install pre-commit
pre-commit install
pre-commit run --all-files

# 6. Commit and push
git add -A
git commit -m "feat: initialize with rylan-labs-shared-configs v1.0.0"
git remote add origin https://github.com/RylanLabs/my-new-repo.git
git push -u origin main
```

### Method 2: Existing Repository (Gradual Migration)

Use this if migrating an existing repository with its own configs.

```bash
# 1. Backup current configurations
mkdir .backup-configs
cp .yamllint .backup-configs/ 2>/dev/null || true
cp pyproject.toml .backup-configs/ 2>/dev/null || true
cp .pre-commit-config.yaml .backup-configs/ 2>/dev/null || true
cp .editorconfig .backup-configs/ 2>/dev/null || true
cp .shellcheckrc .backup-configs/ 2>/dev/null || true

# 2. Remove old configurations
rm -f .yamllint pyproject.toml .pre-commit-config.yaml .editorconfig .shellcheckrc

# 3. Install shared-configs
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# 4. Review and merge changes
# Compare your backed-up configs with new ones
diff .backup-configs/.yamllint .yamllint || true

# 5. Validate the installation
../rylan-labs-shared-configs/scripts/validate-symlinks.sh ../rylan-labs-shared-configs .

# 6. Install and test pre-commit
pip install pre-commit
pre-commit install
pre-commit run --all-files

# 7. Address any pre-commit failures
# Fix violations in your code, then re-run:
# pre-commit run --all-files

# 8. Commit the migration
git add .yamllint pyproject.toml .pre-commit-config.yaml .editorconfig .shellcheckrc
git commit -m "refactor: migrate to rylan-labs-shared-configs v1.0.0

- Centralized linting and CI configurations
- Eliminated local config duplication
- Ensures consistency across RylanLabs repositories
- Guardian: Carter | Ministry: Foundation

Tag: refactor, shared-configs-migration"

git push origin main
```

---

## Troubleshooting

### Issue: Symlinks Not Working (Windows)

**Problem**: `install-to-repo.sh` creates symlinks, but Windows doesn't support them natively.

**Solution**: Use WSL2 or Git Bash:
```bash
# In WSL2 or Git Bash
/mnt/c/path/to/repo $ bash ../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs
```

### Issue: Pre-commit Hooks Fail After Installation

**Problem**: Pre-commit runs hooks that find existing violations.

**Solution**:
```bash
# Option A: Fix violations
pre-commit run --all-files

# Option B: Create .git/hooks/pre-commit bypass (temporary)
mv .git/hooks/pre-commit .git/hooks/pre-commit.bak
pre-commit run --all-files
mv .git/hooks/pre-commit.bak .git/hooks/pre-commit

# Option C: Skip pre-commit during commit
git commit --no-verify -m "WIP: addressing pre-commit violations"
```

### Issue: `validate-symlinks.sh` Reports Missing Files

**Problem**: Symlinks don't resolve to the correct targets.

**Solution**:
```bash
# Check current symlinks
ls -la .yamllint pyproject.toml .pre-commit-config.yaml

# Verify the shared-configs path
readlink -f .yamllint

# Reinstall if necessary
rm .yamllint .pre-commit-config.yaml pyproject.toml
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs
```

### Issue: Pre-commit Can't Find Hooks

**Problem**: `pre-commit run --all-files` fails with "hook not found" errors.

**Solution**:
```bash
# Ensure pre-commit and hooks are installed
pip install --upgrade pre-commit

# Reinstall hooks
pre-commit install --install-hooks

# Update hook definitions
pre-commit autoupdate

# Retry
pre-commit run --all-files
```

---

## Configuration Customization

### Extending Linting Rules

If your repository needs custom linting rules beyond shared-configs:

```bash
# Create a local .pylintrc or extend pyproject.toml
# BUT: Keep symlinks for shared baseline configs

# Example: Extend ruff configuration locally
cat > .ruff.local.toml << 'EOF'
# Local overrides (not symlinked)
[tool.ruff]
ignore = ["E501"]  # Ignore line-length violations
EOF

# Update your CI to use both:
# ruff check . --config .ruff.local.toml
```

### Disabling Specific Pre-commit Hooks

If a hook causes issues in your workflow:

```bash
# Create a .pre-commit-config-local.yaml
cp .pre-commit-config.yaml .pre-commit-config-local.yaml

# Remove problematic hooks from .pre-commit-config-local.yaml
vim .pre-commit-config-local.yaml

# Use locally
pre-commit run --config .pre-commit-config-local.yaml --all-files
```

---

## Keeping Configs Updated

Your symlinks automatically point to the latest shared-configs. To stay synchronized:

```bash
# Periodically pull updates
cd ../rylan-labs-shared-configs
git pull origin main

# Test in your repository
cd ../your-repo
pre-commit run --all-files

# If conflicts arise, create an issue
```

---

## Next Steps

1. **Test your CI**: Push to a branch and verify GitHub Actions workflows pass
2. **Review SYMLINK_SETUP.md**: Deep dive into symlink mechanics
3. **Read CHANGELOG.md**: Understand what's changed in shared-configs
4. **Contact Foundation Ministry**: For custom configs or framework additions

---
