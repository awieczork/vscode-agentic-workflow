---
agent: brain
description: Synthesize prompt-patterns.md - THE way to build prompts
---

# Synthesize: prompt-patterns.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework approach for prompt files.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/prompt-patterns.md` |
| Output | `GENERATION-RULES/PATTERNS/prompt-patterns.md` |

## Source Files (2 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [prompt-files.md](../../cookbook/CONFIGURATION/prompt-files.md) | Extract: structure, frontmatter, invocation |
| 2 | [context-variables.md](../../cookbook/CONTEXT-ENGINEERING/context-variables.md) | Extract: variable syntax, tool references |

## Iteration Plan (Complexity: Medium → 4 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze prompt-files.md + Related | @brain |
| 2 | Analysis | Analyze context-variables.md + Related | @brain |
| 3 | Critique | Challenge decisions D1-Dn | @brain |
| 4 | Synthesis | Final pattern synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-2) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 3) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final prompt-patterns.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `patterns`

## Done When

- [ ] All 2 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] THE prompt structure defined
- [ ] Frontmatter fields (agent, model, tools, description) documented
- [ ] Context variables (${file}, ${selection}, etc.) covered
- [ ] Workspace vs User prompts distinguished
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
