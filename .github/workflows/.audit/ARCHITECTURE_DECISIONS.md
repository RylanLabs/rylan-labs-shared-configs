# Architecture Decisions

**rylanlabs-shared-configs v1.0.0**

---

## Why Tier 0 SOURCE?

This repository serves as the **single source of truth** for RylanLabs standards, configurations, and CI/CD
templates. All other repositories (Tier 1+) **consume** this via symlinks.

### Benefits

- **Zero Duplication**: One linting config, one pre-commit setup, shared everywhere
- **Single Update**: Fix a rule once, all repos inherit automatically (next pull)
- **Consistency**: Standards enforced uniformly across all RylanLabs projects
- **Scalability**: New repos bootstrap in seconds using `install-to-repo.sh`

### Anti-Pattern Avoided

Self-referential symlinks (Tier 0 consuming itself) are an architectural error. This repo is the
**source**, not a consumer.

---

## Symlink Strategy

### Target Pattern

```bash
rylanlabs-shared-configs/linting/.yamllint          ← Source (regular file)
rylanlabs-shared-configs/pre-commit/.pre-commit-config.yaml  ← Source

rylan-labs-common/.yamllint → ../rylanlabs-shared-configs/linting/.yamllint  ← Consumer symlink
rylan-labs-common/.pre-commit-config.yaml → ../rylanlabs-shared-configs/pre-commit/...
```

### Why Not Copy-Paste?

- **Maintenance burden**: Update config → manually push to 10+ repos
- **Drift risk**: Configs diverge, standards inconsistent
- **Git bloat**: 600% duplication (documented problem)

### Why Symlinks Work

- Lightweight: Git tracks as ~50-byte pointer
- Transparent: Tools (yamllint, pre-commit) resolve automatically
- Automatic: Update source → consumer pulls → instant inheritance

---

## Trinity Alignment

- **Carter (Identity)**: Enforces standard propagation via symlinks
- **Bauer (Audit)**: Validates via reusable workflows, cross-repo testing
- **Beale (Security)**: Centralized hardening configs, scanning rules

---

## Canonical Configurations

| File | Purpose | Consumer Target |
| ---- | ------- | --------------- |
| `linting/.yamllint` | YAML validation (120-char lines) | `.yamllint` |
| `linting/pyproject.toml` | Python (mypy --strict, ruff) | `pyproject.toml` |
| `linting/.shellcheckrc` | Bash validation | `.shellcheckrc` |
| `linting/.editorconfig` | IDE formatting | `.editorconfig` |
| `pre-commit/.pre-commit-config.yaml` | Pre-commit hooks (Gatekeeper v∞.5.2) | `.pre-commit-config.yaml` |

---

## Reusable Workflows

5 GitHub Actions workflows for consumer repos:

- `reusable-trinity-ci.yml`: Python + Bash + YAML + Ansible validation
- `reusable-python-validate.yml`: Python-only (mypy + ruff)
- `reusable-bash-validate.yml`: Bash-only (shellcheck + shfmt)
- `reusable-ansible-lint.yml`: Ansible validation
- `self-validate.yml`: Internal validation of this repo

**Usage**: Consumer repos call via `uses: RylanLabs/rylanlabs-shared-configs/.github/workflows/...@main`

---

## Audit Trail: Git-First

No log files. Execution history captured via:

- **Commits**: Each phase → commit message with details
- **Tags**: Phase boundaries marked with semantic tags (v1.0.0-phase-N-complete)
- **Git log**: View audit history via `git log --decorate --oneline`

**Bloat-free**: Text logs replaced with Git commits (already immutable, signed, distributed).

---

## Compliance Frameworks

✅ **Seven Pillars**: Idempotency, Error Handling, Functionality, Audit, Failure Recovery, Security,
Documentation

✅ **Trinity Pattern**: Carter + Bauer + Beale (Identity, Audit, Security)

✅ **Hellodeolu v6**: RTO <15min, Junior-Deployable, Human Confirm Gates, Zero PII

---

**Guardian**: Carter | **Ministry**: Identity
**Version**: v1.0.0 | **Maturity**: v1.0.1
