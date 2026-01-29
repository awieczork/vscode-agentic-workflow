---
agent: brain
description: Synthesize COMPONENT-MATRIX.md - when to use what component
---

# Synthesize: COMPONENT-MATRIX.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Create the decision matrix for "when to use what component" (agent vs skill vs instruction vs prompt).

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/component-matrix.md` |
| Output | `GENERATION-RULES/COMPONENT-MATRIX.md` |

## Source Files (4 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [agent-file-format.md](../../cookbook/CONFIGURATION/agent-file-format.md) | Extract: when to use agents, capabilities, constraints |
| 2 | [skills-format.md](../../cookbook/CONFIGURATION/skills-format.md) | Extract: when to use skills, capabilities, constraints |
| 3 | [instruction-files.md](../../cookbook/CONFIGURATION/instruction-files.md) | Extract: when to use instructions, capabilities, constraints |
| 4 | [prompt-files.md](../../cookbook/CONFIGURATION/prompt-files.md) | Extract: when to use prompts, capabilities, constraints |

## Iteration Plan (Complexity: High → 6 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze agent-file-format.md + Related | @brain |
| 2 | Analysis | Analyze skills-format.md + Related | @brain |
| 3 | Analysis | Analyze instruction-files.md + Related | @brain |
| 4 | Analysis | Analyze prompt-files.md + Related | @brain |
| 5 | Critique | Challenge decisions D1-Dn | @brain |
| 6 | Synthesis | Final matrix synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-4) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 5) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final COMPONENT-MATRIX.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `decision-matrix`

**Exemplar:** [decision-matrix-exemplar.md](../../GENERATION-RULES/_EXEMPLAR/decision-matrix-exemplar.md)

## Done When

- [ ] All 4 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] Matrix covers all 4 component types
- [ ] Every cell has THE framework answer (not options)
- [ ] Decision criteria are unambiguous
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
