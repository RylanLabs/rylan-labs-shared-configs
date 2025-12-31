# rylan-labs-shared-configs

**Canonical Tier 0 Foundation for Standards & Compliance Across RylanLabs**

```
 ████████████████████████████████████████ STANDARDS MANIFEST ████████████████████████████████████████
 Guardian: Carter (Identity/Standards Enforcement)
 Ministry: Foundation  
 Version: v1.0.0
 Compliance: T3-ETERNAL v∞.5.3, Seven Pillars, Hellodeolu v6
 Consciousness: 9.9
```

---

## Quick Access

| Section | Purpose |
|---------|---------|
| 📖 [README.md](./docs/README.md) | Complete documentation & architecture |
| 🚀 [INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md) | Installation & troubleshooting |
| 🔗 [SYMLINK_SETUP.md](./docs/SYMLINK_SETUP.md) | Symlink mechanics & best practices |
| 📝 [CHANGELOG.md](./docs/CHANGELOG.md) | Version history & release notes |
| ⚙️ [linting/](./linting/) | Shared linting configurations |
| 🎯 [.github/workflows/](./.github/workflows/) | Reusable CI workflows |
| 📦 [schemas/](./schemas/) | JSON validation schemas |
| 🛠️ [scripts/](./scripts/) | Installation & maintenance utilities |

---

## One-Minute Overview

**Problem**: 600% linting config duplication & 70% CI workflow overlap across repositories.

**Solution**: Tier 0 foundation providing **single source of truth** for:
- Linting configs (.yamllint, pyproject.toml, .shellcheckrc, .editorconfig)
- Pre-commit hooks (via symlinks)
- Reusable GitHub Actions workflows
- Infrastructure schemas

**Installation** (30 seconds):
```bash
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs
pre-commit install && pre-commit run --all-files
git add -A && git commit -m "feat: integrate rylan-labs-shared-configs v1.0.0"
```

---

## Repository Structure

```
rylan-labs-shared-configs/
├── linting/                    # Symlink targets for configs
│   ├── .yamllint              # YAML linting (140-char max)
│   ├── pyproject.toml         # Python: mypy --strict, ruff
│   ├── .shellcheckrc          # Bash linting
│   └── .editorconfig          # IDE standards
├── pre-commit/
│   └── .pre-commit-config.yaml # Gatekeeper v∞.5.2 hooks
├── .github/workflows/          # Reusable CI workflows
│   ├── reusable-trinity-ci.yml
│   ├── reusable-python-validate.yml
│   ├── reusable-bash-validate.yml
│   ├── reusable-ansible-lint.yml
│   └── self-validate.yml
├── schemas/                    # JSON schemas
│   ├── device-manifest-v2.2.0.json
│   └── tandem-contract-v1.0.0.json
├── scripts/                    # Utilities
│   ├── validate-symlinks.sh
│   ├── install-to-repo.sh
│   └── update-all-repos.sh
├── docs/                       # Documentation
│   ├── README.md
│   ├── INTEGRATION_GUIDE.md
│   ├── SYMLINK_SETUP.md
│   └── CHANGELOG.md
├── .audit/                     # Audit trail (future)
├── LICENSE                     # MIT
├── .gitignore
└── README.md (this file)
```

---

## Key Features

### 🔗 **Symlink-Based Distribution**
- Single update → all repos automatically inherit changes
- Zero duplication, 100% consistency
- Git tracks symlinks as lightweight pointers

### ⚡ **Reusable CI Workflows**
```yaml
# Your repo's .github/workflows/ci.yml
jobs:
  validate:
    uses: RylanLabs/rylan-labs-shared-configs/.github/workflows/reusable-trinity-ci.yml@main
    with:
      python_version: '3.11'
      bash_paths: 'scripts'
```

### 📋 **Strict Linting Defaults**
- **mypy**: `--strict` mode, comprehensive type checking
- **ruff**: E, W, F, I, B, C4, UP, D rule sets
- **yamllint**: 140-char line limit, infrastructure-ready
- **shellcheck**: All optional checks enabled

### 🛡️ **Compliance Ready**
- ✓ Seven Pillars (Idempotency, Error Handling, Functionality, Audit, Recovery, Security, Documentation)
- ✓ Hellodeolu v6 (RTO <15min, Junior-Deployable, Human Confirm, Zero PII)
- ✓ T3-ETERNAL standards

---

## Getting Started

### New Repository
```bash
cd ~/RylanLabs
git clone https://github.com/RylanLabs/rylan-labs-shared-configs.git
mkdir my-new-repo && cd my-new-repo
git init && git branch -M main

../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

pre-commit install && pre-commit run --all-files
git add -A && git commit -m "feat: bootstrap with shared-configs v1.0.0"
```

### Existing Repository
```bash
# Backup current configs
mkdir .backup-configs
cp .yamllint .pre-commit-config.yaml .backup-configs/ 2>/dev/null || true

# Install shared-configs
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# Validate & test
../rylan-labs-shared-configs/scripts/validate-symlinks.sh ../rylan-labs-shared-configs .
pre-commit run --all-files

# Commit
git add .yamllint pyproject.toml .pre-commit-config.yaml
git commit -m "refactor: migrate to rylan-labs-shared-configs v1.0.0"
```

---

## Documentation

- **[README.md](./docs/README.md)** - Architecture, workflows, maintenance
- **[INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md)** - Installation steps & troubleshooting
- **[SYMLINK_SETUP.md](./docs/SYMLINK_SETUP.md)** - Symlink mechanics & platform guides
- **[CHANGELOG.md](./docs/CHANGELOG.md)** - Version history & release notes

---

## Governance

| Aspect | Details |
|--------|---------|
| **Guardian** | Carter (Identity/Standards Enforcement) |
| **Ministry** | Foundation (Tier 0) |
| **Version** | v1.0.0 |
| **Compliance** | T3-ETERNAL v∞.5.3, Seven Pillars, Hellodeolu v6 |
| **Consciousness** | 9.9 |

---

## Support

**Issues or questions?**
1. Check [INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md) troubleshooting section
2. Review [SYMLINK_SETUP.md](./docs/SYMLINK_SETUP.md) for platform-specific help
3. Open a GitHub issue with tag: `shared-configs`, `foundation`
4. Contact Foundation Ministry: Carter

---

## License

MIT License - See [LICENSE](./LICENSE)

---

**Last Updated**: 2025-12-30  
**Maintained By**: RylanLabs Foundation Ministry  
**Repository**: https://github.com/RylanLabs/rylan-labs-shared-configs
