Annotated template showing prompt structure with inline commentary. HTML comments explain each element — remove them in final output.

---

<full_template>

```markdown
---
<!-- description is the only field that affects discoverability -->
<!-- NEVER omit — always include for /menu visibility -->
description: "[VERB] [WHAT] [CONTEXT] — 50-150 characters, single-line"

<!-- Custom display name after / -->
<!-- OMIT if: Filename is already a good name -->
name: "[lowercase-with-hyphens]"

<!-- Placeholder text shown in chat input -->
<!-- OMIT if: Task is self-explanatory from description -->
argument-hint: "[Guidance for user input]"

<!-- Execution delegation — custom agent name -->
<!-- OMIT if: Default chat agent behavior is fine -->
agent: "[brain|architect|build|inspect|custom-agent-name]"

<!-- Override language model -->
<!-- OMIT if: Default model is acceptable -->
model: "[model-identifier]"

<!-- Restrict tool access — prompt tools override agent defaults -->
<!-- OMIT if: No tool restrictions needed -->
tools: ["[tool-1]", "[tool-2]"]
---

<!-- Background info with variables — sets up context for the task -->
<context>

Working in ${workspaceFolder} with ${fileBasename}.

${selection}

</context>

<!-- The actual instruction — verb-first, single clear goal -->
<!-- Place before <context> if task is complex (critical instruction first) -->
<task>

[Clear imperative instruction. What should be done?]

</task>

<!-- Expected output structure — how results should be formatted -->
<!-- OMIT if: Output format is obvious or flexible -->
<format>

[Describe expected output structure]

</format>

<!-- Limits and rules — what to avoid, boundaries -->
<!-- OMIT if: No special constraints needed -->
<constraints>

- [Constraint 1]
- [Constraint 2]

</constraints>
```

</full_template>

---

<minimal_template>

Use when: Simple single-purpose task with no special requirements.

```markdown
---
description: "[VERB] [WHAT]"
---

<task>

[Task instructions]

</task>

Use ${file} for current file context.
Use ${selection} for selected text.
```

XML tags are mandatory for prompts with 2+ logical sections. Even minimal prompts benefit from `<task>` to clearly delineate the instruction.

</minimal_template>

---

<exclusion_guide>

Prompts must NOT contain patterns from other artifact types:

- `<identity>`, `<safety>`, `<boundaries>`, `<iron_law>`, `<modes>` sections — belong in agents
- `handoffs:` frontmatter — prompts cannot hand off; belongs in agents
- `applyTo:` frontmatter — prompts don't auto-apply; belongs in instructions
- `mode:` frontmatter — deprecated; use `agent:` instead
- Multi-step numberd workflows — use a skill instead
- Session persistence — prompts are stateless; use an agent if memory needed

</exclusion_guide>


<references>

- [example-code-review.md](example-code-review.md) — Full working example
- [frontmatter-reference.md](../references/frontmatter-reference.md) — Frontmatter fields, tools, variables

</references>
