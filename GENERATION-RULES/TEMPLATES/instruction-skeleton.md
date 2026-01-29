---
type: template
version: 1.0.0
purpose: Copy-paste starting points for instruction files
applies-to: [generator, build]
template-for: instruction
last-updated: 2026-01-28
---

# Instruction Skeleton

> **Templates for both global and targeted instruction files**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Determine instruction type using DECISION TREE
2. Copy appropriate TEMPLATE (global OR targeted)
3. Replace all `{PLACEHOLDER}` values
4. Validate against checklist

**For Build Agents:**
1. Create file at correct location based on type
2. Fill using appropriate template
3. Ensure NO role/persona definitions (that's agents only)

**For Users:**
1. Global instructions: `.github/copilot-instructions.md`
2. Targeted instructions: `.github/instructions/{name}.instructions.md`

---

## DECISION TREE

```
Does the rule apply to ALL project code?
├─ YES → Use GLOBAL TEMPLATE (copilot-instructions.md)
└─ NO → Does it apply to specific file types or directories?
         ├─ YES → Use TARGETED TEMPLATE (*.instructions.md)
         └─ NO → Probably belongs in global instructions
```

---

## GLOBAL TEMPLATE

**File:** `.github/copilot-instructions.md`

```markdown
# Project: {PROJECT_NAME}

## Tech Stack
- **Language:** {LANGUAGE_VERSION}
- **Runtime:** {RUNTIME_VERSION}
- **Framework:** {FRAMEWORK_VERSION}
<!-- GENERATOR: Add database, testing, auth as applicable -->

## Commands
- `{BUILD_COMMAND}` — {BUILD_DESCRIPTION}
- `{TEST_COMMAND}` — {TEST_DESCRIPTION}
- `{LINT_COMMAND}` — {LINT_DESCRIPTION}
<!-- GENERATOR: Commands in first third of file — most referenced -->

## Code Style
- ✅ {DO_PATTERN_1}
- ✅ {DO_PATTERN_2}
- ❌ {DONT_PATTERN_1}
<!-- GENERATOR: Use positive framing. State what TO do. -->

## File Conventions
- `{DIRECTORY_1}/` — {PURPOSE_1}
- `{DIRECTORY_2}/` — {PURPOSE_2}
<!-- GENERATOR: Document project structure -->

## Testing Requirements
- {TEST_REQUIREMENT_1}
- {TEST_REQUIREMENT_2}
<!-- GENERATOR: Specify framework, coverage expectations -->

## Git Workflow
- Branch: `{BRANCH_PREFIX}/description`
- Commit: `{COMMIT_FORMAT}`
<!-- GENERATOR: Document team conventions -->

## IMPORTANT — Safety Rules (No Exceptions)
- **Never** {SAFETY_RULE_1}
- **Never** {SAFETY_RULE_2}
- **Always** {SAFETY_RULE_3}
<!-- GENERATOR: P1 rules with emphasis. NO escape clauses. -->
```

---

## TARGETED TEMPLATE

**File:** `.github/instructions/{name}.instructions.md`

```yaml
---
applyTo: "{GLOB_PATTERN}"
name: "{DISPLAY_NAME}"
description: "{DESCRIPTION}"
<!-- GENERATOR: Add excludeAgent if needed: excludeAgent: "code-review" -->
---

# {INSTRUCTION_TITLE}

## {CATEGORY_1}
- {RULE_1}
- {RULE_2}
<!-- GENERATOR: Group related rules under category headers -->

## {CATEGORY_2}
- {RULE_3}
- {RULE_4}

<!-- GENERATOR: Keep under 300 lines. Be self-contained. -->
```

---

## PLACEHOLDER DEFINITIONS

### Global Template

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{PROJECT_NAME}` | string | ✅ | Project identifier |
| `{LANGUAGE_VERSION}` | string | ✅ | Explicit: "TypeScript 5.4" not "TypeScript" |
| `{RUNTIME_VERSION}` | string | ✅ | Explicit: "Node.js 20 LTS" |
| `{FRAMEWORK_VERSION}` | string | No | Framework if applicable |
| `{BUILD_COMMAND}` | string | ✅ | Command to build project |
| `{TEST_COMMAND}` | string | ✅ | Command to run tests |
| `{LINT_COMMAND}` | string | No | Command to lint code |
| `{DO_PATTERN_N}` | string | ✅ | Positive coding patterns |
| `{DONT_PATTERN_N}` | string | No | Patterns to avoid |
| `{DIRECTORY_N}` | string | No | Project directory path |
| `{PURPOSE_N}` | string | No | What goes in that directory |
| `{SAFETY_RULE_N}` | string | ✅ | P1 constraints (never overridable) |

### Targeted Template

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{GLOB_PATTERN}` | glob | ✅ | Files to target: `**/*.ts`, `src/api/**` |
| `{DISPLAY_NAME}` | string | No | Shows in VS Code UI |
| `{DESCRIPTION}` | string | No | Purpose of these instructions |
| `{INSTRUCTION_TITLE}` | string | ✅ | H1 heading for the file |
| `{CATEGORY_N}` | string | ✅ | Rule grouping header |
| `{RULE_N}` | string | ✅ | Specific instruction/constraint |

---

## GLOB PATTERN EXAMPLES

```yaml
# Single extension
applyTo: "**/*.py"

# Multiple extensions
applyTo: "**/*.{jsx,tsx}"

# Directory targeting
applyTo: "src/api/**"

# Test files
applyTo: "**/*.test.{ts,js}"

# Multiple patterns
applyTo: "**/*.ts,**/*.tsx"

# Configuration files
applyTo: "**/*.{json,yaml,yml}"
```

---

## CONSTRAINT PRIORITY GUIDE

| Priority | Name | Use In | Override Rule |
|----------|------|--------|---------------|
| **P1** | Safety | IMPORTANT section | NEVER overridable |
| **P2** | Project | Main sections | Team consensus required |
| **P3** | Behavioral | Targeted files | User can override |
| **P4** | Preference | Chat context | Always flexible |

**P1 Rules MUST use:**
- `## IMPORTANT` header
- **Bold emphasis** on keywords
- NO escape clauses ("unless user requests...")

---

## VALIDATION

Before using instruction files, verify:

```
VALIDATE_GLOBAL_INSTRUCTIONS:
  Structure:
  □ File is .github/copilot-instructions.md
  □ Has Tech Stack section with explicit versions
  □ Has Commands section in first third of file
  □ Has IMPORTANT section with P1 rules
  
  Content:
  □ All {PLACEHOLDER} values replaced
  □ Stack versions are explicit (not "latest")
  □ P1 rules use **emphasis**
  □ P1 rules have NO escape clauses
  □ Line count ≤300 (or justified)
  
  Prohibitions:
  □ NO role/persona definitions ("You are...")
  □ NO tool specifications
  □ NO handoff rules

VALIDATE_TARGETED_INSTRUCTIONS:
  Structure:
  □ File is .github/instructions/{name}.instructions.md
  □ Has YAML frontmatter
  □ Has valid applyTo glob pattern
  
  Content:
  □ All {PLACEHOLDER} values replaced
  □ Self-contained (no cross-file dependencies)
  □ Line count ≤300
  
  Prohibitions:
  □ NO role/persona definitions
  □ NO tool specifications
  □ NO duplicate rules from global instructions
```

---

## ANTI-PATTERN QUICK REFERENCE

| ❌ Don't | ✅ Instead |
|----------|-----------|
| "You are a senior developer..." | Put personas in `.agent.md` |
| "Use tools: [...]" | Put tools in agent frontmatter |
| Vague: "Use modern practices" | Specific: "TypeScript 5.4, React 18" |
| P1 rule: "unless user requests" | P1 rules have NO exceptions |
| Reference other instruction files | Make each file self-contained |
| Negative: "Don't skip tests" | Positive: "Write tests for all code" |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [instruction-patterns.md](../PATTERNS/instruction-patterns.md) | Full patterns and rules |
| [agent-patterns.md](../PATTERNS/agent-patterns.md) | Agents inherit instructions |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to use instructions vs agents |
| [instruction-checklist.md](../CHECKLISTS/instruction-checklist.md) | Detailed validation |

---

## SOURCES

- [instruction-patterns.md](../PATTERNS/instruction-patterns.md) — Structure extracted from STRUCTURE section
