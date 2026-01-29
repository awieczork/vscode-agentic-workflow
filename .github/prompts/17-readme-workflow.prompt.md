---
agent: brain
description: Synthesize README + WORKFLOW-GUIDE - final integration
---

# Synthesize: README + WORKFLOW-GUIDE

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE framework workflow + README for GENERATION-RULES folder.

**Requires:** All other deliverables complete (1-16)

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/readme-workflow.md` |
| Output | `GENERATION-RULES/README.md` + `GENERATION-RULES/WORKFLOW-GUIDE.md` |

## Source Files (5 primary + all completed GENERATION-RULES)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [spec-driven.md](../../cookbook/WORKFLOWS/spec-driven.md) | Extract: spec-driven workflow patterns |
| 2 | [research-plan-implement.md](../../cookbook/WORKFLOWS/research-plan-implement.md) | Extract: agent flow patterns |
| 3 | [riper-modes.md](../../cookbook/WORKFLOWS/riper-modes.md) | Extract: mode-based workflow |
| 4 | [wrap-task-decomposition.md](../../cookbook/WORKFLOWS/wrap-task-decomposition.md) | Extract: task decomposition patterns |
| 5 | All completed `GENERATION-RULES/*` files | Extract: cross-references, navigation structure |

## Iteration Plan (Complexity: High → 8 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze spec-driven.md + Related | @brain |
| 2 | Analysis | Analyze research-plan-implement.md + Related | @brain |
| 3 | Analysis | Analyze riper-modes.md + Related | @brain |
| 4 | Analysis | Analyze wrap-task-decomposition.md + Related | @brain |
| 5 | Analysis | Audit all GENERATION-RULES files for cross-refs | @brain |
| 6 | Critique | Challenge workflow synthesis | @brain |
| 7 | Generate | Create README.md + WORKFLOW-GUIDE.md | Brain |
| 8 | Critique | Validate navigation + completeness | @brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-5) — gather all workflow patterns
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 6) — challenge workflow decisions
5. **Address critique** — resolve conflicts
6. **Generate outputs** (iteration 7) — create both files
7. **Spawn final critique** (iteration 8) — validate completeness

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output: README.md

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `index`

## Output: WORKFLOW-GUIDE.md

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `workflow`

Key requirements for these specific files:
- README has FILE INDEX with "Read When" guidance
- WORKFLOW-GUIDE has machine-parseable STAGE definitions
- Both have CROSS-REFERENCES to all other files

## Done When

- [ ] All 5 analysis subagents complete
- [ ] Both critique iterations complete + addressed
- [ ] README provides clear entry point
- [ ] WORKFLOW-GUIDE synthesizes all workflow patterns into ONE approach
- [ ] Cross-references to all other files
- [ ] Generator can navigate folder from README alone
- [ ] User can understand flow from WORKFLOW-GUIDE
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
