---
type: template
version: 1.0.0
purpose: Copy-paste starting point for .prompt.md files
applies-to: [generator, build]
template-for: prompt
last-updated: 2026-01-28
---

# Prompt Skeleton

> **Reusable prompt template for repeated workflows**

---

## HOW TO USE THIS TEMPLATE

**For Generator Agents:**
1. Copy the TEMPLATE section
2. Replace all `{PLACEHOLDER}` values
3. Use four-element body pattern: Instruction, Context, Input, Output
4. Handle empty `${selection}` case if using that variable

**For Build Agents:**
1. Create file at `.github/prompts/{name}.prompt.md`
2. Fill using template
3. Test via Command Palette or `/promptname` in chat

**For Users:**
1. Save to `.github/prompts/{name}.prompt.md`
2. Enable in settings: `"chat.promptFilesLocations": { ".github/prompts": true }`
3. Invoke via `/promptname` in chat

---

## TEMPLATE

```markdown
---
agent: {AGENT_TARGET}
description: {DESCRIPTION}
<!-- GENERATOR: Add model field only if specific model required -->
<!-- GENERATOR: Add tools array if restricting/expanding tools -->
<!-- GENERATOR: Add name field if different from filename -->
<!-- GENERATOR: Add argument-hint for user input prompts -->
---

# {PROMPT_TITLE}

## Instruction

{SPECIFIC_TASK}

## Context

{BACKGROUND_CONSTRAINTS}

<!-- GENERATOR: Add file links for additional context -->
<!-- [conventions](${workspaceFolder}/docs/conventions.md) -->

## Input

${selection}

<!-- GENERATOR: Handle empty selection case -->
(If no selection, {FALLBACK_BEHAVIOR})

## Expected Output

{OUTPUT_FORMAT}

<!-- GENERATOR: Add validation gate for complex workflows -->
<!-- 🚨 **STOP**: Review {checkpoint} before proceeding. -->
```

---

## PLACEHOLDER DEFINITIONS

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{AGENT_TARGET}` | string | ✅ | `ask`, `edit`, `agent`, or custom agent name |
| `{DESCRIPTION}` | string | ✅ | Shows in VS Code picker. Clear, discoverable. |
| `{PROMPT_TITLE}` | string | ✅ | H1 heading identifying the prompt |
| `{SPECIFIC_TASK}` | string | ✅ | What the prompt asks the agent to do |
| `{BACKGROUND_CONSTRAINTS}` | string | ✅ | Context, rules, constraints to follow |
| `{FALLBACK_BEHAVIOR}` | string | ✅ | What to do if `${selection}` is empty |
| `{OUTPUT_FORMAT}` | string | ✅ | Expected structure/format of response |

---

## FRONTMATTER OPTIONS

### Agent Targets

```yaml
agent: ask      # Conversational (no edits)
agent: edit     # File editing mode
agent: agent    # Agentic mode (full tools)
agent: plan     # Planning mode
agent: architect # Custom agent (if defined)
```

### Tools Configuration

```yaml
tools: ['*']                       # All available tools
tools: ['read_file', 'edit_file']  # Specific tools only
tools: ['github/*']                # MCP server wildcard
tools: []                          # No tools (ask-only mode)
```

### Model Override

```yaml
model: Claude Sonnet 4      # Specific model
model: Claude Opus 4.5      # For complex tasks
```

### User Input

```yaml
argument-hint: "Enter the component name"  # Input field hint
name: create-component                      # Name override (default: filename)
```

---

## CONTEXT VARIABLES

| Variable | Resolved To | Example |
|----------|-------------|---------|
| `${file}` | Current file path | `/src/app/page.tsx` |
| `${fileBasename}` | Filename | `page.tsx` |
| `${selection}` | Selected text | Highlighted code |
| `${workspaceFolder}` | Workspace root | `/Users/dev/project` |
| `${input:name}` | User dialog | Runtime value |
| `${input:name:placeholder}` | Dialog with hint | Runtime value |

**⚠️ Undefined variables render as literal strings (silent failure)**

**⚠️ `${selection}` = empty string if nothing selected**

---

## BODY PATTERNS

### Minimal (Quick Task)

```markdown
## Task
{What to do with the selection}

## Input
${selection}
```

### Standard (Four-Element)

```markdown
## Instruction
{Specific task}

## Context
{Background, constraints}

## Input
${selection}

## Expected Output
{Format specification}
```

### Complex (With Validation Gate)

```markdown
## Instruction
{Multi-step task}

## Context
{Background, constraints}

## Phase 1: Analysis
${selection}

🚨 **STOP**: Review analysis before proceeding.
- [ ] Requirements understood
- [ ] Approach approved

## Phase 2: Implementation
{Continue after approval}

## Expected Output
{Format specification}
```

---

## VALIDATION

Before using this prompt file, verify:

```
VALIDATE_PROMPT_SKELETON:
  Structure:
  □ File is .github/prompts/{name}.prompt.md
  □ Has YAML frontmatter with agent + description
  □ Has # Title heading
  □ Has body content with instructions
  
  Content:
  □ All {PLACEHOLDER} values replaced
  □ All <!-- GENERATOR: --> comments removed or filled
  □ Uses only documented ${} variables
  □ Empty ${selection} case handled (if used)
  □ Complex workflows have 🚨 STOP checkpoints
  
  Quality:
  □ Single purpose (one workflow per prompt)
  □ Instructions are positive ("do X" not "don't Y")
  □ Context budget considered (<3 large files per phase)
  □ File links use relative paths or ${workspaceFolder}
```

---

## ANTI-PATTERN QUICK REFERENCE

| ❌ Don't | ✅ Instead |
|----------|-----------|
| Empty frontmatter | Include agent + description minimum |
| Multi-purpose prompt | Split into separate files |
| Negative instructions | Positive framing ("do X") |
| Assume selection exists | Handle empty case explicitly |
| `${undocumentedVar}` | Use only documented variables |
| Load 5+ large files | Phase context loading |
| Hardcode absolute paths | Use `${workspaceFolder}` |
| Skip validation gates | Add 🚨 STOP for complex workflows |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [prompt-patterns.md](../PATTERNS/prompt-patterns.md) | Full patterns and rules |
| [agent-patterns.md](../PATTERNS/agent-patterns.md) | Agents that prompts invoke |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to use prompts vs agents |
| [prompt-checklist.md](../CHECKLISTS/prompt-checklist.md) | Detailed validation |

---

## SOURCES

- [prompt-patterns.md](../PATTERNS/prompt-patterns.md) — Structure extracted from STRUCTURE section
