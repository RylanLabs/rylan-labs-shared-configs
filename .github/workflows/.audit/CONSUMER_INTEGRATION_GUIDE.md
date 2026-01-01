# Consumer Integration Guide

**For Tier 1+ repositories consuming rylanlabs-shared-configs**

---

## Quick Start (30 seconds)

```bash
cd your-repo/
../rylanlabs-shared-configs/scripts/install-to-repo.sh . ../rylanlabs-shared-configs
pre-commit install && pre-commit install --hook-type commit-msg
pre-commit run --all-files
```

Done! Your repo now inherits all standards from the source.

---

## Symlink Architecture

### What Gets Symlinked

```bash
your-repo/
├── .yamllint → ../rylanlabs-shared-configs/linting/.yamllint
├── pyproject.toml → ../rylanlabs-shared-configs/linting/pyproject.toml
├── .shellcheckrc → ../rylanlabs-shared-configs/linting/.shellcheckrc
├── .editorconfig → ../rylanlabs-shared-configs/linting/.editorconfig
└── .pre-commit-config.yaml → ../rylanlabs-shared-configs/pre-commit/.pre-commit-config.yaml
```

### Why Symlinks?

- **Updates automatic**: Fix source → all repos inherit on next pull
- **Zero duplication**: Single config, shared everywhere
- **Lightweight**: Git tracks as ~50-byte pointers

---

## Using Reusable Workflows

### Basic Trinity CI (Python + Bash + YAML + Ansible)

In your `.github/workflows/ci.yml`:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/reusable-trinity-ci.yml@main
    with:
      python_version: '3.11'
      bash_paths: 'scripts/'
      yaml_paths: '.github/'
      ansible_paths: 'playbooks/ roles/'
```

### Python-Only

```yaml
jobs:
  python:
    uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/reusable-python-validate.yml@main
    with:
      python_version: '3.11'
```

### Bash-Only

```yaml
jobs:
  bash:
    uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/reusable-bash-validate.yml@main
    with:
      bash_paths: 'scripts/'
```

### Ansible-Only

```yaml
jobs:
  ansible:
    uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/reusable-ansible-lint.yml@main
    with:
      ansible_paths: 'playbooks/ roles/'
```

---

## Standards Inherited

### YAML Validation

- Maximum line length: 120 characters (code), 160 characters (comments)
- Indentation: 2 spaces
- No trailing whitespace
- LF line endings

### Python

- **mypy**: Strict mode (type checking enforced)
- **ruff**: Linting with security rules (S/BLE)
- **bandit**: Security scanning
- Line length: 120 characters

### Bash

- **shellcheck**: Bash linting (SC2155 fixed, etc.)
- **shfmt**: Bash formatting
- Strict mode: `set -euo pipefail`

### Markdown

- **markdownlint**: Markdown validation
- Line length: 160 characters
- Proper heading spacing, table formatting

---

## Customization

### If You Need Custom Configs

1. **Do NOT** override symlinks with local files
2. **Instead**: Submit a PR to rylanlabs-shared-configs with your changes
3. **Rationale**: Single source of truth; prevents drift

### Local Overrides (Exceptions)

If your repo has legitimate special needs:

1. Create local config file (e.g., `pyproject.toml.local`)
2. Document WHY in your README.md
3. Note in your PR that you're diverging from standard
4. Plan to reconcile when possible

---

## Updating Standards

### When rylanlabs-shared-configs Is Updated

```bash
# Pull latest from source
cd ../rylanlabs-shared-configs && git pull origin main

# Your repo automatically gets updates (symlinks resolve to new content)
cd ../your-repo && git status
# Symlinks unchanged (they point to same path)
# But their content is updated!

# Verify changes
pre-commit run --all-files --verbose

# Commit if changes detected
git add -A
git commit -m "chore: inherit updated standards from rylanlabs-shared-configs"
```

---

## Validation

### Check Symlinks Are Correct

```bash
../rylanlabs-shared-configs/scripts/validate-symlinks.sh
# Output: All symlinks valid ✓
```

### Check Pre-Commit Works

```bash
pre-commit run --all-files --verbose
# Output: All hooks passing
```

### Check Workflows Load

```bash
# In .github/workflows/
yamllint ci.yml
# Should pass with no errors
```

---

## Troubleshooting

### "Symlink: No such file or directory"

```bash
# Verify relative paths
ls -la .yamllint
# Should show: .yamllint → ../rylanlabs-shared-configs/linting/.yamllint

# If broken, reinstall
../rylanlabs-shared-configs/scripts/install-to-repo.sh . ../rylanlabs-shared-configs
```

### Pre-Commit Hook Fails

```bash
# Run with verbose output
pre-commit run --all-files --verbose

# Check if config is valid
yamllint .yaml-lint
mypy --strict --help  # Verify Python version

# Update hooks to latest
pre-commit autoupdate
pre-commit run --all-files
```

### Workflow Not Triggering

```bash
# Validate workflow YAML
yamllint .github/workflows/ci.yml

# Check branch name matches (main vs master)
# Check workflow file is in .github/workflows/
# Check `uses:` path is correct: RylanLabs/rylanlabs-shared-configs/.github/workflows/...
```

---

## Best Practices

1. **Always** use symlinks for shared configs (never copy-paste)
2. **Regularly** pull updates from source (monthly or quarterly)
3. **Test** pre-commit hooks before committing (`pre-commit run --all-files`)
4. **Document** any custom rules or exceptions
5. **Report** issues to rylanlabs-shared-configs repo

---

## Support

- **Issues**: GitHub Issues in rylanlabs-shared-configs
- **Questions**: Ask in #engineering-standards Slack channel
- **Updates**: Subscribe to release notifications

---

**Guardian**: Carter | **Ministry**: Identity
**Version**: v1.0.0 | **Maturity**: v1.0.1
