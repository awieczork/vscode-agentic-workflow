---
when:
  - configuring human-in-the-loop review points
  - setting up approval workflows for risky operations
  - implementing phase transitions requiring user confirmation
pairs-with:
  - destructive-ops
  - escalation-tree
  - permission-levels
  - settings-reference
requires:
  - none
complexity: medium
---

# Approval Gates

Define checkpoints that pause agent execution for human review.

> ⚠️ **Platform Note:** The `checkpoints:` and `escalation:` schema documented below is a **proposed design pattern** synthesized from research across Claude Code, Cursor, and Dify. **It is NOT natively supported in VS Code/GitHub Copilot `.agent.md` files** as of January 2026. Native VS Code approval works through settings and interactive dialogs — see [Native VS Code Approval](#native-vs-code-approval) section.

---

## Native VS Code Approval

VS Code's actual approval mechanisms work through settings, not agent frontmatter:

### Settings-Based Approval

```json
{
  // Auto-approve all tool invocations (DANGEROUS - disables critical security protections)
  "chat.tools.global.autoApprove": false,
  
  // Auto-approve specific terminal commands (object format, not array)
  // Commands map to true (auto-approve) or false (require approval)
  // Regex patterns wrapped in / characters
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "git status": true,
    "git diff": true,
    "rm": false,
    "rmdir": false,
    "del": false,
    "/^git (status|show\\b.*)$/": true
  },
  
  // Block terminal commands that write files outside workspace (experimental)
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  
  // Control which files require edit approval (glob patterns)
  "chat.tools.edits.autoApprove": {
    "**/.env*": false,
    "**/secrets/**": false
  },
  
  // URL request/response auto-approval patterns
  "chat.tools.urls.autoApprove": {
    "github.com": true
  }
}
```

### Interactive Confirmation Dialogs

When a tool invocation requires approval, VS Code shows a dialog with the tool details and an **Allow** dropdown with these options:

| Option | Scope | Behavior |
|--------|-------|----------|
| **Single use** | Once | Approve this one invocation only |
| **Allow in this session** | Session | Approve for current session only |
| **Allow in this workspace** | Workspace | Save to `.vscode/settings.json` |
| **Always allow** | User | Save to user settings globally |
| **Trust all tools for server/extension** | Extension | Approve all tools from this MCP server or extension (v1.106+) |

> **Tip:** Use `Chat: Reset Tool Confirmations` command to clear all saved approvals.
> Use `Chat: Manage Tool Approval` command to manage pre/post-approval settings.

### Native Chat Checkpoints

VS Code provides native checkpoint functionality for reverting workspace state (not to be confused with agent `checkpoints:` frontmatter, which doesn't exist):

```json
{
  // Enable checkpoint feature (default: true since v1.103)
  "chat.checkpoints.enabled": true,
  
  // Show file changes summary at each checkpoint
  "chat.checkpoints.showFileChanges": true
}
```

When enabled, VS Code automatically creates checkpoints during agent sessions. Use the **Restore Checkpoint** action to revert the workspace to a previous state, undoing all file changes made after that checkpoint.

> **Source:** [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

### Handoffs for Sequential Review

Use `handoffs:` to create human review points between workflow phases:

```yaml
---
name: "planner-agent"
handoffs:
  - label: "Review Plan"
    agent: implementation-agent
    prompt: "Review this plan before implementing."
    send: false  # Pre-fill only, user must approve
---
```

The `send: false` option pre-fills the prompt but requires user to manually submit — creating a review checkpoint.

---

## Proposed Checkpoint Schema

> The following schema is a **design pattern** synthesized from research. Implement via agent instructions and workflow conventions.

Add `checkpoints:` to your agent file frontmatter:

```yaml
---
name: "implementation-agent"

checkpoints:
  - trigger: phase_transition
    from: planning
    to: implementation
    action: require_approval

  - trigger: operation_type
    operations: [file_delete, config_change]
    action: always_ask

  - trigger: confidence_threshold
    threshold: 0.7
    action: ask_user

  - trigger: error_count
    max_errors: 2
    action: escalate
---
```

---

## Trigger Types (Proposed)

| Trigger | When Fires | Configuration |
|---------|------------|---------------|
| `phase_transition` | Moving between workflow phases | `from:`, `to:` fields |
| `operation_type` | Specific operation detected | `operations:` list |
| `confidence_threshold` | Agent uncertainty below level | `threshold:` (0.0-1.0) |
| `error_count` | Errors exceed limit | `max_errors:` count |
| `time_elapsed` | Task running too long | `max_minutes:` limit |
| `file_pattern` | Touching sensitive files | `patterns:` glob list |

---

## Actions (Proposed)

| Action | Behavior |
|--------|----------|
| `require_approval` | Stop and wait for explicit user approval |
| `always_ask` | Ask user every time this trigger fires |
| `ask_once` | Ask first time, remember for session |
| `notify` | Show notification but don't block |
| `escalate` | Escalate to different agent or user |
| `log_only` | Record in log, continue execution |

---

## Phase Transition Gates (Instruction-Based)

Since native checkpoint triggers don't exist, implement via agent instructions:

```markdown
## Phase Transition Rules

### Before Implementation
When transitioning from planning to implementation:
1. STOP and present the plan summary
2. Wait for explicit user approval
3. Only proceed after "approved" or "go ahead"

### Before Deployment  
When implementation is complete:
1. STOP and summarize all changes made
2. List affected files
3. Request review before any deployment commands
```

### Workflow Phase Mapping

| Workflow | Phases | Typical Gates |
|----------|--------|---------------|
| **RIPER** | Research → Innovate → Plan → Execute → Review | Gate before Execute |
| **Spec-Driven** | Spec → Plan → Tasks → Implement | Gate before Implement |
| **FIC** | Research → Plan → Implement (fresh context each) | Gate between each |

---

## Operation-Based Gates (Instruction-Based)

Implement via agent instructions and VS Code settings:

### Via Settings (Recommended)

```json
{
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "git status": true,
    "git diff": true,
    "rm": false,
    "rmdir": false
  }
}
```

Commands mapped to `false` always require approval. Commands not listed follow default behavior. Regex patterns can be used by wrapping in `/` characters (e.g., `/^git (status|show\b.*)$/`).

### Via Agent Instructions

```markdown
## Destructive Operations

### Before ANY of these, STOP and ask:
- File deletion (`rm`, `del`, `unlink`)
- Config file changes (`.env`, `*.config.*`)
- Git destructive commands (`git push --force`, `git reset --hard`)
- Package installation (`npm install`, `pip install`)

### Auto-approve (safe commands):
- File reading (`cat`, `type`, `grep`)
- Git read commands (`git status`, `git diff`, `git log`)
- Test execution (`npm test`, `pytest`)
```

### Operation Types Reference

| Type | Includes |
|------|----------|
| `file_delete` | rm, rmdir, unlink |
| `file_create` | touch, mkdir, new file |
| `file_modify` | edit, write, append |
| `config_change` | *.env, *.config.*, settings |
| `git_destructive` | force push, reset --hard |
| `git_write` | commit, push, branch create |
| `network_access` | curl, wget, fetch |
| `package_install` | npm install, pip install |
| `database_modify` | DROP, TRUNCATE, DELETE |

---

## File Pattern Gates (Instruction-Based)

Protect sensitive files via agent instructions:

```markdown
## Protected Files

Before modifying ANY of these, STOP and confirm:
- Environment files: `.env`, `.env.*`
- Secrets: `**/secrets/**`, `**/*.pem`, `**/*.key`
- Production configs: `**/config/production.*`
- CI/CD: `.github/workflows/**`

If user asks to modify these, confirm the specific change before proceeding.
```

Additionally, use VS Code's `files.exclude` to hide sensitive files from workspace search:

```json
{
  "files.exclude": {
    "**/.env*": true,
    "**/secrets/**": true
  }
}
```

---

## Confidence-Based Gates (Instruction-Based)

Train agents to recognize uncertainty via instructions:

```markdown
## When to Ask for Clarification

If ANY of these apply, STOP and ask the user:
- Multiple valid interpretations of the request
- Ambiguous or conflicting requirements  
- Working in unfamiliar domain/technology
- Information in codebase conflicts with request
- Missing critical context to proceed safely

### Template:
"I'm not confident about this approach because [reason]. 
Option A: [describe]
Option B: [describe]
Which direction should I take?"
```

> **Tip:** Anthropic research shows explicitly giving agents "permission to say I don't know" drastically reduces hallucinations.

---

## Error-Based Escalation (Instruction-Based)

Handle repeated failures via instructions:

```markdown
## Error Handling Protocol

### On first error:
1. Analyze the error message
2. Attempt ONE alternative approach
3. If that fails, STOP and report

### On second failure of same operation:
1. STOP immediately
2. Summarize what was attempted
3. Present the error details
4. Ask: "Should I try a different approach, or would you like to handle this?"

### Never:
- Retry the same failing command more than twice
- Ignore errors and continue
- Make assumptions about error causes without evidence
```

---

## Checkpoint Summary Format

When a gate fires, present this summary to user:

```markdown
## ⏸️ Checkpoint: {trigger description}

### What I've Done
- {completed action 1}
- {completed action 2}

### What I Want To Do
- {proposed action requiring approval}

### Why I'm Asking
{explanation of trigger — e.g., "This modifies production config"}

### Risks
- {potential risk 1}
- {potential risk 2}

**Options:**
1. ✅ Approve and continue
2. 🔄 Modify approach (describe changes)
3. ❌ Cancel this operation
```

---

## Complete Agent Example

Combining native VS Code settings with instruction-based checkpoints:

### VS Code Settings (`settings.json`)

```json
{
  "chat.tools.global.autoApprove": false,
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "git status": true,
    "git diff": true,
    "rm": false,
    "rmdir": false,
    "del": false
  },
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  "chat.tools.edits.autoApprove": {
    "**/.env*": false,
    "**/config/production.*": false
  },
  "chat.checkpoints.enabled": true,
  "chat.checkpoints.showFileChanges": true
}
```

### Agent File with Checkpoint Instructions

```yaml
---
name: "secure-implementation-agent"
description: "Implements features with human review checkpoints"
tools:
  - read
  - edit
  - search
  - runTerminal
handoffs:
  - label: "Review Implementation"
    agent: review-agent
    prompt: "Review these changes before merging."
    send: false
---

## Approval Checkpoints

### Phase Transitions
- Before implementing: Present plan, wait for approval
- Before any git push: Summarize commits, wait for approval

### Destructive Operations  
Before ANY of these, STOP and confirm:
- File deletion
- Config file changes
- Force pushes

### Uncertainty Protocol
If unsure about approach, present options and ask.

### Error Handling
Max 2 retries. After that, stop and report.
```

---

## When to Use Gates

| Situation | Gate Type | Rationale |
|-----------|-----------|-----------|
| Sensitive files | `file_pattern` | Prevent accidental exposure |
| Destructive ops | `operation_type` | Avoid irreversible damage |
| Major milestones | `phase_transition` | Ensure alignment before large work |
| New/uncertain domain | `confidence_threshold` | Human expertise needed |
| Repeated failures | `error_count` | Avoid thrashing |

---

## Related

- [permission-levels.md](permission-levels.md) — 4-level approval model
- [destructive-ops.md](destructive-ops.md) — Operation detection categories
- [escalation-tree.md](escalation-tree.md) — Decision flow after gate triggers
- [agent-file-format.md](../CONFIGURATION/agent-file-format.md) — Full frontmatter reference
- [verification-gates.md](../PATTERNS/verification-gates.md) — Evidence-based gates

---

## Sources

**Native VS Code/GitHub:**
- [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Tool approval settings and dialogs
- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings) — `chat.tools.global.autoApprove`, `chat.tools.terminal.autoApprove` (object format)
- [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) — `files.exclude` effect on indexing
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Native checkpoint/restore functionality
- [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_permission-management) — Permission model: session/workspace/user scopes
- [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) — Handoffs with `send: false`
- [Review Code Edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits) — `chat.tools.edits.autoApprove` for sensitive files
- [VS Code v1.106 Updates](https://code.visualstudio.com/updates/v1_106) — "Trust all tools for server/extension" feature

**Design Pattern Sources:**
- [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) — Human-in-the-loop as tool (Factor 7)
- [Claude Code Permissions](https://platform.claude.com/docs/en/agent-sdk/permissions) — Allow/ask/deny model
- [Dify Workflow Patterns](https://docs.dify.ai/en/guides/workflow) — Pause model for HITL
- [phase2-critical-gaps-research.md](../../research/phase2-critical-gaps-research.md) — Escalation tree, permission levels
- [Human-in-the-Loop Best Practices](https://www.permit.io/blog/human-in-the-loop-for-ai-agents-best-practices) — Checkpoint patterns
