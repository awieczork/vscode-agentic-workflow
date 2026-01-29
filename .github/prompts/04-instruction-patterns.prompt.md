---
agent: brain
description: Synthesize instruction-patterns.md - THE way to build instructions (NO ROLES!)
---

# Synthesize: instruction-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework approach for instructions.

**CRITICAL:** Instructions MUST NOT define roles, personas, or identity. That's agents only.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/instruction-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/instruction-patterns.md` |

## Source Files (2 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [instruction-files.md](../../cookbook/CONFIGURATION/instruction-files.md) | Extract: structure, hierarchy, applyTo patterns |
| 2 | [constraint-hierarchy.md](../../cookbook/PATTERNS/constraint-hierarchy.md) | Extract: priority rules, override behavior |

## Iteration Plan (Complexity: Medium → 4 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze instruction-files.md + Related | @brain |
| 2 | Analysis | Analyze constraint-hierarchy.md + Related | @brain |
| 3 | Critique | Challenge decisions D1-Dn | @brain |
| 4 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-2) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 3) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final instruction-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 2 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE instruction structure defined
- [ ] copilot-instructions.md vs .instructions.md distinguished
- [ ] applyTo patterns documented
- [ ] 300-line limit documented
- [ ] **NO ROLES prohibition emphasized**
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
