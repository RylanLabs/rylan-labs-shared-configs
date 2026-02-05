# RylanLabs Mesh-Man: Operational manual

---
title: Mesh-Man Operational Manual
version: v2.1.0-mesh
guardian: Bauer
date: 2026-02-04
---

> [!IMPORTANT]
> This manual is auto-generated. It represents the SINGLE SOURCE OF TRUTH for all mesh operations.

## 🛡️ Core Infrastructure (Canon Library)
These targets are executed from the `rylan-canon-library` anchor.

```bash
[36mMakefile            [0m Topic-driven secret distribution across the mesh
[36mMakefile            [0m Clean local artifacts
[36mMakefile            [0m Domain: Discovery — Extract live state from UniFi Controller
[36mMakefile            [0m Show this help
[36mMakefile            [0m Aggregate all repo targets into a single searchable document
[36mMakefile            [0m Force all local repos back into compliance
[36mMakefile            [0m Verify the status of the entire organizational mesh
[36mMakefile            [0m Heartbeat: Sign, Tag, and Push changes
[36mMakefile            [0m Domain: Audit — Compare live state vs device-manifest.yml
[36mMakefile            [0m Unified entrance for creating or hard-fixing a repository
[36mMakefile            [0m Run Whitaker/Sentinel compliance gates
[36mMakefile            [0m Establish 8-hour password-less GPG session
[36mcommon.mk           [0m Show shared targets
[36mcommon.mk           [0m Run standard Whitaker gates
```

## 🌊 Satellite Standard Targets
All satellites inheriting `common.mk` support these standard targets:

| Target | Purpose | Guardian |
|--------|---------|----------|
| `validate` | Run Whitaker/Sentinel compliance gates | Bauer |
| `warm-session` | Establish GPG session for SOPS | Carter |
| `cascade` | Sync with Tier 0 Canon | Beale |
| `clean` | Purge local artifacts | - |

## 🧠 Architecture Reference
- [Seven Pillars](docs/seven-pillars.md): Core IaC principles
- [Trinity Execution](docs/trinity-execution.md): 5-Agent operational model
- [Hellodeolu v7](docs/hellodeolu-v7.md): Autonomous Governance Architecture
- [Mesh Paradigm](docs/eternal-glue.md): Multi-repo orchestration
