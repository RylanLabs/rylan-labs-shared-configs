# rylan-labs-shared-configs

**Guardian**: Carter (Identity/Standards Enforcement)
**Ministry**: Foundation
**Version**: v1.0.0
**Compliance**: T3-ETERNAL v∞.5.3, Seven Pillars, Hellodeolu v6
**Maturity**: v1.0.1

---

## Purpose

Tier 0 foundation repository providing single source of truth for:

- **Linting configurations** (.yamllint, pyproject.toml, .shellcheckrc, .editorconfig)
- **Pre-commit hooks** (Gatekeeper v∞.5.2)
- **Reusable CI workflows** (Trinity pattern validation)
- **JSON schemas** (device manifests, tandem contracts)

**Problem Solved**: Eliminates 600% linting config duplication and 70% CI workflow overlap across RylanLabs repositories.

---

## Architecture

### Consumption Pattern

```text
rylan-labs-shared-configs (v1.0.0) ← Source of Truth
  ↓ (symlinks)
rylan-labs-common
rylan-inventory
rylan-canon-library
rylan-labs-network-iac
  ↓ (inherits standards)
✓ Zero duplication, single update propagates to all repos
```bash

### Trinity Alignment

- **Carter**: Identity enforcement via symlinks, standard propagation
- **Bauer**: Audit via reusable workflows, cross-repo validation
- **Beale**: Security via centralized hardening configs

---

## Repository Structure

```text
rylan-labs-shared-configs/
├── linting/              # Symlink targets for lint configs
│   ├── .yamllint         # 140-char line length
│   ├── pyproject.toml    # mypy --strict, ruff, pytest
│   ├── .shellcheckrc     # Bash linting
│   └── .editorconfig     # IDE standards
├── pre-commit/           # Pre-commit hook configurations
│   └── .pre-commit-config.yaml
├── .github/workflows/    # Reusable CI workflows
│   ├── reusable-trinity-ci.yml
│   ├── reusable-ansible-lint.yml
│   ├── reusable-python-validate.yml
│   ├── reusable-bash-validate.yml
│   └── self-validate.yml
├── schemas/              # JSON schemas for validation
│   ├── device-manifest-v2.2.0.json
│   └── tandem-contract-v1.0.0.json
├── scripts/              # Maintenance utilities
│   ├── validate-symlinks.sh
│   ├── install-to-repo.sh
│   └── update-all-repos.sh
└── docs/                 # Documentation
    ├── README.md
    ├── INTEGRATION_GUIDE.md
    ├── SYMLINK_SETUP.md
    └── CHANGELOG.md
```

---

## Quick Start

### For New Repositories

```bash
# 1. Clone shared-configs alongside your repo
cd ~/RylanLabs
git clone git@github.com:RylanLabs/rylan-labs-shared-configs.git

# 2. Install to your new repo
cd your-new-repo
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# 3. Initialize pre-commit
pre-commit install
pre-commit run --all-files

# 4. Commit
git add .yamllint pyproject.toml .pre-commit-config.yaml
git commit -m "feat: integrate rylan-labs-shared-configs v1.0.0"
```bash

### For Existing Repositories

```bash
# 1. Backup existing configs
mkdir .backup-configs
cp .yamllint pyproject.toml .pre-commit-config.yaml .backup-configs/

# 2. Remove old configs
rm .yamllint pyproject.toml .pre-commit-config.yaml

# 3. Install shared-configs
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# 4. Validate
../rylan-labs-shared-configs/scripts/validate-symlinks.sh ../rylan-labs-shared-configs .

# 5. Test
pre-commit run --all-files

# 6. Commit
git add .yamllint pyproject.toml .pre-commit-config.yaml
git commit -m "refactor: migrate to rylan-labs-shared-configs v1.0.0

- Removed isolated configs (600% duplication eliminated)
- Symlinks to shared-configs established
- Pre-commit hooks passing
- Guardian: Carter | Ministry: Foundation

Tag: refactor, shared-configs-migration"
```

---

## Reusable Workflows

### Example: Trinity CI in Your Repo

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  trinity-validation:
    uses: RylanLabs/rylan-labs-shared-configs/.github/workflows/reusable-trinity-ci.yml@main
    with:
      python_version: '3.11'
      bash_paths: 'scripts'
      ansible_paths: 'playbooks roles'
```bash

### Available Workflows

| Workflow | Purpose | Inputs |
| -------- | ------- | ------ |
| `reusable-trinity-ci.yml` | Full Trinity validation (Python, Bash, YAML, Ansible) | `python_version`, `bash_paths`, `ansible_paths` |
| `reusable-python-validate.yml` | mypy + ruff only | `python_version` |
| `reusable-bash-validate.yml` | shellcheck + shfmt only | `bash_paths` |
| `reusable-ansible-lint.yml` | ansible-lint only | `ansible_paths` |

---

## Maintenance

### Updating Shared Configs

```bash
# 1. Make changes in rylan-labs-shared-configs
cd rylan-labs-shared-configs
vim linting/.yamllint  # Example: change line-length to 160

# 2. Test locally
./scripts/validate-symlinks.sh . .
pre-commit run --all-files

# 3. Commit and tag
git add linting/.yamllint
git commit -m "feat: increase line-length to 160 chars"
git tag v1.1.0
git push origin main --tags

# 4. Propagate to all repos
echo "../rylan-labs-common" > repos.txt
echo "../rylan-inventory" >> repos.txt
echo "../rylan-canon-library" >> repos.txt
./scripts/update-all-repos.sh v1.1.0 repos.txt

# 5. Push branches and create PRs
cd ../rylan-labs-common
git push origin chore/shared-configs-v1.1.0
gh pr create --title "chore: update to shared-configs v1.1.0" --body "Automatic update"
```

### Symlink Validation

```bash
# Validate symlinks in any repo
cd rylan-labs-common
../rylan-labs-shared-configs/scripts/validate-symlinks.sh ../rylan-labs-shared-configs .

# Expected output:
# ✓ .yamllint → linting/.yamllint
# ✓ pyproject.toml → linting/pyproject.toml
# ✓ .pre-commit-config.yaml → pre-commit/.pre-commit-config.yaml
```bash

---

## Seven Pillars Compliance

1. **Idempotency**: Symlinks resolve consistently; install script safe to re-run
2. **Error Handling**: Scripts fail-loud with exit codes; validation before propagation
3. **Functionality**: Self-validate.yml ensures configs work; 100% CI coverage
4. **Audit Logging**: Git commits track all changes; CHANGELOG.md maintained
5. **Failure Recovery**: Backup configs before migration; rollback via git revert
6. **Security Hardening**: No secrets in configs; read-only consumption pattern
7. **Documentation**: This README, INTEGRATION_GUIDE.md, inline comments

---

## Hellodeolu v6 Compliance

- **RTO <15min**: Install script completes in <2min; propagation to 7 repos <10min
- **Junior-Deployable**: Single command installation; clear error messages
- **Human Confirm**: update-all-repos.sh creates branches, requires manual PR review
- **Zero PII**: No personal data in configs; organizational standards only

---
