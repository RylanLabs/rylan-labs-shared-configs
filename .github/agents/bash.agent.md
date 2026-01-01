# Agent Specification: Bash Overlay

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0

Language-specific rules for Bash script generation. Supplements universal `.agent.md`.

---

## Script Header Template

**Required for all Bash scripts** (Tier 0-1):

```bash
#!/usr/bin/env bash
# Guardian: Carter
# Ministry: Identity
# Maturity: v1.1.0
# Tag: descriptive-tag

set -euo pipefail
```

**Elements**:

- **Shebang**: `#!/usr/bin/env bash` (portable)
- **Guardian**: Carter, Bauer, or Beale
- **Ministry**: Identity, Audit, or Security
- **Maturity**: Semantic version (v1.1.0)
- **Tag**: Single descriptive keyword (bootstrap, validate, audit, etc.)

---

## Set Options

**`set -euo pipefail`** (Mandatory)

- **`-e`**: Exit immediately on error; don't continue executing
- **`-u`**: Fail if undefined variable is referenced
- **`-o pipefail`**: Pipeline fails if ANY command fails (not just the last)

**Example**:

```bash
#!/usr/bin/env bash
set -euo pipefail

# This will exit if config doesn't exist
config=$(cat config.yml)

# This will exit if grep finds nothing
target=$(echo "$config" | grep "^database:")
```

---

## Trap Handlers

**Mandatory**: All scripts must implement trap handlers.

**EXIT Trap**: Cleanup, runs unconditionally.
**ERR Trap**: Logging, runs only on error.

**Pattern**:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Trap setup
trap 'cleanup_on_exit' EXIT
trap 'log_error "Error at line $LINENO"' ERR

cleanup_on_exit() {
    local exit_code=$?
    # Remove temp files
    rm -f /tmp/bootstrap_* || true
    # Report status
    if [[ $exit_code -eq 0 ]]; then
        logger -t bootstrap "COMPLETED SUCCESSFULLY"
    else
        logger -t bootstrap "FAILED with exit code $exit_code"
    fi
    return $exit_code
}

log_error() {
    local msg="$1"
    logger -t bootstrap -p user.err "$msg"
}

main() {
    # Script logic
    echo "Starting bootstrap..."
}

main "$@"
```

---

## Variable Quoting (SC2086)

**Requirement**: ALL variable expansions MUST be quoted.

**Pattern**:

```bash
# ✅ CORRECT
echo "$filename"
ls -la "$directory"/*
for file in "${files[@]}"; do
    cat "$file"
done

# ❌ INCORRECT (SC2086)
echo $filename              # Unquoted
ls -la $directory/*         # Unquoted
for file in "${files[@]}"; do
    cat $file               # Unquoted
done
```

**Exceptions** (rare):

- Command substitution: `$(command)` (already safe)
- Word-splitting intentional (document with `# shellcheck disable=SC2086`)

---

## Function Guidelines

**Naming**: `snake_case_with_verbs`

```bash
# ✅ CORRECT
validate_config() { ... }
bootstrap_agent_specs() { ... }
log_error() { ... }

# ❌ INCORRECT
ValidateConfig() { ... }
bootstrap() { ... }
log() { ... }
```

**Max Length**: 120 lines per function.

**Single Responsibility**: One purpose per function.

**Early Returns**: Use early return pattern.

```bash
validate_path() {
    local path="$1"

    # Early exits for invalid states
    if [[ -z "$path" ]]; then
        log_error "Path is empty"
        return 1
    fi

    if [[ ! -e "$path" ]]; then
        log_error "Path does not exist: $path"
        return 1
    fi

    # Main logic
    echo "Path is valid: $path"
    return 0
}
```

---

## Exit Codes

**Standard**:

- **0**: Success
- **1**: General error
- **2+**: Specific error categories

**Example**:

```bash
INVALID_ARGS=2
MISSING_FILE=3
PERMISSION_ERROR=4

main() {
    if [[ $# -lt 1 ]]; then
        log_error "Usage: $0 <target>"
        return "$INVALID_ARGS"
    fi

    local target="$1"

    if [[ ! -f "$target" ]]; then
        log_error "File not found: $target"
        return "$MISSING_FILE"
    fi

    # Process
    return 0
}

main "$@"
```

---

## Error Messages

**Requirements**:

- Include function/script name
- Include context (file, line, variable value)
- Use stderr (redirect to `>&2`)
- Log for audit trail

**Pattern**:

```bash
log_error() {
    local msg="$1"
    local func="${FUNCNAME[1]}"
    echo "ERROR [$func]: $msg" >&2
    logger -t "${SCRIPT_NAME}" -p user.err "[$func] $msg"
}

validate_config() {
    local config_file="$1"

    if [[ ! -f "$config_file" ]]; then
        log_error "Config file not found: $config_file"
        return 1
    fi

    if ! grep -q "^[a-z_]*=" "$config_file"; then
        log_error "Invalid format in $config_file (expected KEY=VALUE)"
        return 1
    fi
}
```

---

## Common Patterns

### Idempotent File Operations

```bash
# ✅ CORRECT - Idempotent symlink creation
create_symlink() {
    local target="$1"
    local link="$2"

    if [[ -L "$link" ]]; then
        # Symlink exists
        local current_target=$(readlink "$link")
        if [[ "$current_target" == "$target" ]]; then
            log_info "Symlink already points to correct target: $link"
            return 0
        else
            log_error "Symlink points to wrong target: $current_target (expected $target)"
            return 1
        fi
    elif [[ -e "$link" ]]; then
        log_error "File exists (not symlink): $link"
        return 1
    fi

    # Create symlink
    ln -s "$target" "$link"
    log_info "Created symlink: $link -> $target"
}
```

### Arg Parsing

```bash
# ✅ CORRECT - Explicit flag handling
main() {
    local dry_run=false
    local verbose=false
    local target=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                dry_run=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            --target)
                target="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                return 1
                ;;
        esac
    done

    if [[ -z "$target" ]]; then
        log_error "Missing required option: --target"
        return 1
    fi

    # Process
    echo "Target: $target (dry_run=$dry_run, verbose=$verbose)"
}

main "$@"
```

### Logging Functions

```bash
# ✅ CORRECT - Structured logging
SCRIPT_NAME="$(basename "$0")"

log_info() {
    local msg="$1"
    echo "[INFO] $msg" >&2
    logger -t "$SCRIPT_NAME" -p user.info "$msg"
}

log_error() {
    local msg="$1"
    echo "[ERROR] $msg" >&2
    logger -t "$SCRIPT_NAME" -p user.err "$msg"
}

log_debug() {
    local msg="$1"
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        echo "[DEBUG] $msg" >&2
    fi
}
```

---

## ShellCheck Compliance

**Required**: Zero violations on Tier 0-1 scripts.

**Common Violations**:

- **SC2086**: Quote variables
- **SC2181**: Check `$?` on correct command
- **SC2046**: Quote command substitutions
- **SC2155**: Declare and assign separately

**Suppress Only When Justified**:

```bash
# shellcheck disable=SC2086
# Word splitting intentional for glob expansion
ls -la $pattern  # Variable intentionally unquoted
```

---

## Maturity Header Comments

**Update for each version**:

```bash
#!/usr/bin/env bash
# Guardian: Carter
# Ministry: Identity
# Maturity: v1.1.0
# Tag: bootstrap-agent-specs
# Description: Symlink agent specs into consumer repositories
```

---

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0
