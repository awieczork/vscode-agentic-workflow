This file defines the frontmatter contract for VS Code .agent.md files. The governing principle is minimal required fields — most fields are optional with sensible defaults. Source: custom-agents.md (VS Code 1.106+).


<frontmatter_fields>

Set these fields during agent creation. Wrap all string values in single quotes: `name: 'value'`.

- `name` — string, optional. Agent name shown in dropdown, lowercase alphanumeric + hyphens, matches filename minus `.agent.md`. Single-line only. Derive from agent's role or purpose. If omitted, VS Code derives from filename
- `description` — string, required. Brief description, shown as placeholder text in chat input. Drives agent discovery — include trigger words so users and parent agents know when to invoke. Single-line only. Max 1024 chars
- `tools` — string[], optional. Tool or tool-set names available to the agent. Select from `<tool_sets>` and `<tools_list>` based on agent's boundaries. See `<tools_selection_guidance>` for decision rules
- `argument-hint` — string, optional. Hint text shown in chat input to guide user interaction. Single-line only. Base on common usage patterns
- `handoffs` — object[], optional. Suggested next actions to transition between agents. Requires full workflow picture
- `handoffs[].label` — string, required when handoffs present. Display text on handoff button. Single-line only
- `handoffs[].agent` — string, required when handoffs present. Target agent identifier. Single-line only
- `handoffs[].prompt` — string, optional. Prompt text sent to target agent. Single-line only
- `handoffs[].send` — boolean, optional, default `false`. Auto-submit prompt on handoff. Set `true` only when transition is low-risk and reversible
- `agents` — string[], optional. Restricts which sub-agents this agent can invoke. Example: `agents: ['researcher', 'build']`
- `user-invokable` — boolean, optional, default `true`. When `false`, agent is only available as a sub-agent, not selectable by users
- `disable-model-invocation` — boolean, optional. When `true`, agent is only invokable by users, never auto-selected by model
- `target` — string, optional. Restricts agent to a specific VS Code interface. Values: `cli` | `editor`
- `mcp-servers` — string[], optional. List of MCP server names to enable for this agent. Example: `mcp-servers: ['github', 'filesystem']`
- `model` — string, optional. Suggested LLM model. Example: `model: 'claude-sonnet-4'`

</frontmatter_fields>


`infer` — Deprecated. Use `user-invokable: true` combined with `disable-model-invocation: false` instead.


<tool_sets>

Tool sets bundle related tools. Specifying a tool set enables all tools within it. 7 tool sets available.

- `agent` — Delegate tasks to other agents. Includes: `runSubagent`
- `edit` — File and directory modifications. Includes: `createDirectory`, `createFile`, `createJupyterNotebook`, `editFiles`, `editNotebook`
- `execute` — Code execution, terminal commands, tasks, and codebase memory. Includes: `awaitTerminal`, `createAndRunTask`, `getTerminalOutput`, `killTerminal`, `runInTerminal`, `runNotebookCell`, `runTests`, `testFailure`, `memory`
- `read` — Workspace content reading. Includes: `getNotebookSummary`, `problems`, `readFile`, `terminalLastCommand`, `terminalSelection`
- `search` — Workspace search and file discovery. Includes: `changes`, `codebase`, `fileSearch`, `listDirectory`, `searchResults`, `searchSubagent`, `textSearch`, `usages`
- `vscode` — VS Code integration and scaffolding. Includes: `askQuestions`, `extensions`, `getProjectSetupInfo`, `installExtension`, `newWorkspace`, `openSimpleBrowser`, `runCommand`, `switchAgent`, `vscodeAPI`
- `web` — External web and GitHub access. Includes: `fetch`, `githubRepo`

Standalone tools not in any tool set: `todo`, `renderMermaidDiagram`

</tool_sets>


<tools_list>

All individual tools organized by tool set. Use this list when selecting specific tools instead of full tool sets.

**search**

- `codebase` — Find relevant files and code in the workspace
- `searchSubagent` — Launch a dedicated search subagent to orchestrate multiple search tools
- `textSearch` — Search for text in files by pattern
- `fileSearch` — Find files by name or glob pattern
- `listDirectory` — List the contents of a directory
- `searchResults` — Get the results from the Search view
- `usages` — Find references, definitions, and implementations of a symbol
- `changes` — Get diffs of changed files

**read**

- `readFile` — Read the contents of a file
- `problems` — Check errors for a particular file or workspace
- `terminalLastCommand` — Get the last command run in a terminal
- `terminalSelection` — Get the current terminal selection
- `getNotebookSummary` — Get the structure of a notebook

**edit**

- `editFiles` — Edit files
- `createFile` — Create new files
- `createDirectory` — Create new directories
- `createJupyterNotebook` — Create a new Jupyter notebook
- `editNotebook` — Edit a notebook file

**execute**

- `runInTerminal` — Run commands in the terminal
- `runNotebookCell` — Trigger the execution of a notebook cell
- `createAndRunTask` — Create and run a task
- `getTerminalOutput` — Get the output of a terminal command
- `awaitTerminal` — Wait for a background terminal to complete
- `killTerminal` — Kill a terminal by its ID
- `runTests` — Run tests in the workspace — returns pass/fail results
- `testFailure` — Include information about test failures
- `memory` — Store facts about the codebase for future use

**vscode**

- `askQuestions` — Ask user clarifying questions with single/multi-select options and free text input
- `extensions` — Search for VS Code extensions
- `vscodeAPI` — Use VS Code API documentation and extension development info
- `newWorkspace` — Scaffold a new workspace
- `getProjectSetupInfo` — Get project scaffolding instructions and configuration
- `runCommand` — Run a VS Code command
- `installExtension` — Install a VS Code extension
- `openSimpleBrowser` — Preview a web app in the integrated browser
- `switchAgent` — Switch to another agent

**web**

- `fetch` — Fetch the main content from a web page
- `githubRepo` — Search a GitHub repository for code

**agent**

- `runSubagent` — Run a task in an isolated subagent context

**standalone**

- `todo` — Manage and track todo items
- `renderMermaidDiagram` — Render interactive Mermaid diagrams in chat responses

**MCP tools**

- `context7/*` — MCP tool for library and framework documentation lookup. Provides up-to-date API references, usage patterns, and best practices for external dependencies

</tools_list>


<tools_selection_guidance>

- Use **tool set** when the agent needs the full capability (e.g., `search` for an agent that explores codebases)
- Use **individual tool** when the agent needs only one specific capability from a set (e.g., `readFile` only, without `codebase` or `textSearch`)
- Use **individual tool** to enforce boundaries — omitting `editFiles` from `edit` set prevents modifications while allowing `createFile`
- Combine tool sets and individual tools freely: `tools: ['search', 'editFiles', 'runInTerminal']`
- Select the minimal set for the role — excess tools dilute focus and expand boundary surface
- MCP tools (e.g., `context7/*`) provide access to external knowledge sources — use for agents that need library/framework API lookups

</tools_selection_guidance>
