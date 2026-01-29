---
when:
  - creating new custom agents
  - configuring agent tools and model selection
  - setting up agent handoffs between workflow phases
  - defining agent frontmatter properties
pairs-with:
  - agent-naming
  - file-structure
  - instruction-files
  - handoffs-and-chains
requires:
  - none
complexity: medium
---

# Agent File Format (.agent.md)

Define custom chat modes with specialized tools, instructions, and workflows. Each `.agent.md` file creates a selectable agent in VS Code's Copilot Chat.

## File Location

```
.github/
└── agents/
    ├── researcher.agent.md
    ├── implementer.agent.md
    └── reviewer.agent.md
```

Agents are discovered automatically when placed in `.github/agents/`. VS Code detects any `.md` files in this folder as custom agents.

**Alternative Locations:**
- **User Profile:** Store in your VS Code profile for cross-workspace use (via Command Palette → "Create Custom Agent in Profile")
- **Organization:** Store in `.github-private` repository at `/agents/AGENT-NAME.md` for organization-wide distribution

## Complete Frontmatter Reference

```yaml
---
# Identity (all optional)
name: researcher  # Defaults to filename if omitted
description: "Research and gather context before implementation"

# Tool Access
tools: ["read", "search", "fetch"]  # Specific tools
# tools: ["*"]     # All tools (default if omitted)
# tools: []        # No tools (ask-only mode)
# tools: ["github/*", "playwright/*"]  # MCP server tools (built-in)

# Model Selection (VS Code/IDE only — ignored on GitHub.com)
model: "Claude Sonnet 4"
# Models selected via dropdown/picker in IDE

# User Guidance (VS Code only)
argument-hint: "Describe what you want to research..."

# Subagent Availability
infer: true  # Allow this agent to be used as a subagent (default: true)

# Target Environment
target: vscode  # "vscode" | "github-copilot" | omit for both

# MCP Servers (for target: github-copilot; org/enterprise level only)
mcp-servers:
  github:
    type: http
    url: https://api.githubcopilot.com/mcp/
  filesystem:
    type: local  # "stdio" mapped to "local" for coding agent
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem"]

# Workflow Transitions (VS Code/IDE only)
handoffs:
  - label: Create Plan
    agent: planner
    prompt: Based on this research, create an implementation plan.
    send: false  # false = pre-fill for review, true = auto-submit

  - label: Start Coding
    agent: implementer
    prompt: Implement the approved plan.
    send: true

# Metadata (GitHub only — not supported in VS Code)
metadata:
  team: platform
  version: "1.0"
---
```

**Character Limit:** Prompt body has a **30,000 character maximum**. Source: [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#yaml-frontmatter-properties)

**Platform Notes:**
- `model`, `handoffs`, and `argument-hint` are **IDE-only** — ignored on GitHub.com for compatibility
- `mcp-servers` in agent profiles only supported at **organization/enterprise level**
- Repository-level agents use MCP tools from repository settings

## Agent Instructions (Markdown Body)

The body contains Markdown instructions that define the agent's behavior. You can reference specific tools using the `#tool:<tool-name>` syntax.

```markdown
# Research Agent

You are a research specialist who gathers context before any implementation begins.

Use #tool:codebase to search the codebase and #tool:fetch to retrieve web content.

## Persona
- Thorough and methodical
- Questions assumptions
- Documents findings clearly

## Workflow

1. **Understand the request** — Clarify ambiguous requirements
2. **Explore codebase** — Use search and read tools
3. **Check documentation** — Review README, ARCHITECTURE.md
4. **Summarize findings** — Provide structured context

## Boundaries

- ✅ **Always:** Read existing code before suggesting changes
- ✅ **Always:** Check for similar patterns in codebase
- ⚠️ **Ask first:** Before searching external sources
- 🚫 **Never:** Make code changes (hand off to implementer)

## Output Format

Structure your research as:

### Context
[What you found about the current state]

### Relevant Files
- `path/to/file.ts` — [why it's relevant]

### Recommendations
[Informed suggestions for implementation]
```

## Tool Configuration

| Approach | Configuration | When to Use |
|----------|---------------|-------------|
| All tools | Omit `tools` or `tools: ["*"]` | General-purpose agents |
| Specific tools | `tools: ["read", "edit", "search"]` | Constrained specialists |
| No tools | `tools: []` | Advisory/planning agents |
| MCP tools | `tools: ["github/*"]` | External service access |
| Mixed | `tools: ["read", "github/*"]` | Built-in + MCP tools |

### Tool Aliases

Official tool aliases for common operations. Source: [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases)

| Alias | Description |
|-------|-------------|
| `execute` | Shell/terminal commands |
| `read` | File reading |
| `edit` | File editing |
| `search` | Code search |
| `agent` | Subagent invocation |
| `web` | Web browsing |
| `todo` | Task tracking |

### Built-in Tool Categories

```yaml
# File operations
tools: ["read", "edit", "create"]

# Code intelligence
tools: ["search", "references", "definitions"]

# Terminal access
tools: ["execute", "terminal"]

# Testing
tools: ["runTests"]

# Out-of-box MCP servers
tools: ["github/*", "playwright/*"]

# All MCP servers
tools: ["*/*"]

# Extension-contributed tools
tools: ["azure.some-extension/some-tool"]
```

## Best Practices (from 2,500+ Repositories)

### 1. Put Commands Early

```markdown
## Commands
- `npm run build` — Build the project
- `npm run test` — Run tests
- `npm run lint` — Check code style
```

### 2. Code Examples Over Explanations

```markdown
## Code Style

Use this import pattern:
```typescript
import { useState, useEffect } from 'react';
import type { User } from '@/types';
```

Not:
```typescript
import React from 'react';  // Don't import React namespace
```
```

### 3. Set Clear Boundaries

```markdown
## Boundaries
- ✅ **Always:** Run tests before committing
- ⚠️ **Ask first:** Before modifying shared utilities
- 🚫 **Never:** Commit directly to main
- 🚫 **Never:** Delete migration files
```

### 4. Be Specific About Stack

```markdown
## Tech Stack
- **Frontend:** React 18, TypeScript 5.4, Vite
- **Backend:** Node.js 20, Express, PostgreSQL
- **Testing:** Vitest, React Testing Library
- **Styling:** Tailwind CSS 3.4
```

### 5. Cover Six Core Areas

| Area | What to Include |
|------|-----------------|
| Commands | Build, test, lint, deploy scripts |
| Testing | Test framework, coverage requirements |
| Project Structure | Key directories, file conventions |
| Code Style | Formatting, naming, patterns |
| Git Workflow | Branch naming, commit format, PR process |
| Boundaries | What's allowed, forbidden, requires approval |

## Handoff Configuration

Chain agents together for multi-step workflows:

```yaml
handoffs:
  - label: "📋 Create Plan"
    agent: planner
    prompt: |
      Based on my research findings, create an implementation plan.
      Include: file changes, dependencies, testing approach.
    send: false  # User reviews before sending

  - label: "⚡ Implement"
    agent: implementer
    prompt: Implement the approved plan step by step.
    send: true   # Auto-submit (use with caution)

  - label: "🔍 Review"
    agent: reviewer
    prompt: Review the implementation for issues.
    send: false
```

**Handoff Fields:**

| Field | Required | Description |
|-------|----------|-------------|
| `label` | Yes | Button text shown in chat |
| `agent` | Yes | Target agent filename (without `.agent.md`) |
| `prompt` | No | Context passed to target agent |
| `send` | No | `false` (default) = pre-fill, `true` = auto-submit |

## Complete Example: Three-Agent Workflow

### `.github/agents/researcher.agent.md`

```yaml
---
name: researcher
description: Gather context and analyze requirements
tools: ["read", "search", "fetch"]
model: Claude Sonnet 4
handoffs:
  - label: "📋 Plan Implementation"
    agent: planner
    send: false
---

# Research Agent

Investigate thoroughly before any code changes.

## Process
1. Clarify requirements with questions
2. Search codebase for relevant patterns
3. Review related documentation
4. Summarize findings with file references

## Output
Provide structured research summary with:
- Current state analysis
- Relevant code locations
- Potential approaches
- Risks and considerations
```

### `.github/agents/planner.agent.md`

```yaml
---
name: planner
description: Create detailed implementation plans
tools: ["read", "search"]
model: Claude Opus 4.5
handoffs:
  - label: "⚡ Start Implementation"
    agent: implementer
    send: false
---

# Planning Agent

Convert research into actionable implementation plans.

## Plan Format
1. **Overview** — What we're building
2. **Files to Modify** — With specific changes
3. **New Files** — With purpose
4. **Dependencies** — External packages needed
5. **Testing Strategy** — How to verify
6. **Rollback Plan** — If something goes wrong
```

### `.github/agents/implementer.agent.md`

```yaml
---
name: implementer
description: Execute implementation plans
tools: ["*"]
model: Claude Sonnet 4
---

# Implementation Agent

Execute approved plans with precision.

## Rules
- Follow the plan exactly
- Make atomic commits with clear messages
- Run tests after each change
- Stop and ask if plan is unclear

## Boundaries
- ✅ Implement planned changes
- ✅ Fix test failures
- ⚠️ Ask before deviating from plan
- 🚫 Never skip tests
```

## Related

- [instruction-files](instruction-files.md) — Global and file-specific instructions that agents inherit
- [mcp-servers](mcp-servers.md) — Configure external tools for `mcp-servers` field
- [handoffs-and-chains](../WORKFLOWS/handoffs-and-chains.md) — Detailed workflow patterns
- [settings-reference](settings-reference.md) — VS Code settings that enable agent features
- [permission-levels](../CHECKPOINTS/permission-levels.md) — Tool permission model

## Migration Notes

**Legacy `.chatmode.md` files:** VS Code 1.106 renamed "custom chat modes" to "custom agents". Legacy `.chatmode.md` files are still recognized, and VS Code offers a quick-fix to migrate them to `.agent.md`.

**Organization/Enterprise agents:** Store in `.github-private` repository at `/agents/AGENT-NAME.md` for organization-wide distribution.

## Sources

- [VS Code - Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [GitHub Docs - Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [GitHub Docs - Create Custom Agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [GitHub Blog - How to Write a Great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
- [VS Code - Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools)
- [VS Code - Copilot Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features)
