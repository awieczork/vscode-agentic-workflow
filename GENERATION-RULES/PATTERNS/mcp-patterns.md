---
type: patterns
version: 1.0.0
purpose: Define THE framework approach to MCP server configuration
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# MCP Configuration Patterns

> **Extend agent capabilities with external tools via Model Context Protocol**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Parse DECISION RULES to select transport type and stack
2. Use MINIMAL CONFIG for 80% of cases
3. Escalate to WORKFLOW STACKS only when complexity warrants

**For Build Agents:**
1. Copy MINIMAL CONFIG as baseline
2. Add servers per AUTHORING RULES
3. Validate against CHECKLIST before commit

**For Inspect Agents:**
1. Verify `.vscode/mcp.json` follows STRUCTURE
2. Check all secrets use AUTHORING RULES patterns
3. Flag ANTI-PATTERNS

---

## PURPOSE

MCP (Model Context Protocol) servers extend Copilot with external tools — databases, APIs, browsers, search — through a standardized protocol. Configuration lives in `.vscode/mcp.json` for workspace-scoped access.

**Status:** Generally Available since VS Code 1.102

**This pattern defines:**
- THE configuration file format and location
- Transport selection criteria
- Secret management requirements
- Workflow-specific server stacks
- Required VS Code settings

---

## DECISION RULES (Machine-Parseable)

### Transport Selection

```
IF server runs locally AND is trusted
  THEN → STDIO
ELSE IF server is remote/cloud-hosted
  THEN → HTTP/SSE
ELSE IF server executes untrusted code
  THEN → DOCKER
ELSE IF local HTTP server needs socket performance
  THEN → UNIX_SOCKET
ELSE
  THEN → STDIO (default)
```

### Stack Selection

```
IF task needs 0-1 external tools
  THEN → MINIMAL (filesystem only or none)
ELSE IF task needs 2-5 tools AND workflow matches predefined stack
  THEN → WORKFLOW_STACK (full-stack, research, devops, database, testing)
ELSE IF task needs 6+ tools
  THEN → CUSTOM_STACK (compose from workflow stacks)
IF total tools > 128
  THEN → ENABLE_VIRTUAL_TOOLS
```

### Criteria Definitions

| Criterion | True When |
|-----------|----------|
| `trusted` | Server from official MCP registry or known publisher |
| `remote` | Server accessed via network URL, not local process |
| `untrusted_code` | Server executes user-provided code (sandboxing needed) |
| `workflow_match` | Task aligns with: full-stack, research, devops, database, or testing |

---

## STRUCTURE

### Configuration File Location

```
{workspace}/
├── .vscode/
│   └── mcp.json          # ← THE MCP configuration file
└── .env                   # Secrets (gitignored)
```

**Why `.vscode/mcp.json`:** Workspace-scoped, version-controlled (minus secrets), portable across team.

### mcp.json Schema

```json
{
  "servers": {
    "{server-name}": {
      "type": "stdio | http",
      "command": "{executable}",
      "args": ["{arg1}", "{arg2}"],
      "env": {
        "{VAR}": "${env:VAR_NAME}"
      },
      "envFile": ".env",
      "url": "https://...",
      "headers": {}
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "{input-id}",
      "description": "{prompt text}",
      "password": true
    }
  ]
}
```

### Required Fields by Transport

| Transport | Required Fields | Optional Fields |
|-----------|-----------------|-----------------|
| STDIO | `type`, `command` | `args`, `env`, `envFile` |
| HTTP/SSE | `url` | `headers`, `type` |
| Docker | `type: "stdio"`, `command: "docker"`, `args` | `env` |

---

## THE FRAMEWORK APPROACH

### Minimal Configuration (80% of use cases)

Start here. Add servers only when needed.

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

### Required Settings (settings.json)

```json
{
  "chat.mcp.access": true,
  "chat.mcp.discovery.enabled": true
}
```

### Adding GitHub MCP (built-in)

```json
{
  "github.copilot.chat.githubMcpServer.enabled": true,
  "github.copilot.chat.githubMcpServer.toolsets": ["repos", "issues", "pulls"],
  "github.copilot.chat.githubMcpServer.readonly": true
}
```

---

## TRANSPORT PATTERNS

### STDIO (Local Process)

**Use when:** Running trusted local tools

```json
{
  "servers": {
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${env:DATABASE_URL}"
      }
    }
  }
}
```

### HTTP/SSE (Remote Server)

**Use when:** Connecting to cloud-hosted services

```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

With authentication:

```json
{
  "servers": {
    "custom-api": {
      "type": "http",
      "url": "https://api.example.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${input:api-token}"
      }
    }
  },
  "inputs": [{
    "type": "promptString",
    "id": "api-token",
    "description": "API Bearer Token",
    "password": true
  }]
}
```

### Docker (Isolated Execution)

**Use when:** Running untrusted code or needing process isolation

```json
{
  "servers": {
    "sandbox": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/sandbox"]
    }
  }
}
```

### Python (UV-based)

**Use when:** Python MCP servers

```json
{
  "servers": {
    "git": {
      "type": "stdio",
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "${workspaceFolder}"]
    }
  }
}
```

---

## WORKFLOW STACKS

### Full-Stack Development

```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "${env:DATABASE_URL}" }
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    }
  }
}
```

### Research & Documentation

```json
{
  "servers": {
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "${env:BRAVE_API_KEY}" }
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

### DevOps & Infrastructure

```json
{
  "servers": {
    "kubernetes": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"]
    },
    "docker": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-docker"]
    }
  }
}
```

### Stack Sizing Guide

| Complexity | Servers | Tools | Example |
|------------|---------|-------|---------|
| Simple | 0-1 | 0-10 | Filesystem only |
| Moderate | 2-4 | 10-40 | Full-stack dev |
| Complex | 5-8 | 40-80 | Multi-service with testing |
| Research | 3-6 | 20-60 | Search + fetch + memory |

**Constraint:** Maximum 128 tools per chat request (model limit, verified 2026-01).

---

## AUTHORING RULES

```
RULE_001: Secret Management
  REQUIRE: All credentials use ${env:VAR}, envFile, or ${input:...}
  REJECT_IF: Hardcoded secrets in mcp.json
  RATIONALE: Prevents credential commits to version control
  EXAMPLE_VALID: "env": { "API_KEY": "${env:API_KEY}" }
  EXAMPLE_INVALID: "env": { "API_KEY": "sk-abc123..." }

RULE_002: Server Naming
  REQUIRE: camelCase names, no whitespace/special characters
  REJECT_IF: Names with spaces, hyphens in key position
  RATIONALE: JSON key compatibility, consistency
  EXAMPLE_VALID: "braveSearch"
  EXAMPLE_INVALID: "brave-search" (as JSON key)

RULE_003: Workspace Scope
  REQUIRE: MCP config in .vscode/mcp.json
  REJECT_IF: MCP servers in user settings.json
  RATIONALE: Project-specific tools stay with project
  EXAMPLE_VALID: .vscode/mcp.json
  EXAMPLE_INVALID: %APPDATA%/Code/User/settings.json

RULE_004: Version Pinning
  REQUIRE: Explicit versions for critical servers
  REJECT_IF: Unpinned packages in production
  RATIONALE: Reproducible builds, security
  EXAMPLE_VALID: "args": ["-y", "@modelcontextprotocol/server-postgres@1.2.3"]
  EXAMPLE_INVALID: "args": ["-y", "@modelcontextprotocol/server-postgres"]

RULE_005: Docker Cleanup
  REQUIRE: --rm flag for docker containers
  REJECT_IF: Docker without --rm
  RATIONALE: Prevents container accumulation
  EXAMPLE_VALID: ["docker", "run", "-i", "--rm", "image"]
  EXAMPLE_INVALID: ["docker", "run", "-i", "image"]

RULE_006: TLS for Remote
  REQUIRE: HTTPS for all remote MCP connections
  REJECT_IF: HTTP URLs for remote servers
  RATIONALE: Prevents man-in-the-middle attacks
  EXAMPLE_VALID: "url": "https://api.example.com/mcp/"
  EXAMPLE_INVALID: "url": "http://api.example.com/mcp/"
```

---

## VALIDATION CHECKLIST

```
VALIDATE_MCP_CONFIG:
  □ File located at .vscode/mcp.json
  □ No hardcoded secrets (search for "key", "token", "password" literals)
  □ All env vars use ${env:...} or envFile pattern
  □ Server names are camelCase
  □ Docker commands include --rm flag
  □ Remote URLs use HTTPS
  □ settings.json has chat.mcp.access: true
  □ Total tools < 128 (or virtual tools enabled)
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Hardcode API keys | Use `${env:VAR}` or `envFile` | Keys get committed to repos |
| Configure MCP in user settings | Use `.vscode/mcp.json` | Project tools must stay with project |
| Use HTTP for remote servers | Always HTTPS | Security: man-in-the-middle |
| Enable all GitHub toolsets | Start with `["repos", "issues", "pulls"]` | Least privilege |
| Docker without `--rm` | Always include `--rm` | Container accumulation |
| Use `mcp-servers:` in personal agent files | Use `.vscode/mcp.json` + `tools:` filter | `mcp-servers:` frontmatter only works at org/enterprise level |
| Configure 15 servers for simple task | Match stack to complexity | Context waste, slower responses |
| Use archived servers (sqlite, slack, sentry) | Find community alternatives | Deprecated, unmaintained |
| Trust `chat.tools.global.autoApprove: true` | Review tools individually | Disables critical security |

---

## LIMITATIONS

**Platform constraints to be aware of:**

| Limitation | Impact | Workaround |
|------------|--------|------------|
| MCP servers have no VS Code API access | Cannot access debugger, workspace APIs | Use Language Model Tools for VS Code integration |
| `mcp-servers:` frontmatter scope | Only works at org/enterprise level | Use `.vscode/mcp.json` for personal/team |
| No built-in MCP failure recovery | Servers crash without graceful degradation | Monitor server health manually |
| 128 tool limit | Chat requests truncated | Enable virtual tools threshold |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [settings-reference.md](../../cookbook/CONFIGURATION/settings-reference.md) | MCP-related VS Code settings |
| [mcp-servers.md](../../cookbook/CONFIGURATION/mcp-servers.md) | Full transport and config reference |
| [mcp-server-stacks.md](../../cookbook/REFERENCE/mcp-server-stacks.md) | Workflow stack combinations |
| [agent-patterns.md](agent-patterns.md) | Agent `tools:` field for MCP filtering |

---

## SOURCES

- [mcp-servers.md](../../cookbook/CONFIGURATION/mcp-servers.md) — Transport types, config format, security patterns
- [mcp-server-stacks.md](../../cookbook/REFERENCE/mcp-server-stacks.md) — Workflow stacks, sizing guidance
- [settings-reference.md](../../cookbook/CONFIGURATION/settings-reference.md) — MCP settings, enterprise policies
- [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) — Official reference
- [MCP Specification](https://modelcontextprotocol.io/specification) — Protocol spec
