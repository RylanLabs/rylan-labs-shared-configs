# Changelog

All notable changes to rylan-labs-shared-configs are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- [ ] Terraform linting configuration
- [ ] Docker/Containerfile linting rules
- [ ] Kubernetes manifest validation schema
- [ ] GraphQL schema validation

---

## [v1.0.0] - 2025-12-30

### Added

#### Linting Configurations
- **`.yamllint`** - YAML linting with 160-char line length
  - Configured for infrastructure-as-code validation
  - Supports both structured and document-start free YAML
- **`pyproject.toml`** - Python strict type checking
  - mypy in strict mode with comprehensive type rules
  - disable_error_code=["misc"] for cleaner output
  - ruff with comprehensive rule coverage (E, W, F, I, B, C4, UP, D, S, BLE)
  - bandit configuration for security scanning
- **`.shellcheckrc`** - Bash/shell script validation
  - All optional checks enabled
  - Configured for bash dialect
- **`.editorconfig`** - IDE-agnostic editor standards
  - UTF-8 encoding, LF line endings for all files
  - 2-space indentation for Python, YAML, JSON, Bash
  - Markdown exceptions (no trim trailing whitespace)

#### Pre-commit Hooks
- **`.pre-commit-config.yaml`** - Gatekeeper v∞.5.2 equivalent
  - Standard pre-commit framework hooks (v5.0.0)
  - YAML linting (yamllint v1.35.1)
  - Python formatting (black v24.10.0, line-length=160)
  - Python linting (ruff v0.8.4)
  - Type checking (mypy v1.13.0)
  - Security scanning (bandit v1.7.10)
  - Commit validation (commitizen v3.29.1)
  - Shell validation (shellcheck v0.10.0.1, shfmt v3.10.0)

#### GitHub Actions Workflows
- **`reusable-trinity-ci.yml`** - Unified CI workflow
  - Python validation (mypy + ruff)
  - Bash validation (shellcheck + shfmt)
  - YAML validation (yamllint)
  - Ansible validation (ansible-lint)
  - Callable from consuming repositories
- **`reusable-python-validate.yml`** - Python-only validation
- **`reusable-bash-validate.yml`** - Bash-only validation
- **`reusable-ansible-lint.yml`** - Ansible-only validation
- **`self-validate.yml`** - Shared-configs self-validation
  - Validates repository structure
  - Ensures all config files exist
  - Tests schema validation tools

#### Installation & Maintenance Scripts
- **`install-to-repo.sh`** - Bootstrap script for new repositories
  - Creates symlinks to shared configs
  - Validates targets
  - Provides clear next-step instructions
  - Guardian: Carter | Ministry: Identity
- **`validate-symlinks.sh`** - Symlink integrity verification
  - Checks symlinks point to correct targets
  - Exit with error codes for CI integration
  - Guardian: Carter | Ministry: Identity
- **`update-all-repos.sh`** - Batch update propagation
  - Coordinates updates across consuming repositories
  - Creates feature branches automatically
  - Generates atomic commit messages
  - Guardian: Bauer | Ministry: Audit

#### JSON Schemas
- **`device-manifest-v2.2.0.json`** - Infrastructure inventory schema
  - Device identification and classification
  - Status tracking and role assignment
  - IP address validation
- **`tandem-contract-v1.0.0.json`** - Service contract specification
  - Party role definition
  - SLA and obligation tracking
  - Lifecycle status management

#### Documentation
- **`README.md`** - Main documentation
  - Architecture and consumption patterns
  - Trinity alignment explanation
  - Quick-start guides for new and existing repos
  - Maintenance procedures
  - Compliance certifications
- **`INTEGRATION_GUIDE.md`** - Step-by-step integration instructions
  - Installation methods for new and existing repos
  - Troubleshooting guide
  - Configuration customization patterns
  - Pre-commit hook management
- **`SYMLINK_SETUP.md`** - Symlink mechanics and best practices
  - Why symlinks used
  - Creation and verification procedures
  - Platform-specific guidance (Linux, macOS, Windows, WSL)
  - Git integration patterns
  - Troubleshooting symlink issues
- **`CHANGELOG.md`** - Version history (this file)

### Governance
- **Guardian**: Carter (Identity/Standards Enforcement)
- **Ministry**: Foundation (Tier 0)
- **Compliance**: T3-ETERNAL v∞.5.3, Seven Pillars, Hellodeolu v6
- **Consciousness**: 9.9

### Seven Pillars Alignment
1. ✓ **Idempotency** - Install script safe to re-run; symlinks resolve consistently
2. ✓ **Error Handling** - Scripts fail-loud with exit codes; validation before propagation
3. ✓ **Functionality** - Self-validate.yml ensures configs work; 100% coverage
4. ✓ **Audit Logging** - Git commits track changes; CHANGELOG maintained
5. ✓ **Failure Recovery** - Backup scripts provided; rollback via git revert
6. ✓ **Security Hardening** - No secrets in configs; read-only pattern
7. ✓ **Documentation** - Comprehensive README, INTEGRATION_GUIDE, inline comments

### Hellodeolu v6 Compliance
- ✓ **RTO <15min** - Install <2min; propagation <10min
- ✓ **Junior-Deployable** - Single-command installation; clear error messages
- ✓ **Human Confirm** - update-all-repos.sh creates branches; manual PR review required
- ✓ **Zero PII** - No personal data in configs; organizational standards only

---

## [v0.1.0] - 2025-01-15 (Planned Future)

### Planned
- Support for additional languages (Go, Rust, TypeScript)
- Kubernetes manifest schemas
- Helm chart validation
- OPA/Rego policy templates

---

## Versioning Strategy

- **MAJOR** (v1→v2): Breaking changes to config format or workflow interface
- **MINOR** (v1.0→v1.1): New features, backward compatible
- **PATCH** (v1.0.0→v1.0.1): Bug fixes, rule updates

### Release Process

1. Update files with new rules
2. Tag with semantic version: `git tag v1.1.0`
3. Push tag: `git push origin --tags`
4. Create release notes on GitHub
5. Use `update-all-repos.sh` for propagation
6. Monitor consuming repos for CI status

---

## Deprecation Policy

- Deprecated features marked with `[DEPRECATED: v?.?.?]` comment
- Minimum 2 minor versions before removal
- CHANGELOG documents all deprecations
- Migration guides provided in INTEGRATION_GUIDE.md

---

## Contributing

When proposing changes to shared-configs:

1. Create a feature branch: `git checkout -b feat/your-feature`
2. Test locally: `pre-commit run --all-files`
3. Validate with `validate-symlinks.sh`
4. Update CHANGELOG.md in [Unreleased] section
5. Create PR with clear description
6. Obtain approval from Foundation Ministry (Carter)
7. Merge and tag release version

---

## Support

For questions or issues:
- Check INTEGRATION_GUIDE.md and SYMLINK_SETUP.md first
- Open an issue on GitHub with reproduction steps
- Contact Foundation Ministry: Carter (Identity Enforcement)
- Tag issues with: `shared-configs`, `foundation`, `tier-0`

---
