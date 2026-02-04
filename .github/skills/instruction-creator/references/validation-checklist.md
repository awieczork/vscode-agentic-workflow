# Instruction Validation Checklist

Pass/fail checks for instruction files. Run before delivery.

---

<priority_definitions>

## Priority Definitions

- **P1 (Blocking)** — Instruction will fail or cause errors if violated
- **P2 (Required)** — Instruction will work but effectiveness compromised
- **P3 (Optional)** — Improvements that enhance quality

</priority_definitions>

---

<p1_checks>

## P1 Checks (Blocking)

All must pass. Any failure blocks delivery.

### Location and Filename

- [ ] Repo-Wide file is exactly `.github/copilot-instructions.md`
- [ ] Path-Specific files are in `.github/instructions/` folder
- [ ] Path-Specific filename ends with `.instructions.md`

### Frontmatter Format

- [ ] Repo-Wide has NO frontmatter (first non-whitespace is NOT `---`)
- [ ] Path-Specific frontmatter is valid YAML (if present)
- [ ] No syntax errors in YAML block

### Glob Pattern Validation

- [ ] `applyTo` is NOT `**` alone (matches all files)
- [ ] `applyTo` is NOT `*` alone (too broad)
- [ ] `applyTo` includes file extension OR path constraint
- [ ] Pattern uses valid glob syntax (no regex)

### Security

- [ ] No secrets, credentials, API keys in content
- [ ] No internal URLs or sensitive paths
- [ ] No placeholder text remaining (`[PLACEHOLDER]`, `{placeholder}`, `TODO`)

</p1_checks>

---

<p2_checks>

## P2 Checks (Required)

Should pass. Failures compromise effectiveness.

### Auto-Apply Configuration

- [ ] Path-Specific has `applyTo` field (enables auto-apply)
- [ ] `applyTo` pattern matches intended file types

### Rule Quality

- [ ] Rules use imperative voice ("Use X" not "You should use X")
- [ ] Rules are specific and actionable (not "be helpful")
- [ ] Safety-critical rules use ALWAYS/NEVER keywords
- [ ] Rules include versions where relevant ("React 18+")

### Identity Prohibition

- [ ] No persona language ("You are a...", "As a...", "Your role is...")
- [ ] No stance words (thorough, cautious, creative, helpful)
- [ ] No identity assertions

### Size Limits

- [ ] Path-Specific is ≤150 lines
- [ ] Repo-Wide is ≤200 lines
- [ ] If exceeds 100/150 lines, split was evaluated

### Stackability

- [ ] Rules do not contradict existing instructions with overlapping `applyTo`
- [ ] No duplicate rules across instruction files
- [ ] Rules are self-contained (no cross-instruction dependencies)

</p2_checks>

---

<p3_checks>

## P3 Checks (Optional)

Nice to have. Improve quality when present.

### Metadata

- [ ] `name` field provides clear display name
- [ ] `description` field is 50-150 characters, single-line
- [ ] Description explains purpose and scope

### Documentation

- [ ] Code examples show correct/incorrect patterns
- [ ] Anti-patterns section lists common mistakes
- [ ] Examples use realistic, non-trivial code

</p3_checks>

---

<contamination_detection>

## Contamination Detection

Instructions must NOT contain patterns from other artifact types.

### Agent Contamination (REJECT if found)

- [ ] No `<identity>` tags
- [ ] No `<safety>` tags (as structural element)
- [ ] No `<boundaries>` tags
- [ ] No `<modes>` tags
- [ ] No `<iron_law>` tags
- [ ] No `tools:` in frontmatter
- [ ] No `handoffs:` in frontmatter
- [ ] No "You are a..." identity statements

### Prompt Contamination (REJECT if found)

- [ ] No `${input:}` variable syntax
- [ ] No `${selection}` or `${file}` variables
- [ ] No `<task>` tags (as structural element)

### Skill Contamination (REJECT if found)

- [ ] No `scripts/` folder references
- [ ] No shebang lines (`#!/bin/bash`, `#!/usr/bin/env`)
- [ ] No `## Process` or `## Steps` as workflow sections
- [ ] No `references/` folder in instruction output

### Allowed Exceptions

- `<rules>` tags — Valid for semantic grouping within instructions
- `<important>` tags — Valid for P1 rule emphasis
- `<examples>` tags — Valid for code example sections
- Discussing agents/prompts/skills as CONTENT (not structure)

</contamination_detection>

---

<quick_validation>

## Quick Validation (5 Essential Checks)

Run these first. If any fail, full validation will also fail.

1. [ ] Correct location and filename pattern
2. [ ] Frontmatter matches type (none for Repo-Wide, valid YAML for Path-Specific)
3. [ ] `applyTo` specified with valid glob (Path-Specific only)
4. [ ] All rules are specific and actionable
5. [ ] No placeholders, secrets, or persona language

</quick_validation>

---

<validation_decision_tree>

## Validation Decision Tree

```
P1 failure? ────────────────────────────────► REJECT (blocking)
     │
     ▼ (all P1 pass)
P2 failures ≥2? ────────────────────────────► REVISE (effectiveness compromised)
     │
     ▼ (≤1 P2 failure)
Contamination detected? ────────────────────► REJECT (wrong artifact type)
     │
     ▼ (clean)
P3 only? ───────────────────────────────────► ACCEPT (can improve later)
```

</validation_decision_tree>

---

<cross_references>

## Cross-References

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [structure-reference.md](structure-reference.md) — Format and syntax

</cross_references>
