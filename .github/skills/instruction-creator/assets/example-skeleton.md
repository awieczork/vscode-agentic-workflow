# Instruction Skeleton

Annotated templates for both instruction types. Copy and customize.

---

## Path-Specific Template (Full)

Use for comprehensive standards with code examples.

```markdown
---
# FRONTMATTER (Path-Specific only)
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: YAML metadata for auto-apply. Required for Path-Specific.
# OMIT entirely for Repo-Wide (no --- block at all).

applyTo: "[GLOB_PATTERN]"           # REQUIRED for auto-apply. Example: "**/*.ts"
name: "[DISPLAY_NAME]"              # Optional. Defaults to filename without extension.
description: "[PURPOSE_50_150]"     # Optional. Shows in VS Code UI.
---

# [DISPLAY_NAME]
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Title matching the name field or describing the rules domain.

[ONE_LINE_SUMMARY_OF_PURPOSE]

## Core Rules
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: 5-10 imperative rules. Use "Do X" not "You should do X".
# Use ALWAYS/NEVER for safety-critical constraints.

- Use [PATTERN] for [SITUATION]
- Prefer [OPTION_A] over [OPTION_B] when [CONDITION]
- NEVER [DANGEROUS_ACTION] without [SAFEGUARD]
- ALWAYS [REQUIRED_BEHAVIOR] before [ACTION]
- Include [ELEMENT] in [CONTEXT]

## Code Standards
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Correct/incorrect pairs. Include only when prose rules are ambiguous.
# OMIT if rules are clear without examples.

### Correct

```[LANGUAGE]
[CORRECT_CODE_EXAMPLE]
```

### Incorrect

```[LANGUAGE]
[INCORRECT_CODE_EXAMPLE]
```

## Anti-Patterns
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Common mistakes to avoid. 3-5 items.
# OMIT if no common mistakes exist for this domain.

- [ANTI_PATTERN]: [WHY_PROBLEMATIC]
- [ANTI_PATTERN]: [WHY_PROBLEMATIC]
```

---

## Path-Specific Template (Minimal)

Use for focused, single-concern rules under 50 lines.

```markdown
---
applyTo: "**/*.ts"
---

# TypeScript Rules

- Use `interface` for object shapes
- Use `type` for unions and intersections
- Export types alongside their implementations
- Prefer `unknown` over `any` for untyped values
- Enable strict mode in tsconfig.json
```

---

## Repo-Wide Template (Minimal)

Use for global project rules. NO frontmatter allowed.

```markdown
## Project Context

[PROJECT_NAME] uses [FRAMEWORK] [VERSION] with [LANGUAGE] [VERSION].

## Code Style

- [STYLE_RULE_1]
- [STYLE_RULE_2]
- [STYLE_RULE_3]

## Commands

- Build: `[BUILD_COMMAND]`
- Test: `[TEST_COMMAND]`
- Lint: `[LINT_COMMAND]`

## Safety Rules

- NEVER commit secrets or API keys to repository
- NEVER force push to main branch
- ALWAYS run tests before committing
```

---

## What NOT to Include

Instructions are behavioral rules, not personas or procedures.

### Agent Patterns (Use agent-creator instead)

- `<identity>` tags — Instructions have no identity
- `<safety>` tags as structural sections — Use ALWAYS/NEVER in rules
- `<boundaries>` tags — Instructions don't have scope tiers
- `<modes>` tags — Instructions don't have behavioral variations
- `tools:` frontmatter — Instructions don't access tools
- `handoffs:` frontmatter — Instructions don't delegate
- "You are a..." statements — Instructions are rules, not personas
- Stance words (thorough, cautious, creative) — Persona language

### Prompt Patterns (Use prompt-creator instead)

- `${input:}` variables — Instructions have no runtime variables
- `${selection}` or `${file}` — Context variables belong in prompts
- `<task>` tags — One-shot task definitions belong in prompts

### Skill Patterns (Use skill-creator instead)

- `scripts/` folder — Instructions are text-only
- Shebang lines (`#!/bin/bash`) — No executable code
- `## Process` or `## Steps` sections — Multi-step workflows belong in skills
- `references/` folder in output — Instructions are single-file

### Content Exceptions

These ARE allowed when discussing topics (not as structure):
- Mentioning agents, prompts, skills as subjects
- Code examples that happen to include these patterns
- Documentation about the artifact system

---

## Checklist Before Using Template

- [ ] Determined type: Repo-Wide (global) or Path-Specific (file patterns)?
- [ ] If Path-Specific: defined `applyTo` glob pattern?
- [ ] Rules are imperative ("Use X" not "You should use X")?
- [ ] Safety rules use ALWAYS/NEVER keywords?
- [ ] No persona language or identity statements?
- [ ] Size within limits (150 Path-Specific, 200 Repo-Wide)?

---

## Cross-References

- [example-typescript-standards.md](example-typescript-standards.md) — Complete working example
- [structure-reference.md](../references/structure-reference.md) — Syntax details
- [validation-checklist.md](../references/validation-checklist.md) — Full validation
