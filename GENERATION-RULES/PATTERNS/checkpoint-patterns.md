---
type: patterns
version: 1.0.0
purpose: Human-in-the-loop checkpoint patterns for agent safety gates
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# Checkpoint Patterns

> **Human-in-the-loop gates that pause agent execution for approval at critical decision points**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Parse DECISION RULES to determine when checkpoints fire
2. Use STRUCTURE section for checkpoint summary format
3. Apply PERMISSION LEVELS when configuring tool access

**For Build Agents:**
1. Reference AUTHORING RULES when implementing checkpoint logic in agent instructions
2. Use DETECTION CATEGORIES to configure `chat.tools.terminal.autoApprove`
3. Follow CHECKPOINT SUMMARY FORMAT for approval prompts

**For Inspect Agents:**
1. Validate checkpoints against VALIDATION CHECKLIST
2. Verify HARD GATES vs SOFT GUIDANCE distinction is clear
3. Check that permission levels map to VS Code settings correctly

---

## PURPOSE

**Problem:** Agents execute with system-level permissions. Without gates:
- Irreversible damage (file deletion, history corruption)
- Credential exposure
- Unintended scope creep

**Solution:** Pattern-based interception at critical decision points with tiered response.

**Goal:** NOT to block all actions, but to ensure **human awareness before irreversibility**.

---

## HARD GATES vs SOFT GUIDANCE

> ⚠️ **CRITICAL DISTINCTION** — Misunderstanding this creates false security

| Type | Mechanism | Enforcement | Guarantee |
|------|-----------|-------------|-----------|
| **HARD GATES** | VS Code settings, hooks | Platform-enforced | Agent CANNOT bypass |
| **SOFT GUIDANCE** | Agent instructions | Agent compliance | Agent CHOOSES to follow |

### Hard Gates (Enforceable)

```json
{
  "chat.tools.terminal.autoApprove": { "rm": false },
  "chat.tools.edits.autoApprove": { "**/.env*": false },
  "chat.checkpoints.enabled": true
}
```

These are enforced by VS Code. Agents cannot bypass them regardless of instructions or prompt injection.

### Soft Guidance (Best-Effort)

```markdown
## Phase Transition Rules
When transitioning from planning to implementation:
1. STOP and present the plan summary
2. Wait for explicit user approval
```

These depend on agent compliance. They reduce risk but do NOT guarantee safety.

**Rule:** HARD GATES protect P1 (Safety). SOFT GUIDANCE handles P2-P4 workflows.

---

## THE FRAMEWORK APPROACH

Checkpoints are implemented through THREE mechanisms:

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. SETTINGS — Hard gates via chat.tools.* configuration        │
│    • chat.tools.terminal.autoApprove (command patterns)        │
│    • chat.tools.edits.autoApprove (file patterns)              │
│    • chat.checkpoints.enabled (state restoration)              │
├─────────────────────────────────────────────────────────────────┤
│ 2. INSTRUCTIONS — Soft guidance in agent body                  │
│    • Phase transition rules                                     │
│    • Uncertainty protocols                                      │
│    • Error handling limits                                      │
├─────────────────────────────────────────────────────────────────┤
│ 3. HANDOFFS — Review points between agents                     │
│    • handoffs: send: false (pre-fill without auto-submit)      │
│    • Only native workflow gate mechanism                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## STRUCTURE

### Required Checkpoint Elements

| Element | Purpose | Hard/Soft |
|---------|---------|-----------|
| Permission levels (0-3) | Tiered approval model | Hard (settings) |
| Detection categories | Pattern-based op classification | Hard (settings) |
| Escalation decision tree | When to stop/ask/retry/continue | Soft (instructions) |
| Checkpoint summary format | Consistent approval prompts | Soft (instructions) |
| Iteration limits | Max retries before escalation | Soft (instructions) |

### Checkpoint Summary Format

When a gate fires, agents MUST present this structure:

```markdown
## ⏸️ Checkpoint: {trigger description}

### What I've Done
- {completed action 1}
- {completed action 2}

### What I Want To Do
- {proposed action requiring approval}

### Why I'm Asking
{trigger explanation — e.g., "This modifies production config"}

### Risks
- {potential risk 1}
- {potential risk 2}

**Options:**
1. ✅ Approve and continue
2. 🔄 Modify approach (describe changes)
3. ❌ Cancel this operation
```

---

## DECISION RULES (Machine-Parseable)

### Primary Evaluation Flow

```
EVALUATE checkpoint_trigger:
  IF matches_destructive_pattern
    THEN → HARD GATE: Require approval via settings
  ELSE IF phase_transition
    THEN → SOFT GATE: Present summary, wait for "approved"
  ELSE IF agent_uncertain
    THEN → SOFT GATE: Ask clarification before proceeding
  ELSE IF p1_safety_violated
    THEN → HARD STOP: Refuse (no override possible)
  ELSE IF error_occurred
    THEN → EVALUATE error_type:
      IF recoverable THEN retry (max 2)
      ELSE → STOP + report
  ELSE
    THEN → CONTINUE execution
```

### Permission Level Selection

```
SELECT permission_level:
  IF credential_access OR code_execution
    THEN → LEVEL 0 (Always Deny)
  ELSE IF file_deletion OR git_destructive OR network OR config_change
    THEN → LEVEL 1 (Always Ask)
  ELSE IF package_install
    THEN → LEVEL 2 (Ask Once per session)
  ELSE IF safe_read_operation
    THEN → LEVEL 3 (Auto-Approve)
  ELSE
    THEN → DEFAULT to LEVEL 1
```

### Criteria Definitions

| Criterion | True When |
|-----------|----------|
| `matches_destructive_pattern` | Command matches detection category pattern |
| `phase_transition` | Moving between workflow phases (plan→implement) |
| `agent_uncertain` | Multiple valid interpretations, missing context |
| `p1_safety_violated` | Would compromise credentials, system integrity |
| `error_occurred` | Tool returns non-zero exit, exception thrown |
| `recoverable` | Network timeout, rate limit, file locked |

---

## PERMISSION LEVELS

### The 4-Level Model

| Level | Name | Behavior | VS Code Implementation |
|-------|------|----------|------------------------|
| **0** | Always Deny | Block unconditionally | `"command": false` in autoApprove |
| **1** | Always Ask | Require approval each time | Command not in autoApprove list |
| **2** | Ask Once | Approve once per session | User selects "Allow in this session" |
| **3** | Auto-Approve | Execute without prompting | `"command": true` in autoApprove |

**Evaluation precedence:** Deny → Ask → Allow (deny rules ALWAYS win)

### VS Code Settings Configuration

```json
{
  "chat.tools.global.autoApprove": false,
  
  "chat.tools.terminal.autoApprove": {
    // Level 3: Auto-approve safe operations
    "npm test": true,
    "npm run lint": true,
    "git status": true,
    "git diff": true,
    "/^git (log|show|ls-files)\\b/": true,
    
    // Level 0/1: Require approval (explicit false)
    "rm": false,
    "rmdir": false,
    "del": false,
    "curl": false,
    "wget": false,
    "eval": false,
    "/^git (push --force|reset --hard)/": false,
    
    // Safe deletion allowlist (Level 3 for specific patterns)
    "rm -rf node_modules": true,
    "rm -rf dist": true,
    "rm -rf build": true
  },
  
  "chat.tools.edits.autoApprove": {
    "**/.env*": false,
    "**/secrets/**": false,
    "**/config/production.*": false
  },
  
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  "chat.checkpoints.enabled": true
}
```

### Approval Persistence Scopes

| Scope | Storage | Persists | Use For |
|-------|---------|----------|---------|
| **Single Use** | Memory | One invocation | Cautious one-offs |
| **Session** | Memory | Until restart | Active development |
| **Workspace** | `.vscode/settings.json` | Project-specific | Team-shared rules |
| **User** | User settings | All workspaces | Personal preferences |

---

## DETECTION CATEGORIES

### Risk-Tiered Classification

| Category | Operations | Risk | Default Level |
|----------|-----------|------|---------------|
| **Credential Access** | `*.pem`, `*.key`, `*secret*`, `*password*` | 🔴 CRITICAL | 0 - Always Deny |
| **Code Execution** | `eval`, `exec`, `chmod +x`, `source`, `bash -c` | 🔴 CRITICAL | 0 - Always Deny |
| **File Deletion** | `rm`, `rmdir`, `del`, `unlink`, `shred` | 🔴 HIGH | 1 - Always Ask |
| **Git Destructive** | `git push --force`, `git reset --hard`, `git clean -fd` | 🔴 HIGH | 1 - Always Ask |
| **Network/External** | `curl`, `wget`, `fetch`, `nc`, `ssh` | 🔴 HIGH | 1 - Always Ask |
| **Database Ops** | `DROP`, `TRUNCATE`, `DELETE FROM` | 🔴 HIGH | 1 - Always Ask |
| **Config Changes** | `.env`, `*.config.*`, settings files | 🔴 HIGH | 1 - Always Ask |
| **Package Install** | `npm install`, `pip install`, `brew install` | 🟡 MEDIUM | 2 - Ask Once |
| **Emerging Risks** | Cloud costs, rate limits, external APIs | 🟡 MEDIUM | 1 - Always Ask |

### Pattern Detection Limitations

> ⚠️ **Pattern detection is bypassable.** Agents can rephrase to avoid triggers.
> Pattern = first defense, NOT complete solution.

```
"rm -rf directory"     → DETECTED (pattern match)
"Delete all files in directory recursively" → MAY NOT BE DETECTED
```

**Mitigation:** Use curated allowlists for known-safe operations. Deny-by-default for unknown patterns.

---

## ESCALATION DECISION TREE

### The 6-Step Flow

```
1. DESTRUCTIVE OPERATION?
   │
   ├── YES → STOP AND ASK (Hard Gate)
   │
   ▼
2. PHASE TRANSITION?
   │
   ├── YES → CHECKPOINT: Summarize + Confirm (Soft Gate)
   │
   ▼
3. AGENT UNCERTAIN?
   │
   ├── YES → ASK CLARIFICATION
   │   └── User defers → ESCALATE TO DIFFERENT AGENT
   │
   ▼
4. P1 SAFETY VIOLATED?
   │
   ├── YES → STOP AND REFUSE (no override)
   │
   ▼
5. ERROR OCCURRED?
   │
   ├── YES → EVALUATE:
   │   ├── Recoverable → Retry (max 2)
   │   │   └── Still failing → STOP + REPORT
   │   └── Non-recoverable → STOP + REPORT
   │       └── User requests → ESCALATE
   │
   ▼
6. NO TRIGGERS → CONTINUE EXECUTION
```

### Iteration Limits

| Operation | Max | On Exceed | Source |
|-----------|-----|-----------|--------|
| Code revision cycles | **3** | Escalate to human | obra/superpowers |
| Gate retries | **2** | Stop and report | Community pattern |
| Clarification requests | **2** | Best guess + flag | Community pattern |
| Tool invocations/request | **25** | `chat.agent.maxRequests` | VS Code default |

**Rule:** After 3 revision cycles without verification passing, ESCALATE TO HUMAN.

### Red Flags (Immediate HALT)

When ANY of these occur, STOP immediately — no retry, no ask:

- Modifying files outside project scope
- Accessing credential files (*.env, *.pem, *.key)
- Running unreviewed network commands
- Deleting files without explicit approval
- Bypassing verification gates
- Agent expresses uncertainty but continues anyway
- User explicitly says "stop" or "wait"

### Severity-to-Action Mapping

| Severity | Escalation Action | Human Involvement |
|----------|-------------------|-------------------|
| **None/Pass** | Continue workflow | None |
| **Low** | Log, continue | Batch review weekly |
| **Medium** | Flag, continue with warning | Review within 24h |
| **High** | **Pause, require approval** | Synchronous approval |
| **Critical** | **Halt completely** | Immediate escalation |

---

## AUTHORING RULES

```
RULE_001: Distinguish hard vs soft gates
  REQUIRE: P1 safety protections use HARD GATES (settings)
  REJECT_IF: P1 relies on instruction compliance only
  RATIONALE: Agents can ignore instructions; settings are enforced
  EXAMPLE_VALID: `"rm": false` in autoApprove settings
  EXAMPLE_INVALID: "Never use rm" in instructions only

RULE_002: Deny takes absolute precedence
  REQUIRE: Deny rules evaluated before Ask before Allow
  REJECT_IF: Allow rule can override deny rule
  RATIONALE: Safety-critical pattern from Claude Code, Cursor, etc.
  EXAMPLE_VALID: `"rm": false` blocks even if `"rm -rf node_modules": true`... wait no
  EXAMPLE_VALID: Specific allowlist patterns don't override general deny
  EXAMPLE_INVALID: Regex that accidentally allows dangerous patterns

RULE_003: Checkpoint summary format is mandatory
  REQUIRE: All approval prompts use standardized structure
  REJECT_IF: Freeform approval requests without structure
  RATIONALE: Consistent format enables user pattern recognition
  EXAMPLE_VALID: "## ⏸️ Checkpoint:" with What Done/Want/Why/Risks/Options
  EXAMPLE_INVALID: "Should I continue? y/n"

RULE_004: Iteration limits are non-negotiable
  REQUIRE: 3 revision cycles max, 2 retries max, then escalate
  REJECT_IF: Agent continues past limits without escalating
  RATIONALE: Prevents infinite loops, forces human review
  EXAMPLE_VALID: "Attempt 3 failed. Escalating to human review."
  EXAMPLE_INVALID: "Trying again..." (attempt 5)

RULE_005: Subagent permissions ≤ parent
  REQUIRE: Subagents inherit at most parent's permission level
  REJECT_IF: Subagent has higher permissions than spawning agent
  RATIONALE: Principle of least privilege; prevents escalation attacks
  EXAMPLE_VALID: Build agent spawns helper with same tool restrictions
  EXAMPLE_INVALID: Read-only agent spawns subagent with write access

RULE_006: Target checkpoint budget
  REQUIRE: Tune allowlists to target <3 prompts/session for typical work
  REJECT_IF: Every operation triggers approval (prompt fatigue)
  RATIONALE: Too many prompts = users auto-approve, defeating purpose
  EXAMPLE_VALID: Safe commands allowlisted, only risky ops ask
  EXAMPLE_INVALID: Approval required for `ls`, `cat`, `git status`
```

---

## VALIDATION CHECKLIST

```
VALIDATE_checkpoint_configuration:
  □ Hard gates protect P1 safety (credentials, code execution)
  □ Settings use chat.tools.terminal.autoApprove object format
  □ Deny patterns include: rm, rmdir, del, curl, wget, eval, chmod
  □ Safe allowlists exist for known-good patterns (rm -rf node_modules)
  □ chat.checkpoints.enabled = true for state restoration
  □ Instruction-based gates explicitly marked as "best-effort"

VALIDATE_checkpoint_implementation:
  □ Checkpoint summary uses standard format
  □ Phase transitions pause for confirmation
  □ Uncertainty triggers clarification request
  □ Error handling respects iteration limits (3 revisions, 2 retries)
  □ Red flags trigger immediate HALT
  □ Subagent permissions do not exceed parent

VALIDATE_checkpoint_coverage:
  □ All 8 detection categories addressed
  □ Prompt budget reasonable (<3 for typical session)
  □ Recovery path exists (chat.checkpoints for file state)
  □ Audit trail recommended (log checkpoint triggers)
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| `chat.tools.global.autoApprove: true` | Use granular `autoApprove` object | Disables ALL security protections |
| Rely on instructions for P1 safety | Use settings (hard gates) | Instructions can be ignored/jailbroken |
| Infinite retry loops | Max 2 retries, then escalate | Thrashing wastes time, masks real issues |
| Freeform approval prompts | Standard checkpoint format | Consistency enables user pattern recognition |
| Approve all rm commands | Allowlist specific safe patterns | General approval too permissive |
| Trust `files.exclude` for security | Also set `autoApprove: false` | Terminal bypasses workspace exclusions |
| Exit code only verification | Read FULL output | Exit 0 doesn't mean success |
| Continue despite uncertainty | Stop and ask | Compounds errors, erodes trust |
| Single approval for categories | Per-operation or specific pattern | "Allow all git" too broad |

---

## OPTIONAL ENHANCEMENTS

### Code-Level Protection Markers

Inline markers communicate protection levels to agents (experimental, low adoption expected):

| Marker | Meaning | Behavior |
|--------|---------|----------|
| `!cp` | PROTECTED | Do not modify under any circumstances |
| `!cg` | GUARDED | Ask before modifying |
| `!ci` | INFO | Context note for understanding |
| `!cd` | DEBUG | Can be removed safely |
| `!cc` | CRITICAL | Business logic, extra caution |

```python
# !cp - PROTECTED: Core authentication logic
def verify_token(token: str) -> bool:
    ...
```

### GitHub Copilot Hooks (Coding Agent Only)

For the Coding Agent (not VS Code Chat), use `.github/hooks/*.json`:

```json
{
  "hooks": {
    "preToolUse": [{
      "type": "command",
      "bash": "./scripts/security-check.sh"
    }]
  }
}
```

Block via JSON output: `{"permissionDecision":"deny","permissionDecisionReason":"..."}`

---

## EXAMPLES

### Minimal Checkpoint Configuration

```json
{
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "git status": true,
    "rm": false
  },
  "chat.checkpoints.enabled": true
}
```

### Full Checkpoint Configuration

```json
{
  "chat.tools.global.autoApprove": false,
  "chat.tools.terminal.autoApprove": {
    "npm test": true,
    "npm run lint": true,
    "npm run build": true,
    "/^git (status|diff|log|show|ls-files)\\b/": true,
    "rm -rf node_modules": true,
    "rm -rf dist": true,
    "rm -rf build": true,
    "rm": false,
    "rmdir": false,
    "del": false,
    "curl": false,
    "wget": false,
    "eval": false,
    "/^git (push --force|push -f|reset --hard|clean -fd)/": false
  },
  "chat.tools.edits.autoApprove": {
    "**/.env*": false,
    "**/secrets/**": false,
    "**/*.pem": false,
    "**/*.key": false
  },
  "chat.tools.terminal.blockDetectedFileWrites": "outsideWorkspace",
  "chat.checkpoints.enabled": true,
  "chat.agent.maxRequests": 50
}
```

### Agent Instruction Checkpoint Rules

```markdown
## Phase Transition Rules

When transitioning from planning to implementation:
1. STOP and present the plan summary using checkpoint format
2. Wait for explicit user approval ("approved", "go ahead", "yes")
3. Only proceed after confirmation

## Uncertainty Protocol

If ANY of these apply, STOP and ask:
- Multiple valid interpretations of request
- Ambiguous or conflicting requirements
- Working in unfamiliar domain
- Missing critical context

Template: "I'm uncertain because [reason]. Options: A) [option] B) [option]. Which direction?"

## Error Handling

- On first error: Analyze, attempt ONE alternative
- On second failure: STOP and report
- After 3 revision cycles: ESCALATE to human
- NEVER retry same failing command more than twice
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [orchestration-patterns.md](orchestration-patterns.md) | Handoffs, subagent spawning |
| [quality-patterns.md](quality-patterns.md) | Verification gates, evidence requirements |
| [SETTINGS.md](../SETTINGS.md) | Full settings reference |
| [RULES.md](../RULES.md) | P1 safety constraints |

---

## SOURCES

- [approval-gates.md](../../cookbook/CHECKPOINTS/approval-gates.md) — Gate types, triggers, native VS Code mechanisms
- [destructive-ops.md](../../cookbook/CHECKPOINTS/destructive-ops.md) — Detection categories, pattern rules
- [escalation-tree.md](../../cookbook/CHECKPOINTS/escalation-tree.md) — Decision flow, iteration limits
- [permission-levels.md](../../cookbook/CHECKPOINTS/permission-levels.md) — 4-level model, VS Code implementation
- [VS Code Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — Official settings documentation
- [VS Code Chat Tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Tool approval system
- [GitHub Copilot Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — preToolUse hooks
