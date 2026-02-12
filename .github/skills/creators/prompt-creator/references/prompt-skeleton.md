This file defines the structural skeleton of a `.prompt.md` artifact. Every prompt file follows this structure — optional YAML frontmatter for discovery and agent selection, plus a markdown body for task instructions. The governing principle is one task per prompt — domain extension happens through body content and variable slots, not structural complexity.


<body_structure>

Prompt bodies use one of two patterns. Choose based on task complexity.

**Prose format** — Single-instruction prompts. Prose paragraphs with bullet lists. Best for focused tasks with clear output. Use for prompts under ~20 lines.

**XML-structured** — Multi-section prompts needing clear separation between context, task, and format. Tags are ad-hoc (author's choice for clarity) — no fixed vocabulary exists. Common choices: `<context>`, `<task>`, `<format>`, `<constraints>`, `<examples>`. Use for prompts exceeding ~20 lines where section boundaries improve clarity.

</body_structure>


<variable_system>

Variables use `${name}` syntax. The dollar prefix is required — `{name}` is invalid.

**Workspace variables:**

- `${workspaceFolder}` — Full path to workspace root
- `${workspaceFolderBasename}` — Workspace folder name only

**Selection variables:**

- `${selection}` — Currently selected text in editor
- `${selectedText}` — Alias for `${selection}`

**File context variables:**

- `${file}` — Full path to active file
- `${fileBasename}` — Active filename with extension
- `${fileDirname}` — Directory of active file
- `${fileBasenameNoExtension}` — Active filename without extension

**Input variables:**

- `${input:variableName}` — Prompt user for value at runtime
- `${input:variableName:placeholder}` — Prompt with placeholder hint text

**Context references (not variables, but inline references):**

- File references: `[display name](./relative/path)` — Markdown links to workspace files, resolved by VS Code as context
- Tool references: `#tool:<tool-name>` — Inline tool invocation. The agent running the prompt provides its available tools (e.g., `#tool:githubRepo`, `#tool:search`)

</variable_system>


<anti_patterns>

- **Multi-task prompts** — "Create, test, and deploy" in one prompt. Split into separate prompt files — one task per prompt
- **Vague descriptions** — Descriptions that do not help users understand when to invoke. Use verb-first, specific language: "Generate unit tests for selected code" not "Help with testing"
- **Missing descriptions** — Omitting `description` blocks `/` command discovery. Every prompt needs a description for users to find it
- **Identity prose** — Prompt bodies are task-focused. No "You are an expert..." preambles — state the task directly. Target custom agents via the `agent` field instead
- **Built-in agent names** — Never use `ask`, `edit`, or `agent` in the `agent` field. Either omit the field or specify a custom agent name
- **Wrong variable syntax** — Using `{name}` instead of `${name}`. Variables require the dollar prefix: `${input:framework}`, not `{input:framework}`

</anti_patterns>
