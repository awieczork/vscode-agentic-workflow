---
name: 'prompt-creator'
description: 'Creates and refactors .prompt.md files that define reusable prompt files for AI agents. Use when asked to "create a prompt", "build a prompt", "refactor a prompt", "update a prompt file", "improve a prompt", or "scaffold a prompt". Produces YAML frontmatter, task body with optional variables and file references, and validated output.'
---

This skill creates well-structured .prompt.md files that define reusable on-demand prompt files. The governing principle is one task per prompt — each prompt file solves one focused task with parameterized inputs. Begin with `<step_1_analyze>` to determine the task scope and orient subsequent steps.


<use_cases>

- Create a new prompt file from a task description or repeatable process
- Build a reusable prompt file with variables and file references
- Convert a recurring chat interaction into a standardized prompt file
- Create agent-routed prompts that target specific custom agents
- Scaffold a prompt with input variables and file references

</use_cases>


<workflow>

Execute steps sequentially. Each step verifies its own output before proceeding to the next.


<step_1_analyze>

Answer the following questions about the target prompt. Each answer informs decisions in subsequent steps — incomplete answers produce gaps in the final artifact.

- **What is this?** — Platform metadata (name, description) enables `/` command discovery and matching
- **What task does it perform?** — A single focused task statement orients the prompt body. Multi-task prompts dilute focus — split into separate files
- **What context does it need?** — File references (`[name](./path)`), tool references (`#tool:<name>`), variables (`${input:name}`, `${selection}`, `${file}`)
- **What format does it produce?** — Output shape and constraints help the agent deliver structured results
- **Which agent should run it?** — Omit for general-purpose, or target a specific custom agent via the `agent` field

</step_1_analyze>


<step_2_determine_structure>

Load [prompt-skeleton.md](./references/prompt-skeleton.md) for: `<scaling>`, `<body_structure>`, `<visual_skeleton>`, `<core_principles>`.

Select scaling tier based on the prompt's complexity and context needs:

- **Minimal** (~10 lines) — `description` only + plain prose body, 3-5 lines of instructions
- **Standard** (~30 lines) — `description` + `agent` + XML body sections + variables
- **Full** (~50 lines) — All frontmatter fields + multi-section body + file refs + variables

Choose body format from `<body_structure>` in [prompt-skeleton.md](./references/prompt-skeleton.md):

- **Plain markdown** — Single-instruction prompts under ~20 lines. Prose paragraphs with bullet lists
- **XML-structured** — Multi-section prompts needing clear separation. Ad-hoc tags chosen for clarity

Finalize: scaling tier, body format, variable needs.

</step_2_determine_structure>


<step_3_write_frontmatter>

Load [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md) for: `<frontmatter_fields>`, `<description_rules>`, `<agent_mode_guidance>`.

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

Run `<validation>` checks against the completed prompt. Fix all P1 and P2 findings before delivery; flag P3 items without blocking. If any check fails, consult `<error_handling>` for recovery actions.

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

**P1 — Blocking (fix before delivery):**

- `description` present in frontmatter, single-line string in single quotes
- All YAML string values wrapped in single quotes: `description: 'value'`
- Description is verb-first, 50-150 characters, action-oriented
- No multi-task scope in description or body
- No hardcoded secrets or absolute paths
- Variable syntax uses `${name}` not `{name}`
- File location: `.github/prompts/[NAME].prompt.md`
- `agent` field uses only custom agent names — never built-in names (`ask`, `edit`, `agent`)

**P2 — Quality (fix before delivery):**

- No markdown headings — use XML tags for structure when body exceeds ~20 lines
- No identity prose: "You are...", role statements, expertise declarations
- No markdown tables — use bullet lists with em-dash definitions
- File references use relative paths from prompt file location
- `agent` field references existing custom agent (if specified)
- Cross-file XML tag references use linked-file form: `<tag>` in [file.md](path)
- Every `Load [file] for:` directive resolves to an existing file
- No orphaned resources — every file in subfolders referenced from SKILL.md

**P3 — Polish (flag, do not block):**

- Output format specified when quality depends on structure
- Examples included for complex or ambiguous tasks
- `argument-hint` provided when prompt expects user input
- Active voice throughout, no hedging
- Every file in the skill folder opens with a prose intro containing governing principle

</validation>


<resources>

- [prompt-frontmatter-contract.md](./references/prompt-frontmatter-contract.md) — Defines YAML frontmatter fields for .prompt.md files with description formula and agent selection rules. Load for `<frontmatter_fields>`, `<description_rules>`, `<agent_mode_guidance>`
- [prompt-skeleton.md](./references/prompt-skeleton.md) — Structural reference for .prompt.md body sections. Defines body format options (plain markdown vs XML-structured), variable system, scaling tiers, and design rules. Load for `<body_structure>`, `<variable_system>`, `<visual_skeleton>`, `<scaling>`, `<core_principles>`, `<anti_patterns>`
- [example-prompt.md](./assets/example-prompt.md) — Ready-to-use prompt file demonstrating standard scaling tier with custom agent, file references, and selection variables

</resources>
