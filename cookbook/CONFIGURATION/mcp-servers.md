---
when:
  - adding external tool access to agents
  - configuring database, API, or browser automation tools
  - setting up MCP server authentication
  - connecting agents to external services
pairs-with:
  - settings-reference
  - file-structure
  - mcp-server-stacks
requires:
  - mcp-tools
complexity: high
---

# MCP Servers

Model Context Protocol (MCP) servers extend Copilot with external tools—databases, APIs, browser automation, and more. Configure in `.vscode/mcp.json` for workspace-scoped access.

**Status:** Generally Available (GA) since VS Code 1.102

## Configuration File

Create `.vscode/mcp.json` at your workspace root. Use camelCase for server names, avoid whitespace/special characters:

```json
{
  "servers": {
    "server-name": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@scope/server-package"],
      "env": {}
    }
  }
}
```

## Transport Patterns

### STDIO (Local Process)

Most common pattern—runs server as local process:

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

### Python UV-based

For Python MCP servers:

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

### Docker-based

Run servers in containers for isolation:

```json
{
  "servers": {
    "postgres": {
      "type": "stdio",
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/postgres", "postgresql://localhost/mydb"]
    }
  }
}
```

### HTTP/SSE (Remote)

For remote or cloud-hosted servers. VS Code first attempts HTTP Stream transport, falling back to SSE if unsupported:

```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

### HTTP with Bearer Token

For remote APIs requiring authentication:

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

### Unix Socket/Named Pipe

For local HTTP servers via socket or pipe:

```json
{
  "servers": {
    "local-service": {
      "type": "http",
      "url": "unix:///path/to/server.sock"
    }
  }
}
```

Optional subpaths via URL fragments: `unix:///tmp/server.sock#/mcp/subpath`

## Environment Variables

Never hardcode credentials. Use environment variable references:

```json
{
  "servers": {
    "brave-search": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${env:BRAVE_API_KEY}"
      }
    }
  }
}
```

Or load from `.env` file:

```json
{
  "servers": {
    "custom-tool": {
      "type": "stdio",
      "command": "node",
      "args": ["./tools/my-tool.js"],
      "envFile": ".env"
    }
  }
}
```

## Input Prompts

Prompt users for sensitive values at runtime:

```json
{
  "servers": {
    "api-service": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "my-mcp-server"],
      "env": {
        "API_KEY": "${input:api-key}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "api-key",
      "description": "Enter your API key",
      "password": true
    }
  ]
}
```

## Development Mode

Enable file watching and debugging for MCP server development:

```json
{
  "servers": {
    "my-server": {
      "type": "stdio",
      "command": "node",
      "args": ["./dist/index.js"],
      "dev": {
        "watch": "**/*.ts",
        "debug": { "type": "node" }
      }
    }
  }
}
```

## Dev Container Support

Configure MCP servers in Dev Containers via `devcontainer.json`:

```json
{
  "customizations": {
    "vscode": {
      "mcp": {
        "servers": {
          "my-server": {
            "type": "stdio",
            "command": "npx",
            "args": ["-y", "my-mcp-server"]
          }
        }
      }
    }
  }
}
```

## Server Discovery

### GitHub MCP Server Registry

Browse and install MCP servers from the GitHub MCP Server Registry:

1. Open Extensions view (`Ctrl+Shift+X`)
2. Search `@mcp` to filter MCP servers
3. Click Install on desired server

Or use Command Palette: `MCP: Browse Servers`

Enable with: `"chat.mcp.gallery.enabled": true`

### Command Line Installation

Install MCP servers from the command line:

```bash
code --add-mcp "{\"name\":\"my-server\",\"command\": \"uvx\",\"args\": [\"mcp-server-fetch\"]}"
```

### Settings Sync

MCP server configurations can be synchronized across devices via VS Code Settings Sync.

### Enterprise Server Discovery

Organizations can configure centralized MCP server registries via enterprise policy:

```json
{
  "chat.mcp.gallery.serviceUrl": "https://internal-registry.company.com/mcp"
}
```

## Server Categories

| Category | Servers | Use Case |
|----------|---------|----------|
| **Developer Tools** | `github-mcp-server`, `git-server`, `playwright-mcp` | PRs, code analysis, testing |
| **Databases** | `server-postgres`, `server-sqlite`, `mongodb-mcp` | Queries, schema inspection |
| **Browser** | `playwright-mcp`, `puppeteer-mcp` | Scraping, E2E tests |
| **Code Execution** | `mcp-run-python`, `container-use` | Sandboxed execution |
| **Search** | `brave-search`, `fetch-server`, `exa-mcp` | Web search, fetching |
| **Memory** | `server-memory`, `context7` | Persistent context, RAG |
| **Cloud** | `cloudflare-mcp`, `aws-mcp`, `kubernetes-mcp` | Infrastructure |
| **Communication** | `slack-mcp`, `discord-mcp`, `gmail-mcp` | Messaging, notifications |
| **Productivity** | `notion-mcp`, `linear-mcp`, `jira-mcp` | Task management |

## GitHub MCP Server Toolsets

The built-in GitHub MCP server provides tool groups. Source: [GitHub MCP Server](https://github.com/github/github-mcp-server)

### Default Toolsets (enabled by default)

| Toolset | Capabilities |
|---------|-------------|
| `context` | Context management |
| `repos` | Repository operations |
| `issues` | Issue management |
| `pull_requests` | PR management |
| `users` | User information |

### Additional Toolsets

| Toolset | Capabilities |
|---------|-------------|
| `actions` | GitHub Actions workflows |
| `code_security` | Code scanning |
| `dependabot` | Dependency alerts |
| `discussions` | GitHub Discussions |
| `gists` | Gist management |
| `git` | Git operations |
| `labels` | Label management |
| `notifications` | Notification access |
| `orgs` | Organization management |
| `projects` | GitHub Projects |
| `secret_protection` | Secret scanning |
| `security_advisories` | Security advisories |
| `stargazers` | Star information |

### Remote-Only Toolsets

| Toolset | Capabilities |
|---------|-------------|
| `copilot` | Copilot features |
| `copilot_spaces` | Context organization |
| `github_support_docs_search` | Support docs search |

### Configuration Headers

| Header | Description |
|--------|-------------|
| `X-MCP-Toolsets` | Comma-separated list of toolsets to enable |
| `X-MCP-Tools` | Specific tools to enable |
| `X-MCP-Readonly` | Enable read-only mode |
| `X-MCP-Lockdown` | Limit public repo access |
| `X-MCP-Insiders` | Enable insiders features |

Enable specific toolsets:

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "X-MCP-Toolsets": "repos,issues,users,pull_requests,code_security" }
    }
  }
}
```

## MCP Resources & Prompts

Beyond tools, MCP servers can expose:

- **Resources** — Add via chat context picker: `Add Context > MCP Resources`
- **Prompts** — Use as slash commands: `/mcp.servername.promptname`

## Common Configurations

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
    },
    "cloudflare": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@cloudflare/mcp-server"]
    }
  }
}
```

## Security Checklist

- [ ] **No hardcoded secrets** — Use `${env:VAR}` or `envFile`
- [ ] **Use `password: true`** — For input prompts with secrets
- [ ] **Read-only connections** — For database servers when possible
- [ ] **Docker containers** — For untrusted code execution
- [ ] **Workspace scope** — Place in `.vscode/mcp.json`, not user settings
- [ ] **Review tool permissions** — Before permanent approval
- [ ] **TLS encryption** — Require HTTPS for all remote MCP connections
- [ ] **Token audience binding** — Validate token `aud` claims for HTTP servers
- [ ] **Trust confirmation** — Review trust dialog when starting new servers

## Capacity Limits

| Constraint | Limit | Solution |
|------------|-------|----------|
| Tools per chat request | 128 max | Enable `github.copilot.chat.virtualTools.threshold` to use virtual tools |

<!-- NOT IN OFFICIAL DOCS: <10 servers and <80 active tools recommendations - flagged 2026-01-24 -->

**Note:** The 128 tool limit is due to model constraints. Use virtual tools or tool sets to manage large tool collections.

## Enterprise Policies

Organizations can manage MCP centrally:

```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.discovery.allowOrganizationServers": true,
  "github.copilot.chat.mcp.gallery.serviceUrl": "https://internal-registry.company.com/mcp"
}
```

Audit log event: `copilot.swe_agent_mcp_config_updated`

## Debugging Commands

| Command | Purpose |
|---------|---------|
| `MCP: List Servers` | View all configured servers |
| `MCP: Start Server` | Manually start a server |
| `MCP: Stop Server` | Stop a running server |
| `MCP: Reset Cached Tools` | Clear tool discovery cache |
| `MCP: Reset Trust` | Revoke all server approvals |
| `MCP: Show Output` | View JSON-RPC messages and errors |
| `MCP: Browse Servers` | Open GitHub MCP Server Registry |

Access via Command Palette (`Ctrl+Shift+P`).

## Related Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `chat.mcp.access` | `true` | Enable MCP server access |
| `chat.mcp.discovery.enabled` | `false` | Enable MCP server discovery |
| `chat.mcp.gallery.enabled` | `true` | Enable GitHub MCP Registry |
| `chat.mcp.autostart` | experimental | Auto-restart on config change |

## MCP vs Copilot Extensions

| Aspect | MCP Servers | Copilot Extensions |
|--------|-------------|-------------------|
| **Protocol** | MCP (stdio/http) | GitHub App + HTTP |
| **Scope** | VS Code only | Cross-platform |
| **Invocation** | LLM decides | User @mentions |
| **Config** | `.vscode/mcp.json` | GitHub Marketplace |
| **VS Code APIs** | ❌ No access | Via Chat Participants |
| **Tool control** | LLM orchestrates | Extension controls |

Use MCP for local tools and development workflows. Use Extensions for cross-IDE features.

> **📋 Note:** MCP tools run outside VS Code as separate processes without VS Code API access. This is architecturally accurate (MCP servers are external processes), but not explicitly stated as a security boundary in official documentation. For deep VS Code integration (debugger, file system APIs), use Language Model Tools via extension API.

## One-Click Installation

Create installation URLs for easy MCP server deployment:

```
vscode:mcp/install?{"name":"my-server","command":"npx","args":["-y","my-mcp-server"]}
```

Users clicking this URL will be prompted to install the MCP server.

## Referencing in Agents

Agents can specify which MCP servers they need:

```yaml
---
name: database-analyst
description: Analyze database schemas and queries
mcp-servers:
  - postgres
  - sqlite
tools:
  - postgres/*
  - sqlite/*
---
```

## Related

- [settings-reference](./settings-reference.md) — `chat.mcp.access` and related settings
- [agent-file-format](./agent-file-format.md) — `mcp-servers:` frontmatter field
- [mcp-server-stacks](../REFERENCE/mcp-server-stacks.md) — Curated server combinations
- [permission-levels](../CHECKPOINTS/permission-levels.md) — Tool approval patterns

## Sources

- [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- [VS Code Copilot Extensibility Overview](https://code.visualstudio.com/docs/copilot/copilot-extensibility-overview)
- [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)
- [MCP Documentation](https://modelcontextprotocol.io/docs)
- [MCP Specification](https://modelcontextprotocol.io/specification)
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Official MCP Servers](https://github.com/modelcontextprotocol/servers)
