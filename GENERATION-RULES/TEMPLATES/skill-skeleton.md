---
type: template
version: 1.0.0
purpose: Copy-paste starting point for SKILL.md files
applies-to: [generator, build]
template-for: skill
last-updated: 2026-01-28
---

# Skill Skeleton

> **Minimal valid skill file — portable, on-demand capability package**

---

## HOW TO USE THIS TEMPLATE

**For Generator Agents:**
1. Create folder structure: `{skill-name}/SKILL.md`
2. Copy the TEMPLATE section into SKILL.md
3. Replace all `{PLACEHOLDER}` values
4. Validate against checklist

**For Build Agents:**
1. Create skill folder at appropriate location
2. Fill SKILL.md using template
3. Add scripts/references folders only if needed

**For Users:**
1. Create folder: `.github/skills/{skill-name}/`
2. Copy template to `SKILL.md` inside folder
3. Ensure `name` field matches folder name exactly

---

## FOLDER STRUCTURE

```
{skill-name}/
├── SKILL.md          # REQUIRED — entry point (this template)
├── scripts/          # Optional — executable code
├── references/       # Optional — documentation for JIT loading
└── assets/           # Optional — templates, data files
```

**Location Decision:**
- Project skills: `.github/skills/{skill-name}/`
- Personal skills: `~/.copilot/skills/{skill-name}/`
- Community contribution: `skills/{skill-name}/` (root level)

---

## TEMPLATE

```yaml
---
name: {SKILL_NAME}
description: {DESCRIPTION}
<!-- GENERATOR: Add license field if distributing -->
<!-- GENERATOR: Add compatibility field if platform-specific -->
<!-- GENERATOR: Add metadata block for author/version/tags -->
---

# {SKILL_TITLE}

{ONE_LINE_DESCRIPTION}

## Steps

1. {STEP_1}
2. {STEP_2}
3. {STEP_3}
<!-- GENERATOR: Add steps as needed. Use specific commands for fragile operations. -->

## Error Handling

If {FAILURE_CONDITION_1}: {RECOVERY_ACTION_1}
If {FAILURE_CONDITION_2}: {RECOVERY_ACTION_2}
<!-- GENERATOR: Document failure mode for each critical step -->

<!-- GENERATOR: Add Reference Files section if using JIT loading -->

<!-- GENERATOR: Add Validation section if skill produces verifiable output -->
```

---

## PLACEHOLDER DEFINITIONS

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{SKILL_NAME}` | string | ✅ | Lowercase, hyphens only. MUST match parent folder name. 1-64 chars. |
| `{DESCRIPTION}` | string | ✅ | 1-1024 chars. State capability AND trigger (when to invoke). |
| `{SKILL_TITLE}` | string | ✅ | Human-readable name for display |
| `{ONE_LINE_DESCRIPTION}` | string | ✅ | Single sentence: what this skill does |
| `{STEP_N}` | string | ✅ | Action step. Include command if applicable. |
| `{FAILURE_CONDITION_N}` | string | ✅ | What can go wrong at each critical step |
| `{RECOVERY_ACTION_N}` | string | ✅ | How to recover or report the failure |

---

## OPTIONAL SECTIONS

### License (for distribution)

```yaml
license: MIT
```

### Compatibility (platform-specific)

```yaml
compatibility: Requires Windows and PowerShell 5.1+
```

### Metadata (for discoverability)

```yaml
metadata:
  author: {your-name}
  version: "1.0.0"
  tags: [workflow, automation]
```

### Reference Files (JIT loading)

```markdown
## Reference Files

- [{Reference Name}](references/{file}.md)
```

⚠️ References must be ONE level deep only. No nested references.

### Validation (verifiable output)

```markdown
## Validation

Run `{VALIDATION_COMMAND}` to verify success.

Expected:
- [ ] {CHECK_1}
- [ ] {CHECK_2}
```

---

## DEGREE OF FREEDOM GUIDE

Match instruction precision to task fragility:

| Freedom | When to Use | Example |
|---------|-------------|---------|
| **High** (text) | Multiple valid approaches | "Handle errors appropriately" |
| **Medium** (pseudocode) | Preferred pattern exists | "1. Check X 2. If Y then Z" |
| **Low** (specific commands) | Fragile/destructive ops | "Run exactly: `npm run db:migrate`" |

**Rule:** If operation is destructive OR sequence-sensitive → use LOW freedom (specific commands).

---

## VALIDATION

Before using this skill file, verify:

```
VALIDATE_SKILL_SKELETON:
  Structure:
  □ File is SKILL.md inside {skill-name}/ folder
  □ Folder name matches `name` field exactly
  □ Has YAML frontmatter with name + description
  □ Has Steps section with numbered steps
  □ Has Error Handling section
  
  Content:
  □ All {PLACEHOLDER} values replaced
  □ All <!-- GENERATOR: --> comments removed or filled
  □ Description includes WHEN to invoke (not just WHAT)
  □ Body < 500 lines
  
  Naming:
  □ Name is 1-64 characters
  □ Name is lowercase alphanumeric + hyphens
  □ No consecutive hyphens
  □ Doesn't start/end with hyphen
  
  Portability:
  □ No `allowed-tools` field (not supported in VS Code)
  □ Uses forward slashes for paths
  □ Platform-specific ops have compatibility note
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [skill-patterns.md](../PATTERNS/skill-patterns.md) | Full patterns and rules |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to use skill vs other types |
| [skill-checklist.md](../CHECKLISTS/skill-checklist.md) | Detailed validation |

---

## SOURCES

- [skill-patterns.md](../PATTERNS/skill-patterns.md) — Structure extracted from STRUCTURE section
