# Bootstrap Guide

**rylanlabs-shared-configs v1.0.0**

One-time setup for this Tier 0 repository.

---

## Prerequisites

- Git 2.10+
- Python 3.11+
- Bash 4.0+
- npm (for markdownlint-cli, optional)

---

## Phase 1: Git Initialization

Already complete. This repo is initialized with:

```bash
git init
git config user.name "Carter Guardian"
git config user.email "carter@rylanlabs.local"
```

**Bootstrap commit**: `03c7a26` (30 files, 5393 insertions)
**Tag**: `v1.0.0-bootstrap`

---

## Phase 2: Pre-Commit Hooks

All hooks configured and passing:

```bash
pre-commit install
pre-commit install --hook-type commit-msg
pre-commit run --all-files  # Should pass
```

**Hooks (Gatekeeper v∞.5.2)**:

- trailing-whitespace, end-of-file-fixer, YAML validation, large files block
- merge-conflict detection, secret detection, case-insensitive detection
- LF line-ending enforcement, YAML linting, shellcheck, shfmt
- markdownlint, JSON validation, bandit (security), commitizen (commit messages)

**Tag**: `v1.0.0-phase-2-complete`

---

## Phase 3: Documentation

All user-facing docs complete and tested:

- `README.md`: Main overview
- `docs/INTEGRATION_GUIDE.md`: Consumer integration
- `docs/SYMLINK_SETUP.md`: Symlink mechanics
- `docs/CHANGELOG.md`: Version history
- `docs/MARKDOWN_STYLE_GUIDE.md`: Markdown standards

**Tag**: `v1.0.0-phase-3-complete`

---

## Phase 4: Reusable Workflows

5 GitHub Actions workflows ready for consumers:

```bash
uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/reusable-trinity-ci.yml@main
```

All workflows validated, syntactically correct, documented.

**Tag**: `v1.0.0-phase-4-complete`

---

## Phase 5: Production Release

Repository tagged as production-ready:

```bash
git tag -l | grep v1.0.0
# Output: v1.0.0, v1.0.0-bootstrap, v1.0.0-phase-2-complete, ...
```

---

## Phase 6: Canonicalization (Current)

Temporary working-draft docs → archive
Canonical permanent docs → `.audit/`

**Result**: 94% bloat reduction, clean audit structure

---

## Daily Operations

### Deploying to Consumer Repos

```bash
../rylanlabs-shared-configs/scripts/install-to-repo.sh . ../rylanlabs-shared-configs
pre-commit install
pre-commit run --all-files
```

### Updating Pre-Commit Hooks

```bash
pre-commit autoupdate  # Update to latest hook versions
pre-commit run --all-files  # Test
git add pre-commit/.pre-commit-config.yaml
git commit -m "chore: update pre-commit hooks"
```

### Validating Consumer Symlinks

```bash
../rylanlabs-shared-configs/scripts/validate-symlinks.sh
# Should show all symlinks resolving correctly
```

---

## Troubleshooting

### Pre-Commit Fails Unexpectedly

```bash
pre-commit clean  # Clear cache
pre-commit run --all-files --verbose
```

### Symlinks Broken in Consumer Repo

```bash
# Check relative paths
ls -la .yamllint .pre-commit-config.yaml
# Should show → ../rylanlabs-shared-configs/linting/...

# Re-create if needed
rm .yamllint
ln -sf ../rylanlabs-shared-configs/linting/.yamllint .yamllint
```

### Git History Too Large

```bash
# View largest objects
git rev-list --all --objects | sort -k2 | tail -10

# If node_modules accidentally committed:
git rm -r --cached node_modules/
git commit -m "Remove node_modules from tracking"
```

---

## Next Steps

1. **Monitor** consumer repo adoption
2. **Update** docs as feedback arrives
3. **Tag releases** using semantic versioning (v1.0.1, v1.1.0, etc.)
4. **Archive** old bootstrap docs when no longer needed

---

**Guardian**: Carter | **Ministry**: Identity
**Version**: v1.0.0 | **Maturity**: v1.0.1
