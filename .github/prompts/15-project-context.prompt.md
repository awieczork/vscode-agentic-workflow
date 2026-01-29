---
agent: brain
description: Synthesize project-context-template.md - user entry point before interviewer
---

# Synthesize: project-context-template.md

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Synthesize THE user entry point template — what users fill before interviewer.

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/project-context-template.md` |
| Output | `GENERATION-RULES/TEMPLATES/project-context-template.md` |

## Source Files (3 primary + Related refs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | [spec-template.md](../../cookbook/TEMPLATES/spec-template.md) | Extract: template structure, required sections |
| 2 | [project-spec-schema.md](../../cookbook/TEMPLATES/project-spec-schema.md) | Extract: schema fields, validation rules |
| 3 | [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) | Extract: validation criteria, self-checks |

## Iteration Plan (Complexity: Medium → 5 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze spec-template.md + Related | @brain |
| 2 | Analysis | Analyze project-spec-schema.md + Related | @brain |
| 3 | Analysis | Analyze validation-checklist.md + Related | @brain |
| 4 | Critique | Challenge decisions D1-Dn | @brain |
| 5 | Synthesis | Final template synthesis | Brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-3) — one per source file
3. **Log findings** to state file after each subagent returns
4. **Spawn critique subagent** (iteration 4) — challenge accumulated decisions
5. **Address critique** — resolve or document deferral
6. **Synthesize** — produce final project-context-template.md

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Output Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `template`

Key requirements for project-context template specifically:
- `template-for: project-context` in frontmatter
- HOW TO USE for Users, Interviewer, AND Generator
- FIELD DEFINITIONS with validation rules and consuming agents
- SELF-VALIDATION CHECKLIST for users
- NEXT STEPS section

## Done When

- [ ] All 3 subagent analyses complete
- [ ] Critique iteration complete + challenges addressed
- [ ] Minimal required fields identified
- [ ] Optional enhancements listed
- [ ] Validation criteria included
- [ ] Feeds directly into interviewer flow
- [ ] Copy-paste ready for users
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
