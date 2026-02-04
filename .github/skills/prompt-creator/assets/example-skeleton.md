# Example: Prompt Skeleton

Annotated template showing prompt structure with inline commentary.

---

## Full Template

```markdown
---
# TLDR: description is the only field that affects discoverability
# OMIT if: Never — always include description for /menu visibility
description: "[VERB] [WHAT] [CONTEXT] — 50-150 characters, single-line"

# TLDR: Custom display name after /
# OMIT if: Filename is already a good name
name: "[lowercase-with-hyphens]"

# TLDR: Placeholder text shown in chat input
# OMIT if: Task is self-explanatory from description
argument-hint: "[Guidance for user input]"

# TLDR: Execution mode — ask (read-only), edit (file changes), agent (full tools), or custom agent name
# OMIT if: Default chat agent behavior is fine
agent: "[ask|edit|agent|custom-agent-name]"

# TLDR: Override language model
# OMIT if: Default model is acceptable
model: "[model-identifier]"

# TLDR: Restrict tool access — prompt tools override agent defaults
# OMIT if: No tool restrictions needed
# RULE: If tools specified, set agent: agent
tools: ["[tool-1]", "[tool-2]"]
---

# [Title]

# TLDR: Background info with variables — sets up context for the task
<context>

Working in ${workspaceFolder} with ${fileBasename}.

${selection}

</context>

# TLDR: The actual instruction — verb-first, single clear goal
# RULE: Place before <context> if task is complex (critical instruction first)
<task>

[Clear imperative instruction. What should be done?]

</task>

# TLDR: Expected output structure — how results should be formatted
# OMIT if: Output format is obvious or flexible
<format>

[Describe expected output structure]

</format>

# TLDR: Limits and rules — what to avoid, boundaries
# OMIT if: No special constraints needed
<constraints>

- [Constraint 1]
- [Constraint 2]

</constraints>
```

---

## Minimal Template

Use when: Simple single-purpose task with no special requirements.

```markdown
---
description: "[VERB] [WHAT]"
---

# [Title]

<task>

[Task instructions]

</task>

Use ${file} for current file context.
Use ${selection} for selected text.
```

**Note:** XML tags are mandatory for prompts with 2+ logical sections. Even minimal prompts benefit from `<task>` to clearly delineate the instruction.

---

## What NOT to Include

- **`<identity>` section** — Prompts have no persona; this belongs in agents
- **`<safety>` section** — Prompts delegate safety to agents; this belongs in agents
- **`<boundaries>` section** — Prompts have no behavioral limits; this belongs in agents
- **`<iron_law>` tags** — Prompts are one-shot; this belongs in agents
- **`handoffs:` frontmatter** — Prompts cannot hand off; this belongs in agents
- **`applyTo:` frontmatter** — Prompts don't auto-apply; this belongs in instructions
- **`mode:` frontmatter** — Deprecated; use `agent:` instead
- **README.md** — Skills include only SKILL.md and necessary assets
- **Multi-step procedures** — If you need numbered steps with logic, use a skill instead
- **Session persistence** — Prompts are stateless; if you need memory, use an agent
