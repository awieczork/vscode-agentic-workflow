# Skill Skeleton

Annotated structure showing all sections. Copy and customize.

---

```markdown
---
name: 'skill-name'                                    # REQUIRED: matches folder
description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'  # REQUIRED: 1-1024 chars, single-line
license: 'MIT'                                        # OPTIONAL
compatibility: 'Requires Node.js 18+'                 # OPTIONAL: environment needs
metadata:                                             # OPTIONAL
  author: 'your-org'
  version: '1.0.0'
  tags: ['category']
---

# [SKILL_TITLE]

[ONE_SENTENCE_OVERVIEW]

<steps>

## Steps

1. [STEP_1_ACTION]
   - [Detail if needed]

2. [STEP_2_ACTION]
   - [Detail if needed]

3. [STEP_3_ACTION]

</steps>

<error_handling>

## Error Handling

If [CONDITION_1]: [RECOVERY_ACTION]
If [CONDITION_2]: [RECOVERY_ACTION]
If unknown error: Abort with error message and context

</error_handling>

<reference_files>

## Reference Files

- [file-name.md](references/file-name.md) — [What it contains]

</reference_files>

<validation>

## Validation

Before complete:
- [ ] [VERIFIABLE_CHECK_1]
- [ ] [VERIFIABLE_CHECK_2]

</validation>

<notes>

## Notes

- [PREREQUISITE_OR_CAVEAT]

</notes>
```

---

## Minimal Template

For simple skills under 50 lines, use this minimal structure:

```markdown
---
name: 'skill-name'
description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'
---

# [SKILL_TITLE]

[OVERVIEW]

<steps>

## Steps

1. [STEP_1]
2. [STEP_2]
3. [STEP_3]

</steps>

<error_handling>

## Error Handling

If [CONDITION]: [ACTION]

</error_handling>
```

---

## Placeholder Conventions

- `[UPPERCASE]` — Required placeholder, must replace
- `[lowercase]` — Example text, customize as needed
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
