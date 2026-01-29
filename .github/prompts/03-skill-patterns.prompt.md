---
agent: brain
description: Synthesize skill-patterns.md - THE way to build skills
---

# Synthesize: skill-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework approach for building skills.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/skill-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/skill-patterns.md` |

## Source Files (2 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [skills-format.md](../../cookbook/CONFIGURATION/skills-format.md) | Extract: structure, frontmatter, size limits |
| 2 | [collections-format.md](../../cookbook/REFERENCE/collections-format.md) | Extract: bundling, distribution patterns |

## Iteration Plan (Complexity: Medium → 4 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze skills-format.md + Related | @brain |
| 2 | Analysis | Analyze collections-format.md + Related | @brain |
| 3 | Critique | Challenge decisions D1-Dn | @brain |
| 4 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-2) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 3) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final skill-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 2 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE skill structure defined (not options)
- [ ] SKILL.md format specified
- [ ] Portability/reusability explained
- [ ] Size limits (500 lines, 5000 tokens) documented
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
