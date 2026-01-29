---
when:
  - defining which terminal commands require approval
  - setting up deny rules for dangerous operations
  - configuring file deletion safeguards
  - implementing security boundaries for agents
pairs-with:
  - approval-gates
  - permission-levels
  - escalation-tree
  - settings-reference
requires:
  - terminal-access
complexity: medium
---

# Destructive Operations Detection

Identify and handle risky operations before they cause damage.

---

## Detection Categories

| Category | Operations | Risk | Default Action |
|----------|-----------|------|----------------|
| **File Deletion** | `rm`, `rmdir`, `del`, `unlink`, `shred` | 🔴 HIGH | Always Ask |
| **Network/External** | `curl`, `wget`, `fetch`, `nc`, `ssh` | 🔴 HIGH | Always Ask |
| **Code Execution** | `eval`, `exec`, `chmod +x`, `source` | 🔴 HIGH | Always Deny |
| **Git Destructive** | `git push --force`, `git reset --hard`, `git clean -fd` | 🔴 HIGH | Always Ask |
| **Config Changes** | `.env`, `*.config.*`, `*.json`, `*.yaml` | 🔴 HIGH | Always Ask |
| **Credential Access** | `*.pem`, `*.key`, `*secret*`, `*password*` | 🔴 HIGH | Always Deny |
| **Package Install** | `npm install`, `pip install`, `brew install` | 🟡 MEDIUM | Ask Once |
| **Database Ops** | `DROP`, `TRUNCATE`, `DELETE FROM` | 🔴 HIGH | Always Ask |

---

## Permission Levels

Four-tier model adopted across frameworks (Claude Code, Cursor, Warp, GitHub Copilot):

| Level | Name | Behavior | Example |
|-------|------|----------|----------|
| 0 | **Always Deny** | Block unconditionally | `rm -rf`, credential access |
| 1 | **Always Ask** | Require explicit approval each time | `git push --force`, file deletion |
| 2 | **Ask Once** | Approve pattern once per session | `npm install`, package operations |
| 3 | **Auto-Approve** | Execute without prompting | `ls`, `cat`, `git status` |

**Evaluation order:** Deny → Ask → Allow (deny rules take precedence).

---

## Command Pattern Detection

### File System Destructive

```bash
# HIGH RISK — Always require approval
rm -rf *
rm -r directory/
rmdir --ignore-fail-on-non-empty
find . -delete
shred -u sensitive.txt
```

### Git Destructive

```bash
# HIGH RISK — History rewriting
git push --force
git push -f origin main
git reset --hard HEAD~5
git clean -fd
git rebase -i  # Can rewrite history
git branch -D  # Force delete branch
```

### Network Operations

```bash
# HIGH RISK — External communication
curl -X POST https://api.example.com
wget https://unknown-source.com/script.sh
nc -l 8080  # Open listener
ssh remote@server "command"
```

### Code Execution

```bash
# CRITICAL — Never auto-approve
eval "$user_input"
exec some_binary
bash -c "untrusted_command"
chmod +x downloaded_script.sh && ./downloaded_script.sh
source unknown_script.sh
```

---

## Deny Rules Configuration

> **Platform Note:** The `Bash(pattern:*)` syntax below is **Claude Code-specific**. VS Code uses different mechanisms — see [VS Code Settings](#vs-code-settings) and [PreToolUse Hooks](#pretooluse-hooks).

### Claude Code Permission Syntax

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run:*)",
      "Bash(git commit:*)",
      "Read(./src/**)"
    ],
    "ask": [
      "Bash(git push:*)"
    ],
    "deny": [
      "WebFetch",
      "Read(./.env)",
      "Read(./secrets/**)"
    ]
  }
}
```

### Pattern Syntax Reference

| Pattern | Matches |
|---------|----------|
| `Bash` | All Bash commands |
| `Bash(npm run build)` | Exact command |
| `Bash(npm run:*)` | Prefix match with word boundary |
| `Bash(git * main)` | Glob pattern |
| `Read(./.env)` | Specific file |
| `Read(./secrets/**)` | Directory with glob |
| `WebFetch(domain:example.com)` | Domain-specific fetch |

*Source: [Claude Code Docs](https://code.claude.com/docs/en/settings)*

---

## VS Code Settings

### Terminal Auto-Approval (VS Code 1.108+)

`chat.tools.terminal.autoApprove` is an **object** with pattern-based rules:

```json
{
  "chat.tools.terminal.enableAutoApprove": true,
  
  "chat.tools.terminal.autoApprove": {
    // Commands denied by default (override with true to allow)
    "rm": false,
    "rmdir": false,
    "del": false,
    "kill": false,
    "curl": false,
    "wget": false,
    "eval": false,
    "chmod": false,
    "chown": false,
    "/^Remove-Item\\b/i": false,
    
    // Safe commands to auto-approve
    "ls": true,
    "cat": true,
    "grep": true,
    "git status": true,
    "git diff": true,
    "npm test": true,
    "npm run lint": true
  },
  
  // Block file writes outside workspace
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  
    // Auto-approve npm/pnpm/yarn scripts from package.json (VS Code 1.108+)
    "chat.tools.terminal.autoApproveWorkspaceNpmScripts": true,
    
    // Ignore default blocked commands to define your own rules
    "chat.tools.terminal.ignoreDefaultAutoApproveRules": false,
    
    // Prevent agent commands from appearing in shell history
    "chat.tools.terminal.preventShellHistory": true
}
```

**Pattern rules:**
- `true` = auto-approve
- `false` = require approval
- Regex: `/^pattern/flags` (e.g., `/^Remove-Item\b/i`)

### File Exclusion

```json
{
  "files.exclude": {
    "**/.env": true,
    "**/.env.*": true,
    "**/secrets/**": true,
    "**/*.pem": true,
    "**/*.key": true
  }
}
```

> **Note:** `files.exclude` **excludes files from the workspace index**, preventing agent codebase search from finding them. However, `.gitignore` exclusions are bypassed if a file is open or has text selected. Terminal commands can still access any file with system permissions.

*Source: [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context)*

### Additional Security Settings

| Setting | Purpose | Default |
|---------|---------|---------|
| `chat.tools.edits.autoApprove` | File patterns requiring edit confirmation | Sensitive files blocked |
| `chat.tools.global.autoApprove` | ⚠️ **Dangerous** — Auto-approve ALL tools | `false` |
| `chat.tools.eligibleForAutoApproval` | Control which tools can be auto-approved (Org-managed) | All eligible |
| `chat.tools.terminal.ignoreDefaultAutoApproveRules` | Disable default rules to define custom ones | `false` |

> **Warning:** `chat.tools.global.autoApprove` disables critical security protections. Never enable in production environments.

*Source: [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings)*

---

## PreToolUse Hooks

GitHub Copilot coding agent supports hooks for pre-tool validation:

> **Note:** Hooks are stored at `.github/hooks/*.json` (any filename, not just `hooks.json`). Hooks can also be defined at `~/.github/hooks/*.json` for user-level configuration.

```json
// .github/hooks/security-hooks.json
{
  "version": 1,
  "hooks": {
    "preToolUse": [{
      "type": "command",
      "bash": "./scripts/security-check.sh",
      "powershell": "./scripts/security-check.ps1",
      "timeoutSec": 15
    }],
    "postToolUse": [{
      "type": "command",
      "bash": "echo \"$(date): Tool executed\" >> logs/agent-activity.log"
    }]
  }
}
```

### Available Hook Types

| Hook | Trigger | Use Case |
|------|---------|----------|
| `preToolUse` | Before any tool (bash, edit, view) | Approve/deny tool executions |
| `postToolUse` | After tool completes | Logging, cleanup |
| `sessionStart` | Agent session begins | Initialize resources |
| `sessionEnd` | Agent session ends | Cleanup, reporting |
| `userPromptSubmitted` | User sends a prompt | Logging, filtering |
| `errorOccurred` | Tool encounters error | Error handling, alerts |

*Source: [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)*

### Hook Output Format

> **Note:** Blocking is done via JSON output, not exit codes.

| Output | Meaning |
|--------|---------|
| Exit `0` + no JSON | Success, continue execution |
| Exit `0` + `{"permissionDecision":"deny"}` | Block action, show reason to agent |
| Exit `1` | Script error (non-blocking) |

**JSON output fields:**
- `permissionDecision`: `"allow"`, `"deny"`, or `"ask"` (only `"deny"` currently processed)
- `permissionDecisionReason`: Human-readable explanation for blocking

### Example: Security Check Script

```bash
#!/bin/bash
# security-check.sh

COMMAND="$1"

# Check for destructive patterns
if [[ "$COMMAND" =~ rm\ -rf|git\ push\ --force|DROP\ TABLE ]]; then
  # Block via JSON output (not exit code)
  echo '{"permissionDecision":"deny","permissionDecisionReason":"Destructive operation detected"}'
  exit 0
fi

exit 0  # Allow
```

*Source: [GitHub Hooks Docs](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)*

---

## Detection Response Flow

```
Agent generates command
        │
        ▼
┌───────────────────────┐
│ Match against patterns │
└───────────────────────┘
        │
        ├── Matches DENY pattern → BLOCK + Log attempt
        │
        ├── Matches ASK pattern → STOP + Show approval dialog
        │   │
        │   ├── User approves → Execute with logging
        │   │
        │   └── User denies → Abort + Suggest alternative
        │
        └── Matches ALLOW pattern → Execute
```

---

## Contextual Risk Assessment

Same command, different risk levels:

| Command | Context | Risk | Action |
|---------|---------|------|--------|
| `rm -rf node_modules` | Clean rebuild | 🟡 MEDIUM | Ask Once |
| `rm -rf /` | Any context | 🔴 CRITICAL | Always Deny |
| `rm -rf .git` | Any context | 🔴 HIGH | Always Ask |
| `rm test.txt` | Known test file | ✅ LOW | Auto-approve |

### Pattern: Safe Deletion Wrappers

**Claude Code syntax:**

```yaml
# Allow specific cleanup commands
allow:
  - Bash(rm -rf node_modules)
  - Bash(rm -rf dist)
  - Bash(rm -rf build)
  - Bash(rm -rf .cache)
  - Bash(rm -rf __pycache__)

# But deny general recursive delete
deny:
  - Bash(rm -rf:*)
```

**VS Code equivalent:**

```json
{
  "chat.tools.terminal.autoApprove": {
    "rm -rf node_modules": true,
    "rm -rf dist": true,
    "rm -rf build": true,
    "rm": false  // Deny general rm
  }
}
```

---

## Red Flags Checklist

Before any destructive operation, verify:

- [ ] **Reversibility** — Can this be undone? Is there a backup?
- [ ] **Scope** — Is the target specific or broad (`*`, `-r`)?
- [ ] **Context** — Does this make sense for the current task?
- [ ] **Confirmation** — Has user explicitly approved this operation?
- [ ] **Alternatives** — Is there a safer way to achieve the goal?

---

## Safe Alternatives

| Destructive | Safer Alternative |
|-------------|-------------------|
| `rm -rf directory/` | `mv directory/ .trash/` then verify |
| `git push --force` | `git push --force-with-lease` |
| `git reset --hard` | `git stash` then `git reset` |
| `DROP TABLE` | `RENAME TABLE x TO x_backup` |
| Direct `.env` edit | Edit `.env.example`, copy manually |

---

## Related

- [permission-levels.md](permission-levels.md) — 4-level approval model
- [escalation-tree.md](escalation-tree.md) — Decision flow after detection
- [approval-gates.md](approval-gates.md) — Agent file checkpoint configuration
- [iron-law-discipline.md](../PATTERNS/iron-law-discipline.md) — Red Flags stop conditions
- [constraint-hierarchy.md](../PATTERNS/constraint-hierarchy.md) — P1 Safety always wins

---

## Sources

**Official Docs:**
- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/copilot-settings) — Terminal auto-approve configuration
- [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — PreToolUse validation
- [Claude Code Settings](https://code.claude.com/docs/en/settings) — Permission syntax (allow/ask/deny)

**Research:**
- [phase2-critical-gaps-research.md](../../research/phase2-critical-gaps-research.md) — Permission levels, detection categories
- [claude-code-ecosystem-patterns.md](../../research/claude-code-ecosystem-patterns.md) — Permission syntax, hooks
