# Agent Specification: Python Overlay

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0

Language-specific rules for Python code generation. Supplements universal `.agent.md`.

---

## Type Hints (mypy --strict)

**Requirement**: All functions and methods MUST have complete type hints.

**Coverage**:

- Parameter types: Always specify
- Return types: Always specify
- No `Any` without explicit justification
- Use `Optional[T]` or `T | None` (Python 3.10+)

**Example**:

```python
# ✅ CORRECT
def fetch_config(path: str) -> dict[str, Any]:
    """Load configuration from file."""
    with open(path) as f:
        return json.load(f)

# ❌ INCORRECT
def fetch_config(path):  # Missing types
    return json.load(open(path))
```

**Generics**:

```python
# ✅ CORRECT - Using TypeVar for flexible functions
from typing import TypeVar, Callable

T = TypeVar('T')

def retry(fn: Callable[..., T], max_attempts: int) -> T:
    """Retry function with exponential backoff."""
    pass
```

---

## Docstrings (Google Style)

**Required for**:

- All public functions
- All public classes
- All public methods
- Significant private functions

**Format**:

```python
def process_records(
    records: list[dict[str, Any]],
    batch_size: int = 100
) -> int:
    """Process records in batches and return count.

    Validates each record against schema before processing.
    Logs errors per batch for audit trail.

    Args:
        records: List of record dictionaries to process.
        batch_size: Number of records per batch (default 100).

    Returns:
        Total number of successfully processed records.

    Raises:
        ValueError: If record validation fails.
        IOError: If output file cannot be written.

    Examples:
        >>> records = [{'id': '1', 'name': 'test'}]
        >>> count = process_records(records)
        >>> count
        1

    Note:
        Processes are idempotent; safe to retry on failure.
    """
    pass
```

**Sections**:

- **Summary**: One-line description
- **Extended Description** (optional): Additional context
- **Args**: Parameter list with types and descriptions
- **Returns**: What the function returns
- **Raises**: Exception types and conditions
- **Examples** (recommended): Usage examples
- **Note**: Important caveats or assumptions

---

## Import Organization

**Order**:

1. `__future__` imports
2. Standard library
3. Third-party packages
4. Local/relative imports

**Tool**: ruff with `I` rule enforces this.

**Example**:

```python
# ✅ CORRECT
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

import requests
import yaml

from . import utils
from .config import load_config
```

---

## Error Handling

**Requirement**: Specific exceptions, never bare `except:`.

**Example**:

```python
# ✅ CORRECT
try:
    config = json.load(file)
except FileNotFoundError:
    logger.error(f"Config not found: {config_path}")
    raise
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON: {e.msg} at line {e.lineno}")
    raise

# ❌ INCORRECT
try:
    config = json.load(file)
except:  # Catches everything, hides bugs
    pass
```

---

## Bandit Security Scanning

### S603/S607: Subprocess with Shell

**Issue**: Shell injection vulnerability.

**Correct Pattern**:

```python
# ✅ CORRECT - No shell, list arguments
result = subprocess.run(
    ['git', 'clone', repo_url, dest_path],
    capture_output=True,
    check=True
)

# ❌ INCORRECT - shell=True allows injection
result = subprocess.run(f"git clone {repo_url} {dest_path}", shell=True)
```

### S602: Shell Injection via `sh -c`

**Issue**: Executing shell commands with unsanitized input.

**When Necessary**:

```python
# agent-override: Complex pipeline required for log aggregation
# Use shlex.quote for safety
cmd = f"cat {shlex.quote(logfile)} | grep {shlex.quote(pattern)}"
result = subprocess.run(cmd, shell=True, check=True)
```

### S101: Assert Statements

**Allowed**: In test code only.

**Correct Pattern**:

```python
# ✅ CORRECT - In tests
def test_record_validation():
    result = validate_record({'id': '1'})
    assert result is True

# ❌ INCORRECT - In production code
def process_record(record):
    assert record is not None  # Use exceptions instead
```

---

## Ruff Linting

**Key Rules**:

- **D2xx**: Docstring format and content (D200-D213)
- **E**: PEP 8 errors
- **W**: PEP 8 warnings
- **F**: PyFlakes (undefined names, unused imports)
- **I**: isort (import sorting)
- **B**: flake8-bugbear (common bugs)
- **RUF100**: Unused `# noqa` comments must be removed

**Line Length**: 120 characters (configurable per project).

**Auto-fix**:

```bash
ruff check . --fix
ruff format .
```

---

## Testing

**Framework**: pytest

**Guidelines**:

- Min coverage: 70% for Tier 0-1 repos
- Test names: `test_<function>_<scenario>`
- Fixtures: Use for reusable test data

**Example**:

```python
import pytest

@pytest.fixture
def sample_config():
    return {'host': 'localhost', 'port': 8080}

def test_config_load_success(sample_config):
    """Test loading valid configuration."""
    result = load_config(sample_config)
    assert result.host == 'localhost'

def test_config_missing_required_field():
    """Test error when required field missing."""
    with pytest.raises(ValueError):
        load_config({})  # Missing 'host'
```

---

## Logging

**Pattern**:

```python
import logging

logger = logging.getLogger(__name__)

def process(data):
    logger.info("Starting process", extra={'record_count': len(data)})
    try:
        result = transform(data)
        logger.info("Process complete", extra={'result_count': len(result)})
        return result
    except Exception as e:
        logger.error("Process failed", exc_info=True, extra={'error': str(e)})
        raise
```

**Requirements**:

- Log level appropriate to severity
- Include context in extra dict for structured logging
- Always include exceptions with `exc_info=True`

---

## Maturity Tracking

**File Format**:

```python
# Add to module docstring or __init__.py
__version__ = '1.1.0'
__maturity__ = 'v1.1.0'
```

**Update**: Increment PATCH for bug fixes, MINOR for features, MAJOR for breaking changes.

---

**Guardian**: Carter | **Ministry**: Identity | **Maturity**: v1.1.0
