#!/usr/bin/env bash
# Guardian: Carter
# Ministry: Identity
# Maturity: v1.1.0
# Tag: bootstrap-agent-specs

set -euo pipefail

# Configuration
SHARED_CONFIGS_PATH="${SHARED_CONFIGS_PATH:-../rylanlabs-shared-configs}"
DRY_RUN=false
AUDIT_LOG=".audit/agent-bootstrap.log"
SCRIPT_NAME="$(basename "$0")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Error handling
trap 'cleanup_on_exit' EXIT
trap 'log_error "Script failed at line $LINENO"; exit 1' ERR

cleanup_on_exit() {
  local exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    log_info "Bootstrap completed successfully"
  else
    log_error "Bootstrap failed with exit code $exit_code"
  fi
  return $exit_code
}

# Logging functions
log_info() {
  local msg="$1"
  echo -e "${GREEN}[INFO]${NC} $msg" >&2
  mkdir -p "$(dirname "$AUDIT_LOG")"
  echo "{\"timestamp\": \"$(date -Iseconds)\", \"level\": \"INFO\", \"message\": \"$msg\"}" >> "$AUDIT_LOG"
}

log_error() {
  local msg="$1"
  echo -e "${RED}[ERROR]${NC} $msg" >&2
  mkdir -p "$(dirname "$AUDIT_LOG")"
  echo "{\"timestamp\": \"$(date -Iseconds)\", \"level\": \"ERROR\", \"message\": \"$msg\"}" >> "$AUDIT_LOG"
}

log_warning() {
  local msg="$1"
  echo -e "${YELLOW}[WARN]${NC} $msg" >&2
  mkdir -p "$(dirname "$AUDIT_LOG")"
  echo "{\"timestamp\": \"$(date -Iseconds)\", \"level\": \"WARN\", \"message\": \"$msg\"}" >> "$AUDIT_LOG"
}

log_debug() {
  local msg="$1"
  if [[ "${VERBOSE:-false}" == "true" ]]; then
    echo -e "${BLUE}[DEBUG]${NC} $msg" >&2
  fi
}

# Validation functions
validate_shared_configs() {
  log_debug "Validating shared-configs repository..."

  if [[ ! -d "$SHARED_CONFIGS_PATH" ]]; then
    log_error "Shared-configs directory not found: $SHARED_CONFIGS_PATH"
    return 1
  fi

  if [[ ! -d "$SHARED_CONFIGS_PATH/.github/agents" ]]; then
    log_error "Agent specs not found in shared-configs: $SHARED_CONFIGS_PATH/.github/agents"
    return 1
  fi

  if [[ ! -d "$SHARED_CONFIGS_PATH/.github/instructions" ]]; then
    log_error "Instructions not found in shared-configs: $SHARED_CONFIGS_PATH/.github/instructions"
    return 1
  fi

  log_info "Shared-configs validated: $SHARED_CONFIGS_PATH"
}

validate_target_paths() {
  log_debug "Validating target paths in consumer repository..."

  local pwd
  pwd="$(pwd)"
  if [[ "$pwd" == *"rylan-labs-shared-configs"* ]]; then
    log_error "Cannot run bootstrap in shared-configs repository itself"
    return 1
  fi

  log_info "Target repository: $pwd"
}

# Symlink creation
create_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  log_debug "Creating symlink: $target → $source"

  # Check if symlink already exists
  if [[ -L "$target" ]]; then
    local current_target
    current_target=$(readlink "$target")
    if [[ "$current_target" == "$source" ]]; then
      log_info "Symlink already correct: $target"
      return 0
    else
      log_error "Symlink exists but points to wrong target: $target → $current_target (expected $source)"
      return 1
    fi
  fi

  # Check if regular file exists
  if [[ -e "$target" ]]; then
    log_error "File exists (not symlink): $target"
    return 1
  fi

  # Create symlink
  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Would create symlink: $target → $source"
  else
    ln -s "$source" "$target"
    log_info "Created symlink: $target ($description)"
  fi
}

# Bootstrap functions
bootstrap_universal() {
  log_info "Bootstrapping universal agent specs..."

  local source_agent
  source_agent="$(cd "$SHARED_CONFIGS_PATH" && pwd)/.github/agents/.agent.md"
  local source_instructions
  source_instructions="$(cd "$SHARED_CONFIGS_PATH" && pwd)/.github/instructions/.instructions.md"

  create_symlink "$source_agent" ".agent.md" "Universal rules"
  create_symlink "$source_instructions" ".instructions.md" "Seven Pillars enforcement"

  log_info "Universal specs bootstrapped"
}

bootstrap_overlays() {
  log_info "Bootstrapping language overlays (optional)..."

  local base_path
  base_path="$(cd "$SHARED_CONFIGS_PATH" && pwd)/.github/agents"

  # Python overlay
  if [[ -f "$base_path/python.agent.md" ]]; then
    create_symlink "$base_path/python.agent.md" ".agent.python.md" "Python overlay"
  fi

  # Bash overlay
  if [[ -f "$base_path/bash.agent.md" ]]; then
    create_symlink "$base_path/bash.agent.md" ".agent.bash.md" "Bash overlay"
  fi

  # Markdown overlay
  if [[ -f "$base_path/markdown.agent.md" ]]; then
    create_symlink "$base_path/markdown.agent.md" ".agent.markdown.md" "Markdown overlay"
  fi

  # YAML overlay
  if [[ -f "$base_path/yaml.agent.md" ]]; then
    create_symlink "$base_path/yaml.agent.md" ".agent.yaml.md" "YAML overlay"
  fi

  log_info "Language overlays bootstrapped"
}

bootstrap_vscode_config() {
  log_info "Bootstrapping VS Code configuration (optional)..."

  local templates_path
  templates_path="$(cd "$SHARED_CONFIGS_PATH" && pwd)/.github/templates/.vscode"

  if [[ ! -d "$templates_path" ]]; then
    log_warning "VS Code templates not found in shared-configs"
    return 0
  fi

  # Create .vscode directory
  if [[ ! -d ".vscode" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log_info "[DRY-RUN] Would create directory: .vscode"
    else
      mkdir -p ".vscode"
      log_info "Created directory: .vscode"
    fi
  fi

  # Copy settings.json
  if [[ -f "$templates_path/settings.json" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log_info "[DRY-RUN] Would copy settings.json to .vscode/"
    else
      cp "$templates_path/settings.json" ".vscode/settings.json"
      log_info "Copied VS Code settings.json"
    fi
  fi

  # Copy extensions.json
  if [[ -f "$templates_path/extensions.json" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log_info "[DRY-RUN] Would copy extensions.json to .vscode/"
    else
      cp "$templates_path/extensions.json" ".vscode/extensions.json"
      log_info "Copied VS Code extensions.json"
    fi
  fi
}

# Verification
verify_symlinks() {
  log_info "Verifying symlinks..."

  local errors=0

  if [[ ! -L ".agent.md" ]]; then
    log_error "Symlink verification failed: .agent.md not a symlink"
    ((errors++))
  else
    log_info "✓ .agent.md is valid symlink"
  fi

  if [[ ! -L ".instructions.md" ]]; then
    log_error "Symlink verification failed: .instructions.md not a symlink"
    ((errors++))
  else
    log_info "✓ .instructions.md is valid symlink"
  fi

  if [[ $errors -gt 0 ]]; then
    return 1
  fi

  log_info "All symlinks verified successfully"
}

# Main function
main() {
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=true
        log_info "Dry-run mode enabled (no changes will be made)"
        shift
        ;;
      -v | --verbose)
        export VERBOSE=true
        shift
        ;;
      -s | --shared-configs)
        SHARED_CONFIGS_PATH="$2"
        shift 2
        ;;
      -h | --help)
        print_help
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        print_help
        return 1
        ;;
    esac
  done

  # Run bootstrap
  log_info "================================================"
  log_info "Agent Specifications Bootstrap"
  log_info "Guardian: Carter | Maturity: v1.1.0"
  log_info "================================================"

  validate_shared_configs || return 1
  validate_target_paths || return 1

  bootstrap_universal || return 1
  bootstrap_overlays || return 1
  bootstrap_vscode_config || return 1

  verify_symlinks || return 1

  log_info "================================================"
  log_info "Bootstrap completed successfully!"
  log_info "================================================"
  log_info ""
  log_info "Next steps:"
  log_info "1. Reload VS Code (Cmd+Shift+P → 'Reload Window')"
  log_info "2. Verify Copilot uses agent specs for suggestions"
  log_info "3. Review .agent.md and .instructions.md for guidelines"

  if [[ -f ".vscode/settings.json" ]]; then
    log_info "4. VS Code configured with Copilot integration"
  fi
}

print_help() {
  cat << EOF
Bootstrap agent specifications into consumer repository

Usage:
    $SCRIPT_NAME [OPTIONS]

Options:
    --dry-run              Show what would be done without making changes
    -v, --verbose          Enable debug output
    -s, --shared-configs   Path to shared-configs repo (default: ../rylanlabs-shared-configs)
    -h, --help             Show this help message

Examples:
    # Standard bootstrap
    ../rylanlabs-shared-configs/scripts/$SCRIPT_NAME

    # Preview changes
    ../rylanlabs-shared-configs/scripts/$SCRIPT_NAME --dry-run

    # Custom shared-configs path
    ../rylanlabs-shared-configs/scripts/$SCRIPT_NAME -s /path/to/shared-configs

    # Verbose output
    ../rylanlabs-shared-configs/scripts/$SCRIPT_NAME -v

Guardian: Carter | Maturity: v1.1.0
EOF
}

main "$@"
