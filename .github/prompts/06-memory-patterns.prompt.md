---
agent: brain
description: Synthesize memory-patterns.md - THE framework memory approach
---

# Synthesize: memory-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework memory approach (persistent context across sessions).

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/memory-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/memory-patterns.md` |

## Source Files (5 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [memory-bank-files.md](../../cookbook/CONTEXT-MEMORY/memory-bank-files.md) | Extract: file types, purposes, update triggers |
| 2 | [memory-bank-schema.md](../../cookbook/CONFIGURATION/memory-bank-schema.md) | Extract: schema structure, required fields |
| 3 | [tiered-memory.md](../../cookbook/CONTEXT-MEMORY/tiered-memory.md) | Extract: loading tiers, when to load what |
| 4 | [session-handoff.md](../../cookbook/CONTEXT-MEMORY/session-handoff.md) | Extract: handoff patterns, continuation prompts |
| 5 | [telos-goals.md](../../cookbook/CONTEXT-MEMORY/telos-goals.md) | Extract: goal tracking, intent preservation |

## Iteration Plan (Complexity: High → 7 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze memory-bank-files.md + Related | @brain |
| 2 | Analysis | Analyze memory-bank-schema.md + Related | @brain |
| 3 | Analysis | Analyze tiered-memory.md + Related | @brain |
| 4 | Analysis | Analyze session-handoff.md + Related | @brain |
| 5 | Analysis | Analyze telos-goals.md + Related | @brain |
| 6 | Critique | Challenge decisions D1-Dn | @brain |
| 7 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-5) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 6) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final memory-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 5 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE memory structure defined (core files, tiers)
- [ ] Loading strategy synthesized (when to load what)
- [ ] Update triggers specified (when to update each file)
- [ ] Session handoff approach defined
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
