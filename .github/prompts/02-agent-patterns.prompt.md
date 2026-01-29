---
agent: brain
description: Synthesize agent-patterns.md - THE way to build agents
---

# Synthesize: agent-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework approach for building agents.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/agent-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/agent-patterns.md` |

## Source Files (4 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [agent-file-format.md](../../cookbook/CONFIGURATION/agent-file-format.md) | Extract: structure, frontmatter, body format |
| 2 | [agent-naming.md](../../cookbook/CONFIGURATION/agent-naming.md) | Extract: naming conventions, reserved names |
| 3 | [constraint-hierarchy.md](../../cookbook/PATTERNS/constraint-hierarchy.md) | Extract: priority layers, override rules |
| 4 | [twelve-factor-agents.md](../../cookbook/PATTERNS/twelve-factor-agents.md) | Extract: design principles, best practices |

## Iteration Plan (Complexity: High → 6 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze agent-file-format.md + Related | @brain |
| 2 | Analysis | Analyze agent-naming.md + Related | @brain |
| 3 | Analysis | Analyze constraint-hierarchy.md + Related | @brain |
| 4 | Analysis | Analyze twelve-factor-agents.md + Related | @brain |
| 5 | Critique | Challenge decisions D1-Dn | @brain |
| 6 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-4) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 5) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final agent-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 4 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE agent structure defined (not options)
- [ ] All frontmatter fields documented
- [ ] All required sections specified with order
- [ ] Constraints (max modes, line limits) explicit
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
