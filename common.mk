# rylan-labs-common/common.mk
# Guardian: Bauer | Ministry: Oversight
# Shared logic for the RylanLabs Mesh Substrate

# --- Constants ---
DOMAIN_NAME := rylanlabs.io
GPG_KEY_ID  := F5FFF5CB35A8B1F38304FC28AC4A4D261FD62D75

# --- Terminal Styling ---
B_CYAN  := \033[1;36m
B_GREEN := \033[1;32m
B_RED   := \033[1;31m
NC      := \033[0m

# --- Shared Helpers ---
define log_info
	@echo "$(B_CYAN)[INFO]$(NC) $(1)"
endef

define log_success
	@echo "$(B_GREEN)[OK]$(NC) $(1)"
endef

define log_error
	@echo "$(B_RED)[FAIL]$(NC) $(1)"
endef

# --- Common Targets ---
.PHONY: help-common validate-common

help-common: ## Show shared targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(lastword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

validate-common: ## Run standard Whitaker gates
	@$(call log_info, "Checking mandatory files...")
	@for file in Makefile README.md .gitleaks.toml; do \
		if [ ! -f "$$file" ]; then \
			$(call log_error, "Missing $$file"); \
			exit 1; \
		fi; \
	done
	@$(call log_success, "Basic scaffolding valid.")
