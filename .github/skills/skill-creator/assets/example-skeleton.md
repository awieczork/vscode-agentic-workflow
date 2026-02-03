# Skill Skeleton

Annotated structure showing all sections. Copy and customize.

---

```markdown
---
# FRONTMATTER
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Metadata for discovery. Only `name` and `description` are required.

name: 'skill-name'                                    # REQUIRED: matches folder
description: '[VERB] [WHAT] when [TRIGGER]'           # REQUIRED: triggers invocation
license: 'MIT'                                        # OPTIONAL
compatibility: 'Requires Node.js 18+'                 # OPTIONAL: environment needs
metadata:                                             # OPTIONAL
  author: 'your-org'
  version: '1.0.0'
  tags: ['category']
---

# [SKILL_TITLE]
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Human-readable name, title case

[ONE_SENTENCE_OVERVIEW]
# TLDR: What this skill does in one line

## Steps
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Numbered procedure. Use imperative form. Be specific.

1. [STEP_1_ACTION]
   - [Detail if needed]

2. [STEP_2_ACTION]
   - [Detail if needed]

3. [STEP_3_ACTION]

## Error Handling
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: What to do when things fail. Format: If [condition]: [action]

If [CONDITION_1]: [RECOVERY_ACTION]
If [CONDITION_2]: [RECOVERY_ACTION]
If unknown error: Abort with error message and context

## Reference Files
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Only if using references/ folder. Link with descriptions.
# OMIT THIS SECTION for simple skills without references.

- [file-name.md](references/file-name.md) — [What it contains]

## Validation
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: How to verify success. OMIT if success is self-evident.

Before complete:
- [ ] [VERIFIABLE_CHECK_1]
- [ ] [VERIFIABLE_CHECK_2]

## Notes
# ─────────────────────────────────────────────────────────────────────────────
# TLDR: Caveats, prerequisites, warnings. OMIT if none.

- [PREREQUISITE_OR_CAVEAT]
```

---

## Minimal Template

For simple skills under 50 lines, use this minimal structure:

```markdown
---
name: 'skill-name'
description: '[VERB] [WHAT] when [TRIGGER]'
---

# [SKILL_TITLE]

[OVERVIEW]

## Steps

1. [STEP_1]
2. [STEP_2]
3. [STEP_3]

## Error Handling

If [CONDITION]: [ACTION]
```

---

## Placeholder Conventions

- `[UPPERCASE]` — Required placeholder, must replace
- `[lowercase]` — Example text, customize as needed
- `# TLDR:` — Annotation comment, remove in final skill
- `# OMIT` — Section is optional, remove if not needed

---

## What NOT to Include

Skills should NOT have:

- README.md
- CHANGELOG.md
- INSTALLATION_GUIDE.md
- Any file besides SKILL.md and its resources

Skills should NOT contain:

- Identity statements ("You are...")
- Safety sections (`<safety>`)
- Boundary definitions (`<boundaries>`)
- Handoff specifications
- Mode variations
