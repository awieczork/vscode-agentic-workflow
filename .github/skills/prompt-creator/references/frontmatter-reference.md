This file defines frontmatter fields, tool aliases, agent delegation, and variable syntax for `.prompt.md` files. Load when drafting prompts in `<step_4_draft>`. All frontmatter fields are optional — include only what adds value.


<frontmatter_fields>

- `description` — Short description for `/` menu. 50-150 chars, single-line, verb-first. **Required for discoverability.**
- `name` — Display name. 3-50 chars, lowercase-hyphens. Default: filename without extension.
- `argument-hint` — Placeholder text in chat input. 10-100 chars. VS Code native feature.
- `agent` — Custom agent delegation. See `<agent_delegation>`.
- `model` — Language model override. Use when specific model capabilities needed.
- `tools` — Tool whitelist array. See `<tools_syntax>`. Prompt tools override (not merge with) agent tools.

```yaml
---
description: "Generate unit tests for selected code"
name: "gen-tests"
argument-hint: "Select code to generate tests for"
agent: "build"
tools: ["read", "edit", "search"]
---
```

</frontmatter_fields>


<tools_syntax>

```yaml
tools: ['read', 'edit', 'search', 'execute']
```

**Tool aliases:**
- `read` — readFile, listDirectory
- `edit` — editFiles, createFile
- `search` — codebase, textSearch, fileSearch
- `execute` — runInTerminal
- `agent` — runSubagent
- `web` — fetch, WebSearch
- `todo` — manage_todo_list

**MCP tools:** Use `server/*` (all tools from server) or `server/tool` (specific tool) syntax.

**Constraints:**
- Prompt tools override (not merge with) agent tools
- Unavailable tools are silently ignored — test prompt to verify tool access
- Target ≤4 tools; warn if >4, review necessity if >6
- Using server name alone is ambiguous — always use `server/*` or `server/tool`

</tools_syntax>


<agent_delegation>

The `agent` field delegates prompt execution to a custom agent. This project uses specialized agents.

**Core agents:**
- `brain` — Research, analysis, exploration
- `architect` — Planning, decomposition, design
- `build` — Implementation, file changes, execution
- `inspect` — Quality verification, review, audit

**Selection heuristic:**
- Research/analysis task → `agent: "brain"`
- Planning/decomposition task → `agent: "architect"`
- Implementation/file changes → `agent: "build"`
- Quality verification → `agent: "inspect"`
- Custom domain task → `agent: "[domain-agent-name]"`

**Default when omitted:** VS Code uses the default chat participant without specialized agent behavior. For prompts that modify files or run commands, explicitly specify an agent.

</agent_delegation>


<variable_syntax>

**Critical:** Use `${name}` syntax, not `{name}`. Braces alone do not trigger substitution.

<workspace_variables>

- `${workspaceFolder}` — Full path to workspace root
- `${workspaceFolderBasename}` — Workspace folder name only

</workspace_variables>

<file_variables>

- `${file}` — Full path to current file
- `${fileBasename}` — Filename with extension
- `${fileDirname}` — Directory containing file
- `${fileBasenameNoExtension}` — Filename without extension

</file_variables>

<selection_variables>

- `${selection}` — Currently selected text
- `${selectedText}` — Alias for `${selection}` (VS Code native alias)

</selection_variables>

<user_input_variables>

- `${input:name}` — Prompt user for input at runtime
- `${input:name:placeholder}` — Input with placeholder hint

</user_input_variables>

<file_context_references>

- `[filename](./path/to/file.ext)` — Inject file content as context via markdown link
- Example: `See [config](./config.json) for settings`

</file_context_references>

<inline_tool_references>

- `#tool:<toolname>` — Reference specific tool inline in prompt body
- Example: `Use #tool:search to find relevant files`

</inline_tool_references>

</variable_syntax>


<references>

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [example-skeleton.md](../assets/example-skeleton.md) — Annotated templates

</references>
