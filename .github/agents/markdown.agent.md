# Agent Specification: Markdown Overlay

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0

Language-specific rules for Markdown generation. Supplements universal `.agent.md`.

---

## Code Fence Language (MD040)

**Requirement**: ALL code fences MUST specify a language identifier.

**Supported Languages**: `bash`, `python`, `yaml`, `json`, `text`, `markdown`, `shell`, `dockerfile`

### Language Detection Logic

**Bash** (`bash` or `shell`):

```markdown
- Contains `$`, `cd `, `git `, `echo`, `if [[`
- Example: Shell commands, terminal examples
```

**Python** (`python`):

```markdown
- Contains `def `, `import `, `class `, `try:`, `@decorator`
- Example: Code snippets, configuration scripts
```

**YAML** (`yaml`):

```markdown
- Contains `name:`, `hosts:`, `tasks:`, `vars:`
- Example: Ansible playbooks, configuration files
```

**JSON** (`json`):

```markdown
- Contains `{`, `}`, `"key":`, `[`, `]`
- Example: Configuration, API responses
```

**Markdown** (`markdown`):

```markdown
- Contains `#`, `|`, `---`, `` ``` ``
- Example: Showing markdown syntax, nested examples
```

**Text** (`text`):

```markdown
- Contains output, errors, logs
- Contains `→`, `ERROR`, `WARNING`, terminal prompts
- Example: Command output, error messages
```

### Examples

```markdown
# ✅ CORRECT

## Python Example
```python
def validate_config(data: dict) -> bool:
    return 'host' in data
```

## Bash Example

```bash
#!/usr/bin/env bash
echo "Hello"
```

## Terminal Output

```text
$ echo "Hello"
Hello
```

# ❌ INCORRECT

## Missing Language

```
def validate_config(data):
    pass
```

## Vague Language

```code
echo "Hello"
```

```

---

## Line Length (MD013)

**Limit**: 160 characters for markdown files.

**Rationale**: Technical documentation with long command examples, URLs, or code excerpts may exceed typical 80-char limit. 160 provides readable balance.

**Wrapping**:
```markdown
# ✅ CORRECT - Wrapped to ~140-150 chars
This is a long line that explains how to install the agent specifications by running the bootstrap
script in your consumer repository directory.

# ❌ INCORRECT - Single very long line
This is a very long line that goes on and on explaining how to install the agent specifications by running the bootstrap script in your consumer repository directory and then validating that the symlinks were created correctly.
```

---

## Blank Lines Around Fences and Lists (MD031/MD032)

**Requirement**: One blank line before/after code fences and lists.

**Pattern**:

```markdown
# ✅ CORRECT

Paragraph before code.

```python
def hello():
    pass
```

Paragraph after code.

- List item 1
- List item 2

Next paragraph.

# ❌ INCORRECT

Paragraph before code.

```python
def hello():
    pass
```

Paragraph after code.

- List item 1
- List item 2
Next paragraph.

```

---

## Table Formatting (MD060)

**Requirement**: Spaces around pipes (`| Header |` not `|Header|`).

**Pattern**:
```markdown
# ✅ CORRECT

| Column 1 | Column 2 |
| -------- | -------- |
| Value 1  | Value 2  |

# ❌ INCORRECT

|Column 1|Column 2|
|--------|--------|
|Value 1|Value 2|
```

**Separator Row**: Must have spaces around dashes.

```markdown
| --- |       ← spaces required
|---|             ← INCORRECT
```

---

## Heading Blank Lines (MD022)

**Requirement**: One blank line above AND below headings.

**Pattern**:

```markdown
# ✅ CORRECT

Some paragraph text.

## Section Heading

More text under the heading.

## Another Section

More text.

# ❌ INCORRECT

Some paragraph text.
## Section Heading
More text under the heading.
## Another Section
More text.
```

---

## Nested Code Fences

**For Showing Markdown Code Itself**: Use 4+ backticks for outer fence.

**Pattern**:

```markdown
# ✅ CORRECT - Show markdown with nested fence

To create a Python code fence, use 3 backticks:

````markdown
```python
def hello():
    pass
```

````

# ❌ INCORRECT - Nested fences with same backtick count

This will break the rendering:

```markdown
```python
def hello():
    pass
```
```
```

---

## Link Format

**Pattern**: Use markdown link notation with display text and a target path.

**Guidelines**:
- Display text describes the link destination clearly
- Use relative paths from repository root
- Add line numbers with hash symbol for specificity
- Add section anchors for subsection navigation

**Example Usage**: When documenting other files, create links to help readers navigate quickly throughout the documentation.

---

---

## List Formatting

**Unordered Lists**: Use `-` consistently.

```markdown
# ✅ CORRECT

- First item
- Second item
  - Nested item
  - Another nested

# ❌ INCORRECT (Mixing * and -)

* First item
- Second item
  * Nested item
  - Another nested
```

**Ordered Lists**: Use `1.`, `2.`, etc.

```markdown
# ✅ CORRECT

1. First step
2. Second step
3. Third step

# ❌ INCORRECT (1. 1. 1.)

1. First step
1. Second step
1. Third step
```

---

## Emphasis and Bolding

**Bold**: `**text**` for emphasis
**Italic**: `*text*` for emphasis (sparingly)

```markdown
# ✅ CORRECT

This is **important** and *recommended*.

# ❌ INCORRECT (Using emphasis for headings)

**This Should Be A Heading**
Some text here.
```

---

## Code Inline

**Pattern**: `` `code` `` for inline code.

```markdown
# ✅ CORRECT

Run `make ci-local` to validate locally.
Set `VERBOSE=true` to enable debug output.

# ❌ INCORRECT

Run make ci-local to validate locally.
Set VERBOSE=true to enable debug output.
```

---

## Multi-Line Code Blocks

**Pattern**: Triple backticks with language.

```markdown
# ✅ CORRECT

```bash
#!/usr/bin/env bash
echo "Hello"
```

# ❌ INCORRECT

```
#!/usr/bin/env bash
echo "Hello"
```
```

---

## Examples in Documentation

**Complete Example**:
```markdown
# Installation Guide

To install agent specifications:

1. Navigate to your consumer repository:

```bash
cd /path/to/consumer-repo
```

2. Run the bootstrap script:

```bash
../rylanlabs-shared-configs/scripts/bootstrap-agent-specs.sh
```

3. Verify symlinks were created:

```bash
ls -la .agent.md .instructions.md
```

Expected output:

```text
lrwxr-xr-x  1 user  group   42 Dec 31 12:34 .agent.md -> ../rylanlabs-shared-configs/agents/.agent.md
lrwxr-xr-x  1 user  group   42 Dec 31 12:34 .instructions.md -> ../rylanlabs-shared-configs/instructions/.instructions.md
```

Now your Copilot will use the agent specs for suggestions!
```

---

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0
