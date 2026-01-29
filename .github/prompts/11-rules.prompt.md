---
agent: brain
description: Synthesize RULES.md - cross-cutting MUST/NEVER rules
---

# Synthesize: RULES.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize cross-cutting MUST/NEVER rules that apply across all component types.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/rules.md` |
| Output | `GENERATION-RULES/RULES.md` |

## Source Files (3 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [constraint-hierarchy.md](../../cookbook/PATTERNS/constraint-hierarchy.md) | Extract: priority levels, override rules |
| 2 | [iron-law-discipline.md](../../cookbook/PATTERNS/iron-law-discipline.md) | Extract: non-negotiables, rationalization patterns |
| 3 | [constitutional-principles.md](../../cookbook/PATTERNS/constitutional-principles.md) | Extract: immutable rules, constitution structure |

## Iteration Plan (Complexity: Medium → 5 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze constraint-hierarchy.md + Related | @brain |
| 2 | Analysis | Analyze iron-law-discipline.md + Related | @brain |
| 3 | Analysis | Analyze constitutional-principles.md + Related | @brain |
| 4 | Critique | Challenge decisions D1-Dn | @brain |
| 5 | Synthesis | Final rules synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-3) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 4) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final RULES.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `rules`

## Done When

- [ ] All 3 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] Priority stack defined (Safety > ...)
- [ ] Universal rules synthesized
- [ ] Component-specific rules organized
- [ ] Iron laws identified (never override)
- [ ] Red flags / rationalization patterns documented
- [ ] Every rule traces to source
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
