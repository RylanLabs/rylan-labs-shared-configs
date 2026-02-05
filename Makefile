# RylanLabs Repository Makefile
# Anchor: rylan-inventory
# Guardian: Bauer | Ministry: Oversight

-include common.mk

.PHONY: help validate clean warm-session org-audit mesh-man mesh-remediate repo-init cascade publish fetch reconcile

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

fetch: ## Domain: Discovery — Extract live state from UniFi Controller
	@chmod +x scripts/discovery-extract-unifi.sh
	@./scripts/discovery-extract-unifi.sh

reconcile: ## Domain: Audit — Compare live state vs device-manifest.yml
	@python3 scripts/audit-consensus-engine.py

warm-session: ## Establish 8-hour password-less GPG session
	@chmod +x scripts/warm-session.sh
	@./scripts/warm-session.sh

validate: ## Run Whitaker/Sentinel compliance gates
	@chmod +x scripts/validate.sh
	@./scripts/validate.sh

org-audit: ## Verify the status of the entire organizational mesh
	@chmod +x scripts/org-audit.sh
	@./scripts/org-audit.sh

mesh-man: ## Aggregate all repo targets into a single searchable document
	@chmod +x scripts/generate-mesh-man.sh
	@./scripts/generate-mesh-man.sh

mesh-remediate: ## Force all local repos back into compliance
	@chmod +x scripts/mesh-remediate.sh
	@./scripts/mesh-remediate.sh

repo-init: ## Unified entrance for creating or hard-fixing a repository
	@chmod +x scripts/repo-init.sh
	@./scripts/repo-init.sh

cascade: ## Topic-driven secret distribution across the mesh
	@chmod +x scripts/publish-cascade.sh
	@./scripts/publish-cascade.sh

publish: validate ## Heartbeat: Sign, Tag, and Push changes
	@git add .
	@read -p "Commit message: " msg; \
	git commit -S -m "$$msg"
	@git tag -s v$$(date +%Y%m%d-%H%M%S) -m "Mesh heartbeat"
	@git push origin main --tags

clean: ## Clean local artifacts
	@rm -rf .cache/ .tmp/ .audit/compliance/*
