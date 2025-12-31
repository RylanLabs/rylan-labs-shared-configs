# Markdown Style Guide - RylanLabs Canonical Standards

**Guardian**: Carter (Identity/Standards)  
**Version**: 1.0.0  
**Date**: 2025-12-31  
**Compliance**: markdownlint ✓ | Seven Pillars ✓

---

## Overview

This document defines the canonical markdown formatting standards for all RylanLabs repositories. These rules ensure consistent, lint-compliant documentation across the organization.

## Table Formatting (MD060)

### Rule: Table Column Style

**Requirement**: Table separator rows MUST have spaces around pipes.

**❌ INCORRECT**:

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
```

**✅ CORRECT**:

```markdown
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Value 1  | Value 2  | Value 3  |
```

### Table Formatting Rationale

- Improves readability in plain text
- Ensures consistent rendering across markdown parsers
- Prevents markdownlint MD060 violations
- Aligns with GitHub Flavored Markdown best practices

### Implementation

```bash
# Find tables without proper spacing
grep -n "^|--" *.md

# Pattern to fix:
# BEFORE: |----------|---------|
# AFTER:  | -------- | ------- |
```

---

## List Formatting (MD032)

### Rule: Blanks Around Lists

**Requirement**: Lists MUST be surrounded by blank lines (before and after).

**❌ INCORRECT**:

```markdown
This is a paragraph:
- Item 1
- Item 2
- Item 3
Next paragraph starts here.
```

**✅ CORRECT**:

```markdown
This is a paragraph:

- Item 1
- Item 2
- Item 3

Next paragraph starts here.
```

### List Formatting Rationale

- Prevents lists from merging with surrounding text
- Improves visual separation in editors
- Ensures correct rendering in all markdown parsers
- Prevents markdownlint MD032 violations

---

## Heading Formatting (MD022)

### Rule: Blanks Around Headings

**Requirement**: Headings MUST have blank lines before and after (except at document start).

**❌ INCORRECT**:

```markdown
Paragraph text here.
### Heading
Content starts immediately.
```

**✅ CORRECT**:

```markdown
Paragraph text here.

### Heading

Content starts after blank line.
```

### Heading Formatting Rationale

- Improves document structure clarity
- Prevents heading merging with content
- Ensures consistent TOC generation
- Prevents markdownlint MD022 violations

---

## Code Fence Formatting (MD031, MD040)

### Rule: Blanks Around Fences

**Requirement**: Code blocks MUST be surrounded by blank lines.

**❌ INCORRECT**:

```markdown
Paragraph before code.
```bash
command here
```
Paragraph after code.
```

**✅ CORRECT**:

```markdown
Paragraph before code.

```bash
command here
```

Paragraph after code.
```

### Rule: Language Specification (MD040)

**Requirement**: Code fences MUST specify language for syntax highlighting.

**❌ INCORRECT**:

````text
```
code without language
```
````

**✅ CORRECT**:

````text
```bash
echo "Bash code"
```

```python
print("Python code")
```

```text
Plain text diagram
```
````

### Supported Languages

| Language | Use Case |
| -------- | -------- |
| `bash` | Shell scripts, terminal commands |
| `python` | Python code |
| `yaml` | YAML configuration files |
| `json` | JSON data structures |
| `markdown` | Nested markdown examples |
| `text` | Plain text, diagrams, ASCII art |
| `diff` | Git diffs, patch files |

---

## Emphasis and Headers (MD036)

### Rule: No Emphasis as Heading

**Requirement**: Use proper heading syntax, not bold/italic for headers.

**❌ INCORRECT**:

```markdown
**This looks like a heading**

Content starts here.
```

**✅ CORRECT**:

```markdown
## This Is a Proper Heading

Content starts here.
```

### Code Fence Rationale

- Enables proper document outline/TOC generation
- Improves accessibility (screen readers)
- Ensures semantic HTML structure
- Prevents markdownlint MD036 violations

---

## Line Length (MD013)

### Rule: Line Length Limit

**Requirement**: Lines SHOULD be wrapped at 80 characters (soft limit) or 160 characters (hard limit for infrastructure code).

**Exception**: Tables, URLs, and code blocks may exceed limits.

**Configuration**:

```yaml
# .markdownlint.yaml
MD013:
  line_length: 80
  code_blocks: false
  tables: false
```

### Rationale

- Improves readability in text editors
- Facilitates side-by-side diffs
- Aligns with RylanLabs 160-char infrastructure standard
- Prevents excessive horizontal scrolling

---

## Inline HTML (MD033)

### Rule: Minimize Inline HTML

**Requirement**: Prefer pure markdown over HTML when possible.

**❌ DISCOURAGED**:

```markdown
<b>Bold text</b>
<br>
<i>Italic text</i>
```

**✅ PREFERRED**:

```markdown
**Bold text**

*Italic text*
```

### Exception

HTML is acceptable for:

- Complex tables with merged cells
- Custom styling not supported by markdown
- Embedding images with specific dimensions

---

## Enforcement

### Pre-commit Hook

```yaml
# .pre-commit-config.yaml
- repo: https://github.com/igorshubovych/markdownlint-cli
  rev: v0.42.0
  hooks:
    - id: markdownlint
      name: Lint Markdown files
      args: ['--config', '.markdownlint.yaml']
```

### CI/CD Validation

```yaml
# .github/workflows/docs-lint.yml
name: Documentation Lint
on: [push, pull_request]
jobs:
  markdown-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: nosborn/github-action-markdown-cli@v3.3.0
        with:
          files: "**/*.md"
          config_file: ".markdownlint.yaml"
```

### Local Validation

```bash
# Install markdownlint-cli
npm install -g markdownlint-cli

# Lint all markdown files
markdownlint "**/*.md"

# Auto-fix issues (where possible)
markdownlint --fix "**/*.md"
```

---

## Quick Reference

| Rule | Code | Summary | Fix |
| ---- | ---- | ------- | --- |
| Table column style | MD060 | Spaces around pipes in separators | `\| --- \|` not `\|---\|` |
| Blanks around lists | MD032 | Blank lines before/after lists | Add empty lines |
| Blanks around headings | MD022 | Blank lines around headers | Add empty lines |
| Blanks around fences | MD031 | Blank lines around code blocks | Add empty lines |
| Fenced code language | MD040 | Specify language in code fences | `\`\`\`bash` not `\`\`\`` |
| No emphasis as heading | MD036 | Use `##` not `**text**` | Replace with heading |
| Line length | MD013 | 80-char soft limit | Wrap lines |

---

## Validation Metrics

### Before Remediation (2025-12-31)

- Total markdown files: 10
- Total violations: 90+
- MD060 violations: ~70 (78%)
- MD032 violations: ~8 (9%)
- MD022 violations: ~5 (6%)
- MD031/MD040 violations: ~7 (7%)

### After Remediation (2025-12-31)

- Total violations: 0 ✓
- Compliance rate: 100% ✓
- Commits: 2 (0c08385, 12768c6)

---

## Adoption Checklist

For any RylanLabs repository adopting these standards:

- [ ] Copy `.markdownlint.yaml` from `rylan-labs-shared-configs`
- [ ] Add markdownlint pre-commit hook
- [ ] Run `markdownlint --fix "**/*.md"` to auto-fix violations
- [ ] Manually fix violations that can't be auto-fixed
- [ ] Commit with message: `chore: adopt canonical markdown standards`
- [ ] Verify CI passes with new linting rules

---

## References

- [markdownlint Rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [GitHub Flavored Markdown Spec](https://github.github.com/gfm/)
- [RylanLabs Shared Configs](https://github.com/RylanLabs/rylan-labs-shared-configs)
- [Seven Pillars Documentation Standard](./INTEGRATION_GUIDE.md#documentation)

---

**Guardian**: Carter | **Maturity**: v1.0.1  
**Status**: CANONICAL ✓ | **Compliance**: markdownlint ✓
