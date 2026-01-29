---
agent: brain
description: Synthesize TEMPLATES/ - skeleton files for each component type
---

# Synthesize: TEMPLATES/

**FIRST:** Read the [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) completely — especially the **Subagent Synthesis Workflow** section.

## Task

Create skeleton templates for each component type based on synthesized patterns.

**Requires:** All PATTERNS/*.md files complete (deliverables 2-10)

## Files

| Type | Path |
|------|------|
| Reference | [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) |
| State | `workshop/synthesis-state/templates.md` |
| Output | `GENERATION-RULES/TEMPLATES/` (5 files) |

## Output Files

Create these skeleton templates:
- `GENERATION-RULES/TEMPLATES/agent-skeleton.md`
- `GENERATION-RULES/TEMPLATES/skill-skeleton.md`
- `GENERATION-RULES/TEMPLATES/instruction-skeleton.md`
- `GENERATION-RULES/TEMPLATES/prompt-skeleton.md`
- `GENERATION-RULES/TEMPLATES/memory-skeleton.md`

## Source Files (5 completed patterns + 1 reference)

| # | Source File | Subagent Task |
|---|-------------|---------------|
| 1 | `GENERATION-RULES/PATTERNS/agent-patterns.md` | Extract: required structure for agent skeleton |
| 2 | `GENERATION-RULES/PATTERNS/skill-patterns.md` | Extract: required structure for skill skeleton |
| 3 | `GENERATION-RULES/PATTERNS/instruction-patterns.md` | Extract: required structure for instruction skeleton |
| 4 | `GENERATION-RULES/PATTERNS/prompt-patterns.md` | Extract: required structure for prompt skeleton |
| 5 | `GENERATION-RULES/PATTERNS/memory-patterns.md` | Extract: required structure for memory skeleton |
| 6 | [spec-template.md](../../cookbook/TEMPLATES/spec-template.md) | Extract: template formatting patterns |

## Iteration Plan (Complexity: Medium → 5 iterations)

| # | Phase | Task | Subagent |
|---|-------|------|----------|
| 1 | Analysis | Analyze all 5 pattern files (batch) | @brain |
| 2 | Analysis | Analyze spec-template.md for format | @brain |
| 3 | Generate | Create agent + skill skeletons | Brain |
| 4 | Generate | Create instruction + prompt + memory skeletons | Brain |
| 5 | Critique | Validate all skeletons match patterns | @brain |

## Workflow

1. **Create state file** with iteration plan above
2. **Spawn subagent** (iteration 1) — batch analyze all pattern files
3. **Spawn subagent** (iteration 2) — analyze template format reference
4. **Generate skeletons** (iterations 3-4) — brain creates files
5. **Spawn critique subagent** (iteration 5) — validate against patterns
6. **Fix any gaps** — adjust skeletons per critique

## Rules

**See [synthesis-reference.md](../../workshop/brainstorm/synthesis-reference.md) → HARD RULES section**

## Template Format

**CRITICAL:** Follow [OUTPUT-FORMAT-SPEC.md](../../GENERATION-RULES/OUTPUT-FORMAT-SPEC.md) type: `template`

Key requirements for templates specifically:
- `template-for` field specifying target component type
- PLACEHOLDER DEFINITIONS table
- Comments use `<!-- GENERATOR: -->` prefix for agent instructions
- Built-in VALIDATION checklist

## Done When

- [ ] Both analysis subagents complete
- [ ] All 5 skeleton files created
- [ ] Critique validation complete
- [ ] Each matches its pattern file's STRUCTURE section
- [ ] Minimal but complete
- [ ] Ready for generator to use
- [ ] State file: Status: Complete

## Capture Discoveries

Log to [synthesis-discoveries.md](../../workshop/brainstorm/synthesis-discoveries.md)
