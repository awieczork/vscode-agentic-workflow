Frontmatter specifications for all VS Code Copilot customization artifacts. Each section is self-contained — load the section matching the artifact type you are writing. All YAML string values use single quotes.


<agent>

Agent files (`.agent.md`) use YAML frontmatter for identity, tool access, and invocation control. Only `description` is required — all other fields have sensible defaults.

| Field | Type | Required | Description |
|---|---|---|---|
| `description` | string | yes | Brief description shown as placeholder in chat input. Drives discovery — include trigger words. Max 1024 chars |
| `name` | string | no | Agent name in dropdown. Lowercase alphanumeric + hyphens. Derived from filename if omitted |
| `tools` | string[] | no | Tool or tool-set names. See tool aliases and tool sets below |
| `model` | string | strongly recommended | LLM model. Example: `'claude-sonnet-4'` |
| `target` | string | no | Restrict to VS Code interface: `'cli'` or `'editor'` |
| `user-invokable` | boolean | no | Default `true`. Set `false` to hide from user selection (sub-agent only) |
| `disable-model-invocation` | boolean | no | When `true`, agent is only user-invokable, never auto-selected by model |
| `agents` | string[] | no | Restricts which sub-agents this agent can invoke. Example: `['researcher', 'build']` |
| `mcp-servers` | string[] | no | MCP server names to enable. Example: `['github', 'filesystem']` |
| `handoffs` | object[] | no | Suggested next-action buttons to transition between agents (VS Code 1.106+) |
| `argument-hint` | string | no | Hint text in chat input guiding user interaction |

> **Deprecated:** `infer` — use `user-invokable` + `disable-model-invocation` instead.

**Handoff objects:** Each entry requires `label` (button text) and `agent` (target identifier). Optional: `prompt` (text sent to target), `send` (boolean, default `false` — auto-submit on handoff).

**Tool aliases**

Tool sets bundle related capabilities. Specify a set name to enable all tools within it.

| Set | Includes |
|---|---|
| `search` | `codebase`, `searchSubagent`, `textSearch`, `fileSearch`, `listDirectory`, `searchResults`, `usages`, `changes` |
| `read` | `readFile`, `problems`, `terminalLastCommand`, `terminalSelection`, `getNotebookSummary` |
| `edit` | `createDirectory`, `createFile`, `createJupyterNotebook`, `editFiles`, `editNotebook` |
| `execute` | `runInTerminal`, `getTerminalOutput`, `awaitTerminal`, `killTerminal`, `createAndRunTask`, `runNotebookCell`, `runTests`, `testFailure`, `memory` |
| `agent` | `runSubagent` |
| `web` | `fetch`, `githubRepo` |
| `vscode` | `askQuestions`, `extensions`, `vscodeAPI`, `newWorkspace`, `getProjectSetupInfo`, `runCommand`, `installExtension`, `openSimpleBrowser`, `switchAgent` |

Standalone tools (not in any set): `todo`, `renderMermaidDiagram`, `context7/*` (MCP).

**Tool selection guidance**

- Use a **tool set** when the agent needs the full capability group
- Use **individual tools** to enforce boundaries (e.g., `readFile` without `codebase`)
- Combine freely: `tools: ['search', 'editFiles', 'runInTerminal']`
- Select the minimal set for the role — excess tools dilute focus

**Example**

```yaml
---
name: 'builder'
description: 'Executes implementation tasks — produces working code and reports completion'
tools: ['search', 'read', 'edit', 'execute', 'context7', 'web']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</agent>


<skill>

Skill files (`SKILL.md`) use two required fields — both serve discovery. No optional fields exist.

| Field | Type | Required | Constraints |
|---|---|---|---|
| `name` | string | yes | Lowercase alphanumeric + hyphens, 1-64 chars. Must match parent folder name exactly |
| `description` | string | yes | What and when to use. Max 1024 chars. Drives skill discovery |

**Name rules**

- Lowercase alphanumeric + hyphens only — no underscores, spaces, or uppercase
- Must match parent folder: `skills/api-scaffold/SKILL.md` → `name: 'api-scaffold'`
- No leading or trailing hyphens
- Valid: `api-scaffold`, `webapp-testing`, `code-review`
- Invalid: `API_Scaffold`, `my skill`, `-leading-hyphen`

**Description formula**

**Pattern:** `[What it does]. Use when [trigger phrases]. [Key capabilities].`

- Include 2-4 trigger phrases in quotes — these are the activation words
- List at least 3 concrete capabilities
- Stay under 1024 characters
- No negative triggers, no XML tags

**Example**

```yaml
---
name: 'artifact-creator'
description: 'Creates VS Code Copilot customization artifacts. Use when asked to "create an agent", "write a prompt", "add instructions", or "scaffold a skill". Produces frontmatter, body structure, and validated output for all artifact types.'
---
```

</skill>


<prompt>

Prompt files (`.prompt.md`) use frontmatter for `/` command discovery and execution context. Only `description` is technically required, but most prompts benefit from explicit configuration.

| Field | Type | Required | Description |
|---|---|---|---|
| `description` | string | recommended | Verb-first, 50-150 chars. Drives `/` command matching |
| `name` | string | no | Name after `/` in chat. Kebab-case. Derived from filename if omitted |
| `agent` | string | no | Target custom agent. Never use built-in names (`ask`, `edit`, `agent`). Omit for general-purpose prompts |
| `model` | string | no | LLM model override. Example: `'claude-sonnet-4'` |
| `tools` | string[] | no | Restrict tool availability. When omitted, agent defaults apply |
| `argument-hint` | string | no | Hint text in chat input field |

**Description rules**

- **Length:** 50-150 characters, verb-first, action-oriented
- Good: `'Generate comprehensive test cases for selected code'`
- Good: `'Perform a REST API security review and list issues'`
- Bad: `'Help with testing'` — vague, no action
- Bad: `'A prompt for code review'` — noun-first, passive

**Variable system**

Variables use `${name}` syntax — the dollar prefix is required.

| Variable | Purpose |
|---|---|
| `${input:name}` | Prompt user for value at runtime |
| `${input:name:placeholder}` | Prompt with hint text |
| `${selection}` / `${selectedText}` | Currently selected text in editor |
| `${file}` | Full path to active file |
| `${fileBasename}` | Active filename with extension |
| `${fileDirname}` | Directory of active file |
| `${fileBasenameNoExtension}` | Filename without extension |
| `${workspaceFolder}` | Full path to workspace root |
| `${workspaceFolderBasename}` | Workspace folder name only |

**File and tool references**

- **File references:** `[display name](./relative/path)` — resolved by VS Code as context
- **Tool references:** `#tool:<tool-name>` — inline tool invocation using the agent's available tools

**Example**

```yaml
---
description: 'Scaffold a new REST endpoint with validation and error handling'
name: 'new-endpoint'
agent: 'builder'
tools: ['edit', 'read', 'codebase']
---
```

</prompt>


<instruction>

Instruction files (`.instructions.md`) use frontmatter for conditional auto-attachment and on-demand discovery.

| Field | Type | Required | Description |
|---|---|---|---|
| `description` | string | recommended | Keyword-rich, 50-150 chars. Drives on-demand task-relevance matching |
| `name` | string | no | Display name in UI. Derived from filename if omitted |
| `applyTo` | string or string[] | no | Glob pattern(s) for auto-attachment when matching files appear in context |

**Discovery modes**

- **File-triggered:** `applyTo` present — auto-attaches when matching files appear in context
- **On-demand:** `description` only — agent detects task relevance from keywords
- **Both:** `applyTo` + `description` — file-triggered with on-demand fallback (most common)
- **Manual:** No frontmatter — user must reference explicitly

**Decision rule:** If rules mention specific file extensions → use `applyTo`. If rules apply to a task type regardless of files → use `description` only.

**Description patterns**

**File-triggered:** `'[DOMAIN] [CONSTRAINT_TYPE] for [SCOPE]'`

- `'TypeScript coding standards for type safety and naming conventions'`
- `'Python testing conventions for pytest-based test files'`

**On-demand:** `'Use when [TASK]. [SUMMARY].'`

- `'Use when writing database migrations. Covers safety checks, rollback procedures, and naming conventions.'`

**Glob patterns**

`applyTo` uses VS Code glob syntax (not regex). Use arrays for multiple patterns.

| Pattern | Matches |
|---|---|
| `'**/*.ts'` | All TypeScript files |
| `['**/*.ts', '**/*.tsx']` | TypeScript and TSX files |
| `'src/api/**'` | Everything under src/api/ |
| `'**/test/**/*.spec.ts'` | Spec files in any test directory |

**Example**

```yaml
---
description: 'TypeScript coding standards for type safety and naming conventions'
applyTo: '**/*.ts'
---
```

</instruction>


<copilot_instructions>

The project-level `copilot-instructions.md` file has no frontmatter — it is plain markdown, auto-applied to all chat requests.

- **Location:** `.github/copilot-instructions.md`
- **Discovery:** Automatic — VS Code attaches it to every chat request in the workspace
- **Content:** Project context, conventions, constraints, and decision frameworks
- **Structure:** Use XML tags for section organization, prose for project-specific rules

</copilot_instructions>
