# Agent Specification: YAML Overlay

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0

Language-specific rules for YAML generation. Supplements universal `.agent.md`.

---

## Line Length

**Limits**:

- **Playbooks** (Ansible): 140 characters max
- **Configuration Files**: 120 characters max
- **Rationale**: Infrastructure-as-code often has long values (URLs, command strings, paths)

**Wrapping**:

```yaml
# ✅ CORRECT - Wrapped to ~135 chars
vars:
  long_command: |
    /usr/local/bin/complex-command --option1=value1 --option2=value2 \
      --option3=value3 --output=/path/to/file

# ❌ INCORRECT - Very long single line
vars:
  long_command: /usr/local/bin/complex-command --option1=value1 --option2=value2 --option3=value3 --output=/path/to/file
```

---

## Indentation

**Standard**: 2 spaces (no tabs).

**Consistency**: All levels must align properly.

**Example**:

```yaml
# ✅ CORRECT - Consistent 2-space indentation

root:
  child1:
    grandchild: value
    grandchild2: value2
  child2:
    grandchild: value

# ❌ INCORRECT - Inconsistent indentation

root:
   child1:          # 3 spaces (wrong)
    grandchild: value
  child2:           # 2 spaces (inconsistent)
     grandchild: value  # 5 spaces (wrong)
```

---

## Quoting

**Strings with Special Characters**: MUST be quoted.

**Pattern**:

```yaml
# ✅ CORRECT

name: "node-01"
port: "8080"
enabled: true           # Boolean (not quoted)
count: 42               # Number (not quoted)
message: "Hello: World" # Contains colon
path: "/etc/config.yml"
command: "echo $HOME"   # Contains special char

# ❌ INCORRECT

name: node-01           # Should be quoted
port: 8080              # Should be quoted (if string)
enabled: yes            # Should use true/false
message: Hello: World   # Colon needs quoting
```

---

## Booleans

**Standard**: Use `true` or `false` (lowercase).

**Never**: `yes`, `no`, `on`, `off`, or `True`/`False`.

**Example**:

```yaml
# ✅ CORRECT

services:
  - name: "apache"
    enabled: true
    restart_on_failure: false
  - name: "nginx"
    enabled: true

# ❌ INCORRECT

services:
  - name: "apache"
    enabled: yes
    restart_on_failure: no
  - name: "nginx"
    enabled: True
```

---

## Comments

**Format**: `#` followed by space, then comment text.

**Placement**: Above relevant line or inline.

```yaml
# ✅ CORRECT

# Configure API endpoints
api:
  primary: "https://api1.example.com"  # Primary endpoint
  fallback: "https://api2.example.com" # Fallback endpoint

# ❌ INCORRECT

#Configure API endpoints
api:
  primary: "https://api1.example.com"#Primary endpoint (no space)
  fallback: "https://api2.example.com"
```

---

## Lists

**Format**: Use `-` with space for list items.

**Indentation**: Maintain consistent 2-space indentation.

```yaml
# ✅ CORRECT

services:
  - name: "apache"
    port: 80
  - name: "nginx"
    port: 8080

# Alternative format for simple lists:
tags:
  - production
  - web-server
  - monitored

# ❌ INCORRECT (Inconsistent spacing)

services:
  -name: "apache"    # Missing space after -
    port: 80
 - name: "nginx"     # Wrong indentation
   port: 8080
```

---

## Anchors and Aliases (DRY Principle)

**Purpose**: Reuse configuration blocks to avoid duplication.

**Pattern**:

```yaml
# ✅ CORRECT - Define once with &, reference with *

defaults: &default_settings
  timeout: 30
  retries: 3
  log_level: "INFO"

job1:
  <<: *default_settings
  name: "job-1"

job2:
  <<: *default_settings
  name: "job-2"
  timeout: 60  # Override specific field

# ❌ INCORRECT - Repeated configuration

job1:
  timeout: 30
  retries: 3
  log_level: "INFO"
  name: "job-1"

job2:
  timeout: 30
  retries: 3
  log_level: "INFO"
  name: "job-2"
```

---

## Null Values

**Handling**: Explicitly use `null` or omit key entirely.

```yaml
# ✅ CORRECT

config:
  setting1: "value"
  setting2: null       # Explicit null
  # setting3 omitted   # Key not present

# ❌ INCORRECT

config:
  setting1: "value"
  setting2:            # Ambiguous null
  setting3: ~          # Unclear null marker
```

---

## Multiline Strings

**Literal Block** (`|`): Preserve newlines.

```yaml
description: |
  This is a multiline description.
  Each line is preserved.
  Useful for longer text blocks.
```

**Folded Block** (`>`): Fold lines (join with spaces).

```yaml
description: >
  This is a longer description that spans
  multiple lines but will be folded into
  a single line with spaces between.
```

---

## Playbook-Specific Guidelines

**Header Format**:

```yaml
---
# Guardian: Carter
# Ministry: Identity
# Maturity: v1.1.0
# Tag: deploy-web-servers

- name: "Deploy web servers"
  hosts: "webservers"
  vars:
    app_version: "1.1.0"

  tasks:
    - name: "Validate configuration"
      assert:
        that:
          - app_version is defined
        fail_msg: "app_version must be defined"
```

**Task Guidelines**:

- Descriptive names
- Single responsibility per task
- Idempotent operations
- Error handling with `ignore_errors` or `failed_when`

---

## yamllint Compliance

**Run Validation**:

```bash
yamllint -c .yamllint pre-commit/
yamllint playbooks/
```

**Common Violations**:

- **Line too long**: Wrap at 140 or 120 chars
- **Wrong indentation**: Use 2 spaces
- **Trailing spaces**: Remove
- **Inconsistent quoting**: Quote special chars

---

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0
