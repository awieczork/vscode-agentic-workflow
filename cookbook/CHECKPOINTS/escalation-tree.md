---
when:
  - designing agent decision flows for errors and blockers
  - implementing retry logic with escalation
  - defining when agents should stop vs continue
  - setting up phase transition checkpoints
pairs-with:
  - approval-gates
  - destructive-ops
  - handoffs-and-chains
  - verification-gates
requires:
  - none
complexity: medium
---

# Escalation Tree

Decision flow for when to stop, ask, retry, or escalate to a different agent.

> **Platform Note**: This file synthesizes escalation patterns from multiple sources. GitHub Copilot Hooks (`preToolUse`, `postToolUse`, `errorOccurred`) are documented for the [Coding Agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks). The decision flowchart, severity mapping, and retry patterns are community-derived design patterns. VS Code checkpoints (`chat.checkpoints.enabled`) are for file state restoration, not workflow phase transitions. For agent delegation, use native `handoffs` in custom agents.

> **Implementation Note**: These patterns can be implemented via GitHub Copilot [Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) (`preToolUse`, `postToolUse`, `errorOccurred`) or through prompt engineering in agent instructions. VS Code also provides 3 additional hooks: `sessionStart`, `sessionEnd`, `userPromptSubmitted`.

---

## The Decision Flowchart

```
Agent encounters decision point
        │
        ▼
┌─────────────────────────────────────┐
│ Is DESTRUCTIVE OPERATION?           │
└─────────────────────────────────────┘
        │
        ├── YES → [STOP AND ASK USER]
        │
        ▼
┌─────────────────────────────────────┐
│ Is PHASE TRANSITION?                │
└─────────────────────────────────────┘
        │
        ├── YES → [CHECKPOINT: SUMMARIZE & CONFIRM]
        │
        ▼
┌─────────────────────────────────────┐
│ Is agent UNCERTAIN?                 │
└─────────────────────────────────────┘
        │
        ├── YES → [ASK FOR CLARIFICATION]
        │         │
        │         └── User defers → [ESCALATE TO DIFFERENT AGENT]
        │
        ▼
┌─────────────────────────────────────┐
│ Is P1 SAFETY CONSTRAINT violated?   │
└─────────────────────────────────────┘
        │
        ├── YES → [STOP AND REFUSE]
        │
        ▼
┌─────────────────────────────────────┐
│ Has ERROR occurred?                 │
└─────────────────────────────────────┘
        │
        ├── YES → [EVALUATE ERROR TYPE]
        │         │
        │         ├── Recoverable → Auto-retry (max 2)
        │         │                 │
        │         │                 └── Still failing → [STOP AND REPORT]
        │         │
        │         └── Non-recoverable → [STOP AND REPORT]
        │                               │
        │                               └── User requests help → [ESCALATE TO DEBUG AGENT]
        │
        └── NO → [CONTINUE EXECUTION]
```

---

## Escalation Triggers

| Trigger | Condition | Action |
|---------|-----------|--------|
| **Destructive Op** | Matches [destructive operation](destructive-ops.md) | Stop + Ask User |
| **Phase Transition** | Moving between workflow phases | Checkpoint + Confirm |
| **Uncertainty** | Agent lacks confidence to proceed | Ask for Clarification |
| **P1 Violation** | Safety constraint would be violated | Stop + Refuse |
| **Recoverable Error** | Transient failure (network, timeout) | Retry up to 2× |
| **Non-recoverable Error** | Logic error, missing resource | Stop + Report |
| **Iteration Limit** | 3 revision cycles without progress | Escalate to Human |
| **Red Flag Detected** | Stop condition observed | Immediate Halt |
| **Context Degradation** | "Summarized conversation history" appears | Session split recommended |

---

## Discovery Priority Escalation

When issues are discovered during work, classify by blocking impact:

| Priority | Name | Description | Action |
|----------|------|-------------|--------|
| **P0** | Blocker | Blocks ALL work (security vulnerability, data loss risk) | Stop immediately, escalate |
| **P1** | Blocking | Blocks current track (missing dependency, broken contract) | Stop this track, file issue |
| **P2** | High | Should address soon (tech debt, performance concern) | Continue, flag for review |
| **P3** | Medium | Nice to have (improvement opportunity) | File for later |
| **P4** | Low | Future consideration (idea, exploration) | Document only |

**Rule**: Continue execution unless P0/P1 (blocking) discovery. Based on [steveyegge/beads](https://github.com/steveyegge/beads) discovery protocol.

---

## Stop Conditions (Red Flags)

<!-- NOT IN OFFICIAL DOCS: "Red Flags" terminology - community pattern from obra/superpowers. VS Code native: chat.tools.terminal.autoApprove setting - flagged 2026-01-26 -->
When any of these occur, **STOP immediately**:

```markdown
- Attempting to modify files outside project scope
- Accessing credential files (*.env, *.pem, *.key)
- Running unreviewed network commands
- Deleting files without explicit approval
- Bypassing verification gates
- Agent expresses uncertainty but continues anyway
- Task complexity exceeds agent capabilities
- User explicitly says "stop" or "wait"
```

> **VS Code Native**: Use `chat.tools.terminal.autoApprove` setting to block dangerous terminal commands (`rm`, `rmdir`, `del`, `kill`, `curl`, `wget`, `eval`, `chmod`, `chown`).

### Mode-Specific Forbidden Actions

From [RIPER Framework](../WORKFLOWS/riper-modes.md) — each mode has explicit restrictions:

| Mode | Forbidden Actions |
|------|-------------------|
| **Research** | Modify files, suggest implementations, make changes |
| **Innovate** | Write actual code, modify files, make final decisions |
| **Plan** | Implement code, modify files, skip steps |
| **Execute** | Deviate from plan without approval, add unplanned features, skip verification |
| **Review** | Make code changes, modify files |

---

## Retry Rules

<!-- NOT IN OFFICIAL DOCS: Retry configuration with exponential backoff - community design pattern, not native VS Code Copilot feature - flagged 2026-01-26 -->
### Auto-Retry (Recoverable Errors)

```yaml
recoverable_errors:
  - network_timeout
  - rate_limit_exceeded
  - transient_api_failure
  - file_locked

retry_config:
  max_attempts: 2
  backoff: exponential
  initial_delay_ms: 1000
```

### Escalation After Retry Failure

```
Attempt 1 → Fail → Wait 1s
Attempt 2 → Fail → Wait 2s
Attempt 3 → Fail → STOP AND REPORT
```

---

## Iteration Limits

| Operation | Max Iterations | On Limit Exceeded |
|-----------|----------------|-------------------|
| Code revision cycles | 3 | Escalate to human review |
| Gate retries | 2 | Stop and report |
| Clarification requests | 2 | Proceed with best guess + flag |
| Tool call retries | 3 | Try alternative tool |
| Tool invocations per request | 25 (default) | Adjust via `chat.agent.maxRequests` |

<!-- NOT IN OFFICIAL DOCS: 3 revision cycles limit - community pattern from obra/superpowers - flagged 2026-01-26 -->
**Rule**: After 3 revision cycles without passing verification, escalate to human.

### VS Code Setting

```json
{
  "chat.agent.maxRequests": 100  // Increase for complex workflows (default: 25)
}
```

---

## Escalation Paths

### To User (Default)

```markdown
## ⚠️ Escalation Required

**Trigger**: {what triggered escalation}
**Context**: {relevant state}
**Options**:
1. {Option A}
2. {Option B}
3. Skip this step

What would you like me to do?
```

### To Different Agent

<!-- NOT IN OFFICIAL DOCS: escalation: field with fallback_agent - proposed design pattern. Native VS Code: use handoffs field - flagged 2026-01-26 -->
> **VS Code Native**: Use `handoffs` in custom agents for agent transitions:
> ```yaml
> handoffs:
>   - label: "Debug this error"
>     agent: debugging-agent
>     prompt: "Analyze the error and suggest fixes"
> ```

Proposed pattern (not native):

```yaml
escalation:
  on_failure:
    retry_limit: 2
    action: escalate_to_different_agent
    fallback_agent: debugging-agent
```

### Fallback Agent Routing

| Situation | Escalate To |
|-----------|-------------|
| Build failures | `build-debugger` agent |
| Test failures | `test-analyzer` agent |
| Architecture questions | `architect` agent |
| Security concerns | `security-reviewer` agent |
| Unknown errors | User (no agent fallback) |

---

## Severity-to-Action Mapping

<!-- NOT IN OFFICIAL DOCS: Severity-to-action mapping - cookbook design pattern from obra/superpowers, not native VS Code feature - flagged 2026-01-26 -->
From red-team critique integration — map finding severity to escalation action:

| Severity | Escalation Action | Human Involvement |
|----------|-------------------|-------------------|
| **None/Pass** | Continue workflow | No |
| **Low** | Log, continue | Batch review weekly |
| **Medium** | Flag, continue with warning | Review within 24h |
| **High** | **Pause, require approval** | Synchronous approval |
| **Critical** | **Halt completely** | Immediate escalation |

See [iron-law-discipline.md](../PATTERNS/iron-law-discipline.md) for severity definitions.

---

## Phase Transition Checkpoints

<!-- NOT IN OFFICIAL DOCS: checkpoints: YAML field - proposed design pattern. VS Code checkpoints (chat.checkpoints.enabled) are for file state restoration. Use handoffs for workflow transitions - flagged 2026-01-26 -->
Require confirmation when moving between workflow phases:

> **VS Code Native Alternative**: Use `handoffs` in custom agents to create guided workflows between agents. See [custom agents docs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs).

```yaml
checkpoints:
  - trigger: phase_transition
    from: planning
    to: implementation
    action: require_approval

  - trigger: phase_transition
    from: implementation
    to: deployment
    action: require_approval
```

### Checkpoint Summary Format

```markdown
## Checkpoint: {from} → {to}

### Completed in {from} phase:
- {accomplishment 1}
- {accomplishment 2}

### Ready for {to} phase:
- {next step 1}
- {next step 2}

### Risks/Concerns:
- {any issues to flag}

Proceed to {to} phase? [Yes/No]
```

---

## Agent File Configuration

<!-- NOT IN OFFICIAL DOCS: checkpoints:, escalation:, confidence_threshold, fallback_agent fields - proposed design pattern, NOT in official .agent.md schema - flagged 2026-01-26 -->
> **Platform Note**: The YAML schema below is a **proposed design pattern**, not official VS Code syntax. Official `.agent.md` frontmatter supports: `name`, `description`, `tools`, `model`, `infer`, `target`, `mcp-servers`, `handoffs`. For agent delegation, use the official `handoffs` field instead of `escalation:`.

Complete escalation config for `.agent.md` (proposed pattern):

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

escalation:
  on_failure:
    retry_limit: 2
    action: escalate_to_different_agent
    fallback_agent: debugging-agent

  on_uncertainty:
    confidence_threshold: 0.7
    action: ask_user

  iteration_limits:
    revision_cycles: 3
    gate_retries: 2
---
```

---

## Error Type Classification

| Error Type | Recoverable | Action |
|------------|-------------|--------|
| `network_timeout` | ✅ Yes | Retry with backoff |
| `rate_limit` | ✅ Yes | Wait and retry |
| `file_not_found` | ❌ No | Stop, report missing resource |
| `permission_denied` | ❌ No | Stop, report access issue |
| `syntax_error` | ❌ No | Stop, report with line number |
| `test_failure` | ⚠️ Partial | Retry once, then escalate |
| `build_failure` | ⚠️ Partial | Escalate to build-debugger |

### Session End Reasons (GitHub Hooks)

GitHub Copilot Hooks provide these official [session end reasons](https://docs.github.com/en/copilot/reference/hooks-configuration#session-end-hook):

| Reason | Description |
|--------|-------------|
| `complete` | Session completed successfully |
| `error` | Session ended due to an error |
| `abort` | Session was aborted by user or system |
| `timeout` | Session timed out (default: 30 seconds for hooks) |
| `user_exit` | User explicitly ended the session |

### Error Handling Modes

<!-- NOT IN OFFICIAL DOCS: Error handling modes (terminated, continue-on-error, etc.) - Dify platform feature, NOT VS Code Copilot - flagged 2026-01-26 -->
> **External Platform**: These modes are from [Dify workflow patterns](https://docs.dify.ai/en/guides/workflow), not native VS Code Copilot features.

| Mode | Behavior |
|------|----------|
| `terminated` | Stop immediately (default) |
| `continue-on-error` | Skip failed items, return null |
| `remove-abnormal-output` | Filter out failed items |

### Workflow Status Progression

<!-- NOT IN OFFICIAL DOCS: Workflow status states - Dify platform concept, VS Code uses session states - flagged 2026-01-26 -->
> **External Platform**: These states are from Dify workflows, not VS Code Copilot sessions.

```
RUNNING → SUCCEEDED | FAILED | STOPPED | PARTIAL_SUCCEEDED
```

- `PARTIAL_SUCCEEDED` — Some nodes failed but workflow continued

---

## Related

- [permission-levels.md](permission-levels.md) — 4-level approval model
- [destructive-ops.md](destructive-ops.md) — Operation detection categories
- [approval-gates.md](approval-gates.md) — Checkpoint configuration
- [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) — Agent-to-agent transitions
- [iron-law-discipline.md](../PATTERNS/iron-law-discipline.md) — Red Flags stop conditions
- [verification-gates.md](../PATTERNS/verification-gates.md) — Gate pass/fail → escalation
- [riper-modes.md](../WORKFLOWS/riper-modes.md) — Mode-specific forbidden actions
- [task-tracking.md](../WORKFLOWS/task-tracking.md) — Discovery priority (P0-P4) system

---

## Sources

- [phase2-critical-gaps-research.md](../../research/phase2-critical-gaps-research.md) — Primary escalation decision tree source
- [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — 6 hook types: `sessionStart`, `sessionEnd`, `userPromptSubmitted`, `preToolUse`, `postToolUse`, `errorOccurred`
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs) — Official `handoffs` field for agent transitions
- [VS Code Copilot Settings](https://code.visualstudio.com/docs/copilot/reference/copilot-settings#_agent-settings) — `chat.agent.maxRequests`, `chat.tools.terminal.autoApprove`
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — File state restoration checkpoints
- [Claude Code Permissions](https://code.claude.com/docs/en/iam) — Permission precedence (deny→ask→allow)
- [steveyegge/beads](https://github.com/steveyegge/beads) — Discovery protocol (P0-P4)
- [Dify Workflow Error Handling](https://docs.dify.ai/en/guides/workflow) — Error handling modes (external platform)
- [Azure Responsible AI](https://learn.microsoft.com/en-us/azure/well-architected/ai/responsible-ai) — HITL checkpoint patterns
