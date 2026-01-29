---
agent: brain
description: Synthesize CHECKLISTS/ - validation checklists for all components
---

# Synthesize: CHECKLISTS/

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Create validation checklists for each component type plus general quality/security.

**Requires:** All PATTERNS/*.md files complete (deliverables 2-10)

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/checklists.md` |
| Output | `GENERATION-RULES/CHECKLISTS/` (8 files) |

## Output Files

Create these checklists:
- `GENERATION-RULES/CHECKLISTS/agent-checklist.md`
- `GENERATION-RULES/CHECKLISTS/skill-checklist.md`
- `GENERATION-RULES/CHECKLISTS/instruction-checklist.md`
- `GENERATION-RULES/CHECKLISTS/prompt-checklist.md`
- `GENERATION-RULES/CHECKLISTS/memory-checklist.md`
- `GENERATION-RULES/CHECKLISTS/general-quality-checklist.md`
- `GENERATION-RULES/CHECKLISTS/security-checklist.md`
- `GENERATION-RULES/CHECKLISTS/pre-generation-checklist.md`

## Source Files (patterns + reference docs)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | All `GENERATION-RULES/PATTERNS/*.md` | Extract: rules to verify per component |
| 2 | [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) | Extract: checklist format, testability |
| 3 | [iron-law-verification.md](../../cookbook/RED-TEAM/iron-law-verification.md) | Extract: security checks, non-negotiables |
| 4 | [critique-template.md](../../cookbook/RED-TEAM/critique-template.md) | Extract: quality verification patterns |

## Iteration Plan (Complexity: Medium → 6 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze all pattern files (batch) | @brain |
| 2 | Analysis | Analyze validation-checklist.md | @brain |
| 3 | Analysis | Analyze iron-law-verification.md | @brain |
| 4 | Analysis | Analyze critique-template.md | @brain |
| 5 | Generate | Create all 8 checklist files | Brain |
| 6 | Critique | Validate checklists are testable | @brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagents** (iterations 1-4) — gather all checklist criteria
3. **Log findings** to state file after each subagent returns
4. **Generate checklists** (iteration 5) — brain creates all 8 files
5. **Spawn critique subagent** (iteration 6) — validate testability
6. **Fix any gaps** — ensure all checks are yes/no testable

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Checklist Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `checklist`

Key requirements for checklists specifically:
- `checklist-for` field specifying target component
- CHECK_NNN format with VERIFY/PASS_IF/FAIL_IF/SEVERITY
- Both machine-parseable blocks AND human-readable checkboxes
- CROSS-REFERENCES to pattern files being validated

## Done When

- [ ] All 4 analysis subagents complete
- [ ] All 8 checklist files created
- [ ] Critique validation complete
- [ ] Each verifies its pattern file
- [ ] general-quality covers context/verification/hallucination
- [ ] security covers secrets/permissions/destructive ops
- [ ] pre-generation covers spec completeness
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
