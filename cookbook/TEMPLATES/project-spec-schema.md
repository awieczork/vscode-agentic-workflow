---
when:
  - Defining what project.spec.md files should contain
  - Interviewer agent producing specs for Generator consumption
pairs-with:
  - spec-template
  - spec-driven
requires:
  - none
complexity: low
---

# Project Spec Schema

> **Version:** 1.0 | **Contract:** Interviewer → Generator

This schema defines the `project.spec.md` format — the contract between the Interviewer agent (which creates specs) and the Generator agent (which consumes them).

---

## Usage

### Option 1: Use @interviewer (Recommended)
```
@interviewer
```
The Interviewer will guide you through discovery and produce a valid spec.

### Option 2: Create Manually
Copy the template below and fill in your project details.

### Option 3: Use @generator Directly
```
@generator I want to build a Python CLI for data validation
```
Generator's Mode 2 extracts spec from casual descriptions.

---

## Schema Definition

```yaml
# project.spec.md
# Contract between Interviewer → Generator
# Version: 1.0

# ─────────────────────────────────────────────────────────────────
# METADATA (Generator may use for guidance, but not required)
# ─────────────────────────────────────────────────────────────────
_meta:
  generated_by: interviewer | manual      # Who created this spec
  spec_version: "1.0"                     # Schema version
  cookbook_version: "2026-01"             # Cookbook version for compatibility
  interview_mode: discovery | revision    # Which interview flow was used
  confidence:                             # How each field was determined
    goals: explicit                       # Always explicit (user stated)
    components: inferred | explicit       # inferred = suggested, explicit = user modified
    tooling: defaulted                    # defaulted = silent defaults applied
    frameworks: inferred | explicit       # inferred = suggested from language

# ─────────────────────────────────────────────────────────────────
# PROJECT (Core specification - Generator's primary input)
# ─────────────────────────────────────────────────────────────────
project:
  name: "my-project"                      # REQUIRED - Project identifier
  type: cli-tool                          # REQUIRED - One of: cli-tool, api-service, 
                                          #            web-app, data-pipeline, library, mixed
  languages:                              # REQUIRED - Primary language(s)
    - python
  frameworks:                             # Optional - Frameworks/libraries
    - click                               # e.g., click, fastapi, react, pandas
  complexity: moderate                    # Inferred - simple, moderate, complex
  goals: |                                # REQUIRED - What this project accomplishes
    - Primary objective stated clearly
    - Secondary objectives if any

# ─────────────────────────────────────────────────────────────────
# PREFERENCES (Tooling defaults - can be overridden)
# ─────────────────────────────────────────────────────────────────
preferences:
  testing: pytest                         # Testing framework (pytest, jest, go test, etc.)
  linting: ruff                           # Linting tool (ruff, eslint, golangci-lint, etc.)

# ─────────────────────────────────────────────────────────────────
# COMPONENTS (What to generate)
# ─────────────────────────────────────────────────────────────────
components:
  agents:                                 # Domain-specific agents beyond core 5
    - data-validator                      # Example: specialized validation agent
  skills:                                 # Skills to add to existing agents
    - []                                  # Example: API integration skill
  instructions:                           # Scoped instruction files
    - []                                  # Example: security guidelines

# ─────────────────────────────────────────────────────────────────
# WORKFLOW (Generation behavior)
# ─────────────────────────────────────────────────────────────────
workflow:
  parallel-research: true                 # Allow parallel research tasks
  checkpoint-frequency: stage-boundaries  # When to pause for confirmation
```

---

## Field Reference

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `project.name` | string | Project identifier, used for folder/file naming |
| `project.type` | enum | Project category — determines component suggestions |
| `project.languages` | list | Primary programming language(s) |
| `project.goals` | string | What the project should accomplish |

### Project Types

| Type | Description | Typical Components |
|------|-------------|-------------------|
| `cli-tool` | Command-line application | arg-parsing, config, logging, error-handling |
| `api-service` | REST/GraphQL API | routing, auth, validation, error-handling |
| `web-app` | Frontend web application | routing, state-management, auth, ui-components |
| `data-pipeline` | Data processing workflow | ingestion, transformation, validation, output |
| `library` | Reusable package/module | public-api, error-types |
| `mixed` | Hybrid/novel project | User specifies explicitly |

### Complexity Levels

| Level | Criteria | Generator Behavior |
|-------|----------|-------------------|
| `simple` | Single concept, <5 files expected | Minimal scaffolding |
| `moderate` | Multiple concepts, 5-20 files | Standard scaffolding |
| `complex` | System-level, 20+ files | Full scaffolding with patterns |

### Confidence Tracking

The `_meta.confidence` section tells Generator how each field was determined:

| Value | Meaning | Generator Action |
|-------|---------|-----------------|
| `explicit` | User stated or confirmed | Trust as-is |
| `inferred` | Interviewer suggested, user accepted | May surface "review this?" |
| `defaulted` | Silent default applied | May surface "using default X" |

---

## Examples

### Example 1: Python CLI Tool

```yaml
_meta:
  generated_by: interviewer
  spec_version: "1.0"
  cookbook_version: "2026-01"
  interview_mode: discovery
  confidence:
    goals: explicit
    components: inferred
    tooling: defaulted
    frameworks: explicit

project:
  name: "data-validator"
  type: cli-tool
  languages: [python]
  frameworks: [click, pydantic]
  complexity: moderate
  goals: |
    - Validate CSV files against schema definitions
    - Report validation errors in human-readable format
    - Support batch processing of multiple files

preferences:
  testing: pytest
  linting: ruff

components:
  agents:
    - schema-validator
  skills: []
  instructions:
    - data-validation-rules

workflow:
  parallel-research: true
  checkpoint-frequency: stage-boundaries
```

### Example 2: FastAPI Service

```yaml
_meta:
  generated_by: interviewer
  spec_version: "1.0"
  cookbook_version: "2026-01"
  interview_mode: discovery
  confidence:
    goals: explicit
    components: explicit
    tooling: defaulted
    frameworks: explicit

project:
  name: "user-service"
  type: api-service
  languages: [python]
  frameworks: [fastapi, sqlalchemy, pydantic]
  complexity: moderate
  goals: |
    - CRUD operations for user management
    - JWT authentication
    - Role-based access control

preferences:
  testing: pytest
  linting: ruff

components:
  agents:
    - api-tester
  skills:
    - database-migrations
  instructions:
    - api-security-guidelines

workflow:
  parallel-research: true
  checkpoint-frequency: stage-boundaries
```

### Example 3: Mixed/Hybrid Project

```yaml
_meta:
  generated_by: interviewer
  spec_version: "1.0"
  cookbook_version: "2026-01"
  interview_mode: discovery
  confidence:
    goals: explicit
    components: explicit          # User specified (no inference for mixed)
    tooling: defaulted
    frameworks: explicit

project:
  name: "ml-pipeline-service"
  type: mixed
  languages: [python]
  frameworks: [fastapi, pandas, scikit-learn]
  complexity: complex
  goals: |
    - Ingest data via API endpoints
    - Run ML training pipelines
    - Serve predictions via REST API
    - Dashboard for monitoring

preferences:
  testing: pytest
  linting: ruff

components:
  agents:
    - data-engineer
    - ml-trainer
    - api-monitor
  skills:
    - model-versioning
  instructions:
    - ml-best-practices
    - api-design-guidelines

workflow:
  parallel-research: true
  checkpoint-frequency: stage-boundaries
```

---

## Validation Rules

Generator expects these rules to be satisfied:

1. **Required fields present:** `project.name`, `project.type`, `project.languages`, `project.goals`
2. **Valid type enum:** Must be one of the 6 defined types
3. **Languages non-empty:** At least one language specified
4. **Goals non-empty:** At least one objective stated

### What Generator Ignores

- `_meta` section — Used for guidance only, not required
- Unknown fields — Forward-compatible, extras ignored

### What Generator Validates

- Type matches known patterns
- Languages have tooling defaults
- Components are reasonable for type

---

## Versioning

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01 | Initial schema |

**Compatibility:** Generator checks `_meta.cookbook_version` to handle evolution. Older specs remain valid.
