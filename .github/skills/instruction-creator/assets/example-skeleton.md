Annotated templates for both instruction types. Copy and customize. The annotations (HTML comments) explain each element — remove them in final output.

---

<path_specific_full>

**Path-Specific template (full)** — Use for comprehensive standards with examples.

```markdown
---
applyTo: "[GLOB_PATTERN]"                       <!-- REQUIRED for auto-apply. Example: "**/*.ts" -->
name: "[DISPLAY_NAME]"                           <!-- Optional. Defaults to filename without extension. -->
description: "[PURPOSE_50_150, single-line]"     <!-- Required. Shows in VS Code UI. -->
---

<!-- Opening prose paragraph: state purpose and governing principle -->
[ONE_LINE_SUMMARY_OF_PURPOSE]. The governing principle is [CORE_CONCEPT].


<[DOMAIN]_rules>

<rules>

- Use [PATTERN] for [SITUATION]
- Prefer [OPTION_A] over [OPTION_B] when [CONDITION]
- NEVER [DANGEROUS_ACTION] without [SAFEGUARD]
- ALWAYS [REQUIRED_BEHAVIOR] before [ACTION]
- Include [ELEMENT] in [CONTEXT]

</rules>

<justification>

<!-- Include ONLY for rules that deviate from training defaults. 2-4 sentences. -->
[WHY_THESE_RULES_DIFFER_FROM_DEFAULTS]

</justification>

<benefit>

<!-- 1-2 sentences stating concrete outcome -->
[CONCRETE_OUTCOME]

</benefit>

<anti_patterns>

- Wrong: [BAD_PATTERN] → Correct: [GOOD_PATTERN]
- Wrong: [BAD_PATTERN] → Correct: [GOOD_PATTERN]

</anti_patterns>

</[DOMAIN]_rules>
```

</path_specific_full>

---

<path_specific_minimal>

**Path-Specific template (minimal)** — Use for focused, single-concern rules under 50 lines.

```markdown
---
applyTo: "**/*.ts"
description: "TypeScript type safety rules for all TypeScript files"
---

Enforce strict type safety across all TypeScript code.


<type_safety>

<rules>

- Use `interface` for object shapes
- Use `type` for unions and intersections
- Export types alongside their implementations
- Prefer `unknown` over `any` for untyped values
- Enable strict mode in tsconfig.json

</rules>

</type_safety>
```

</path_specific_minimal>

---

<repo_wide_template>

**Repo-Wide template (minimal)** — Use for global project rules. NO frontmatter allowed.

```markdown
<!-- NO frontmatter (---) block. First line must be prose or XML tag. -->
[PROJECT_NAME] uses [FRAMEWORK] [VERSION] with [LANGUAGE] [VERSION]. The governing principle is [CORE_CONCEPT].


<project_commands>

<rules>

- Build: `[BUILD_COMMAND]`
- Test: `[TEST_COMMAND]`
- Lint: `[LINT_COMMAND]`

</rules>

</project_commands>


<code_style>

<rules>

- [STYLE_RULE_1]
- [STYLE_RULE_2]
- [STYLE_RULE_3]

</rules>

</code_style>


<safety_constraints>

<rules>

- NEVER commit secrets or API keys to repository
- NEVER force push to main branch
- ALWAYS run tests before committing

</rules>

</safety_constraints>
```

</repo_wide_template>

---

<exclusion_guide>

Instructions are behavioral rules, not personas or multi-step processes.

**Agent patterns (use agent-creator instead):**
- `<identity>`, `<safety>`, `<boundaries>`, `<modes>` tags
- `tools:` or `handoffs:` in frontmatter
- "You are a..." identity statements
- Stance words (thorough, cautious, creative)

**Prompt patterns (use prompt-creator instead):**
- `${input:}` runtime variables
- `${selection}` or `${file}` context variables
- `<task>` tags as one-shot definitions

**Skill patterns (use skill-creator instead):**
- `scripts/` folder or shebang lines
- Multi-step workflows with `<step_N>` tags
- `references/` folder in instruction output

**Content exceptions** — These ARE allowed when discussing topics (not as structure):
- Mentioning agents, prompts, skills as subjects
- Code examples that happen to include these patterns

</exclusion_guide>

---

<pre_use_checklist>

Before using template:
- [ ] Determined type: Repo-Wide (global) or Path-Specific (file patterns)?
- [ ] If Path-Specific: defined `applyTo` glob pattern?
- [ ] Rules are imperative ("Use X" not "You should use X")?
- [ ] Safety rules use ALWAYS/NEVER keywords?
- [ ] No persona language or identity statements?
- [ ] No markdown headings — XML tags are exclusive structure?
- [ ] Size within limits (150 Path-Specific, 200 Repo-Wide)?

</pre_use_checklist>


<references>

- [example-typescript-standards.md](example-typescript-standards.md) — Complete working example
- [structure-reference.md](../references/structure-reference.md) — Syntax details
- [validation-checklist.md](../references/validation-checklist.md) — Full validation

</references>
