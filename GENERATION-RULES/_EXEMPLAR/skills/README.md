# Skills

This folder contains **skill files** — portable instruction packages that bundle related capabilities.

## When to Use Skills

Per COMPONENT-MATRIX.md:
- Scripts that should be portable across projects
- Capabilities that need bundled assets (templates, configs)
- Instructions that apply to specific task types (not file patterns)

## Naming Convention

```
{capability}.skill.md
```

Examples:
- `git-workflow.skill.md` — Git branching and commit patterns
- `testing.skill.md` — Test writing patterns for this project
- `deployment.skill.md` — Deployment procedures

## Structure

```markdown
---
description: What this skill provides
---

# {Skill Name}

## Purpose
What capability this skill adds

## Instructions
Step-by-step guidance

## Examples
Concrete usage examples
```

## Current Skills

*No domain-specific skills included in core. Projects add their own.*

---

> **Reference:** See `GENERATION-RULES/PATTERNS/skill-patterns.md` for authoring guidelines.
