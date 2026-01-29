---
agent: brain
description: Synthesize quality-patterns.md - context engineering, verification, hallucination prevention
---

# Synthesize: quality-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework quality approach (context engineering, verification, hallucination prevention, red-team).

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/quality-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/quality-patterns.md` |

## Source Files (6 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [context-quality.md](../../cookbook/CONTEXT-ENGINEERING/context-quality.md) | Extract: quality hierarchy, relevance criteria |
| 2 | [utilization-targets.md](../../cookbook/CONTEXT-ENGINEERING/utilization-targets.md) | Extract: utilization metrics, sweet spots |
| 3 | [compaction-patterns.md](../../cookbook/CONTEXT-ENGINEERING/compaction-patterns.md) | Extract: compaction triggers, strategies |
| 4 | [hallucination-reduction.md](../../cookbook/PATTERNS/hallucination-reduction.md) | Extract: grounding patterns, "I don't know" |
| 5 | [verification-gates.md](../../cookbook/PATTERNS/verification-gates.md) | Extract: evidence requirements, claim validation |
| 6 | [four-modes.md](../../cookbook/RED-TEAM/four-modes.md) | Extract: red-team modes, review patterns |

## Iteration Plan (Complexity: High → 8 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze context-quality.md + Related | @brain |
| 2 | Analysis | Analyze utilization-targets.md + Related | @brain |
| 3 | Analysis | Analyze compaction-patterns.md + Related | @brain |
| 4 | Analysis | Analyze hallucination-reduction.md + Related | @brain |
| 5 | Analysis | Analyze verification-gates.md + Related | @brain |
| 6 | Analysis | Analyze four-modes.md + Related | @brain |
| 7 | Critique | Challenge decisions D1-Dn | @brain |
| 8 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-6) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 7) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final quality-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 6 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] Context engineering approach defined (quality hierarchy, utilization)
- [ ] Verification gates synthesized (evidence before claims)
- [ ] Hallucination reduction patterns ("I don't know", grounding)
- [ ] Compaction triggers defined
- [ ] Red-team modes (Security/Logic/Bias/Completeness) specified
- [ ] Anti-sycophancy patterns
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
