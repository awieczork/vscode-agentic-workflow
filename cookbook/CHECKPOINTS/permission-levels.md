---
when:
  - configuring which actions need human approval
  - setting up auto-approve rules for safe commands
  - implementing tiered permission models
  - defining trust boundaries for agents
pairs-with:
  - approval-gates
  - destructive-ops
  - settings-reference
  - escalation-tree
requires:
  - terminal-access
complexity: medium
---

# Permission Levels

Tiered approval model for agent actions — from auto-approve to always-deny.

> **Platform Note:** VS Code uses a **tool approval system** with session/workspace/user scopes rather than numbered "permission levels." The 4-level model below is a **design pattern** synthesized from community frameworks (Claude Code, obra/superpowers, 12-Factor Agents). VS Code's native mechanism uses `chat.tools.terminal.autoApprove` settings with true/false values and interactive approval dialogs.

---

## The 4-Level Model

<!-- NOT IN OFFICIAL DOCS: "Level 0-3" terminology is a cookbook design pattern, not official VS Code naming - flagged 2026-01-26 -->
All major frameworks converge on this tiered approach:

| Level | Name | Behavior | Use For |
|-------|------|----------|---------|
| **0** | Always Deny | Block unconditionally | `rm -rf`, credential access |
| **1** | Always Ask | Require approval each time | File edits, git commits |
| **2** | Ask Once | Approve pattern once per session | Package installs |
| **3** | Auto-Approve | Execute without prompting | Safe read operations |

**Evaluation order**: Deny → Ask → Allow

Deny rules always take precedence, then ask rules, then allow rules.

---

## VS Code Implementation

### settings.json Configuration

```json
{
  // Object format: command → true (auto-approve) or false (always deny)
  "chat.tools.terminal.autoApprove": {
    "npm run build": true,
    "npm run test": true,
    "npm run lint": true,
    "git status": true,
    "git diff": true,
    "/^git log/": true,          // Regex patterns wrapped in /
    "rm -rf": false              // Explicitly deny dangerous commands
  },

  // Auto-approve npm scripts defined in workspace package.json
  "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true,

  // Master toggle for terminal auto-approval (ORG controllable)
  "chat.tools.terminal.enableAutoApprove": true,

  // Global auto-approve (⚠️ disables critical security protections)
  "chat.tools.global.autoApprove": false,

  // Prevent specific tools from auto-approval (experimental)
  "chat.tools.eligibleForAutoApproval": {
    "terminalCommand": true,
    "editFile": false            // Always ask for file edits
  },

  // Ignore default auto-approve rules for full control (experimental)
  "chat.tools.terminal.ignoreDefaultAutoApproveRules": false,

  // Require approval for terminal file writes outside workspace (experimental)
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",

  // URL request/response auto-approval
  "chat.tools.urls.autoApprove": {
    "*.example.com": { "approveRequest": true, "approveResponse": true }
  },

  // Prevent commands from appearing in shell history
  "chat.tools.terminal.preventShellHistory": false,

  "files.exclude": {
    "**/.env": true,
    "**/secrets/**": true,
    "**/*.pem": true
  }
}
```

**VS Code 1.108+ Default Auto-Approve Rules:** `git ls-files`, `git --no-pager <safe_subcommand>`, `git -C <dir> <safe_subcommand>`, `rg` (ripgrep, excluding `--pre` and `--hostname-bin`), `sed` (excluding some args), `Out-String`, and npm/pnpm/yarn scripts from workspace `package.json`.

**Default Deny List:** `rm`, `rmdir`, `del`, `kill`, `curl`, `wget`, `eval`, `chmod`, `chown`, `/^Remove-Item\b/i`

> **Tip:** Use **Chat: Reset Tool Confirmations** command to clear all saved tool approvals.

### Approval Persistence Scopes

| Scope | Stored In | Persists |
|-------|-----------|----------|
| **Single Use** | Memory | One-time only |
| **Session** | Memory | Until VS Code restart |
| **Workspace** | `.vscode/settings.json` | Project-specific |
| **User** | User settings | All workspaces (all future invocations) |

Source: [VS Code Tool Approval](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_tool-approval)

### Trust Boundaries

VS Code defines multiple trust boundaries for security:

| Boundary | What It Protects |
|----------|------------------|
| **Workspace** | Requires Workspace Trust before agents can run |
| **Extension Publisher** | Extensions must be trusted before execution |
| **MCP Server** | MCP servers prompt for trust on first use |
| **Network Domain** | URL requests require domain approval |

Source: [VS Code Security Model](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries)

### Mapping to Claude Code Model

| Claude Code | VS Code Equivalent |
|-------------|-------------------|
| `allow` rules | `chat.tools.terminal.autoApprove` object (value: `true`) |
| `deny` rules | `chat.tools.terminal.autoApprove` object (value: `false`), `files.exclude`, MCP tool filtering |
| `ask` rules | Default behavior (user confirms) |
| Tool restrictions | `.agent.md` `tools:` frontmatter |

---

## Default Risk Categories

Use these categories to assign permission levels:

| Category | Operations | Risk | Default Level |
|----------|-----------|------|---------------|
| **File Deletion** | `rm`, `rmdir`, `del`, `unlink` | 🔴 HIGH | 1 - Always Ask |
| **Network/External** | `curl`, `wget`, `fetch` | 🔴 HIGH | 1 - Always Ask |
| **Code Execution** | `eval`, `exec`, `chmod +x` | 🔴 HIGH | 0 - Always Deny |
| **Git Destructive** | `git push --force`, `git reset --hard` | 🔴 HIGH | 1 - Always Ask |
| **Config Changes** | `.env`, `*.config.*` | 🔴 HIGH | 1 - Always Ask |
| **Package Install** | `npm install`, `pip install` | 🟡 MEDIUM | 2 - Ask Once |
| **Safe Commands** | `ls`, `cat`, `grep`, `git status` | ✅ SAFE | 3 - Auto-Approve |

---

## Agent File Configuration

> **Platform Note:** The `permissions:` frontmatter field with `mode/allow/deny/ask` structure shown below is **Claude Code syntax**, not VS Code. VS Code `.agent.md` files use `tools:` frontmatter to control available tools. This section is included for teams using Claude Code or implementing similar patterns in custom tooling.

<!-- NOT IN OFFICIAL DOCS: permissions: frontmatter field is Claude Code syntax, not VS Code Copilot - flagged 2026-01-26 -->
Specify permissions in `.agent.md` frontmatter (Claude Code format):

```yaml
---
name: "build-agent"
permissions:
  mode: default  # default | acceptEdits | plan | bypassPermissions

  allow:
    - Read
    - Grep
    - Bash(npm test:*)
    - Bash(git status)

  deny:
    - Bash(rm:*)
    - Bash(curl:*)
    - Write(*.env)

  ask:
    - Edit
    - Write
    - Bash(git commit:*)
---
```

### Permission Modes

<!-- NOT IN OFFICIAL DOCS: Permission modes (default, acceptEdits, plan, bypassPermissions) are Claude Code settings, not VS Code - flagged 2026-01-26 -->

| Mode | Behavior | Platform |
|------|----------|----------|
| `default` | Normal — ask for edits, deny risky ops | Claude Code |
| `acceptEdits` | Auto-accept file edits (use with trusted agents) | Claude Code |
| `plan` | Generate plan only, no execution | VS Code (via Plan agent) |
| `bypassPermissions` | Full autonomy (⚠️ use with caution) | Claude Code |

> **VS Code:** Use the built-in **Plan** agent or enable **Planning mode** checkbox for plan-only behavior. See [VS Code Planning Mode](https://code.visualstudio.com/docs/copilot/chat/chat-planning).

---

## Pattern-Based Rules

> **Platform Note:** The `Bash()`, `Read`, `Write`, `Grep`, `Edit` pattern syntax below is **Claude Code format**. VS Code uses `chat.tools.terminal.autoApprove` with command patterns and regex. This section is included for Claude Code users or teams implementing similar patterns.

<!-- NOT IN OFFICIAL DOCS: Pattern syntax (Bash(), Read, Write, Grep, Edit) is Claude Code format, not VS Code - flagged 2026-01-26 -->
Use wildcards for flexible rules (Claude Code syntax):

```yaml
# Allow all npm run commands
allow:
  - Bash(npm run:*)

# Deny any rm command
deny:
  - Bash(rm:*)

# Ask for any git write operation
ask:
  - Bash(git commit:*)
  - Bash(git push:*)
```

### Common Safe Patterns

```yaml
allow:
  # Read operations
  - Read
  - Grep
  - Bash(cat:*)
  - Bash(ls:*)
  - Bash(head:*)
  - Bash(tail:*)

  # Git read
  - Bash(git status)
  - Bash(git diff:*)
  - Bash(git log:*)

  # Build/test
  - Bash(npm test:*)
  - Bash(npm run lint:*)
  - Bash(npm run build:*)
```

### Common Deny Patterns

```yaml
deny:
  # Destructive file operations
  - Bash(rm:*)
  - Bash(rmdir:*)
  - Write(*.env)
  - Write(*.pem)
  - Write(*secret*)

  # Network operations
  - Bash(curl:*)
  - Bash(wget:*)

  # Dangerous git
  - Bash(git push --force:*)
  - Bash(git reset --hard:*)

  # Code execution
  - Bash(eval:*)
  - Bash(exec:*)
```

### VS Code Equivalent Patterns

For VS Code, use `chat.tools.terminal.autoApprove` in settings.json:

```json
{
  "chat.tools.terminal.autoApprove": {
    // Safe read operations
    "cat": true,
    "ls": true,
    "head": true,
    "tail": true,
    "/^git (status|diff|log|ls-files)\\b/": true,

    // Build/test (or use autoApproveWorkspaceNpmScripts)
    "/^npm (run test|run lint|run build)/": true,

    // Explicitly deny dangerous commands
    "rm": false,
    "rmdir": false,
    "del": false,
    "curl": false,
    "wget": false,
    "eval": false,
    "/^git (push --force|reset --hard)/": false
  }
}
```

Source: [VS Code Terminal Auto-Approve](https://code.visualstudio.com/docs/copilot/chat/chat-tools#_automatically-approve-terminal-commands)

---

## RIPER Mode Integration

Permission levels map to [RIPER modes](../WORKFLOWS/riper-modes.md):

| Mode | Permission Stance |
|------|-------------------|
| **RESEARCH** | Read-only — deny all writes |
| **INNOVATE** | Brainstorm only — deny all execution |
| **PLAN** | Document only — deny implementation |
| **EXECUTE** | Allow specified changes only |
| **REVIEW** | Read-only — deny modifications |

---

## Code-Level Protection Markers

Use inline markers to communicate protection levels to agents (from [CursorRIPER.sigma](https://github.com/johnpeterman72/CursorRIPER.sigma)):

| Level | Marker | Behavior |
|-------|--------|----------|
| **PROTECTED** | `!cp` | Do not modify under any circumstances |
| **GUARDED** | `!cg` | Ask before modifying |
| **INFO** | `!ci` | Context note for understanding |
| **DEBUG** | `!cd` | Debugging code (can be removed) |
| **CRITICAL** | `!cc` | Business logic (extra caution) |

```python
# !cp - PROTECTED: Core authentication logic
def verify_token(token: str) -> bool:
    ...

# !cg - GUARDED: Rate limiting config
RATE_LIMIT = 100  # requests per minute
```

---

## Escalation Decision Tree

When permission level triggers action:

```
START: Agent encounters decision point
    │
    ├── Is DESTRUCTIVE OPERATION? → YES → [STOP AND ASK USER]
    │
    ├── Is PHASE TRANSITION? → YES → [CHECKPOINT: SUMMARIZE & CONFIRM]
    │
    ├── Is agent UNCERTAIN? → YES → [ASK FOR CLARIFICATION]
    │   └── User defers → [ESCALATE TO DIFFERENT AGENT]
    │
    ├── Has ERROR occurred? → YES → [EVALUATE ERROR TYPE]
    │   ├── Recoverable → Auto-retry (max 2) → Still failing → [STOP AND REPORT]
    │   └── Non-recoverable → [STOP AND REPORT]
    │       └── User requests help → [ESCALATE TO DEBUGGING AGENT]
    │
    └── NO → [CONTINUE EXECUTION]
```

**Quick Reference:**
| Trigger | Action |
|---------|--------|
| Level 0 (Deny) | Block + Log attempt |
| Level 1 (Ask) | Stop + Show approval dialog |
| Level 2 (Once) | Ask first time → remember for session |
| Level 3 (Auto) | Execute silently |

For detailed escalation flow, see [escalation-tree.md](escalation-tree.md).

---

## Related

- [destructive-ops.md](destructive-ops.md) — Detection categories for risky operations
- [escalation-tree.md](escalation-tree.md) — Decision flow after permission denial
- [approval-gates.md](approval-gates.md) — Checkpoint configuration in agent files
- [riper-modes.md](../WORKFLOWS/riper-modes.md) — Mode-based permission boundaries
- [twelve-factor-agents.md](../PATTERNS/twelve-factor-agents.md) — Factor #7: Human-in-the-loop

---

## Sources

### Official Documentation
- [VS Code Chat Tools Documentation](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Tool approval and auto-approve settings
- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — All agent-related settings
- [VS Code Copilot Security](https://code.visualstudio.com/docs/copilot/security) — Trust boundaries and permission management
- [VS Code 1.108 Release Notes](https://code.visualstudio.com/updates/v1_108) — Auto-approve defaults and new settings
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Agent file format (tools: frontmatter)

### Community Frameworks
- [Claude Code Settings](https://code.claude.com/docs/en/settings) — Permission syntax and modes (allow/deny/ask)
