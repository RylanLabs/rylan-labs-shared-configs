# Canon Integration Architecture

**Repository**: rylanlabs-shared-configs
**Canon Version**: v2.0.0
**Integration Date**: 2026-01-14
**Status**: ✅ Phase 1-5 Complete | Phase 6 Pending

---

## Dual Role Overview

The `rylanlabs-shared-configs` repository serves **two distinct roles** in the RylanLabs ecosystem:

### Role 1: Consumer of Canon Enforcement ✅

- **Inherits** canon disciplines (vault, rotation, security, network, API, playbook patterns)
- **Inherits** canon validation scripts (bash, ansible, yaml, python)
- **Symlinks** to canon library for immutable enforcement patterns
- **Validates** via `audit-canon.sh` (zero-drift detection)

### Role 2: Source of Linting Configs 📦

- **Provides** `.yamllint` to all downstream repos (labs-common, iac, network-iac)
- **Provides** `pyproject.toml` for Python linting consistency
- **Provides** `.shellcheckrc` for Bash consistency
- **Is the authority** on linting standards across Tier 1-3 repositories

#### Why Dual Role?

- Linting configs are org-wide standards (not subject to canon enforcement)
- Canon is an **enforcement engine**, not the linting config library
- Shared-configs eliminates 600% duplication via symlinks **from** it
- Separate concerns: Canon enforces discipline; shared-configs enforces consistency

---

## Architecture Diagram

```text
┌─────────────────────────────────────────────────────────────────┐
│                   RylanLabs Tier 0                              │
│                  Shared Configs Integration                      │
└─────────────────────────────────────────────────────────────────┘

                    rylan-canon-library v2.0.0
                    (Tier 0 Enforcement Engine)
                             │
                ┌────────────┼────────────┐
                │            │            │
         Disciplines      Scripts    Templates
         (*.md files)  (validate-*) (config.template)
                │            │            │
                └────────────┼────────────┘
                             ↓
        rylanlabs-shared-configs (Tier 0 Source)
        ┌────────────────────────────────────────┐
        │ Consumer Role:                         │
        │  docs/*.md → SYMLINKS                  │
        │  scripts/validate-* → SYMLINKS         │
        │  scripts/linters → SYMLINKS            │
        │                                        │
        │ Source Role:                           │
        │  .yamllint → LOCAL (Original)          │
        │  pyproject.toml → LOCAL                │
        │  .shellcheckrc → LOCAL                 │
        └────────────────────────────────────────┘
                      ↓         ↓         ↓
        ┌─────────────┼─────────┼──────────┐
        │             │         │          │
    labs-common    labs-iac  network-iac  other
    (symlink to  (symlink to (symlink to  (symlink to
    .yamllint)   .yamllint)  .yamllint)   .yamllint)
```

---

## Symlink Map

### Consumer Symlinks (FROM Canon)

#### Disciplines (`docs/`)

| File | Canonical Source | Type | Immutable |
|------|------------------|------|-----------|
| `ansible-vault-discipline.md` | `canon/docs/ansible-vault-discipline.md` | Symlink | ✅ Yes |
| `rotation-discipline.md` | `canon/docs/rotation-discipline.md` | Symlink | ✅ Yes |
| `security-posture-discipline.md` | `canon/docs/security-posture-discipline.md` | Symlink | ✅ Yes |
| `network-versioning-discipline.md` | `canon/docs/network-versioning-discipline.md` | Symlink | ✅ Yes |
| `api-coverage-discipline.md` | `canon/docs/api-coverage-discipline.md` | Symlink | ✅ Yes |
| `trinity-execution.md` | `canon/docs/trinity-execution.md` | Symlink | ✅ Yes |

#### Validation Scripts (`scripts/`)

| File | Canonical Source | Type | Immutable |
|------|------------------|------|-----------|
| `validate-rotation-readiness.sh` | `canon/scripts/validate-rotation-readiness.sh` | Symlink | ✅ Yes |
| `validate-security-posture.sh` | `canon/scripts/validate-security-posture.sh` | Symlink | ✅ Yes |
| `validate-bash.sh` | `canon/scripts/validate-bash.sh` | Symlink | ✅ Yes |
| `validate-ansible.sh` | `canon/scripts/validate-ansible.sh` | Symlink | ✅ Yes |
| `validate-yaml.sh` | `canon/scripts/validate-yaml.sh` | Symlink | ✅ Yes |
| `validate-python.sh` | `canon/scripts/validate-python.sh` | Symlink | ✅ Yes |
| `playbook-structure-linter.py` | `canon/scripts/playbook-structure-linter.py` | Symlink | ✅ Yes |
| `track-endpoint-coverage.py` | `canon/scripts/track-endpoint-coverage.py` | Symlink | ✅ Yes |

### Source Files (LOCAL - NOT Symlinked)

#### Linting Configs (Root)

| File | Role | Consumer Repos | Status |
|------|------|----------------|--------|
| `.yamllint` | Source of truth | labs-common, labs-iac, network-iac | 📦 Provided |
| `pyproject.toml` | Python linting authority | All downstream | 📦 Provided |
| `.shellcheckrc` | Bash linting authority | All downstream | 📦 Provided |
| `.editorconfig` | IDE standardization | All downstream | 📦 Provided |
| `.markdownlint.yaml` | Markdown standards | All downstream | 📦 Provided |

---

## Documented Overrides (Dual Role Reconciliation)

### Override 1: `.yamllint` (LOCAL, Not Symlinked from Canon)

**Reason**: Shared-configs is the Tier 0 **linting SOURCE**, not a canon consumer.

**Details**:

```yaml
# Shared-configs .yamllint
rules:
  line-length:
    max: 160              # ← SOURCE setting for all downstream repos
    level: error

# Canon .yamllint (for reference)
rules:
  line-length:
    max: 120              # ← Canon standard (different purpose)
    level: warning
```

**Justification**:

- Downstream repos symlink **FROM** `shared-configs/.yamllint` (not from canon)
- Line length 160 is intentional for shared-configs authorship
- Path aligned to root (/) to match Canon manifest standard
- Zero-drift enforcement via `audit-canon-drift` job

**Guardian Approval**: Carter (Identity - symlink source integrity)

### Override 2: `pyproject.toml` (LOCAL, Not Symlinked from Canon)

**Reason**: Python linting config is primary export to downstream repos.

**Details**:

```toml
# Shared-configs pyproject.toml
[tool.ruff]
line-length = 160

# Matches .yamllint for consistency across all linters
```

**Guardian Approval**: Bauer (Auditing - linting consistency across Tier 1-3)

---

## CI/CD Integration

### Phase 0: Canon Drift Detection (`audit-canon-drift` job)

- ✅ Validates all symlinks to canon are intact
- ✅ Confirms canon library v2.0.0 availability
- ✅ Checks `.canon-metadata.yml` exists
- ✅ Runs on: push to main, PRs
- ✅ Path Alignment: All sacred files aligned to manifest destinations (docs/, scripts/, /)

### Phase 1: Linting Validation (`validate-disciplines` job)

- ✅ Validates `.yamllint` syntax and functionality
- ✅ Confirms linting configs are LOCAL (not symlinks)
- ✅ Tests downstream consumer compatibility
- ✅ Documents dual role in CI logs
- ✅ Runs on: push to main, PRs

### Workflow File

- **Location**: `.github/workflows/self-validate.yml`
- **Key Jobs**:
  - `audit-canon-drift` (Phase 0)
  - `validate` (Phase 1 - Trinity validation)
  - `validate-disciplines` (Phase 1 - Linting compatibility)
  - `ci-summary-canon-integrated` (Reporting)

---

## Sync Process

### Initial Integration (One-Time, Completed)

```bash
# Phase 1: Bootstrap
cd ~/repos/rylan-labs-shared-configs

# 1. Create symlinks to canon
mkdir -p docs scripts
ln -sf ../rylan-canon-library/docs/ansible-vault-discipline.md docs/
ln -sf ../rylan-canon-library/docs/rotation-discipline.md docs/
# ... (8 more discipline/script symlinks)

# 2. Preserve local linting configs (aligned to root)
mv linting/.yamllint .
mv linting/pyproject.toml .

# 3. Document overrides
cat > .canon-metadata.yml << 'EOF'
canon_version: "2.0.0"
integration_date: "2026-01-14"
role:
  - consumer: "Inherits canon disciplines and validation scripts"
  - source: "Provides linting configs to downstream repos"
overrides:
  - file: ".yamllint"
    reason: "Shared-configs is linting SOURCE, not consumer"
EOF
```

### Ongoing Maintenance (After Initial Integration)

#### When Canon Library Updates

```bash
# 1. Check for updates
cd ~/repos/rylan-canon-library
git fetch
git tag -l | grep "^v[0-9]" | sort -V | tail -5

# 2. Update symlink targets (automatic via relative paths)
# Relative symlinks self-update when canon repo updates

# 3. Run audit to detect drift
cd ~/repos/rylanlabs-shared-configs
/path/to/canon/scripts/audit-canon.sh .

# 4. Document if version changed
vim .canon-metadata.yml
# Update: integration_date, canon_version
```

#### When Linting Configs Need Updates

```bash
# 1. Update local configs (shared-configs maintains authority)
vim linting/.yamllint
vim linting/pyproject.toml

# 2. Test locally
make ci-local

# 3. Notify downstream repos
# Email: "Linting config updated in shared-configs v1.2.1"
# Action: Downstream repos auto-consume via symlinks

# 4. Commit with clear message
git commit -m "refactor(linting): Update .yamllint rules for compliance"
```

#### When Canon Adds New Sacred Files

```bash
# 1. Review canon-manifest.yaml
cat ~/repos/rylan-canon-library/canon-manifest.yaml | grep sacred_files

# 2. Add symlinks for NEW disciplines/scripts
ln -sf ../../rylan-canon-library/docs/new-discipline.md docs/disciplines/

# 3. Update .canon-metadata.yml
# Add new symlink entry with canonical path

# 4. Run validation
./.github/workflows/self-validate.yml (via `make ci-local`)

# 5. Commit
git commit -m "feat(canon): Add new discipline symlinks (canon v2.0.1)"
```

---

## Downstream Consumer Integration

### For Existing Downstream Repos (e.g., `rylan-labs-common`)

**No Changes Required** ✅

Your symlinks continue to work:

```bash
ls -la /path/to/labs-common/.yamllint
# → /path/to/rylanlabs-shared-configs/linting/.yamllint

# The source (.yamllint) is still LOCAL in shared-configs
# The path resolution is unchanged
```

### For New Tier 1-3 Repos

**Use `install-to-repo.sh`**

```bash
cd ~/repos/new-tier-1-repo
../rylanlabs-shared-configs/scripts/install-to-repo.sh . ../rylanlabs-shared-configs

# This symlinks:
# - .yamllint → ../rylanlabs-shared-configs/linting/.yamllint
# - pyproject.toml → ../rylanlabs-shared-configs/linting/pyproject.toml
# - .shellcheckrc → ../rylanlabs-shared-configs/linting/.shellcheckrc
# - (and pre-commit config)
```

---

## Validation Strategy

### Pre-Commit (Local Developer)

```bash
# Symlinks are valid
ls -l docs/disciplines/ scripts/validate-*.sh
# All should be blue (symlinks)

# Linting configs are LOCAL
ls -L linting/.yamllint
# Should NOT be a symlink

# Canon metadata exists
cat .canon-metadata.yml | head -5
```

### CI/CD (automated)

**Job: `audit-canon-drift`**

- Clones `rylan-canon-library v2.0.0`
- Validates all symlink targets exist
- Confirms no broken links

**Job: `validate-disciplines`**

- Tests `.yamllint` functionality
- Confirms linting configs are LOCAL
- Documents dual role

**Job: `ci-summary-canon-integrated`**

- Reports status of both phases
- Confirms downstream compatibility
- Guardian alignment verification

### Manual Verification (Post-Integration)

```bash
# 1. Check symlinks
readlink -f docs/disciplines/ansible-vault-discipline.md
# Should resolve to: /home/egx570/repos/rylan-canon-library/docs/...

# 2. Check linting source
file linting/.yamllint
# Should output: "linting/.yamllint: ASCII text"

# 3. Verify downstream repos still work
cd ~/repos/rylan-labs-common
head -1 .yamllint
# Should show: ---

# 4. Run canon audit
cd ~/repos/rylan-canon-library
./scripts/audit-canon.sh ~/repos/rylanlabs-shared-configs
# Expected: "Grade: A (100/100)" or "Grade: A (97/100)" with documented exceptions
```

---

## Guardian Alignment

### Carter (Identity)

**Principle**: Identity is programmable infrastructure
**Role**: Symlink integrity, bootstrap authority
**Validation**:

- ✅ All 14 symlinks verified as valid
- ✅ Relative paths ensure portability
- ✅ No circular dependencies
- ✅ Downstream symlink chains unbroken

### Bauer (Auditor)

**Principle**: Trust nothing, verify everything
**Role**: Drift detection, linting compliance
**Validation**:

- ✅ Documented overrides tracked in `.canon-metadata.yml`
- ✅ `audit-canon-drift` job validates in CI
- ✅ Linting config compatibility verified
- ✅ Zero-drift for symlinked files (exceptions documented)

### Beale (Bastille)

**Principle**: The network is the first line of defense
**Role**: Security posture, no-bypass enforcement
**Validation**:

- ✅ Local linting configs are intentional (not bypass)
- ✅ Canon enforcement scripts symlinked (not editable)
- ✅ Pre-commit hooks include security checks
- ✅ No accidental exposure of canon enforcement mechanisms

---

## Troubleshooting

### Problem: Symlink is Broken

```bash
# Check if target exists in canon
readlink -f docs/disciplines/ansible-vault-discipline.md
# ls /target/path
# If missing: Canon library may not be cloned at expected path
```

**Solution**:

```bash
# Verify canon library location
ls ~/repos/rylan-canon-library/docs/ansible-vault-discipline.md
# Should exist and be readable
```

### Problem: Linting Config Not Being Used

**Check if it's a symlink (it shouldn't be)**:

```bash
file linting/.yamllint
# If output says "symbolic link" → ERROR
# If output says "ASCII text" → CORRECT
```

**Fix**:

```bash
cd linting
rm .yamllint
# Restore from git
git checkout .yamllint
```

### Problem: Downstream Repo Can't Find Shared-Configs

**Check symlink chain**:

```bash
cd ~/repos/rylan-labs-common
readlink -f .yamllint
# Should resolve to: /home/egx570/repos/rylanlabs-shared-configs/linting/.yamllint

# If not: Recreate symlink
rm .yamllint
ln -sf ../rylanlabs-shared-configs/linting/.yamllint .yamllint
```

---

## Glossary

| Term | Definition |
|------|-----------|
| **Canon Library** | Tier 0 enforcement engine (v2.0.0) - source of disciplines & validators |
| **Shared-Configs** | Tier 0 source repository - provides linting configs to downstream |
| **Consumer Symlinks** | Shared-configs consuming canon disciplines/scripts (14 symlinks) |
| **Source Symlinks** | Downstream repos consuming shared-configs linting configs |
| **Immutable Override** | Documented exception to canon enforcement (2: .yamllint, pyproject.toml) |
| **Dual Role** | Shared-configs is both canon consumer AND linting source |
| **Drift Detection** | `audit-canon.sh` validates symlink targets haven't changed |
| **Guardian** | Authority figure (Carter/Bauer/Beale) for specific domains |

---

## Related Documentation

- [Canon Library Integration Guide](https://github.com/RylanLabs/rylan-canon-library/docs/INTEGRATION_GUIDE.md)
- [Canon Manifest](https://github.com/RylanLabs/rylan-canon-library/canon-manifest.yaml)
- [Shared-Configs Bootstrap Script](./scripts/install-to-repo.sh)
- [Integration Metadata](./.canon-metadata.yml)
- [Integration CHANGELOG](./docs/CHANGELOG.md) (Phase 1-3 entries)

---

## References

- **Canon Version**: v2.0.0 (Tier 0 Enforcement Engine)
- **Shared-Configs Version**: v1.2.0-canon-integrated (Tier 0 Source)
- **Integration Date**: 2026-01-14
- **Last Updated**: 2026-01-14
- **Status**: ✅ Production Ready

---

> *The Trinity endures. Fortress eternal. 🛡️*
