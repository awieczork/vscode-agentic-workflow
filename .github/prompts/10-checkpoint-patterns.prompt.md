---
agent: brain
description: Synthesize checkpoint-patterns.md - THE framework approval approach
---

# Synthesize: checkpoint-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework checkpoint/approval approach (human-in-the-loop controls).

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/checkpoint-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/checkpoint-patterns.md` |

## Source Files (4 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [approval-gates.md](../../cookbook/CHECKPOINTS/approval-gates.md) | Extract: gate types, triggers, criteria |
| 2 | [destructive-ops.md](../../cookbook/CHECKPOINTS/destructive-ops.md) | Extract: detection patterns, safeguards |
| 3 | [escalation-tree.md](../../cookbook/CHECKPOINTS/escalation-tree.md) | Extract: escalation flow, decision points |
| 4 | [permission-levels.md](../../cookbook/CHECKPOINTS/permission-levels.md) | Extract: level definitions, capabilities |

## Iteration Plan (Complexity: Medium → 5 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze approval-gates.md + Related | @brain |
| 2 | Analysis | Analyze destructive-ops.md + Related | @brain |
| 3 | Analysis | Analyze escalation-tree.md + Related | @brain |
| 4 | Analysis | Analyze permission-levels.md + Related | @brain |
| 5 | Critique | Challenge decisions D1-Dn | @brain |
| 6 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-4) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 5) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final checkpoint-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 4 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE checkpoint approach defined
- [ ] Permission levels (0-3) synthesized
- [ ] Destructive ops detection and handling
- [ ] Escalation tree/decision flow specified
- [ ] Approval gate categories (safety, quality, resource)
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
