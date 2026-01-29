---
type: patterns
version: 1.0.0
purpose: THE framework approach for building VS Code Copilot agents
---

# Agent Patterns

> **Definitive patterns for creating `.agent.md` files in VS Code Copilot**

---

## PURPOSE

Agent files (`.agent.md`) create **specialized chat personas** in VS Code Copilot with:
- Defined identity and behavioral stance
- Scoped tool access
- Workflow transitions via handoffs
- Domain-specific instructions

**Problem Solved:** Without agents, Copilot is a generalist. Agent files create domain-specific personas that behave consistently, have appropriate tool access, and chain into workflows.

---

## GENERAL PRACTICES

### TOOLS
You can reference specific tools using the `#tool:<tool-name>` syntax.
 
Example: 
`Use #tool:codebase to search the codebase and #tool:fetch to retrieve web content.`

### BEST PRACTICES
1. If needed - put commands early
2. Code examples over explanations - if applicable
3. 

### Cover Six Core Areas



## STRUCTURE

### File Location

```
.github/
└── agents/
    └── {agent-name}.agent.md
```

### Required Sections

| Section | Purpose | TL:DR |
|---------|---------|----------|
| **YAML Frontmatter** | Identity, tools, handoffs | TODO |
| **Title + Summary** | Agent name and one-line purpose | TODO |
| **Role/Identity** | Persona definition, stance | TODO |
| **Safety** | P1 constraints that cannot be overridden | TODO |
| **Context Loading** | What to load at session start | TODO |
| **Modes/Workflow** | Operational modes or workflow phases | TODO |
| **Boundaries** | ✅ Always / ⚠️ Ask / 🚫 Never rules | TODO |
| **Outputs** | Response formats, file naming | TODO |
| **Stopping Rules** | When to handoff vs execute directly | TODO |

### Section Order

```
1. YAML Frontmatter (---)
2. Title + Summary (# Agent Name)
3. <role> or ## Role
4. <safety> or ## Safety  
5. <context_loading> or ## Context Loading
6. <modes> or ## Modes/Workflow
7. <boundaries> or ## Boundaries
8. <outputs> or ## Outputs
9. <stopping_rules> or ## Stopping Rules
```

---

## NAMING RULES

### File Naming Pattern

```
{agent-name}.agent.md
```

### Name Format Rules

| Rule | Requirement | Example |
|------|-------------|---------|
| **Case** | All lowercase | ✅ `architect` ❌ `Architect` |
| **Separators** | Hyphens only | ✅ `meta-synthesis` ❌ `metaSynthesis` |
| **Semantic** | Name reflects function | ✅ `meta-decision-mapper` ❌ `mapper` |
| **Length** | ≤50 characters | Prevents filesystem issues |

### Reserved Names (Do Not Use)

These conflict with VS Code built-ins:

```
workspace, terminal, vscode, github, azure,
plan, ask, edit, agent
```

---

## AUTHORING RULES

### RULE_001: Frontmatter Schema

```yaml
REQUIRE: YAML frontmatter with at least `name` or filename-derived identity
REJECT_IF: Unknown frontmatter fields (VS Code ignores; signals copy-paste error)
RATIONALE: Frontmatter controls agent behavior at platform level
```

**Valid Frontmatter Fields:**

| Field | Type | Default | Purpose |
|-------|------|---------|---------|
| `name` | string | filename | Display name |
| `description` | string | — | Purpose shown in UI |
| `tools` | array | `["*"]` | Tool access list |
| `model` | string | — | Model selection |
| `argument-hint` | string | — | User input placeholder |
| `infer` | boolean | `true` | Allow as subagent |
| `target` | string | both | `"vscode"` or `"github-copilot"` |
| `handoffs` | array | — | Workflow transitions |

### RULE_002: Tool Configuration

```yaml
REQUIRE: Explicit `tools:` for constrained agents; omit for general-purpose
REJECT_IF: `tools: []` without clear advisory-only purpose documented
RATIONALE: Empty tools = ask-only mode; must be intentional
```

**Tool Configuration Patterns:**

| Pattern | Configuration | Use When |
|---------|---------------|----------|
| All tools | omit or `["*"]` | General-purpose agents |
| Specific | `["read", "edit", "search"]` | Constrained specialists |
| Read-only | `["read", "search"]` | Research/planning agents |
| None | `[]` | Advisory agents (document why) |
| MCP | `["github/*", "playwright/*"]` | External service access |

**Official Tool Aliases:**

| Alias | Description |
|-------|-------------|
| `execute` | Shell/terminal commands |
| `read` | File reading |
| `edit` | File editing |
| `search` | Code search |
| `agent` | Subagent invocation |
| `web` | Web browsing |
| `todo` | Task tracking |

### RULE_003: Handoff Configuration

```yaml
REQUIRE: `send: false` default (human review before transition)
REJECT_IF: `send: true` on handoffs to agents with edit/execute tools
RATIONALE: Automated transitions to powerful agents bypass safety review
```

**Handoff Fields:**

| Field | Required | Purpose |
|-------|----------|---------|
| `label` | ✅ | Button text shown in chat |
| `agent` | ✅ | Target agent filename (without `.agent.md`) |
| `prompt` | No | Context passed to target |
| `send` | No | `false` (default) = pre-fill; `true` = auto-submit |

**Example:**

```yaml
handoffs:
  - label: "📋 Create Plan"
    agent: architect
    prompt: Based on research findings, create implementation plan.
    send: false  # Human reviews before sending
```

### RULE_004: Safety Section

```yaml
REQUIRE: <safety> section with P1 constraints for any agent with edit/execute tools
REJECT_IF: Escape clauses on P1 rules ("unless user requests...")
RATIONALE: P1 constraints are NEVER overridable; escape clauses invite bypass
```

**Safety Section Pattern:**

```markdown
<safety>
<!-- P1: Cannot be overridden -->
- **Never** commit secrets, API keys, or credentials
- **Never** fabricate sources — say "I don't know" when uncertain
- **Priority:** Safety > Clarity > Flexibility > Convenience
</safety>
```

### RULE_005: Context Loading Section

```yaml
REQUIRE: <context_loading> declaring what to load at session start
REJECT_IF: Agent has no context strategy (starts blind every session)
RATIONALE: Consistent context = consistent behavior across sessions
```

**Context Loading Pattern:**

```markdown
<context_loading>
## Session Start
Read in order:
1. `.github/memory-bank/projectbrief.md` — Current phase, project context
2. `.github/memory-bank/activeContext.md` — Current focus (if exists)

## On-Demand
- Source files when referenced in task
- Prior session reports for continuation
</context_loading>
```

### RULE_006: Boundaries Section

```yaml
REQUIRE: Three-tier boundary format (✅/⚠️/🚫)
REJECT_IF: Vague boundaries ("be careful with...") without actionable rules
RATIONALE: Clear boundaries enable consistent behavior and violation detection
```

**Boundary Format Example:**

```markdown
<boundaries>
**Do:** (✅ Always)
- Explore options, frame decisions
- Reference project context
- Execute small tasks directly

**Ask First:** (⚠️)
- Before modifying shared utilities
- Before changes >50 lines

**Don't:** (🚫 Never)
- Write large implementation code (→ @build)
- Conduct deep research (→ @research)
</boundaries>
```

### RULE_007: Character Limit

```yaml
REQUIRE: Agent body ≤25,000 characters
REJECT_IF: Body exceeds 25,000 characters
RATIONALE: 30k platform limit minus 5k buffer for context injection
```

### RULE_008: Step Scope

```yaml
REQUIRE: Agent designed for 3-10 step tasks
REJECT_IF: Agent attempts unbounded iteration without exit criteria
RATIONALE: Focused agents maintain context quality; complex tasks decompose via handoffs
```

---

## VALIDATION CHECKLIST
**Structure:**
  - Has YAML frontmatter
  - Has title with one-line summary
  - Has <role> or <identity> 
  - Has <safety> 
  - Has <context_loading> 
  - Has <modes> or <workflow> or both or both nested -> <workflow-mode> under <mode-{name}>
  - Has <boundaries> 
  - Has <outputs> (if applicable)
  - Has <stopping_rules> 

**Naming:**
  - Filename is lowercase with hyphens
  - Name does not conflict with reserved names
  - Prefix matches category (none/meta-/domain-)
  
**Constraints:**
  - Body ≤25,000 characters
  - Under 300 lines
  - P1 safety rules have NO escape clauses
  - Handoffs default to `send: false`
  
**Quality:**
  - Tools explicitly configured OR intentionally ["*"]
  - Exit criteria defined for iterative modes
  - Stopping rules define handoff triggers


---

## HARD-RULES
1. Keep under 300 lines, if needed attach files to <context_loading>
2. Default handoffs to `send: false` unless requested by user
3. Use orchestrator pattern for multi-agent workflows (hub-and-spoke)
4. Provide DO THIS / NOT THIS code samples instead of explanation-heavy instructions
5. Include exit conditions in loops (e.g., "After 3 cycles, escalate to human")
6. Specify exact versions for stacks (e.g., "Python 3.11") to ensure consistency
7. P1 constraints have NO exceptions

---

## EXAMPLES

<!-- TODO -->

---

### Feature Requirements

| Feature | Required Setting |
|---------|------------------|
| Custom agents as subagents | `chat.customAgentInSubagent.enabled: true` (experimental) |
| MCP server access | `chat.mcp.access: true` |
| Agent mode | `chat.agent.enabled: true` |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | When to use agent vs skill vs instruction |
| [skill-patterns.md](skill-patterns.md) | Companion component type |
| [instruction-patterns.md](instruction-patterns.md) | Global rules agents inherit |
| [CHECKLISTS/agent-checklist.md](../CHECKLISTS/agent-checklist.md) | Validation checklist |
| [TEMPLATES/agent-template.md](../TEMPLATES/agent-template.md) | Copy-paste starting point |

---

## SOURCES

- [VS Code — Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Official agent file format
- [GitHub Docs — Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration) — Frontmatter schema, limits
- [GitHub Blog — AGENTS.md Lessons from 2,500+ Repositories](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) — Best practices
- [cookbook/CONFIGURATION/agent-file-format.md](../../cookbook/CONFIGURATION/agent-file-format.md) — Detailed format reference
- [cookbook/CONFIGURATION/agent-naming.md](../../cookbook/CONFIGURATION/agent-naming.md) — Naming conventions
- [cookbook/PATTERNS/constraint-hierarchy.md](../../cookbook/PATTERNS/constraint-hierarchy.md) — P1-P4 priority system
- [cookbook/PATTERNS/twelve-factor-agents.md](../../cookbook/PATTERNS/twelve-factor-agents.md) — Design principles
