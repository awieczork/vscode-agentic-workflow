# VS Code Copilot Cookbook

Practical patterns, configurations, and templates for building agentic workflows with GitHub Copilot in VS Code.

**49 files** • **9 sections** • Synthesized from **13 research reports**

---

## Quick Start

| I want to... | Start here |
|--------------|------------|
| Configure my first agent | [agent-file-format](CONFIGURATION/agent-file-format.md) |
| Set up project-wide instructions | [instruction-files](CONFIGURATION/instruction-files.md) |
| Understand the file structure | [file-structure](CONFIGURATION/file-structure.md) |
| Add MCP tools to my agent | [mcp-servers](CONFIGURATION/mcp-servers.md) |
| Build a spec-driven workflow | [spec-driven](WORKFLOWS/spec-driven.md) |
| Preserve context across sessions | [memory-bank-files](CONTEXT-MEMORY/memory-bank-files.md) |
| Copy a ready-to-use spec template | [spec-template](TEMPLATES/spec-template.md) |

---

## Table of Contents

### [CONFIGURATION/](CONFIGURATION/) — 8 files
Core file formats and settings for VS Code Copilot.

| File | Description |
|------|-------------|
| [agent-file-format](CONFIGURATION/agent-file-format.md) | `.agent.md` specification with all frontmatter fields |
| [instruction-files](CONFIGURATION/instruction-files.md) | `copilot-instructions.md` and `.instructions.md` hierarchy |
| [skills-format](CONFIGURATION/skills-format.md) | `SKILL.md` format for agent capabilities |
| [prompt-files](CONFIGURATION/prompt-files.md) | `.prompt.md` reusable prompt templates |
| [settings-reference](CONFIGURATION/settings-reference.md) | VS Code `settings.json` for Copilot |
| [mcp-servers](CONFIGURATION/mcp-servers.md) | MCP server configuration (stdio, http, docker) |
| [file-structure](CONFIGURATION/file-structure.md) | `.github/` folder organization |
| [memory-bank-schema](CONFIGURATION/memory-bank-schema.md) | `.github/memory-bank/` directory structure |

### [CONTEXT-ENGINEERING/](CONTEXT-ENGINEERING/) — 6 files
Managing context window effectively.

| File | Description |
|------|-------------|
| [context-variables](CONTEXT-ENGINEERING/context-variables.md) | Complete `#file`, `#codebase`, `#selection` reference |
| [utilization-targets](CONTEXT-ENGINEERING/utilization-targets.md) | 40-60% target, context rot prevention |
| [compaction-patterns](CONTEXT-ENGINEERING/compaction-patterns.md) | FIC workflow, tool result clearing |
| [subagent-isolation](CONTEXT-ENGINEERING/subagent-isolation.md) | `#runSubagent` context control |
| [just-in-time-retrieval](CONTEXT-ENGINEERING/just-in-time-retrieval.md) | Progressive disclosure, load on demand |
| [context-quality](CONTEXT-ENGINEERING/context-quality.md) | Correctness > Completeness > Size |

### [WORKFLOWS/](WORKFLOWS/) — 9 files
Structured approaches to agent-assisted development.

| File | Description |
|------|-------------|
| [spec-driven](WORKFLOWS/spec-driven.md) | Specify → Plan → Tasks → Implement |
| [spec-templates](WORKFLOWS/spec-templates.md) | `.spec.md` templates, Current→Proposed format |
| [research-plan-implement](WORKFLOWS/research-plan-implement.md) | R→P→I with compaction triggers |
| [riper-modes](WORKFLOWS/riper-modes.md) | 5-mode system with permission boundaries |
| [wrap-task-decomposition](WORKFLOWS/wrap-task-decomposition.md) | Write → Refine → Atomic → Pair |
| [handoffs-and-chains](WORKFLOWS/handoffs-and-chains.md) | Agent-to-agent transitions |
| [workflow-orchestration](WORKFLOWS/workflow-orchestration.md) | DAG patterns, branching, aggregation |
| [conditional-routing](WORKFLOWS/conditional-routing.md) | Task classification, priority routing |
| [task-tracking](WORKFLOWS/task-tracking.md) | Issue-based orchestration |

### [PATTERNS/](PATTERNS/) — 7 files
Proven patterns for reliable agent behavior.

| File | Description |
|------|-------------|
| [iron-law-discipline](PATTERNS/iron-law-discipline.md) | Inviolable rules, Red Flags, Rationalization Tables |
| [verification-gates](PATTERNS/verification-gates.md) | Evidence-before-claims protocol |
| [hallucination-reduction](PATTERNS/hallucination-reduction.md) | "I don't know", grounding, citations |
| [twelve-factor-agents](PATTERNS/twelve-factor-agents.md) | 12-Factor Agents principles |
| [prompt-engineering](PATTERNS/prompt-engineering.md) | 4-element structure, ReAct, positive framing |
| [constitutional-principles](PATTERNS/constitutional-principles.md) | Immutable rules pattern |
| [constraint-hierarchy](PATTERNS/constraint-hierarchy.md) | Safety > Context > Persona priority |

### [CONTEXT-MEMORY/](CONTEXT-MEMORY/) — 5 files
Persistent memory across sessions.

| File | Description |
|------|-------------|
| [memory-bank-files](CONTEXT-MEMORY/memory-bank-files.md) | 6-file templates with update triggers |
| [tiered-memory](CONTEXT-MEMORY/tiered-memory.md) | Hot/Warm/Cold/Frozen tiers |
| [conflict-resolution](CONTEXT-MEMORY/conflict-resolution.md) | ADD/UPDATE/DELETE/NOOP strategies |
| [session-handoff](CONTEXT-MEMORY/session-handoff.md) | Cross-session continuity template |
| [telos-goals](CONTEXT-MEMORY/telos-goals.md) | TELOS-lite goal files |

### [CHECKPOINTS/](CHECKPOINTS/) — 4 files
Human-in-the-loop controls.

| File | Description |
|------|-------------|
| [permission-levels](CHECKPOINTS/permission-levels.md) | 0-3 approval model |
| [destructive-ops](CHECKPOINTS/destructive-ops.md) | Detection and handling |
| [escalation-tree](CHECKPOINTS/escalation-tree.md) | Decision flow for stopping/asking |
| [approval-gates](CHECKPOINTS/approval-gates.md) | `.agent.md` checkpoint configuration |

### [RED-TEAM/](RED-TEAM/) — 3 files
Quality assurance and bias detection.

| File | Description |
|------|-------------|
| [four-modes](RED-TEAM/four-modes.md) | Security/Logic/Bias/Completeness |
| [iron-law-verification](RED-TEAM/iron-law-verification.md) | Anti-sycophancy checks |
| [critique-template](RED-TEAM/critique-template.md) | `.critique.md` format |

### [REFERENCE/](REFERENCE/) — 4 files
Quick reference materials.

| File | Description |
|------|-------------|
| [keyboard-shortcuts](REFERENCE/keyboard-shortcuts.md) | VS Code Copilot shortcuts |
| [mcp-server-stacks](REFERENCE/mcp-server-stacks.md) | Recommended server combinations |
| [vision-capabilities](REFERENCE/vision-capabilities.md) | Image input use cases |
| [collections-format](REFERENCE/collections-format.md) | `.collection.yml` bundling |

### [TEMPLATES/](TEMPLATES/) — 3 files
Ready-to-use copy-paste files.

| File | Description |
|------|-------------|
| [spec-template](TEMPLATES/spec-template.md) | Complete `.spec.md` template |
| [validation-checklist](TEMPLATES/validation-checklist.md) | 5-gate validation format |
| [constitution-template](TEMPLATES/constitution-template.md) | Constitutional principles template |

---

## Quality Standards

All content in this cookbook is:

| Standard | Meaning |
|----------|---------|
| **Actionable** | Copy-paste ready code blocks, not descriptions |
| **Sourced** | Links to original documentation and repos |
| **Verified** | Patterns from production use, not theory |
| **Connected** | Cross-references between related topics |

---

## Source Material

Synthesized from 13 research reports analyzing:
- GitHub Copilot documentation
- VS Code extension APIs
- 2,500+ agent repositories
- Anthropic context engineering guides
- Community patterns (Memory Bank, RIPER, etc.)

Full research corpus: [`../research/`](../research/)

---

## Archives

Synthesis process artifacts archived in [`../archive/synthesis-v3/`](../archive/synthesis-v3/):
- `DISCOVERY-TRACKER.md` — How structure emerged
- `VALIDATION-TRACKER.md` — Research validation pass
- `OFFICIAL-DOCS-VALIDATION-TRACKER.md` — Official docs validation pass
- `PARKED-ITEMS-TRANSLATION.md` — Evaluated but excluded patterns
