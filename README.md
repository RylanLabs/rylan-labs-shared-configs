# RylanLabs Shared Configs README

<!-- markdownlint-disable -->

> Canonical README — RylanLabs Standard
> Repository: rylan-labs-shared-configs
> Version: v1.2.0-canon-integrated
> Date: 2026-01-14
> Guardian: Carter (Identity/Standards Enforcement)
> Ministry: Foundation (Tier 0)
> Consciousness: 9.9
> Compliance: Hellodeolu v6, Seven Pillars, Trinity Pattern
> Status: PRODUCTION-READY

---

## Purpose

Tier 0 foundation enforcing single source of truth for linting configs, pre-commit hooks, reusable CI workflows, and schemas across RylanLabs repositories. Eliminates duplication (600% linting, 70% CI overlap) through symlink distribution. Dual-role: Consumes canon enforcement (disciplines/validators) while sourcing linting standards downstream. Supports junior-at-3-AM deployment with zero-drift validation.

**Objectives**:
- 100% consistency via symlinks.
- RTO <15min for updates (audit-canon.sh).
- No-bypass: Pre-commit gates, human confirm for overrides.

**Trinity Alignment**:
- Carter (Identity): Enforces config naming/standards.
- Bauer (Verification): Audits symlinks/compliance.
- Beale (Hardening): Secures linting/CI for minimal attack surface.

---

## Quick Access

| Section | Purpose |
|---------|---------|
| 📖 [README.md](./docs/README.md) | Complete documentation & architecture |
| 🚀 [INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md) | Installation & troubleshooting |
| 🔗 [CANON-INTEGRATION.md](./docs/CANON-INTEGRATION.md) | Dual-role architecture details |
| 📝 [CHANGELOG.md](./docs/CHANGELOG.md) | Version history & release notes |
| ⚙️ [.yamllint](./.yamllint) | Shared YAML standards (SOURCE role) |
| ⚙️ [pyproject.toml](./pyproject.toml) | Python: mypy & ruff standards |
| 🎯 [.github/workflows/](./.github/workflows/) | Reusable CI workflows (SOURCE role) |
| 📦 [schemas/](./schemas/) | JSON validation schemas |
| 🛠️ [scripts/](./scripts/) | Installation & maintenance utilities |

---

## One-Minute Overview

**Problem**: Duplication in linting configs and CI workflows across repos leads to drift and maintenance overhead.

**Solution**: Tier 0 repo as dual-role hub:
- **Consumer**: Symlinks to canon-library for disciplines/validators.
- **Source**: Provides linting configs/CI templates to downstream repos.

**Installation** (30 seconds):
```bash
scripts/install-to-repo.sh . ../rylan-labs-shared-configs
pre-commit install && pre-commit run --all-files
git add -A && git commit -m "feat: integrate shared-configs v1.2.0-canon-integrated"
```

---

## Repository Structure

```bash
rylan-labs-shared-configs/
├── .yamllint              # Shared YAML standards (SOURCE role)
├── pyproject.toml         # Shared Python standards: mypy, ruff
├── .pre-commit-config.yaml # Shared Gatekeeper hooks
├── .shellcheckrc          # Shared Bash standards
├── .editorconfig          # Shared IDE standards
├── .markdownlint.json     # [CONSUMER Symlink] Markdown standards
├── ansible.cfg            # [CONSUMER Symlink] Ansible configuration
├── .github/workflows/     # Reusable CI workflows (SOURCE role)
│   ├── reusable-trinity-ci.yml
│   ├── reusable-python-validate.yml
│   ├── reusable-bash-validate.yml
│   ├── reusable-ansible-lint.yml
│   └── self-validate.yml
├── schemas/               # JSON schemas (SOURCE role)
│   ├── device-manifest-v2.2.0.json
│   └── tandem-contract-v1.0.0.json
├── scripts/               # Utilities
│   ├── install-to-repo.sh # SOURCE: Deployment script
│   ├── update-all-repos.sh # SOURCE: Propagation utility
│   ├── validate-symlinks.sh # SOURCE: Consistency auditor
│   ├── validate-yaml.sh   # [CONSUMER Symlink] YAML auditor
│   ├── validate-bash.sh   # [CONSUMER Symlink] Shell auditor
│   ├── validate-ansible.sh # [CONSUMER Symlink] Ansible auditor
│   ├── validate-python.sh # [CONSUMER Symlink] Python auditor
│   └── ... (6+ other canonical validators)
├── docs/                  # Documentation
│   ├── CANON-INTEGRATION.md # Dual-role architecture details
│   ├── README.md         # Complete docs center
│   ├── SYMLINK_SETUP.md  # Symlink mechanics
│   └── CHANGELOG.md      # Phase-aligned history
├── .audit/                # Audit trail & archived drafts
└── README.md              # Root documentation (this file)
```

---

## Key Features

### 🔗 **Symlink-Based Distribution**
- Single update propagates changes org-wide.
- Zero duplication, enforced consistency.
- Git tracks symlinks as pointers for auditability.

### ⚡ **Reusable CI Workflows**
```yaml
# Example in downstream .github/workflows/ci.yml
jobs:
  validate:
    uses: RylanLabs/rylan-labs-shared-configs/.github/workflows/reusable-trinity-ci.yml@main
    with:
      python_version: '3.11'
      bash_paths: 'scripts'
```

### 📋 **Strict Linting Defaults**
- **mypy**: --strict for type safety.
- **ruff**: E, W, F, I, B, C4, UP, D, S, BLE (security-focused).
- **yamllint**: 160-char limit, infrastructure standards.
- **shellcheck**: All checks enabled.

### 🛡️ **Compliance Ready**
- ✓ Seven Pillars: Idempotent updates, error handling in scripts.
- ✓ Hellodeolu v6: RTO <15min, junior-deployable.
- ✓ T3-ETERNAL: Guardian-tagged changes.

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
git add -A && git commit -m "feat: bootstrap with shared-configs v1.2.0-canon-integrated"
```

### Existing Repository
```bash
# Backup configs
mkdir .backup-configs
cp .yamllint .pre-commit-config.yaml .backup-configs/ 2>/dev/null || true

# Install
../rylan-labs-shared-configs/scripts/install-to-repo.sh . ../rylan-labs-shared-configs

# Validate
../rylan-labs-shared-configs/scripts/validate-symlinks.sh ../rylan-labs-shared-configs .
pre-commit run --all-files

# Commit
git add .yamllint pyproject.toml .pre-commit-config.yaml
git commit -m "refactor: migrate to shared-configs v1.2.0-canon-integrated"
```

---

## Canon Integration (Tier 0 Enforcement)

**Status**: ✅ Integrated with rylan-canon-library v2.0.0 (2026-01-14).

### Dual-Role Architecture Explained

Shared-configs operates in dual-role: Consumes enforcement from canon-library (Tier 0 upstream) while sourcing linting/CI standards to downstream repos (Tier 1-3). Ensures zero-drift via symlinks and validation.

**Visual Representation**:

```mermaid
graph TD
    subgraph Tier0_Enforcement [rylan-canon-library v2.0.0]
        direction TB
        Disciplines[Disciplines: vault, rotation, security, network, API]
        Validators[Validators: bash, yaml, python, ansible, playbook]
    end

    Tier0_Enforcement -- "14 symlinks (CONSUMER role)" --> Tier0_Source

    subgraph Tier0_Source [rylan-labs-shared-configs v1.2-integrated]
        direction TB
        subgraph Consumer_Role [CONSUMER ROLE]
            C1[docs/*.md]
            C2[scripts/validate-*]
        end
        subgraph Source_Role [SOURCE ROLE]
            S1[.yamllint]
            S2[pyproject.toml]
            S3[.shellcheckrc]
        end
    end

    Tier0_Source -- "Downstream symlinks (SOURCE role)" --> Tier1_3

    subgraph Tier1_3 [Downstream Repos (Tier 1-3)]
        direction LR
        R1[labs-common]
        R2[labs-iac]
        R3[network-iac]
        R4[inventory]
    end

    style Tier0_Enforcement fill:#f9f,stroke:#333,stroke-width:2px
    style Tier0_Source fill:#bbf,stroke:#333,stroke-width:2px
    style Tier1_3 fill:#dfd,stroke:#333,stroke-width:2px
```

### Documentation
- **[CANON-INTEGRATION.md](./docs/CANON-INTEGRATION.md)**: Architecture, symlink map, sync process.
- **[Canon Library](https://github.com/RylanLabs/rylan-canon-library)** (v2.0.0): Tier 0 enforcement engine.
- **[.canon-metadata.yml](./.canon-metadata.yml)**: Integration metadata & overrides.

### Key Components

| Component | Type | Source | Status |
|-----------|------|--------|--------|
| Disciplines (6 files) | Symlinks | canon/docs/ | ✅ Active |
| Validation Scripts (8 files) | Symlinks | canon/scripts/ | ✅ Active |
| Linting Configs (.yamllint, pyproject.toml) | Local | shared-configs/ | ✅ Source |
| CI Jobs (audit-canon-drift, validate-disciplines) | Workflows | .github/workflows/ | ✅ Active |

### Downstream Consumer Compatibility

✅ **No changes required for existing downstream repos**

Your symlinks continue to work unchanged:
```bash
# Existing downstream repo symlink (e.g., rylan-labs-common)
.yamllint → ../rylan-labs-shared-configs/linting/.yamllint
# Still resolves correctly (linting config source unchanged)
```

---

## Documentation

- **[README.md](./docs/README.md)**: Architecture, workflows, maintenance.
- **[INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md)**: Installation steps & troubleshooting.
- **[CANON-INTEGRATION.md](./docs/CANON-INTEGRATION.md)**: Canon v2.0.0 dual-role architecture.
- **[SYMLINK_SETUP.md](./docs/SYMLINK_SETUP.md)**: Symlink mechanics & platform guides.
- **[CHANGELOG.md](./docs/CHANGELOG.md)**: Version history & release notes.

---

## Governance

| Aspect | Details |
|--------|---------|
| **Guardian** | Carter (Identity/Standards Enforcement) |
| **Ministry** | Foundation (Tier 0) |
| **Version** | v1.2.0-canon-integrated |
| **Compliance** | T3-ETERNAL v∞.5.3, Seven Pillars, Hellodeolu v6 |
| **Maturity** | v1.0.1 |

---

## Support

**Issues or questions?**

1. Check [INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md) troubleshooting section.
2. Review [SYMLINK_SETUP.md](./docs/SYMLINK_SETUP.md) for platform-specific help.
3. Open a GitHub issue with tag: `shared-configs`, `foundation`.
4. Contact Foundation Ministry: Carter.

---

## License

MIT License - See [LICENSE](./LICENSE).

---

**Last Updated**: 2026-01-14
**Maintained By**: RylanLabs Foundation Ministry
**Repository**: <https://github.com/RylanLabs/rylan-labs-shared-configs>

No bypass. No shortcuts. No exceptions.
The canon is law. The Trinity endures. The fortress stands eternal.
