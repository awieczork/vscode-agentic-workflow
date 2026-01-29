---
when:
  - referencing files and code in chat
  - using hash tools for context injection
  - building prompts with dynamic variables
  - invoking chat participants and tools
pairs-with:
  - prompt-files
  - just-in-time-retrieval
  - agent-file-format
requires:
  - none
complexity: low
---

# Context Variables

Reference context in prompts, chat, and agent configurations. Variables inject dynamic content like selected code, files, and user input into Copilot interactions.

## Chat Tools (`#`)

Type `#` in chat to invoke context tools. These are **tools** that perform actions (read, search, fetch), not just simple context references.

> **Note:** Tool names in VS Code use **camelCase** (e.g., `#readFile`, `#editFiles`). Some tools like `#file`, `#block`, `#function` are **chat variables** that add context without performing actions.
>
> Source: [VS Code Chat Tools Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#_chat-tools)

### Code Context Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#file` | Current file content | "Explain #file" |
| `#selection` | Selected text | "Refactor #selection" |
| `#codebase` | Full workspace search | "Find auth patterns in #codebase" |
| `#block` | Current code block | "Optimize #block" |
| `#function` | Current function/method | "Add tests for #function" |
| `#class` | Current class | "Document #class" |
| `#line` | Current line | "Fix #line" |
| `#sym` | Symbol at cursor | "Explain #sym" |
| `#comment` | Current comment | "Expand #comment" |
| `#path` | File path | "What does #path do?" |
| `#project` | Project context | "Summarize #project structure" |

### Search & Discovery Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#textSearch` | Text search in workspace | "Find all TODO comments with #textSearch" |
| `#fileSearch` | Find files by pattern | "Find config files with #fileSearch" |
| `#usages` | Find references/implementations | "Show all usages of this function with #usages" |
| `#searchResults` | Current search results | "Analyze #searchResults" |

### External Context Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#fetch <URL>` | Retrieve web content | "#fetch https://api.example.com/docs" |
| `#githubRepo <repo>` | Search GitHub repos | "#githubRepo microsoft/vscode find extension API" |

### Diagnostics & Testing Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#problems` | Workspace diagnostics | "Fix all #problems in this file" |
| `#testFailure` | Unit test failures | "Why is #testFailure happening?" |
| `#changes` | Source control changes | "Review my #changes" |
| `#todos` | Track implementation progress | "Show remaining #todos" |

### Terminal Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#terminalLastCommand` | Last terminal command | "Explain #terminalLastCommand output" |
| `#terminalSelection` | Terminal selection | "What does #terminalSelection mean?" |

### Agent & Orchestration Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#runSubagent` | Spawn isolated subagent | "Research this topic with #runSubagent" |

### VS Code Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `#extensions` | VS Code extensions | "List installed #extensions" |
| `#VSCodeAPI` | VS Code extension APIs | "How do I use #VSCodeAPI for this?" |
| `#new` | Scaffold new VS Code workspace | "Create a new React project with #new" |
| `#newWorkspace` | Create new workspace | "Set up workspace with #newWorkspace" |
| `#newJupyterNotebook` | Scaffold new Jupyter notebook | "Create notebook with #newJupyterNotebook" |
| `#openSimpleBrowser` | Open built-in Simple Browser | "Preview docs with #openSimpleBrowser" |
| `#runVscodeCommand` | Run VS Code command | "Format document with #runVscodeCommand" |
| `#installExtension` | Install VS Code extension | "Add Python support with #installExtension" |

### File References

Reference specific files by name using `#` followed by the filename:

```
#login.ts
#package.json
#copilot-instructions.md
```

Reference multiple files:

```
Review these files for security issues:
#auth.ts
#users.ts
#validate.ts
```

> **📋 Note:** VS Code uses `#filename` syntax (e.g., `#auth.ts`). The `#file:path` syntax (e.g., `#file:gameReducer.js`) is for Visual Studio IDE, not VS Code. Use VS Code's autocomplete after typing `#` to ensure correct file references.

> **Tip:** Type `#` then start typing a filename. VS Code provides autocomplete suggestions for files in your workspace.
>
> Source: [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context)

### Tool Sets

Tool sets group related tools for common operations:

| Tool Set | Includes | Use Case |
|----------|----------|----------|
| `#edit` | File editing tools | "Make changes using #edit" |
| `#search` | Search and discovery | "Find patterns using #search" |
| `#runCommands` | Terminal execution | "Run build using #runCommands" |
| `#runNotebooks` | Notebook cell execution | "Run analysis using #runNotebooks" |
| `#runTasks` | Task execution | "Build project using #runTasks" |

Source: [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_tool-sets)

## Chat Participants (`@`)

Type `@` to invoke specialized participants:

| Participant | Purpose | Example |
|-------------|---------|---------|
| `@workspace` | Workspace code structure | "@workspace find all API routes" |
| `@terminal` | Terminal shell and contents | "@terminal explain last error" |
| `@github` | GitHub operations | "@github create PR for this branch" |
| `@vscode` | VS Code commands | "@vscode how to split editor" |
| `@azure` | Azure services (**preview**, requires extension) | "@azure deploy to App Service" |

Source: [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

## Prompt Variables (`${}`)

Use in `.prompt.md` files for dynamic content:

| Variable | Description | Resolved To |
|----------|-------------|-------------|
| `${file}` | Current file path | `/src/app/page.tsx` |
| `${selection}` | Selected text/code | Highlighted content |
| `${selectedText}` | Alias for selection | Highlighted content |
| `${workspaceFolder}` | Workspace root | `/Users/dev/my-project` |
| `${workspaceFolderBasename}` | Workspace folder name | `my-project` |
| `${fileDirname}` | Current file directory | `/src/app` |
| `${fileBasename}` | Current filename | `page.tsx` |
| `${fileBasenameNoExtension}` | Filename without extension | `page` |
| `${input:name}` | Prompt user for input | Dialog value |
| `${input:name:placeholder}` | Input with placeholder | Dialog with default |

### Usage in Prompt Files

```markdown
---
mode: agent
tools: ['read_file', 'edit_file']
description: Refactor selected code
---

# Refactor

Analyze and improve ${selection}:

1. Review [conventions](${workspaceFolder}/docs/conventions.md)
2. Apply appropriate patterns
3. Maintain existing functionality

Target file: ${file}
Working in: ${workspaceFolderBasename}
```

### User Input Variables

Prompt for values at runtime:

```markdown
---
description: Create new component
---

# Create Component: ${input:componentName}

Create a new React component named ${input:componentName} in ${workspaceFolder}/src/components/.

Component type: ${input:componentType:functional}
```

When invoked, user sees dialogs for `componentName` (blank) and `componentType` (pre-filled with "functional").

### Tool References in Prompts

Reference specific tools using `#tool:<name>` syntax:

```markdown
---
description: Research and implement
tools: ['fetch', 'githubRepo']
---

# Research First

Use #tool:fetch to read the documentation at the provided URL.
Then use #tool:githubRepo to find similar implementations.
```

## Tool References

Reference tools in agent configurations:

```yaml
---
name: implement
tools:
  - read_file
  - edit_file
  - grep_search
  - file_search
  - run_in_terminal
---
```

### Built-in Agent Tools

<!-- NOTE: Tool names shown here are for agent YAML frontmatter. In chat, use #toolName syntax with camelCase -->

| Tool (YAML) | Chat Syntax | Purpose |
|-------------|-------------|---------|
| `readFile` | `#readFile` | Read file contents |
| `editFiles` | `#editFiles` | Modify files |
| `createFile` | `#createFile` | Create new files |
| `createDirectory` | `#createDirectory` | Create directories |
| `fileSearch` | `#fileSearch` | Find files by pattern |
| `textSearch` | `#textSearch` | Search file contents |
| `semantic_search` | `#codebase` | Natural language code search |
| `runInTerminal` | `#runInTerminal` | Run shell commands |
| `listDirectory` | `#listDirectory` | List directory contents |
| `get_errors` | `#problems` | Retrieve diagnostics |

> **Note:** VS Code agent tools use **camelCase**. The `tools:` array in agent YAML accepts either naming convention, but chat `#` references must use the exact tool name.
>
> Source: [VS Code Chat Tools Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#_chat-tools)

### MCP Tools

MCP servers add external tools. Reference with server prefix:

```yaml
tools:
  - github/*           # All GitHub MCP tools
  - postgres/query     # Specific tool
```

In chat, use `#tool:` syntax:

```
#tool:github_list_pull_requests
#tool:github_get_pull_request_diff
```

## Environment Variables

For MCP server configurations, use direct environment values or input variables for sensitive data:

```json
{
  "servers": {
    "database": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost:5432/mydb"
      }
    }
  }
}
```

For sensitive data like API keys, use input variables:

```json
{
  "inputs": [
    {
      "id": "db-password",
      "type": "promptString",
      "description": "Database password",
      "password": true
    }
  ],
  "servers": {
    "database": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-postgres"],
      "env": {
        "DB_PASSWORD": "${input:db-password}"
      }
    }
  }
}
```

> **Note:** The `${env:VAR_NAME}` syntax works in `tasks.json` and `launch.json`, but MCP configurations use `${input:variable-id}` for dynamic values.
>
> Source: [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_input-variables-for-sensitive-data)

## Context Loading Patterns

### Just-in-Time Loading

Load context only when needed:

```markdown
## Phase 1: Understand
Read #routes.ts to understand current structure.

## Phase 2: Plan
Based on understanding, create implementation plan.

## Phase 3: Implement
Only now read additional files as needed.
```

### Scoped Context

Load minimal context for focused tasks:

```markdown
# Good: Specific
Review #login.ts for security issues.

# Avoid: Broad
Review #codebase for security issues.
```

### Progressive Disclosure

Start narrow, expand as needed:

```markdown
1. First, check #selection for obvious issues
2. If unclear, read full #file for context
3. If still unclear, search #codebase for patterns
```

## Best Practices

### Do

```markdown
# Specific file references
Implement the pattern from #repository.ts

# Targeted selection
Refactor #selection following our naming conventions

# Scoped searches
Find similar functions using #fileSearch
```

### Avoid

```markdown
# Too broad (fills context)
Review everything in #codebase

# Redundant (file already open)
Read #file when selection is sufficient

# Unclear references
Fix the thing in that file
```

### Context Budget

<!-- NOT IN OFFICIAL DOCS: Context budget percentages are community-derived guidelines, not official recommendations - flagged 2026-01-25 -->

Keep context utilization in check:

| Usage | Risk | Recommendation |
|-------|------|----------------|
| <40% | Underutilized | Add relevant context |
| 40-60% | Optimal | Ideal for complex tasks |
| 60-80% | Heavy | Monitor for quality drop |
| >80% | Overloaded | Split into phases |

## Related

- [prompt-files](../CONFIGURATION/prompt-files.md) — `${variable}` syntax in prompts
- [agent-file-format](../CONFIGURATION/agent-file-format.md) — `tools:` configuration
- [mcp-servers](../CONFIGURATION/mcp-servers.md) — MCP tool availability
- [settings-reference](../CONFIGURATION/settings-reference.md) — Enable context features
- [utilization-targets](./utilization-targets.md) — Context budget management
- [just-in-time-retrieval](./just-in-time-retrieval.md) — Progressive loading patterns

## Sources

- [GitHub Copilot Cheat Sheet](https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode) — Chat variables and participants
- [VS Code Copilot Features](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) — Complete chat tools reference
- [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — Context management
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — Prompt variable syntax
- [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Tool types and sets
