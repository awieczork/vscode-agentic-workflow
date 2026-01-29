---
type: template
version: 1.0.0
purpose: Copy-paste starting point for .agent.md files
applies-to: [generator, build]
template-for: agent
last-updated: 2026-01-28
---


---

## TEMPLATE

```markdown
---
name: {AGENT_NAME}
description: {DESCRIPTION}
tools: {TOOLS_ARRAY}
<!-- GENERATOR: Add model field only if specific model required -->
<!-- GENERATOR: Add handoffs array if agent chains to others -->
---

# {DISPLAY_NAME}****

> {ONE_LINE_SUMMARY}

<!-- GENERATOR: Add <role> section if agent needs defined persona/stance -->

<safety>
<!-- P1: Cannot be overridden -->
- **Never** {SAFETY_RULE_1}
- **Never** {SAFETY_RULE_2}
- **Priority:** Safety > Clarity > Flexibility > Convenience
</safety>

<context_loading>
## Session Start
Read in order:
1. `.github/memory-bank/projectbrief.md` — {WHY_LOAD_THIS}
<!-- GENERATOR: Add additional files as needed -->

## On-Demand
- {ON_DEMAND_FILE_1}
</context_loading>

<modes>
## Mode 1: {MODE_NAME}
**Trigger:** "{TRIGGER_PHRASE}"
<!-- GENERATOR: Add 3-5 steps for this mode -->

<!-- GENERATOR: Add additional modes as needed (2-4 typical) -->
</modes>

<boundaries>
**Do:** (✅ Always)
- {ALWAYS_DO_1}
- {ALWAYS_DO_2}

**Ask First:** (⚠️)
- {ASK_FIRST_1}

**Don't:** (🚫 Never)
- {NEVER_DO_1} (→ @{HANDOFF_AGENT})
</boundaries>

<!-- GENERATOR: Add <outputs> section if agent produces files -->
<!-- GENERATOR: Add <stopping_rules> section if agent has handoff triggers -->
```

---

## PLACEHOLDER DEFINITIONS

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{AGENT_NAME}` | string | ✅ | Lowercase, hyphen-separated. Must match filename. |
| `{DESCRIPTION}` | string | ✅ | 1-2 sentences: what agent does + when to invoke |
| `{TOOLS_ARRAY}` | array | No | `["*"]` for all tools, or specific list. Omit for default. |
| `{DISPLAY_NAME}` | string | ✅ | Human-readable title (can include emoji) |
| `{ONE_LINE_SUMMARY}` | string | ✅ | Single sentence describing agent's purpose |
| `{SAFETY_RULE_1}` | string | ✅ | First P1 safety constraint (never overridable) |
| `{SAFETY_RULE_2}` | string | ✅ | Second P1 safety constraint |
| `{WHY_LOAD_THIS}` | string | ✅ | Reason for loading each context file |
| `{ON_DEMAND_FILE_1}` | string | No | Files loaded during task execution |
| `{MODE_NAME}` | string | ✅ | Name of operational mode |
| `{TRIGGER_PHRASE}` | string | ✅ | User input that activates this mode |
| `{ALWAYS_DO_1}` | string | ✅ | Actions agent always performs |
| `{ASK_FIRST_1}` | string | No | Actions requiring user confirmation |
| `{NEVER_DO_1}` | string | ✅ | Actions agent must not perform |
| `{HANDOFF_AGENT}` | string | No | Agent to handoff to for restricted actions |

---

## OPTIONAL SECTIONS

### Role Section (if agent needs defined persona)

```markdown
<role>
**Identity:** {WHO_THE_AGENT_IS}
**Stance:** {BEHAVIORAL_APPROACH}
</role>
```

### Handoffs (if agent chains to others)

```yaml
handoffs:
  - label: "{BUTTON_TEXT}"
    agent: {TARGET_AGENT}
    prompt: {CONTEXT_FOR_TARGET}
    send: false  # Always false unless trusted chain
```

### Outputs (if agent produces files)

```markdown
<outputs>
**{OUTPUT_TYPE}:** `{FILE_PATH_PATTERN}`
</outputs>
```

### Stopping Rules (if agent has conditional handoffs)

```markdown
<stopping_rules>
| Trigger | Action |
|---------|--------|
| {CONDITION} | → @{TARGET_AGENT} |
</stopping_rules>
```

---

## VALIDATION

Before using this agent file, verify:

```
VALIDATE_AGENT_SKELETON:
  Structure:
  □ File saved to .github/agents/{name}.agent.md
  □ Filename matches `name` field in frontmatter
  □ Has YAML frontmatter
  □ Has title with one-line summary
  □ Has <safety> section with P1 rules
  □ Has <context_loading> section
  □ Has <modes> section with at least one mode
  □ Has <boundaries> section with Do/Ask/Don't
  
  Content:
  □ All {PLACEHOLDER} values replaced
  □ All <!-- GENERATOR: --> comments removed or filled
  □ Safety rules have NO escape clauses
  □ Body ≤25,000 characters
  
  Naming:
  □ Name is lowercase with hyphens
  □ Name is ≤50 characters
  □ Name doesn't conflict with reserved names (workspace, terminal, vscode, github, plan, ask, edit, agent)
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [agent-patterns.md](../PATTERNS/agent-patterns.md) | Full patterns and rules |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to use agent vs other types |
| [agent-checklist.md](../CHECKLISTS/agent-checklist.md) | Detailed validation |

---

## SOURCES

- [agent-patterns.md](../PATTERNS/agent-patterns.md) — Structure extracted from STRUCTURE section
