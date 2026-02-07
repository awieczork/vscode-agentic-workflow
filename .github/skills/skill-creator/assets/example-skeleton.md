Annotated structure showing all sections. Templates use `[UPPERCASE]` placeholders for required fields that must be replaced, lowercase for customizable examples. Copy the template and replace all placeholders.


<full_template>

```markdown
---
name: 'skill-name'
description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'
---

[ONE_SENTENCE_OVERVIEW]. The governing principle is [CORE_PRINCIPLE].

<workflow>

<step_1_[ACTION]>

1. [STEP_1_ACTION]
   - [Detail if needed]

</step_1_[ACTION]>

<step_2_[ACTION]>

2. [STEP_2_ACTION]
   - [Detail if needed]

</step_2_[ACTION]>

<step_3_[ACTION]>

3. [STEP_3_ACTION]

</step_3_[ACTION]>

</workflow>

<error_handling>

If [CONDITION_1]: [RECOVERY_ACTION]
If [CONDITION_2]: [RECOVERY_ACTION]
If unknown error: Abort with error message and context

</error_handling>

<references>

- [file-name.md](references/file-name.md) — [What it contains]

</references>

<validation>

Before complete:
- [ ] [VERIFIABLE_CHECK_1]
- [ ] [VERIFIABLE_CHECK_2]

</validation>

<notes>

- [PREREQUISITE_OR_CAVEAT]

</notes>
```

</full_template>


<minimal_template>

For simple skills under 50 lines:

```markdown
---
name: 'skill-name'
description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'
---

[OVERVIEW]

<step_1_[ACTION]>

1. [STEP_1]

</step_1_[ACTION]>

<step_2_[ACTION]>

2. [STEP_2]

</step_2_[ACTION]>

<step_3_[ACTION]>

3. [STEP_3]

</step_3_[ACTION]>

<error_handling>

If [CONDITION]: [ACTION]

</error_handling>
```

</minimal_template>


<placeholder_conventions>

- `[UPPERCASE]` — Required placeholder, must replace
- `[lowercase]` — Example text, customize as needed
- Optional sections (`<references>`, `<validation>`, `<notes>`) — Remove entirely if not needed

</placeholder_conventions>


<scope_boundaries>

**Skills contain:**
- SKILL.md as entry point
- Supporting resources in scripts/, references/, assets/ as needed

**Skills use:**
- Procedural structure with numbered steps
- XML tags as exclusive structure (no markdown headings)
- Imperative voice throughout

**Skills never contain:**
- Agent identity (`<identity>`, `<safety>`, `<boundaries>`)
- Persona language ("You are a...")
- External dependencies (`knowledge-base/`, `memory-bank/`)
- Unsupported frontmatter fields (`license`, `compatibility`, `metadata`, `tools`, `model`)

</scope_boundaries>
