---
when:
  - configuring MCP servers for specific workflows
  - setting up development environment
  - choosing server combinations for project type
  - adding tool capabilities to agents
pairs-with:
  - mcp-servers
  - settings-reference
  - workflow-orchestration
requires:
  - mcp-tools
complexity: medium
---

# MCP Server Stacks

Curated MCP server combinations for common development workflows.

> **Platform Note:** MCP (Model Context Protocol) support reached General Availability in VS Code 1.102. Server configurations are stored in `.vscode/mcp.json` for project-level or user settings for global access. See [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/customization/mcp-servers).

---

## Stack Selection Guide

Choose your stack based on workflow type:

| Workflow | Recommended Stack | Tools Added |
|----------|-------------------|-------------|
| **Code Review** | GitHub + Git + Filesystem | PR analysis, diff review |
| **Bug Investigation** | Datadog + Postgres + Filesystem | Error tracking, log analysis |
| **Documentation** | Brave Search + Fetch + Memory + Context7 | Research, knowledge persistence |
| **Testing** | Playwright + Puppeteer + Browserbase | Browser automation, E2E |
| **Database Work** | Postgres + MongoDB + DuckDB | Schema exploration, queries |
| **Infrastructure** | Kubernetes + AWS + Terraform | Cluster management, IaC |
| **API Integration** | Fetch + OpenAPI + GraphQL | API exploration, requests |
| **Content Creation** | Notion + Obsidian + Google Docs | Document management |

---

## Full-Stack Development

```json
{
  "servers": {
    "github": {
      "type": "http",
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
      "env": {
        "DATABASE_URL": "${env:DATABASE_URL}"
      }
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    }
  }
}
```

---

## Research & Documentation

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
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

---

## DevOps & Infrastructure

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
      "args": ["-y", "@cloudflare/mcp-server"],
      "env": {
        "CLOUDFLARE_API_TOKEN": "${env:CLOUDFLARE_API_TOKEN}"
      }
    },
    "terraform": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-terraform"]
    }
  }
}
```

---

## Database Work

```json
{
  "servers": {
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "${env:POSTGRES_URL}"
      }
    },
    "mongodb": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mongodb-mcp"],
      "env": {
        "MONGODB_URI": "${env:MONGODB_URI}"
      }
    }
  }
}
```

> **Note:** The official `@modelcontextprotocol/server-sqlite` has been archived. For SQLite support, use community alternatives from [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers).

---

## Testing & Browser Automation

```json
{
  "servers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    },
    "puppeteer": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-puppeteer"]
    },
    "browserbase": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-browserbase"],
      "env": {
        "BROWSERBASE_API_KEY": "${env:BROWSERBASE_API_KEY}"
      }
    }
  }
}
```

---

## Minimal Stack (Single Lookup)

For simple tasks needing minimal tools:

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

---

## Stack Sizing by Complexity

Match stack size to task complexity:

| Complexity | Tools | Example Stack |
|------------|-------|---------------|
| **Simple** | 0-1 | None or filesystem only |
| **Moderate** | 2-5 | Filesystem + GitHub + Postgres |
| **Complex** | 6-15 | Full-stack development |
| **Research** | 2-20 | Brave + Fetch + Memory + specialized |

**Guidelines:**
<!-- NOT IN OFFICIAL DOCS: 10 server limit - flagged 2026-01-26 -->
- Keep under 10 MCP servers active per project for optimal performance (community guideline, not official)
- **Maximum 128 tools** per chat request (model constraint)
- Enable `github.copilot.chat.virtualTools.threshold` to use virtual tools when approaching limits
<!-- NOT IN OFFICIAL DOCS: 80 tools guideline - flagged 2026-01-26 -->
- Use under 80 tools simultaneously for best context efficiency (community guideline, not official)

---

## Popular Server Sources

| Server | Package | Purpose |
|--------|---------|---------|
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | File read/write |
| **GitHub** | Remote HTTP server (requires config) | GitHub API access |
| **Git** | `mcp-server-git` (uvx) | Repository operations |
| **Postgres** | `@modelcontextprotocol/server-postgres` | Database queries |
| **Brave Search** | `@modelcontextprotocol/server-brave-search` | Web search |
| **Fetch** | `@modelcontextprotocol/server-fetch` | HTTP requests |
| **Memory** | `@modelcontextprotocol/server-memory` | Knowledge graph persistence |
| **Playwright** | `@playwright/mcp` | Browser automation |
| **Puppeteer** | `@anthropic/mcp-puppeteer` | Browser control |
| **Context7** | `@context7/mcp-server` | Library documentation |
| **Sequential Thinking** | `@modelcontextprotocol/server-sequential-thinking` | Dynamic problem-solving |

**Server Discovery:**
- **GitHub MCP Registry**: Search `@mcp` in VS Code Extensions view
- **Full catalog**: [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) (79k+ stars, 50+ categories)

> **Archived Servers:** (As of May 2025) `@modelcontextprotocol/server-sqlite`, `@modelcontextprotocol/server-slack`, `@modelcontextprotocol/server-sentry` have been archived. See [servers-archived](https://github.com/modelcontextprotocol/servers-archived) for historical reference. **Alternatives:** Slack is now maintained by [Zencoder](https://github.com/zencoderai/slack-mcp-server). For full catalog, see [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers).

---

## Configuration Location

Save as `.vscode/mcp.json` for project-specific servers:

```
your-project/
├── .vscode/
│   └── mcp.json      # Project-specific servers
└── ...
```

**Additional Options:**
- **Dev Containers**: Configure in `devcontainer.json` via `customizations.vscode.mcp` section
- **Settings Sync**: MCP configurations can sync across devices via Settings Sync
- **Auto-discovery**: Enable `chat.mcp.discovery.enabled` to detect configs from other apps (like Claude Desktop)
- **Auto-start**: Enable `chat.mcp.autoStart` (Experimental) to start servers automatically on config changes

For transport types, env vars, and security patterns, see [mcp-servers.md](../CONFIGURATION/mcp-servers.md).

---

## Agent-Specific Stacks

Scope servers to specific agents via frontmatter:

```yaml
---
name: "database-agent"
mcp-servers:
  - postgres
  - mongodb
tools:
  - "postgres/*"
  - "mongodb/*"
---
```

See [agent-file-format.md](../CONFIGURATION/agent-file-format.md) for full frontmatter reference.

---

## Related

- [mcp-servers.md](../CONFIGURATION/mcp-servers.md) — Transport patterns, env vars, security
- [settings-reference.md](../CONFIGURATION/settings-reference.md) — `chat.mcp.*` settings
- [agent-file-format.md](../CONFIGURATION/agent-file-format.md) — Agent-level MCP scoping
- [conditional-routing.md](../WORKFLOWS/conditional-routing.md) — Complexity-based tool selection
- [permission-levels.md](../CHECKPOINTS/permission-levels.md) — Tool approval model

---

## Sources

- [VS Code MCP Servers Documentation](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- [VS Code MCP Developer Guide](https://code.visualstudio.com/docs/copilot/guides/mcp-developer-guide)
- [VS Code Variables Reference](https://code.visualstudio.com/docs/reference/variables-reference)
- [GitHub MCP Server Registry](https://github.com/mcp/io.github.github/github-mcp-server)
- [Model Context Protocol Docs](https://modelcontextprotocol.io/docs)
- [Official MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [Archived MCP Servers](https://github.com/modelcontextprotocol/servers-archived)
- [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)
- [prompts-mcp-repositories-patterns.md](../../research/prompts-mcp-repositories-patterns.md)

*Validated: 2026-01-26 (Official Docs)*
