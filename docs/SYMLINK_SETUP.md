# Symlink Setup & Mechanics

## Overview

rylan-labs-shared-configs uses **symbolic links (symlinks)** to establish a single source of truth for linting and configuration files across all RylanLabs repositories.

---

## Why Symlinks?

### Problem: Configuration Duplication

Without symlinks, each repository maintains its own copy of:

- `.yamllint` (740 bytes × 50 repos = 37 KB wasted)
- `pyproject.toml` (1.2 KB × 50 repos = 60 KB wasted)
- `.pre-commit-config.yaml` (2.1 KB × 50 repos = 105 KB wasted)
- Total: **~200 KB of duplication** + **human sync errors**

### Solution: Symlinks

```text
rylan-labs-shared-configs (source)
  └── linting/.yamllint
        ↑ (symlink)
    your-repo/.yamllint (pointer)
```text

**Benefits**:
- Single update propagates instantly to all repos
- 100% consistency enforcement
- No merge conflicts on config updates
- Minimal storage overhead

---

## Symlink Mechanics

### What Gets Symlinked

```text
Your Repository          Shared Configs (Source)
───────────────          ─────────────────────────
.yamllint         ──→    linting/.yamllint
pyproject.toml    ──→    linting/pyproject.toml
.pre-commit-config.yaml ──→ pre-commit/.pre-commit-config.yaml
.shellcheckrc     ──→    linting/.shellcheckrc       (optional)
.editorconfig     ──→    linting/.editorconfig       (optional)
```text

### What Does NOT Get Symlinked

- `.gitignore` (repo-specific)
- `README.md` (repo-specific)
- `LICENSE` (org-level in shared-configs)
- GitHub Actions workflows (optional integration)
- Application code and tests

---

## Creating Symlinks

### Using install-to-repo.sh (Recommended)

```bash
cd /path/to/your/repo
/path/to/rylan-labs-shared-configs/scripts/install-to-repo.sh . /path/to/rylan-labs-shared-configs
```text

**What it does**:
1. Creates symlinks for required configs
2. Skips existing local configs (preserves `.editorconfig`, etc.)
3. Validates symlink targets
4. Provides next-step instructions

### Manual Symlink Creation

If `install-to-repo.sh` doesn't work (e.g., Windows):

```bash
cd /path/to/your/repo

# Create symlink: ln -sf <source> <link-name>
ln -sf /path/to/rylan-labs-shared-configs/linting/.yamllint .yamllint
ln -sf /path/to/rylan-labs-shared-configs/linting/pyproject.toml pyproject.toml
ln -sf /path/to/rylan-labs-shared-configs/pre-commit/.pre-commit-config.yaml .pre-commit-config.yaml
ln -sf /path/to/rylan-labs-shared-configs/linting/.shellcheckrc .shellcheckrc
ln -sf /path/to/rylan-labs-shared-configs/linting/.editorconfig .editorconfig

# Verify
ls -la .yamllint pyproject.toml .pre-commit-config.yaml
# Should show: link -> /path/to/...
```text

---

## Verifying Symlinks

### Check Symlink Status

```bash
# List with symlink details
ls -la .yamllint .pre-commit-config.yaml pyproject.toml

# Output example:
# lrwxr-xr-x  1 user  staff   75 Dec 30 10:23 .yamllint -> /path/to/rylan-labs-shared-configs/linting/.yamllint
# lrwxr-xr-x  1 user  staff   88 Dec 30 10:23 pyproject.toml -> /path/to/rylan-labs-shared-configs/linting/pyproject.toml
```text

### Read Symlink Target

```bash
# See where symlink points
readlink .yamllint
# Output: /path/to/rylan-labs-shared-configs/linting/.yamllint

# See absolute path
readlink -f .yamllint
# Output: /absolute/path/to/rylan-labs-shared-configs/linting/.yamllint
```text

### Automated Validation

```bash
# Run Carter Guardian validation script
/path/to/rylan-labs-shared-configs/scripts/validate-symlinks.sh /path/to/rylan-labs-shared-configs .

# Expected output:
# === Carter Guardian: Symlink Validation ===
# Shared configs: /path/to/rylan-labs-shared-configs
# Repository root: .
# ✓ .yamllint → linting/.yamllint
# ✓ pyproject.toml → linting/pyproject.toml
# ✓ .pre-commit-config.yaml → pre-commit/.pre-commit-config.yaml
# === Validation Passed: All symlinks valid ===
```text

---

## Fixing Broken Symlinks

### Symlink Points to Wrong Location

**Symptom**: `readlink .yamllint` shows incorrect path

**Fix**:
```bash
# Remove broken symlink
rm .yamllint

# Recreate with correct path
ln -sf /correct/path/to/rylan-labs-shared-configs/linting/.yamllint .yamllint

# Verify
readlink .yamllint
```text

### Symlink Target Deleted

**Symptom**: `ls -la .yamllint` shows red broken link

**Fix**:
```bash
# Ensure shared-configs is cloned/updated
cd /path/to/rylan-labs-shared-configs
git status
git pull origin main

# Return to your repo and verify
cd /path/to/your/repo
ls -la .yamllint
readlink .yamllint  # Should now work
```text

### Relative vs Absolute Paths

**Recommendation**: Use absolute paths to avoid confusion

```bash
# GOOD: Absolute path
ln -sf /home/user/repos/rylan-labs-shared-configs/linting/.yamllint .yamllint

# RISKY: Relative path (breaks if directory structure changes)
ln -sf ../../rylan-labs-shared-configs/linting/.yamllint .yamllint
```text

---

## Git Integration

### Committing Symlinks

Git tracks symlinks as lightweight pointers (< 100 bytes):

```bash
# Add symlinks to git
git add .yamllint pyproject.toml .pre-commit-config.yaml

# Git stores symlink path, not file contents
git ls-files -s
# Output:
# 120000 hash .yamllint
# ^^ mode 120000 = symlink

# Verify in .gitmodules or git status
git status
# On branch main
# Changes to be committed:
#   new file:   .yamllint -> ../../rylan-labs-shared-configs/linting/.yamllint
```text

### Checking Out Symlinks

When cloning a repo with symlinks:

```bash
# Clone normally (symlinks included)
git clone https://github.com/RylanLabs/your-repo.git
cd your-repo

# Symlinks exist, but targets may not be present
ls -la .yamllint
# lrwxr-xr-x .yamllint -> ../../rylan-labs-shared-configs/linting/.yamllint

# Resolve symlinks by cloning shared-configs alongside
cd ..
git clone https://github.com/RylanLabs/rylan-labs-shared-configs.git

# Now symlinks work
cd your-repo
cat .yamllint  # Contents displayed (symlink resolved)
```text

---

## Platform-Specific Notes

### Linux/macOS

✓ Full symlink support (native)
✓ No special configuration needed

### Windows 10+ with WSL2

```bash
# Use WSL2 terminal (not PowerShell)
wsl.exe bash

# Create symlinks within WSL
ln -sf /mnt/c/path/to/rylan-labs-shared-configs/linting/.yamllint .yamllint
```text

### Windows (Git Bash / MinGW)

```bash
# Git Bash can create symlinks if:
# 1. You have admin privileges, OR
# 2. Developer Mode enabled (Windows 10+)

# Try creating symlink
ln -sf /c/path/to/rylan-labs-shared-configs/linting/.yamllint .yamllint

# If fails, use NTFS junctions (Windows alternative)
mklink /J .yamllint C:\path\to\rylan-labs-shared-configs\linting\.yamllint
```text

---

## Troubleshooting Symlink Issues

| Problem | Symptom | Solution |
| ------- | ------- | -------- |
| Symlink broken | Red text in `ls -la` | Reinstall shared-configs or fix target path |
| Path not found | `cat .yamllint` fails | Clone shared-configs in correct location |
| Wrong target | `readlink` shows wrong path | Delete and recreate symlink |
| Windows: Not supported | `ln` command fails | Use WSL2 or enable Developer Mode |
| Relative path issues | Symlink works locally, fails on CI | Use absolute paths with `install-to-repo.sh` |

---

## Best Practices

1. **Always use absolute paths** when creating symlinks
2. **Document symlink locations** in your repo's README
3. **Validate symlinks in CI** before running linters
4. **Update shared-configs regularly** via `git pull`
5. **Test locally** before merging symlink updates
6. **Keep .gitignore updated** (don't ignore symlinked files)

---

## Related Resources

- [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md) - Installation steps
- [validate-symlinks.sh](../scripts/validate-symlinks.sh) - Validation script
- [install-to-repo.sh](../scripts/install-to-repo.sh) - Installation script
- [README.md](./README.md) - Main documentation

---
