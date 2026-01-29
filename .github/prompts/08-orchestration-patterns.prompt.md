---
agent: brain
description: Synthesize orchestration-patterns.md - THE framework orchestration approach
---

# Synthesize: orchestration-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework orchestration approach (agent-to-agent, subagents, workflows).

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/orchestration-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/orchestration-patterns.md` |

## Source Files (4 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [handoffs-and-chains.md](../../cookbook/WORKFLOWS/handoffs-and-chains.md) | Extract: handoff patterns, chain types |
| 2 | [workflow-orchestration.md](../../cookbook/WORKFLOWS/workflow-orchestration.md) | Extract: orchestration models, state management |
| 3 | [subagent-isolation.md](../../cookbook/CONTEXT-ENGINEERING/subagent-isolation.md) | Extract: isolation rules, context budgets |
| 4 | [conditional-routing.md](../../cookbook/WORKFLOWS/conditional-routing.md) | Extract: routing logic, decision points |

## Iteration Plan (Complexity: High → 7 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze handoffs-and-chains.md + Related | @brain |
| 2 | Analysis | Analyze workflow-orchestration.md + Related | @brain |
| 3 | Analysis | Analyze subagent-isolation.md + Related | @brain |
| 4 | Analysis | Analyze conditional-routing.md + Related | @brain |
| 5 | Critique | Challenge decisions D1-Dn (round 1) | @brain |
| 6 | Critique | Challenge critique resolutions | @brain |
| 7 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-4) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 5) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Spawn second critique** (iteration 6) — validate resolutions
7. **Synthesize** — produce final orchestration-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 4 subagent analyses complete
- [ ] Both critique iterations complete + challenges addressed
- [ ] THE orchestration approach defined
- [ ] Handoff patterns (hub-and-spoke, chain, parallel) synthesized
- [ ] Subagent isolation rules specified
- [ ] Conditional routing approach defined
- [ ] Context utilization for subagents (40-60%)
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
