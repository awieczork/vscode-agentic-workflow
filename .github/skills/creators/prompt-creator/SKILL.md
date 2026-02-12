---
name: 'prompt-creator'
description: 'Creates and refactors .prompt.md files that define reusable prompt files for AI agents. Use when asked to "create a prompt", "refactor a prompt", "update a prompt file", or "scaffold a prompt". Produces YAML frontmatter, task body with optional variables and file references, and validated output.'
---

This skill creates well-structured .prompt.md files that define reusable on-demand prompt files. The governing principle is one task per prompt — each prompt file solves one focused task with parameterized inputs. Begin with `<step_1_analyze>` to determine the task scope.


<use_cases>

- Create or scaffold a prompt file from a task description or repeatable process
- Build a reusable prompt file with variables and file references
- Convert a recurring chat interaction into a standardized prompt file
- Create agent-targeted prompts that target specific custom agents
- Improve an existing prompt file's structure, variables, or body organization

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_analyze>

Verify this request creates a prompt file (`.prompt.md`). If it describes an agent, instruction, skill, or general document, route to the appropriate creator skill instead.

Answer the following questions about the target prompt.

- **What is this?** — Platform metadata (name, description) enables `/` command discovery and matching
- **What task does it perform?** — A single focused task statement orients the prompt body. Multi-task prompts dilute focus — split into separate files
- **What context does it need?** — File references (`[name](./path)`), tool references (`#tool:<name>`), variables (`${input:name}`, `${selection}`, `${file}`)
- **What format does it produce?** — Output shape and constraints help the agent deliver structured results
- **Which agent should run it?** — Omit for general-purpose, or target a specific custom agent via the `agent` field

If any answer is unclear or contradictory, ask for clarification before proceeding to step_2.

</step_1_analyze>


<step_2_determine_structure>

Load [prompt-skeleton.md](./references/prompt-skeleton.md) for: `<body_structure>`.

Select scaling tier based on the prompt's complexity and context needs:

- **Minimal** (~10 lines) — `description` only + plain prose body, 3-5 lines of instructions
- **Standard** (~30 lines) — `description` + `agent` + XML body sections + variables
- **Full** (~50 lines) — All frontmatter fields + multi-section body + file refs + variables

Choose body format from `<body_structure>` in [prompt-skeleton.md](./references/prompt-skeleton.md):

- **Prose format** — Single-instruction prompts under ~20 lines. Prose paragraphs with bullet lists
- **XML-structured** — Multi-section prompts needing clear separation. Ad-hoc tags chosen for clarity

Finalize: scaling tier, body format, variable needs.

</step_2_determine_structure>


<step_3_write_frontmatter>

Load [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md) for: `<frontmatter_fields>`, `<description_rules>`, `<agent_mode_guidance>`, including `tools` and `model` fields.

**Description (required):**

1. Build using `<description_rules>` in [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md): verb-first, specific, action-oriented
2. Validate: 50-150 characters, single-line, no multi-task language
3. Include domain keywords that help `/` command discovery

**Optional fields** — include only when needed:

- `name` — Override `/` command name. If omitted, then VS Code derives from filename
- `agent` — Target a specific custom agent. Use `<agent_mode_guidance>` in [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md) for selection. Never use built-in agent names (`ask`, `edit`, `agent`)
- `argument-hint` — Guide users on expected input in the chat field

Validate: all YAML string values in single quotes.

</step_3_write_frontmatter>


<step_4_write_body>

Load [prompt-skeleton.md](./references/prompt-skeleton.md) for: `<body_structure>`, `<variable_system>`, `<anti_patterns>`.

Load [example-prompt.md](./assets/example-prompt.md) for: reference output.

**Body content:**

- State the task directly — no "You are an expert..." preambles
- Use imperative voice: "Generate...", "Review...", "Scaffold..."
- Include specific constraints and output format requirements
- Add examples of expected output when quality depends on structure

**Context references** per `<variable_system>` in [prompt-skeleton.md](./references/prompt-skeleton.md):

- File references: `[display name](./relative/path)` — resolved by VS Code as context
- Tool references: `#tool:<tool-name>` — invoke agent tools inline (the agent's available tools apply regardless of prompt)
- Variables: `${input:name}` for user input, `${selection}` for selected text, `${file}` for active file

**Anti-contamination** — verify against `<anti_patterns>` in [prompt-skeleton.md](./references/prompt-skeleton.md):

- No identity prose: "You are...", role statements, expertise declarations
- No multi-task scope: "create, test, and deploy" in one prompt
- No vague descriptions

</step_4_write_body>


<step_5_validate>

Run `<validation>`. Fix P1/P2 before delivery; flag P3.

</step_5_validate>


</workflow>


<error_handling>

- If description is vague or noun-first, then rephrase as verb-first action: "Help with testing" → "Generate unit tests for selected code"
- If prompt contains multiple tasks, then split into separate prompt files — one task per prompt
- If identity prose detected ("You are an expert..."), then remove and state the task directly
- If `agent` field uses a built-in name (`ask`, `edit`, `agent`), then either omit the field or use a custom agent name
- If `agent` field references a non-existent custom agent, then verify agent exists or omit the field
- If variable syntax uses `{name}` instead of `${name}`, then add dollar prefix: `${input:name}`
- If description exceeds 150 characters, then trim to essential content preserving verb-first format

</error_handling>


<validation>

Load [shared-validation-rules.md](../artifact-author/references/shared-validation-rules.md) for: shared P1/P2/P3 validation rules

**Output validation:**

**P1 — Blocking (fix before delivery):**

- `description` present in frontmatter, single-line string in single quotes
- Description is verb-first, 50-150 characters, action-oriented
- No multi-task scope in description or body
- Variable syntax uses `${name}` not `{name}`
- File location: `.github/prompts/[NAME].prompt.md`
- `agent` field uses only custom agent names — never built-in names (`ask`, `edit`, `agent`)

**P2 — Quality (fix before delivery):**

- No identity prose: "You are...", role statements, expertise declarations
- No markdown tables — use bullet lists with em-dash definitions
- File references use relative paths from prompt file location
- `agent` field references existing custom agent (if specified)
- If `tools` specified, verify tool names match VS Code built-in tools or MCP server tools

**P3 — Polish (flag, do not block):**

- Output format specified when quality depends on structure
- Examples included for complex or ambiguous tasks
- `argument-hint` provided when prompt expects user input

</validation>


<resources>

- [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md) — Defines YAML frontmatter fields for .prompt.md files with description formula and agent selection rules
- [prompt-skeleton.md](./references/prompt-skeleton.md) — Structural reference for .prompt.md body sections. Defines body format options (Prose format vs XML-structured), variable system, scaling tiers, and design rules
- [example-prompt.md](./assets/example-prompt.md) — Ready-to-use prompt file demonstrating full scaling tier with custom agent, file references, and selection variables
- [shared-validation-rules.md](../artifact-author/references/shared-validation-rules.md) — Shared P1/P2/P3 validation rules applied across all creator skills

</resources>
