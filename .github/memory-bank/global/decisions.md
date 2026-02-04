# Architecture Decision Records

Cross-session decision log. Agents reference for context continuity.

<decision_format>

## ADR-[NNN]: [Title]

**Date:** [YYYY-MM-DD]

**Status:** proposed | accepted | deprecated | superseded

**Context:** [Why this decision was needed]

**Decision:** [What was decided]

**Consequences:**
- [Positive consequence]
- [Negative consequence or tradeoff]

**Supersedes:** [ADR-XXX if applicable]

</decision_format>

<decisions>

## ADR-001: Brain Agent Mode Structure and Boundaries

**Date:** 2026-02-04

**Status:** accepted

**Context:** Brain agent needed enhancement to match user vision as strategic partner. Original had 5 modes (exploration, research, synthesis, iteration, perspective) with tools-boundaries misalignment (had `edit` tool but boundaries said "Don't edit files").

**Decision:** Refactor brain agent with:
1. **5 modes (restructured):** explore, decide (new), ideate (new), research (absorbed synthesis), perspective (enhanced)
2. **Iteration as capability:** Not a standalone mode; available cross-mode via subagent spawning
3. **Boundaries scoped:** Brain CAN edit own reports and memory-bank files; CANNOT edit codebase or external artifacts
4. **Iron Law IL_003 revised:** "Never edit codebase or external artifacts" (was "never edit files")
5. **Three handoff package types:** Research Report, Analysis Report, Ideation Summary
6. **Portability:** Context paths as conventions ("load if present"), cross-references conditional

**Consequences:**
- Brain can persist its own findings to memory-bank
- Tools-boundaries alignment fixed (edit tool + scoped boundaries)
- Iron laws and rationalization tables retained (skill-compliant)
- Modes reduced but more focused (5 instead of overlapping 5)
- Handoff packages now typed for different outputs
- Agent is portable across repos (no hardcoded paths)

**Implications for other artifacts:**
- Skills referencing brain modes must update to new names (explore, decide, ideate, research, perspective)
- Agents receiving brain handoffs should expect typed packages
- Memory-bank paths are conventions, not requirements

## ADR-002: Memory-Bank Unified Access Pattern

**Date:** 2026-02-04

**Status:** accepted

**Context:** Brain agent was given edit permissions for memory-bank. Other core agents (architect, build, inspect) also need to persist findings, decisions, and session state. Without unified access: (1) each agent learns memory-bank structure independently, (2) inconsistent update patterns, (3) no reusable session-end workflow.

**Decision:** Implement unified memory-bank access:
1. **All core agents get `edit` tool** — Required for memory-bank writes
2. **New instruction: `memory-bank.instructions.md`** — Auto-applies to `memory-bank/**` files; defines structure, update patterns, and rules all agents must follow
3. **New prompt: `session-end.prompt.md`** — Reusable prompt user invokes at session end to trigger memory-bank updates regardless of active agent

**Consequences:**
- Consistent memory-bank structure across all agents
- Instruction auto-loads when any agent touches memory-bank files
- User has single command (`/session-end`) to persist session state
- Reduces duplication — agents reference instruction instead of embedding rules
- All core agents require `edit` tool (architect, build, inspect need update if missing)

**Artifacts created:**
- `.github/instructions/memory-bank.instructions.md`
- `.github/prompts/session-end.prompt.md`

</decisions>
