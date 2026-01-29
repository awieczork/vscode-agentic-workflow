---
type: specification
version: 1.0.0
purpose: Definitive format specification for all GENERATION-RULES files
applies-to: [generator, build, inspect, architect, brain]
last-updated: 2026-01-28
---

# Output Format Specification

> **The single source of truth for GENERATION-RULES file formats**

⚠️ **AUTHORITY:** This file is authoritative for all format questions. If synthesis-reference.md or other files conflict with this spec, THIS FILE WINS.

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Reference this spec when creating any GENERATION-RULES file
2. Select the appropriate TYPE from the catalog below
3. Follow the required structure exactly
4. Validate output against the type's checklist

**For Build Agents:**
1. Use this spec to validate files you're creating/modifying
2. Check required sections are present and in order

**For Inspect Agents:**
1. Validate any GENERATION-RULES file against this spec
2. Flag missing required sections
3. Verify YAML frontmatter completeness

---

## TYPE CATALOG

| Type | Purpose | Used By |
|------|---------|---------|
| `decision-matrix` | Choose between options | COMPONENT-MATRIX.md |
| `patterns` | Define HOW to create something | PATTERNS/*.md |
| `rules` | Cross-cutting MUST/NEVER constraints | RULES.md, NAMING.md |
| `configuration` | Settings and config values | SETTINGS.md |
| `template` | Copy-paste starting points | TEMPLATES/*.md |
| `checklist` | Verification checklists | CHECKLISTS/*.md |
| `index` | Navigation and file discovery | README.md |
| `workflow` | Process and stage definitions | WORKFLOW-GUIDE.md |
| `specification` | Meta-format definitions | This file |

---

## UNIVERSAL REQUIREMENTS

**ALL files MUST have:**

### 1. YAML Frontmatter

```yaml
---
type: {type from catalog}
version: {semver}
purpose: {one-line description}
applies-to: [{list of agents that use this file}]
last-updated: {YYYY-MM-DD}
---
```

### 2. Title and Summary

```markdown
# {Title}

> **{One-line summary of what this file does}**
```

### 3. HOW TO USE THIS FILE Section

```markdown
## HOW TO USE THIS FILE

**For Generator Agents:**
{How to parse and use}

**For Build Agents:**
{How to reference during implementation}

**For Inspect Agents:**
{What to validate against}
```

### 4. CROSS-REFERENCES Section

```markdown
## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `path/to/file.md` | {how they relate} |
```

### 5. SOURCES Section

```markdown
## SOURCES

- [source.md](path) — {what was extracted}
```

---

## TYPE: decision-matrix

**Purpose:** Choose between mutually exclusive options

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `DECISION RULES (Machine-Parseable)` | IF-THEN-ELSE selection logic |
| `VALIDATION RULES` | REQUIRE/REJECT_IF for each option |
| `{DOMAIN} MATRIX` | Capability/constraint tables |
| `USE-CASE MAPPING` | Scenario → option table |
| `ANTI-PATTERNS` | Don't/Instead/Why table |

**Decision Rules Format:**

```
IF condition_a OR condition_b
  THEN → OPTION_1
ELSE IF condition_c
  THEN → OPTION_2
ELSE
  THEN → DEFAULT
```

**Validation Rules Format:**

```
VALID_{OPTION}_SELECTION:
  REQUIRE at_least_one_of:
    - criterion_a
    - criterion_b
  REJECT_IF:
    - anti_pattern → use ALTERNATIVE instead
```

**Criteria Definitions Table:**

| Criterion | True When |
|-----------|----------|
| `criterion_name` | {specific condition} |

---

## TYPE: patterns

**Purpose:** Define HOW to create a component type

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `PURPOSE` | Why this component exists |
| `THE FRAMEWORK APPROACH` | THE single way we do it |
| `STRUCTURE` | Required sections table + order |
| `AUTHORING RULES` | RULE_NNN format rules |
| `VALIDATION CHECKLIST` | Checkbox verification |
| `ANTI-PATTERNS` | Don't/Instead/Why table |
| `EXAMPLES` | Minimal + Full examples |

**Authoring Rules Format:**

```
RULE_001: {rule name}
  REQUIRE: {what must be present}
  REJECT_IF: {what invalidates}
  RATIONALE: {why this rule exists}
  EXAMPLE_VALID: {good example}
  EXAMPLE_INVALID: {bad example}
```

**Validation Checklist Format:**

```
VALIDATE_{component}:
  □ {check item 1}
  □ {check item 2}
  ...
```

---

## TYPE: rules

**Purpose:** Cross-cutting MUST/NEVER constraints

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `PRIORITY STACK` | Conflict resolution order |
| `UNIVERSAL RULES` | Rules for all components |
| `COMPONENT-SPECIFIC RULES` | Per-component subsections |
| `IRON LAWS` | Never-override rules |
| `VALIDATION CHECKLIST` | Verification items |

**Rule Format:**

```
RULE_U001: {rule name}
  LEVEL: MUST | MUST_NOT | SHOULD | SHOULD_NOT
  APPLIES_TO: all | agent | skill | instruction | prompt
  RULE: {the constraint}
  RATIONALE: {why}
  VIOLATION: {consequence if broken}
```

**Iron Law Format:**

```
IRON_001: {name}
  RULE: {inviolable constraint}
  RATIONALE: {why this can never be overridden}
```

---

## TYPE: configuration

**Purpose:** Settings and configuration values

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `REQUIRED SETTINGS` | Must-have settings table + JSON |
| `MCP CONFIGURATION` | mcp.json if applicable |
| `WORKSPACE VS USER` | Which goes where |
| `OPTIONAL ENHANCEMENTS` | Nice-to-have settings |
| `VALIDATION CHECKLIST` | Verification items |

**Settings Table Format:**

| Setting | Value | Rationale |
|---------|-------|-----------|
| `setting.name` | `value` | {why required} |

**Include copy-paste ready JSON blocks.**

---

## TYPE: template

**Purpose:** Copy-paste starting points

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `HOW TO USE THIS TEMPLATE` | Fill instructions |
| `TEMPLATE` | The actual template |
| `PLACEHOLDER DEFINITIONS` | What to replace |
| `VALIDATION` | Self-check before use |

**Additional Frontmatter:**

```yaml
template-for: agent | skill | instruction | prompt | memory | project-context
```

**Placeholder Format:**

```markdown
<!-- GENERATOR: {instruction for generator agent} -->
{PLACEHOLDER_NAME}
```

**Placeholder Definitions Table:**

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{NAME}` | string | ✅ | {what this should contain} |

---

## TYPE: checklist

**Purpose:** Verification checklists

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `HOW TO USE THIS CHECKLIST` | When and how to run |
| `STRUCTURE CHECKS` | Structural verification |
| `RULE CHECKS` | Rule compliance |
| `QUALITY CHECKS` | Quality criteria |

**Additional Frontmatter:**

```yaml
checklist-for: agent | skill | instruction | prompt | memory | quality | security | pre-generation
```

**Check Format:**

```
CHECK_S001: {check name}
  VERIFY: {what to look for}
  PASS_IF: {condition for pass}
  FAIL_IF: {condition for fail}
  SEVERITY: BLOCKING | WARNING
```

**Human-Readable Format:**

```markdown
- [ ] CHECK_S001: {human-readable summary}
```

---

## TYPE: index

**Purpose:** Navigation and file discovery

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `FILE INDEX` | All files with purpose and "Read When" |
| `QUICK START` | Minimal steps to begin |
| `NAVIGATION` | How to find things |

**File Index Table:**

| File | Type | Purpose | Read When |
|------|------|---------|-----------|
| `file.md` | {type} | {purpose} | {when to read} |

---

## TYPE: workflow

**Purpose:** Process and stage definitions

**Required Sections (in order):**

| Section | Purpose |
|---------|---------|
| `THE WORKFLOW` | Stage definitions |
| `STAGE DETAILS` | Per-stage breakdown |
| `AGENT SELECTION MATRIX` | Which agent for what |
| `HANDOFF PATTERNS` | Agent-to-agent transitions |
| `ERROR RECOVERY` | What to do when things fail |

**Stage Format:**

```
STAGE_1: {name}
  AGENT: @{agent-name}
  INPUT: {what this stage receives}
  OUTPUT: {what this stage produces}
  NEXT: STAGE_2 | COMPLETE | CONDITIONAL
```

---

## TYPE: specification

**Purpose:** Meta-format definitions — files that define how other files should be structured.

**Frontmatter:**
```yaml
type: specification
version: 1.0.0
purpose: {what formats this spec defines}
applies-to: [generator, build, inspect, architect, brain]
last-updated: YYYY-MM-DD
```

**Required Sections:**

| Section | Content |
|---------|---------|
| `HOW TO USE THIS FILE` | Per-agent usage instructions |
| `TYPE CATALOG` | Index of all types defined |
| `UNIVERSAL REQUIREMENTS` | Common rules for all types |
| `TYPE: {name}` | One section per type with format details |
| `VALIDATION CHECKLIST` | How to verify compliance |
| `SOURCES` | Where format rules came from |

**Self-Documenting Rule:** This file (`OUTPUT-FORMAT-SPEC.md`) is the canonical example of `type: specification`.

---

## VALIDATION CHECKLIST

For ANY GENERATION-RULES file:

```
VALIDATE_FORMAT:
  □ Has YAML frontmatter with all required fields
  □ Type is from TYPE CATALOG
  □ Has HOW TO USE THIS FILE section
  □ Has CROSS-REFERENCES section
  □ Has SOURCES section
  □ Uses tables instead of prose for structured data
  □ No hedging language ("consider", "you could")
  □ All rules have RATIONALE
```

---

## SOURCES

- [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) — Pattern file format definitions
- [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) — Exemplar for decision-matrix type
