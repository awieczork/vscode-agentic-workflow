---
agent: brain
description: Synthesize NAMING.md - all naming conventions
---

# Synthesize: NAMING.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize all naming conventions for the framework.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/naming.md` |
| Output | `GENERATION-RULES/NAMING.md` |

## Source Files (2 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [agent-naming.md](../../cookbook/CONFIGURATION/agent-naming.md) | Extract: naming patterns, categories, reserved names |
| 2 | [file-structure.md](../../cookbook/CONFIGURATION/file-structure.md) | Extract: folder conventions, file locations |

## Iteration Plan (Complexity: Low → 3 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze agent-naming.md + Related | @brain |
| 2 | Analysis | Analyze file-structure.md + Related | @brain |
| 3 | Synthesis | Final naming synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-2) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Synthesize** — produce final NAMING.md (no critique for Low complexity)

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `rules`

Key requirements for naming rules specifically:
- NAME_RULE_NNN format with PATTERN/VALID_EXAMPLES/INVALID_EXAMPLES/RATIONALE
- Tables with Valid AND Invalid examples
- VALIDATION CHECKLIST for inspect agents

## Done When

- [ ] All 2 subagent analyses complete
- [ ] File naming patterns for all component types
- [ ] Folder structure conventions
- [ ] Agent naming categories (workflow, meta, domain)
- [ ] Reserved names documented
- [ ] Anti-patterns documented with "why"
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
