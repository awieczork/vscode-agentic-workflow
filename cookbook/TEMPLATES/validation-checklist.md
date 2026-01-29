---
when:
  - validating specifications before implementation
  - reviewing requirements quality
  - checking phase transition readiness
  - auditing spec completeness
pairs-with:
  - spec-template
  - spec-driven
  - approval-gates
  - verification-gates
requires:
  - none
complexity: low
---

# Validation Checklist

Copy-paste checklist for validating specifications before implementation. Use this at phase transitions to ensure quality gates are met.

> **Pattern Origin:** The 5-gate structure synthesizes patterns from [GitHub Spec-Kit](https://github.com/github/spec-kit) and research. EARS notation (Easy Approach to Requirements Syntax) originated from Alistair Mavin at Rolls-Royce for aerospace requirements engineering.

> **Platform Note:** This checklist is a **community workflow pattern**, not a native VS Code feature. VS Code provides native approval mechanisms through `chat.tools.edits.autoApprove` settings and interactive Keep/Undo buttons for code review. See [Native VS Code Approval](#native-vs-code-approval) section below.

## 5-Gate Spec Validation

```markdown
# Spec Validation Report

**Spec:** [project-name].spec.md
**Reviewer:** [agent/human]
**Date:** [YYYY-MM-DD]

---

## Gate 1: Metadata Completeness

- [ ] Project name is present and descriptive
- [ ] Status is set (draft / review / approved)
- [ ] Project type is specified (web / mobile / library / etc.)
- [ ] Tech stack is defined (language, frameworks)
- [ ] Version number present

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## Gate 2: Requirement Quality

- [ ] All `[NEEDS CLARIFICATION]` markers resolved
- [ ] At least 3 user stories defined
- [ ] Each user story has priority (P1/P2/P3)
- [ ] Each user story has acceptance criteria (EARS or Given/When/Then)
- [ ] Acceptance criteria are testable

**Acceptance Criteria Formats:**
- **EARS (Kiro):** `WHEN [condition], THE SYSTEM SHALL [behavior]`
- **Gherkin (Spec-Kit):** `Given [state], When [action], Then [outcome]`

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## Gate 3: State Delta Clarity

- [ ] Current State section has ≥3 bullet points
- [ ] Proposed State section has ≥3 bullet points
- [ ] Current State ≠ Proposed State (actual delta exists)
- [ ] Delta is implementation-actionable (not vague aspirations)

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## Gate 4: Constraint Validation

- [ ] At least 1 MUST constraint defined
- [ ] At least 1 MUST NOT constraint defined
- [ ] Out of Scope section is not empty
- [ ] Constraints use unambiguous language

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## Gate 5: Resource Availability

- [ ] Domain expertise level specified
- [ ] Required dependencies identified
- [ ] External APIs/services documented
- [ ] Reference resources linked

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## Summary

| Gate | Status | Notes |
|------|--------|-------|
| 1. Metadata | | |
| 2. Requirements | | |
| 3. State Delta | | |
| 4. Constraints | | |
| 5. Resources | | |

**Overall:** [ ] PASS — Ready for planning  [ ] FAIL — Needs revision

**Blocking Issues:**
- [Issue 1]
- [Issue 2]
```

## Quick Validation (Inline)

Minimal checklist for embedding in agent instructions:

```markdown
## Spec Validation (Quick)

Before proceeding to planning, verify:

- [ ] No `[NEEDS CLARIFICATION]` markers remain
- [ ] Each user story has acceptance criteria
- [ ] Current→Proposed delta is clear
- [ ] MUST constraints are defined
- [ ] Out of Scope is documented

If ANY fail: request clarification, do NOT proceed.
```

## Failure Actions

When gates fail, take action based on severity:

| Failure Type | Severity | Action |
|--------------|----------|--------|
| Missing metadata | Low | Flag, request completion |
| Unresolved clarifications | High | Halt, request answers |
| No acceptance criteria | High | Halt, cannot verify completion |
| Empty constraints | Medium | Flag, proceed with caution |
| Vague state delta | High | Halt, request specifics |

### Severity → Response

| Severity | Response | Continue? |
|----------|----------|-----------|
| **Critical** | Stop immediately, escalate | No |
| **High** | Pause, require human approval | No |
| **Medium** | Flag issue, continue with warning | Yes |
| **Low** | Log for review, continue | Yes |

## Implementation Validation

After implementation, verify against spec:

```markdown
# Implementation Validation Report

**Spec:** [project-name].spec.md
**Implementation:** [commit/PR reference]
**Date:** [YYYY-MM-DD]

## Acceptance Criteria Verification

For EACH acceptance criterion in the spec:

### US-001: [Title]

| # | Criterion | Evidence | Status |
|---|-----------|----------|--------|
| 1 | WHEN [X], THE SYSTEM SHALL [Y] | [file:line or test name] | ✅/❌ |
| 2 | WHEN [X], THE SYSTEM SHALL [Y] | [file:line or test name] | ✅/❌ |

### US-002: [Title]

| # | Criterion | Evidence | Status |
|---|-----------|----------|--------|
| 1 | WHEN [X], THE SYSTEM SHALL [Y] | [file:line or test name] | ✅/❌ |

## Constraint Verification

| Constraint | Satisfied | Evidence |
|------------|-----------|----------|
| MUST: [requirement] | ✅/❌ | [how verified] |
| MUST NOT: [prohibition] | ✅/❌ | [how verified] |

## Test Results

- Tests run: [count]
- Passed: [count]
- Failed: [count]
- Coverage: [percentage]

## Overall Verdict

[ ] PASS — All criteria met, ready for merge
[ ] PARTIAL — [X/Y] criteria met, issues documented
[ ] FAIL — Critical criteria not met
```

## Agent Integration

Embed validation in agent instructions (body section of `.agent.md`):

```markdown
---
name: planner
description: Creates implementation plans from specs
tools:
  - filesystem
---

## Validation Gate (Before Planning)

Run 5-gate validation on any spec before creating a plan:

1. **Metadata complete?** — Project name, status, tech stack
2. **Requirements have criteria?** — EARS or Given/When/Then format
3. **State delta clear?** — Current ≠ Proposed, actionable changes
4. **Constraints defined?** — MUST and MUST NOT present
5. **Resources available?** — Domain expertise, dependencies documented

**If ANY gate fails:** Report failures, request clarification. Do NOT proceed to planning.
```

> **Platform Note:** The `checkpoints:` field shown in some examples is a **proposed design pattern**, not native VS Code schema. For native approval gates, use `handoffs:` with `send: false` for review points, or embed validation rules in agent instructions. See [approval-gates](../CHECKPOINTS/approval-gates.md) for details.

## Native VS Code Approval

VS Code provides built-in approval mechanisms for code changes:

### Code Edit Review

When Copilot proposes code changes, VS Code shows:
- **Keep** / **Undo** buttons for each edit
- File-level diff view showing proposed changes
- Ability to accept or reject individual changes

Source: [Review Code Edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits)

### Sensitive File Protection

Use `chat.tools.edits.autoApprove` to require approval for specific files:

```json
{
  "chat.tools.edits.autoApprove": {
    "enabled": true,
    "include": ["**"],
    "exclude": ["**/.env", "**/.vscode/*.json"]
  }
}
```

Files matching `exclude` patterns always require manual approval before edits are applied.

Source: [Review Code Edits - Sensitive Files](https://code.visualstudio.com/docs/copilot/chat/review-code-edits#_edit-sensitive-files)

### Tool Invocation Approval

MCP tool calls require explicit user approval:
- **Session-level** — Approve once per session
- **Workspace-level** — Approve once per workspace (persisted)

Configure via `chat.tools.autoApprove` setting.

Source: [Security - Permission Management](https://code.visualstudio.com/docs/copilot/security#_permission-management)

### Chat Checkpoints (History)

Use chat checkpoints to roll back to previous states within a session:
- Navigate to earlier conversation points
- Restore code to checkpoint state
- Persists until VS Code session ends

Source: [Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

## Related

- [spec-template](spec-template.md) — The artifact being validated
- [spec-driven](../WORKFLOWS/spec-driven.md) — Full workflow context
- [verification-gates](../PATTERNS/verification-gates.md) — Evidence-before-claims patterns
- [approval-gates](../CHECKPOINTS/approval-gates.md) — Checkpoint configuration
- [critique-template](../RED-TEAM/critique-template.md) — Severity definitions

## Sources

<!-- Community patterns and external frameworks -->
- [GitHub Spec-Kit](https://github.com/github/spec-kit) — `/speckit.checklist` command, spec validation patterns
- [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [Kiro IDE: EARS Notation](https://kiro.dev/docs/specs/concepts/) — `WHEN/SHALL` acceptance criteria format
- [EARS Original](https://alistairmavin.com/ears/) — Alistair Mavin's Easy Approach to Requirements Syntax
- [obra/superpowers](https://github.com/obra/superpowers) — Verification gates pattern

<!-- Official VS Code documentation -->
- [VS Code: Review Code Edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits) — Native Keep/Undo approval workflow
- [VS Code: Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Session history and rollback
- [VS Code: Security](https://code.visualstudio.com/docs/copilot/security) — Tool approval mechanisms
- [VS Code: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — `handoffs:` with `send: false` for review points
