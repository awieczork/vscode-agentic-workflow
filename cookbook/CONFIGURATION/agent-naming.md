---
when:
  - naming new custom agents
  - organizing agent taxonomy
  - avoiding naming conflicts with VS Code built-ins
pairs-with:
  - agent-file-format
  - file-structure
requires:
  - none
complexity: low
---

# Agent Naming Conventions

> **Purpose:** Guidelines for naming agents in the VS Code agentic framework
> **Reference:** [Agent Taxonomy Final](../../archive/brainstorm-reports-v1/2026-01-26-agent-taxonomy-final.md)

---

## Core Agents (User-Facing Workflow)

Core agents are **unprefixed** and used directly by users for standard workflow tasks.

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| `brainstorm` | Explore options, surface tradeoffs | Unclear direction, need to think through |
| `research` | Quick lookup, fact-check | Need specific information fast |
| `architect` | Create actionable plans, verify results | Know what to do, need structured approach |
| `build` | Execute plans, any file type | Have approved plan, ready to implement |
| `inspect` | Verify build matches spec | After build, before sign-off |

**Workflow Pattern:**
```
brainstorm → architect → build → inspect
```

---

## Meta Agents (Framework Development Tools)

Meta agents are **prefixed with `meta-`** and used for building/maintaining the framework itself.

| Agent | Purpose |
|-------|---------|
| `meta-decision-mapper` | Extracts architectural decisions from cookbook |
| `meta-prompt` | Prompt engineering for framework |
| `meta-synthesis` | Orchestrates synthesis pipeline |
| `meta-synthesis-reader-{model}` | Reads documentation sources |
| `meta-synthesis-validator-{model}` | Validates claims against official docs |
| `meta-research` | Deep research with comprehensive reports |

**Naming Pattern:**
- Base: `meta-{function}`
- With model variant: `meta-{function}-{model}`

---

## Naming Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Lowercase** | All agent names in lowercase | ✅ `architect` ✗ `Architect` |
| **Hyphenated** | Multi-word names use hyphens | ✅ `meta-synthesis` ✗ `metaSynthesis` |
| **Descriptive** | Name reflects primary function | ✅ `meta-decision-mapper` ✗ `mapper` |
| **No Conflicts** | Avoid VS Code built-in commands | ✅ `architect` ✗ `plan` (@Plan conflict) |

### Model Variant Suffix

When multiple models perform the same task:
- Pattern: `{agent-name}-{model}`
- Example: `meta-synthesis-reader-opus`, `meta-synthesis-reader-gemini`

---

## File Naming

Agent files use the pattern:
```
{agent-name}.agent.md
```

Examples:
- `brainstorm.agent.md`
- `meta-synthesis.agent.md`
- `meta-synthesis-reader-opus.agent.md`

---

## Related Documents

- [Agent File Format](agent-file-format.md) — Structure of `.agent.md` files
- [File Structure](file-structure.md) — Where agents live in the project
- [Agent Taxonomy Final](../../archive/brainstorm-reports-v1/2026-01-26-agent-taxonomy-final.md) — Full taxonomy decisions
