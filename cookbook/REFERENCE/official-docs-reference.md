# Official VS Code/Copilot Documentation Reference

> **Purpose:** Synthesized knowledge base from official documentation validation. Use as reference for generating and validating agents against authoritative sources.
>
> **Last Updated:** 2026-01-26

---

## Quick Reference: Tier 1 Documentation URLs

| ID | URL | Topics |
|----|-----|--------|
| D1 | https://code.visualstudio.com/docs/copilot/customization/custom-agents | Agent files, frontmatter, model, handoffs |
| D2 | https://code.visualstudio.com/docs/copilot/customization/prompt-files | Prompt files, variables |
| D3 | https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Instruction files, scoping |
| D4 | https://code.visualstudio.com/docs/copilot/customization/mcp-servers | MCP configuration |
| D5 | https://code.visualstudio.com/docs/copilot/chat/chat-tools | Tools, tool sets |
| D6 | https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context | Context management |
| D7 | https://code.visualstudio.com/docs/copilot/chat/chat-sessions | Sessions, subagents |
| D8 | https://docs.github.com/en/copilot/customizing-copilot | GitHub customization |
| D9 | https://modelcontextprotocol.io/docs/learn/architecture | MCP architecture |
| D10 | https://modelcontextprotocol.io/docs/learn/server-concepts | MCP primitives |

---

## Part 1: Configuration Knowledge

### 1.1 Agent File Format (`.agent.md`)

**Location:** `.github/agents/*.agent.md`

#### Confirmed Frontmatter Fields

| Field | Type | Required | Default | Source |
|-------|------|----------|---------|--------|
| `name` | string | No | filename | VS Code docs |
| `description` | string | No | — | VS Code docs |
| `tools` | array | No | all (`["*"]`) | GitHub docs |
| `model` | string | No | auto | VS Code docs |
| `argument-hint` | string | No | — | VS Code docs |
| `infer` | boolean | No | `true` | VS Code docs |
| `target` | string | No | — | VS Code docs |
| `mcp-servers` | array | No | — | GitHub docs (org/enterprise) |
| `handoffs` | array | No | — | VS Code docs |
| `metadata` | object | No | — | GitHub only |

**Key Quotes:**

> "VS Code detects any `.md` files in the `.github/agents` folder of your workspace as custom agents."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

> "The prompt can be a maximum of 30,000 characters."
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)

> "Enable all available tools: Omit the `tools` property entirely or use `tools: ["*"]`"
> — [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)

#### Tool Aliases (Official)

| Alias | Alternatives | Description |
|-------|--------------|-------------|
| `execute` | shell, Bash, powershell | Shell tools |
| `read` | — | File reading |
| `edit` | — | File editing |
| `search` | — | Codebase search |

**⚠️ NOT Official:** `permissions`, `checkpoints`, `escalation` frontmatter fields — community patterns only.

---

### 1.2 Instruction Files

**Locations:**
- `.github/copilot-instructions.md` — Repository-wide
- `.github/instructions/*.instructions.md` — Path-specific
- `AGENTS.md` — Workspace root (all AI agents)
- `CLAUDE.md` / `GEMINI.md` — Alternatives to AGENTS.md

#### Frontmatter Fields

| Field | Type | Required | Purpose |
|-------|------|----------|---------|
| `applyTo` | glob | No | Auto-apply pattern |
| `name` | string | No | Display name |
| `description` | string | No | Purpose description |
| `excludeAgent` | string | No | `"code-review"` or `"coding-agent"` |

**Key Quote:**

> "If you have multiple types of instructions files in your project, VS Code combines and adds them to the chat context, **no specific order is guaranteed**."
> — [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

#### Instruction Precedence (GitHub)

| Priority | Level |
|----------|-------|
| 1 (Highest) | Personal instructions |
| 2 | Path-specific instructions |
| 3 | Repository-wide instructions |
| 4 | Agent file (AGENTS.md) |
| 5 (Lowest) | Organization instructions |

---

### 1.3 Prompt Files (`.prompt.md`)

**Location:** `.github/prompts/*.prompt.md`

#### Frontmatter Fields

| Field | Type | Purpose |
|-------|------|---------|
| `name` | string | Display name |
| `description` | string | Purpose |
| `argument-hint` | string | User input hint |
| `agent` | string | `ask`, `edit`, `agent`, or custom agent name |
| `model` | string | Model selection |
| `tools` | array | Tool list or `["server/*"]` |

**Key Quote:**

> "Tool list priority: 1. Tools specified in the prompt file 2. Tools from the referenced custom agent 3. Default tools for the selected agent"
> — [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

---

### 1.4 Skills Format

**Locations:**
- `.github/skills/*/SKILL.md` — Project (recommended)
- `.claude/skills/` — Legacy
- `~/.copilot/skills/` — Personal

**Limits:**
- `SKILL.md` < 500 lines / 5000 tokens
- `name` 1-64 characters
- `description` 1-1024 characters
- `compatibility` 1-500 characters (optional)

**Status:** Preview — enable with `chat.useAgentSkills` setting.

---

### 1.5 MCP Server Configuration

**Location:** `.vscode/mcp.json`

#### Transport Types

| Type | Configuration |
|------|---------------|
| stdio | `command`, `args`, `env` |
| HTTP/SSE | `url`, `headers` (Bearer auth) |
| Docker | `command: docker`, `args: [run, ...]` |

**Key Quotes:**

> "MCP support in VS Code is generally available starting from VS Code 1.102."
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)

> "A chat request can have a maximum of 128 tools enabled at a time due to model constraints."
> — [VS Code MCP Servers FAQ](https://code.visualstudio.com/docs/copilot/customization/mcp-servers#_faq)

> "Use camelCase for the server name, such as 'uiTesting' or 'githubIntegration'"
> — [VS Code MCP Servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)

---

### 1.6 Critical Settings Reference

#### Agent Settings

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.agent.enabled` | `true` | Enable agent mode |
| `chat.agent.maxRequests` | `25` | Max requests per session |
| `chat.mcp.access` | `true` | Allow MCP tools |
| `chat.customAgentInSubagent.enabled` | `false` | Custom agents as subagents |

#### Tool Approval Settings

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.tools.global.autoApprove` | `false` | Auto-approve all tools |
| `chat.tools.terminal.autoApprove` | Object | Per-command approval |
| `chat.tools.terminal.blockDetectedFileWrites` | `"outsideWorkspace"` | File write protection |
| `chat.tools.terminal.autoApproveWorkspaceNpmScripts` | `true` | Auto-approve npm scripts |
| `chat.tools.edits.autoApprove` | `[]` | Glob patterns for auto-approve |

#### Default Deny List (Terminal)

```json
{
  "rm": false,
  "rmdir": false,
  "del": false,
  "kill": false,
  "curl": false,
  "wget": false,
  "eval": false,
  "chmod": false,
  "chown": false,
  "/^Remove-Item\\b/i": false
}
```

#### Context & Memory Settings

| Setting | Default | Purpose |
|---------|---------|---------|
| `chat.checkpoints.enabled` | `true` | Enable workspace checkpoints |
| `github.copilot.chat.summarizeAgentConversationHistory.enabled` | `true` | Auto-summarize long sessions |
| `github.copilot.chat.anthropic.thinking.budgetTokens` | `4000` | Extended thinking budget |

---

## Part 2: Context Engineering Knowledge

### 2.1 Context Variables & Tools

#### Chat Tools (`#` prefix)

| Tool | Purpose | Source |
|------|---------|--------|
| `#file` | Current file content | GitHub Cheat Sheet |
| `#selection` | Selected text | GitHub Cheat Sheet |
| `#codebase` | Workspace context | VS Code docs |
| `#block`, `#function`, `#class` | Code structures | GitHub Cheat Sheet |
| `#textSearch`, `#fileSearch` | Search tools | VS Code docs |
| `#fetch`, `#githubRepo` | External data | VS Code docs |
| `#problems`, `#testFailure` | Diagnostics | VS Code docs |
| `#terminalLastCommand`, `#terminalSelection` | Terminal context | VS Code docs |
| `#runSubagent` | Subagent delegation | VS Code docs |

#### Tool Sets

| Set | Contains |
|-----|----------|
| `#edit` | File editing tools |
| `#search` | Search tools |
| `#runCommands` | Terminal execution |
| `#runNotebooks` | Jupyter execution |
| `#runTasks` | Task runner |

#### Chat Participants (`@` prefix)

| Participant | Purpose |
|-------------|---------|
| `@workspace` | Codebase questions |
| `@terminal` | Terminal context |
| `@github` | GitHub operations |
| `@vscode` | VS Code questions |
| `@azure` | Azure integration (preview) |

---

### 2.2 Context Limits & Behavior

**Key Quote:**

> "If possible, the full contents of the file will be included when you attach a file. If that is too large to fit into the context window, an outline of the file will be included... If the outline is also too large, then the file won't be part of the prompt."
> — [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

**Limits:**
- Max tools per request: **128**
- Max agent prompt: **30,000 characters**
- Instruction files: **~1000 lines** recommended

**Context Overflow Behavior:**
1. Full file content → 2. Outline (functions without implementations) → 3. Exclude file

---

### 2.3 Subagent Isolation

**Key Quotes:**

> "Subagents don't run asynchronously or in the background, however, they operate autonomously without pausing for user feedback."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

> "Subagents use the same agent and have access to the same tools available to the main chat session, **except for creating other subagents**."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

**Characteristics:**
- Context-isolated (own window)
- Sequential execution (NOT parallel)
- Cannot spawn nested subagents
- `infer: false` prevents subagent usage

---

## Part 3: Workflow Knowledge

### 3.1 Handoffs

**Configuration:**

```yaml
handoffs:
  - label: "Review with Inspector"
    agent: inspector
    prompt: "Review the implementation for {{selection}}"
    send: false  # Default: user reviews before sending
```

| Field | Type | Default | Purpose |
|-------|------|---------|---------|
| `label` | string | Required | Button text |
| `agent` | string | Required | Target agent name |
| `prompt` | string | Optional | Pre-filled prompt |
| `send` | boolean | `false` | Auto-submit prompt |

**Key Quote:**

> "Handoffs enable you to create guided sequential workflows that transition between agents with suggested next steps."
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

---

### 3.2 Session Management

**Native Features:**
- **Session History:** All sessions saved, workspace-scoped
- **Checkpoints:** Snapshot workspace state at key points
- **Export:** `Chat: Export Chat...` → JSON file
- **Save as Prompt:** `/savePrompt` → reusable `.prompt.md`

**Key Quote:**

> "All your chat sessions are saved in the session history, allowing you to return to previous conversations and continue where you left off."
> — [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

---

### 3.3 GitHub Copilot Hooks

**Location:** `.github/hooks/*.json`

| Hook Type | Trigger | Key Use |
|-----------|---------|---------|
| `sessionStart` | Session begins | Initialize logging |
| `sessionEnd` | Session ends | Cleanup, reporting |
| `userPromptSubmitted` | User sends prompt | Validate input |
| `preToolUse` | Before tool execution | **Block dangerous ops** |
| `postToolUse` | After tool execution | Log, validate output |
| `errorOccurred` | Error in session | Alert, recover |

**Blocking Operations (preToolUse):**

```json
{
  "permissionDecision": "deny",
  "permissionDecisionReason": "Blocked: destructive command detected"
}
```

**Key Quote:**

> "preToolUse: Executed before the agent uses any tool. This is the most powerful hook as it can **approve or deny tool executions**."
> — [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

---

## Part 4: Security & Permissions

### 4.1 Trust Boundaries

| Boundary | Scope | User Action |
|----------|-------|-------------|
| Workspace | Project folder | Trust workspace |
| Extension Publisher | Extension source | Install extension |
| MCP Server | External tools | Approve server |
| Network Domain | URLs | Approve URLs |

**Key Quote:**

> "Trust boundaries limit critical operations unless trust is explicitly granted by the user."
> — [VS Code Security](https://code.visualstudio.com/docs/copilot/security)

---

### 4.2 Tool Approval Scopes

| Scope | Persistence | Use Case |
|-------|-------------|----------|
| Single use | This request only | One-time operations |
| Session | Until VS Code closes | Temporary trust |
| Workspace | This project | Project-specific |
| Always | All future | Trusted tools |
| Server/Extension | All tools from source | Bulk trust |

**Commands:**
- `Chat: Reset Tool Confirmations` — Clear all saved approvals
- `Chat: Manage Tool Approval` — Pre-approve or revoke

---

### 4.3 Content Exclusion

| Method | Effect |
|--------|--------|
| `files.exclude` | Excludes from workspace index |
| `.gitignore` | Excludes from workspace index |
| `.copilotignore` | Excludes from Copilot context |

**Caveat:** `.gitignore` bypassed if file is open or text selected.

**Enterprise:** Content exclusion in GitHub Repository Settings (Business/Enterprise plans).

---

## Part 5: Memory & Persistence

### 5.1 GitHub Agentic Memory (Official)

**Status:** Public Preview (Jan 2026)

**Key Characteristics:**
- **Repository-scoped** (not user-scoped)
- **28-day retention** (auto-expires)
- **Citation-validated** (checks against codebase)
- **Cross-agent** (coding agent, code review, CLI)
- **Opt-in** (user-based, not repository)

**NOT yet in VS Code Chat** — currently GitHub.com PRs and CLI only.

**Key Quotes:**

> "Memories are repository scoped, not user scoped, so all memories stored for a repository are available for use in Copilot operations initiated by any user."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

> "Memories are automatically deleted after 28 days to avoid stale information adversely affecting agentic decision making."
> — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

---

### 5.2 Native Session Features

| Feature | Command/Setting | Purpose |
|---------|-----------------|---------|
| Session History | Automatic | Resume conversations |
| Checkpoints | `chat.checkpoints.enabled` | Restore workspace state |
| Export to JSON | `Chat: Export Chat...` | Portable backup |
| Save as Prompt | `/savePrompt` | Reusable template |
| Auto-summarize | `summarizeAgentConversationHistory.enabled` | Fit context window |

---

## Part 6: Community Patterns (Not Official)

These patterns are widely used but **NOT native VS Code features**:

### 6.1 Memory Bank Pattern (Cline)

**Location:** `.github/memory-bank/`

**Files:** projectbrief.md, productContext.md, techContext.md, systemPatterns.md, activeContext.md, progress.md

**Status:** Community pattern — implement via instructions.

---

### 6.2 Tiered Memory (mem0/CrewAI)

**Tiers:** Hot (current session) → Warm (recent) → Cold (archived) → Frozen (immutable)

**Status:** Design pattern — no native support.

---

### 6.3 Utilization Targets (HumanLayer ACE)

| Zone | Utilization | Action |
|------|-------------|--------|
| Optimal | 40-60% | Normal operation |
| Caution | 60-80% | Consider compaction |
| Overloaded | >80% | Trigger compaction |

**Status:** Community guideline — VS Code auto-summarizes but doesn't expose thresholds.

---

### 6.4 Iron Law Pattern (obra/superpowers)

**Concept:** Inviolable rules with Red Flags and Rationalization Prevention.

**Implementation:** Via agent instructions, not native feature.

---

### 6.5 RIPER Modes (CursorRIPER)

**Modes:** Research → Innovate → Plan → Execute → Review

**Status:** Community workflow pattern.

---

### 6.6 TELOS Framework (danielmiessler)

**Files:** 10-file goal system for AI agent purpose capture.

**Status:** External framework — use custom instructions to implement.

---

## Part 7: Validation Summary

### Correction Patterns Found

| Pattern | Count | Example |
|---------|-------|---------|
| Setting name wrong | 5 | `chat.tools.autoApprove` → `chat.tools.global.autoApprove` |
| Default value wrong | 4 | `maxRequests: 50` → `25` |
| Field name wrong | 3 | `mode: agent` → `agent: agent` |
| Tool name wrong | 2 | `terminal` → `execute` |
| Syntax wrong | 4 | `#file:path` → `#filename` |

### Silent Flags (Community Claims)

| Category | Count | Examples |
|----------|-------|----------|
| Frontmatter fields | 3 | `permissions`, `checkpoints`, `escalation` |
| Utilization thresholds | 6 | 40-60% optimal, >80% overloaded |
| Memory patterns | 8 | Memory bank, tiered memory |
| Workflow patterns | 4 | RIPER modes, Iron Law |
| Terminology | 3 | "context rot" → "stale context" |

### Key Conflicts Resolved

| Topic | Resolution |
|-------|------------|
| `chat.tools.autoApprove` vs `chat.tools.global.autoApprove` | Use `chat.tools.global.autoApprove` per VS Code settings reference |
| `#file:path` vs `#filename` | Use `#filename` (simpler syntax) per VS Code docs |
| Subagents parallel vs sequential | Sequential only — confirmed |

---

## Appendix: Sources by Category

### VS Code Official Documentation
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/docs/copilot/customization/agent-skills
- https://code.visualstudio.com/docs/copilot/chat/chat-tools
- https://code.visualstudio.com/docs/copilot/chat/chat-sessions
- https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints
- https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context
- https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide
- https://code.visualstudio.com/docs/copilot/guides/prompt-engineering-guide
- https://code.visualstudio.com/docs/copilot/reference/copilot-settings
- https://code.visualstudio.com/docs/copilot/security

### GitHub Official Documentation
- https://docs.github.com/en/copilot/customizing-copilot
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/concepts/agents/copilot-memory
- https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks
- https://docs.github.com/en/copilot/reference/hooks-configuration

### MCP Specification
- https://modelcontextprotocol.io/docs/learn/architecture
- https://modelcontextprotocol.io/docs/learn/server-concepts
- https://modelcontextprotocol.io/specification/2025-11-25

### Community Sources (For Context Only)
- HumanLayer 12-Factor Agents: https://github.com/humanlayer/12-factor-agents
- Cline Memory Bank: https://github.com/cline/cline
- obra/superpowers: https://github.com/obra/superpowers
- CursorRIPER: https://github.com/CursorRIPER/CursorRIPER.sigma
- danielmiessler/Telos: https://github.com/danielmiessler/Telos
