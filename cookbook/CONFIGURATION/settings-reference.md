---
when:
  - configuring VS Code settings for Copilot agents
  - setting up terminal auto-approve rules
  - enabling agent features and MCP access
  - customizing file exclusions and instruction paths
pairs-with:
  - permission-levels
  - destructive-ops
  - file-structure
  - mcp-servers
requires:
  - none
complexity: low
---

# Settings Reference

VS Code settings.json configuration for GitHub Copilot agent workflows. Copy-paste ready blocks for common setups.

## Recommended Baseline

Complete settings block for agentic workflows:

```json
{
  "github.copilot.enable": { "*": true },
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 100,
  "chat.mcp.access": true,
  "chat.mcp.discovery.enabled": true,
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    ".vscode/instructions": true
  },
  "chat.promptFilesLocations": { ".github/prompts": true },
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true,
  "chat.useAgentSkills": true,
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "git status": true
  },
  "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true
}
```

## Settings by Category

### Core Agent Settings

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.agent.enabled` | `true` | Enable agent mode in chat |
| `chat.agent.maxRequests` | `25` | Max tool calls per request |
| `chat.mcp.access` | `true` | Allow MCP server access |
| `chat.mcp.discovery.enabled` | `false` | Auto-discover MCP servers |
| `chat.viewSessions.enabled` | `true` | Show agent sessions in Chat view |
| `chat.viewSessions.orientation` | `"auto"` | Session list orientation (auto/stacked/sideBySide) |
<!-- NOT IN OFFICIAL DOCS: chat.restoreLastPanelSession default=true - flagged 2026-01-24 -->
| `chat.restoreLastPanelSession` | `true` | Restore previous chat session on restart |

```json
{
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 100,
  "chat.mcp.access": true,
  "chat.mcp.discovery.enabled": true,
  "chat.viewSessions.enabled": true
}
```

### Instruction Files

| Setting | Default | Purpose |
|---------|---------|---------|
| `github.copilot.chat.codeGeneration.useInstructionFiles` | `true` | Enable .instructions.md |
| `chat.instructionsFilesLocations` | `{".github/instructions": true}` | Search paths |

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    ".vscode/instructions": true,
    "docs/instructions": true
  }
}
```

### Prompt Files

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.promptFilesLocations` | `{".github/prompts": true}` | Search paths |
| `chat.promptFilesRecommendations` | `[]` | Prompt file recommendations (key-value pairs) |

```json
{
  "chat.promptFilesLocations": { ".github/prompts": true },
  "chat.promptFilesRecommendations": {
    "code-review": true,
    "refactor": "editorLangId == typescript"
  }
}
```

### Agent Files and Skills

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.useAgentsMdFile` | `true` | Enable AGENTS.md |
| `chat.useNestedAgentsMdFiles` | `false` | Nested AGENTS.md (experimental) |
| `chat.useAgentSkills` | `false` | Agent skills (experimental) |
| `chat.useClaudeSkills` | `false` | Reuse Claude skills (experimental) |
| `chat.customAgentInSubagent.enabled` | `false` | Use custom agents as subagents (experimental) |

```json
{
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true,
  "chat.useAgentSkills": true
}
```

### Terminal Auto-Approve

Pre-approve safe terminal commands. Uses an object format with default deny rules for dangerous commands.

**Default deny patterns:** `rm`, `rmdir`, `del`, `kill`, `curl`, `wget`, `eval`, `chmod`, `chown`, `/^Remove-Item\b/i` (PowerShell)

> **Source:** [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings)

```json
{
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "npm run build": true,
    "git status": true,
    "git diff": true,
    "git log --oneline -10": true,
    "rm": false,
    "rmdir": false
  },
  "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true,
  "chat.tools.terminal.preventShellHistory": false,
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  "chat.tools.terminal.outputLocation": "panel"
}
```

Use patterns for flexibility (regex patterns wrapped in `/`):

```json
{
  "chat.tools.terminal.autoApprove": {
    "/^npm run /": true,
    "git status": true,
    "/^git diff/": true,
    "/^pnpm test/": true
  }
}
```

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.tools.terminal.autoApprove` | `{...deny patterns}` | Commands to auto-approve (object with patterns) |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | `false` | Auto-approve npm scripts from package.json |
| `chat.tools.terminal.preventShellHistory` | `false` | Prevent commands from shell history |
| `chat.tools.terminal.blockDetectedFileWrites` | `"outsideWorkspace"` | Require approval for file writes (values: `outsideWorkspace`, `always`, `never`) |
| `chat.tools.terminal.outputLocation` | `"panel"` | Where to display terminal output |
| `chat.tools.terminal.ignoreDefaultAutoApproveRules` | `false` | Ignore default deny rules |

### Custom Instructions for Specific Features

Override default behavior for code generation, reviews, and commits:

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    { "text": "Use TypeScript strict mode" },
    { "text": "Prefer async/await over callbacks" }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    { "text": "Focus on security vulnerabilities and performance issues" }
  ],
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "Use conventional commit format: type(scope): description" }
  ]
}
```

### File Exclusions

Hide sensitive files from Copilot:

```json
{
  "files.exclude": {
    "**/.env": true,
    "**/.env.*": true,
    "**/secrets/**": true,
    "**/*.key": true,
    "**/*.pem": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/coverage": true,
    "**/*.min.js": true,
    "**/package-lock.json": true,
    "**/yarn.lock": true
  }
}
```

Also use `.copilotignore` at project root for workspace indexing exclusions (respects both `.gitignore` and `.copilotignore`).

> **Source:** [VS Code 1.84 Release Notes](https://code.visualstudio.com/updates/v1_84#_workspace)

### GitHub MCP Server (Built-in)

VS Code includes a built-in GitHub MCP Server (Preview) for repository operations:

> **Source:** [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107#_github-mcp-server-provided-by-github-copilot-chat-preview)

| Setting | Default | Purpose |
|---------|---------|---------||
| `github.copilot.chat.githubMcpServer.enabled` | `false` | Enable built-in GitHub MCP |
| `github.copilot.chat.githubMcpServer.toolsets` | `["default"]` | Enabled tool categories (can add: `workflows`) |
| `github.copilot.chat.githubMcpServer.readonly` | `false` | Read-only mode (prevents write operations) |
| `github.copilot.chat.githubMcpServer.lockdown` | `false` | Additional security control |

```json
{
  "github.copilot.chat.githubMcpServer.enabled": true,
  "github.copilot.chat.githubMcpServer.toolsets": ["repos", "issues", "pulls"],
  "github.copilot.chat.githubMcpServer.readonly": false
}
```

### Advanced Settings

| Setting | Default | Purpose |
|---------|---------|---------|
| `github.copilot.chat.summarizeAgentConversationHistory.enabled` | `true` | Auto-summarize when context window full |
| `github.copilot.chat.anthropic.thinking.budgetTokens` | `4000` | Extended thinking budget (set to 0 to disable) |
| `chat.tools.edits.autoApprove` | `false` | Auto-approve file edits (pattern-based) |
| `chat.tools.urls.autoApprove` | `[]` | URL patterns to auto-approve |
| `chat.tools.global.autoApprove` | `false` | Auto-approve ALL tools (disables security) |
| `github.copilot.chat.virtualTools.threshold` | `128` | Tool count for virtual tools |
| `inlineChat.enableV2` | `false` | New inline chat UX (Preview) |
| `chat.mcp.autoStart` | `"newAndOutdated"` | MCP server auto-start behavior |
| `github.copilot.chat.agent.autoFix` | `true` | Auto-diagnose and fix code issues |
| `chat.checkpoints.enabled` | `true` | Enable chat checkpoints |

> **Source:** [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings), [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107)

## Settings Precedence

Settings are merged/overridden in this order (later wins):

| Priority | Source | Location |
|----------|--------|----------|
| 1 | Default | Built-in VS Code defaults |
| 2 | User | `%APPDATA%\Code\User\settings.json` (Windows) |
| 3 | Remote | SSH/container settings |
| 4 | Workspace | `.vscode/settings.json` |
| 5 | Workspace Folder | Multi-root per-folder settings |
| 6 | Language-specific | `[typescript]` blocks (always override) |
| 7 | Policy | Admin-enforced (always override all) |

**Merge behavior:**
- Object settings (like `instructionsFilesLocations`): **merged**
- Array/primitive settings: **overridden**

## Profile-Based Configurations

### Minimal (Getting Started)

```json
{
  "github.copilot.enable": { "*": true },
  "chat.agent.enabled": true,
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}
```

### Standard (Recommended)

```json
{
  "github.copilot.enable": { "*": true },
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 100,
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true
  },
  "chat.promptFilesLocations": { ".github/prompts": true },
  "chat.useAgentsMdFile": true,
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "git status": true
  }
}
```

### Full Agentic (Power User)

```json
{
  "github.copilot.enable": { "*": true },
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 150,
  "chat.mcp.access": true,
  "chat.mcp.discovery.enabled": true,
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    ".vscode/instructions": true
  },
  "chat.promptFilesLocations": { ".github/prompts": true },
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true,
  "chat.useAgentSkills": true,
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.githubMcpServer.enabled": true,
  "chat.tools.terminal.autoApprove": {
    "npm run *": true,
    "pnpm *": true,
    "git status": true,
    "git diff *": true,
    "git log *": true
  },
  "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true,
  "github.copilot.chat.reviewSelection.instructions": [
    { "text": "Focus on security, performance, and maintainability" }
  ],
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "Use conventional commits: type(scope): description" }
  ],
  "files.exclude": {
    "**/.env*": true,
    "**/secrets/**": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/coverage": true
  }
}
```

### Organization/Enterprise

```json
{
  "github.copilot.chat.customAgents.showOrganizationAndEnterpriseAgents": true,
  "github.copilot.chat.mcp.gallery.serviceUrl": "https://internal-registry.company.com/mcp",
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.discovery.allowOrganizationServers": true,
  "chat.tools.eligibleForAutoApproval": ["readFile", "searchFiles"]
}
```

**Enterprise MCP Policy:** MCP servers are disabled by default in enterprise. Enable via "AI Controls → MCP" in enterprise settings.

### Deprecated Settings

| Setting | Replaced By | Notes |
|---------|-------------|-------|
| `chat.tools.terminal.shellIntegrationTimeout` | `terminal.integrated.shellIntegration.timeout` | Use general terminal setting |
| `github.copilot.chat.codeGeneration.instructions` | `.instructions.md` files | Prefer file-based instructions |
| `github.copilot.chat.testGeneration.instructions` | `.instructions.md` files | Prefer file-based instructions |

## Language-Specific Overrides

```json
{
  "[typescript]": {
    "github.copilot.chat.codeGeneration.instructions": [
      { "text": "Use strict mode, explicit return types" }
    ]
  },
  "[python]": {
    "github.copilot.chat.codeGeneration.instructions": [
      { "text": "Use type hints, follow PEP 8" }
    ]
  }
}
```

## Related

- [instruction-files](./instruction-files.md) — .instructions.md file format
- [prompt-files](./prompt-files.md) — .prompt.md file format
- [skills-format](./skills-format.md) — SKILL.md format
- [agent-file-format](./agent-file-format.md) — .agent.md format
- [mcp-servers](./mcp-servers.md) — MCP server configuration
- [permission-levels](../CHECKPOINTS/permission-levels.md) — Auto-approve patterns

## Sources

- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — Authoritative settings reference
- [VS Code 1.109 Insiders Notes](https://code.visualstudio.com/updates/v1_109) — Agent skills locations
- [VS Code 1.108 Release Notes](https://code.visualstudio.com/updates/v1_108) — Terminal auto-approve, agent skills
- [VS Code 1.107 Release Notes](https://code.visualstudio.com/updates/v1_107) — GitHub MCP Server, Anthropic thinking, Claude skills
- [VS Code 1.106 Release Notes](https://code.visualstudio.com/updates/v1_106) — Agent sessions, shell integration timeout deprecated
- [VS Code 1.84 Release Notes](https://code.visualstudio.com/updates/v1_84#_workspace) — .copilotignore support
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — Instruction file settings
- [GitHub Enterprise MCP Policy](https://docs.github.com/en/enterprise-cloud@latest/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-enterprise-policies) — Enterprise settings
- [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) — Indexing configuration
