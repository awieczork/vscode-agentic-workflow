---
type: configuration
version: 1.0.0
purpose: THE optimal VS Code + Copilot settings for agentic workflows
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# SETTINGS.md

> **The definitive VS Code configuration for GitHub Copilot agentic workflows**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Copy REQUIRED SETTINGS to `.vscode/settings.json` for new projects
2. Add MCP configuration based on project needs
3. Customize terminal auto-approve based on tech stack

**For Build Agents:**
1. Verify settings exist before proceeding with implementation
2. Reference this file when asked to "set up Copilot" or "configure agents"

**For Inspect Agents:**
1. Validate `.vscode/settings.json` against REQUIRED SETTINGS
2. Flag security anti-patterns (hardcoded secrets, missing exclusions)
3. Verify MCP configuration follows SECURITY RULES

---

## PURPOSE

VS Code settings control GitHub Copilot's agentic capabilities. Without proper configuration:

| Missing Setting | Consequence |
|-----------------|-------------|
| `chat.agent.enabled` | No tool usage, no agentic behavior |
| `chat.useAgentsMdFile` | Custom agents not discovered |
| `chat.instructionsFilesLocations` | Instructions ignored |
| `chat.mcp.access` | MCP servers inaccessible |
| `chat.tools.terminal.autoApprove` | Every command requires manual approval |
| `files.exclude` for `.env*` | Secrets exposed to context |

---

## REQUIRED SETTINGS

**Copy this entire block to `.vscode/settings.json`:**

```json
{
  "github.copilot.enable": { "*": true },
  "chat.agent.enabled": true,
  "chat.agent.maxRequests": 100,
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true
  },
  "chat.useAgentsMdFile": true,
  "chat.mcp.access": true,
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "npm run build": true,
    "git status": true,
    "git diff": true,
    "rm": false,
    "rmdir": false,
    "del": false,
    "curl": false,
    "wget": false
  },
  "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true,
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  "files.exclude": {
    "**/.env": true,
    "**/.env.*": true,
    "**/secrets/**": true,
    "**/*.key": true,
    "**/*.pem": true
  }
}
```

| Setting | Value | Rationale |
|---------|-------|-----------|
| `github.copilot.enable` | `{ "*": true }` | Master enable for all file types |
| `chat.agent.enabled` | `true` | Enables agent mode (tool usage) |
| `chat.agent.maxRequests` | `100` | Default 25 too low for complex tasks |
| `github.copilot.chat.codeGeneration.useInstructionFiles` | `true` | Enables `.instructions.md` discovery |
| `chat.instructionsFilesLocations` | `{".github/instructions": true}` | Standard location for instructions |
| `chat.promptFilesLocations` | `{".github/prompts": true}` | Standard location for prompts |
| `chat.useAgentsMdFile` | `true` | Enables `.agent.md` discovery |
| `chat.mcp.access` | `true` | Enables MCP server access |
| `chat.tools.terminal.autoApprove` | Object with safe/denied | Accelerates workflow, blocks danger |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | `true` | Trusts package.json scripts |
| `chat.tools.terminal.blockDetectedFileWrites` | `"outsideWorkspace"` | Prevents escaping workspace |
| `files.exclude` | `.env*`, secrets, keys | Keeps secrets out of context |

---

## MCP CONFIGURATION

Create `.vscode/mcp.json` at workspace root.

### Minimal Configuration (Recommended Start)

```json
{
  "servers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
    }
  }
}
```

### With GitHub MCP (For PR/Issue Workflows)

Add this VS Code setting:

```json
{
  "github.copilot.chat.githubMcpServer.enabled": true,
  "github.copilot.chat.githubMcpServer.toolsets": ["repos", "issues", "pull_requests"],
  "github.copilot.chat.githubMcpServer.readonly": false
}
```

### Full Stack (Web Research + Memory + Browser)

```json
{
  "servers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
    },
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${env:BRAVE_API_KEY}"
      }
    },
    "fetch": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### MCP Security Rules

| Rule | Implementation |
|------|----------------|
| No hardcoded secrets | Use `${env:VAR_NAME}` or `envFile: ".env"` |
| Runtime prompts for keys | `${input:secret-id}` with `"password": true` |
| Workspace scope only | Place in `.vscode/mcp.json`, not user settings |
| HTTPS required | All remote servers must use TLS |

**Input prompt example:**

```json
{
  "inputs": [{
    "type": "promptString",
    "id": "api-key",
    "description": "Enter your API key",
    "password": true
  }]
}
```

---

## WORKSPACE VS USER SETTINGS

### Workspace Settings (`.vscode/settings.json`)

Settings that MUST be in workspace (project-specific):

| Setting | Why Workspace |
|---------|---------------|
| `chat.instructionsFilesLocations` | Path relative to project |
| `chat.promptFilesLocations` | Path relative to project |
| `chat.tools.terminal.autoApprove` | Project-specific commands |
| `files.exclude` | Project-specific secrets |

### User Settings (Global)

Settings that SHOULD be in user (personal preferences):

| Setting | Why User |
|---------|----------|
| `github.copilot.enable` | Global enable |
| `chat.agent.enabled` | Personal preference |
| `chat.agent.maxRequests` | Personal workflow |
| `chat.viewSessions.enabled` | UI preference |

### Merge Behavior

| Type | Behavior | Example |
|------|----------|---------|
| Object settings | **MERGED** | `instructionsFilesLocations` adds paths |
| Primitives/Arrays | **OVERRIDDEN** | `maxRequests` replaces |

**Precedence order:**
Default → User → Remote → Workspace → Workspace Folder → Language-specific → Policy

---

## OPTIONAL ENHANCEMENTS

### Experimental Features (Opt-In)

```json
{
  "chat.useNestedAgentsMdFiles": true,
  "chat.useAgentSkills": true,
  "chat.customAgentInSubagent.enabled": true,
  "chat.mcp.discovery.enabled": true
}
```

| Setting | Purpose | Stability |
|---------|---------|-----------|
| `chat.useNestedAgentsMdFiles` | Multi-folder agent discovery | Experimental |
| `chat.useAgentSkills` | SKILL.md files | Experimental |
| `chat.customAgentInSubagent.enabled` | Custom agents as subagents | Experimental |
| `chat.mcp.discovery.enabled` | Auto-discover MCP servers | Experimental |

### Extended Thinking (Claude)

```json
{
  "github.copilot.chat.anthropic.thinking.budgetTokens": 8000
}
```

| Value | Effect |
|-------|--------|
| `0` | Disable extended thinking |
| `4000` | Default budget |
| `8000-16000` | Deeper reasoning for complex tasks |

### Session Management

```json
{
  "chat.viewSessions.enabled": true,
  "chat.restoreLastPanelSession": true,
  "chat.checkpoints.enabled": true
}
```

### Auto-Fix and Review

```json
{
  "github.copilot.chat.agent.autoFix": true,
  "github.copilot.chat.reviewSelection.instructions": [
    { "text": "Focus on security vulnerabilities and performance issues" }
  ],
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "Use conventional commits: type(scope): description" }
  ]
}
```

### File Indexing Exclusions

In addition to `files.exclude`, use `.copilotignore` at project root:

```
# .copilotignore
node_modules/
dist/
coverage/
*.min.js
package-lock.json
yarn.lock
```

---

## VALIDATION CHECKLIST

```
VALIDATE_SETTINGS:
  □ `.vscode/settings.json` exists
  □ `chat.agent.enabled: true` present
  □ `chat.agent.maxRequests` ≥ 100
  □ `chat.instructionsFilesLocations` includes project path
  □ `chat.useAgentsMdFile: true` if using custom agents
  □ `chat.mcp.access: true` if using MCP servers
  □ `files.exclude` covers `.env*` files
  □ `chat.tools.terminal.autoApprove` denies `rm`, `curl`, `wget`
  □ No hardcoded secrets in settings
  □ MCP config in `.vscode/mcp.json` (not user settings)
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| `"chat.tools.global.autoApprove": true` | Approve specific commands | Disables ALL security prompts |
| `chat.agent.maxRequests: 25` (default) | Set to `100` | Too low for complex agentic tasks |
| `chat.agent.maxRequests: 500` | Use `100-150` | Runaway tasks, token burn |
| Hardcode API keys in mcp.json | `${env:KEY}` or `${input:key}` | Security breach |
| User-level instruction paths | Workspace settings | Won't work across projects |
| Missing `files.exclude` for `.env*` | Always exclude | Secrets in context |
| `chat.tools.terminal.ignoreDefaultAutoApproveRules: true` without explicit denies | Keep false or add denies | Removes `rm`, `curl` protection |
| Enable all MCP toolsets | Enable only what needed | 128 tool limit, context waste |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `PATTERNS/instruction-patterns.md` | What goes in `.github/instructions/` |
| `PATTERNS/prompt-patterns.md` | What goes in `.github/prompts/` |
| `PATTERNS/agent-patterns.md` | How to create `.agent.md` files |
| `PATTERNS/mcp-patterns.md` | MCP configuration details |
| `CHECKLISTS/pre-generation.md` | Settings verification before generation |

---

## SOURCES

- [settings-reference.md](../cookbook/CONFIGURATION/settings-reference.md) — Primary VS Code settings
- [mcp-servers.md](../cookbook/CONFIGURATION/mcp-servers.md) — MCP configuration patterns
- [permission-levels.md](../cookbook/CHECKPOINTS/permission-levels.md) — Auto-approve patterns
- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — Official documentation
- [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) — Official MCP docs
