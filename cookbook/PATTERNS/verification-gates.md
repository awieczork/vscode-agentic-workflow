---
when:
  - requiring proof before completion claims
  - implementing test-before-merge workflows
  - adding quality checkpoints to agents
  - preventing false success reports
pairs-with:
  - approval-gates
  - iron-law-discipline
  - hallucination-reduction
  - destructive-ops
requires:
  - terminal-access
complexity: medium
---

# Verification Gates

Require evidence before claims. A verification gate is a checkpoint that forces the agent to prove its work before proceeding—running tests, reading output, confirming results match expectations.

> **Platform Note:** This pattern synthesizes guidance from community projects (obra/superpowers, HumanLayer ACE) and official VS Code features. VS Code provides native verification mechanisms through [chat checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints), [hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks), and [trust boundaries](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries). The structured gate patterns below can be implemented via agent instructions and hook configurations.

## Core Principle

```
NEVER claim completion without verifiable evidence.
```

> "Evidence before claims, always." — [obra/superpowers](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md)

The pattern prevents:
- False completion claims
- Untested code
- Hallucinated success
- Skipped quality checks

## VS Code Native Checkpoints

VS Code provides built-in checkpoint functionality for verification:

| Setting | Purpose | Default |
|---------|---------|----------|
| `chat.checkpoints.enabled` | Save state at critical points | `true` |
| `chat.checkpoints.showFileChanges` | Show file change summary | `true` |
| `chat.editRequests` | Edit previous chat requests | `true` |

Checkpoints allow you to save the state of your chat session at a specific point, experiment with different approaches, and rollback if needed.

### Trust Boundaries (Built-in Gates)

VS Code enforces trust boundaries as automatic verification gates:

- **Workspace Trust** — Blocks operations in untrusted folders
- **Extension Publisher Trust** — Validates extension sources  
- **MCP Server Trust** — Requires consent before MCP server start

These gates limit critical operations unless trust is explicitly granted.

Source: [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints), [VS Code Security](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries)

## Common Verification Failures

Recognize these anti-patterns that undermine verification:

| Failure Pattern | Signal | Correct Behavior |
|-----------------|--------|------------------|
| **Exit code only** | "Test returned 0" | Read FULL output, not just exit code |
| **Assumed success** | "Tests should pass" | Run tests, show actual results |
| **Partial verification** | "Most tests pass" | ALL tests must pass for success |
| **Stale evidence** | Evidence from previous run | Fresh verification for each claim |
| **Regression blindness** | Test passes immediately | Verify test FAILS before fix, PASSES after |

Source: [obra/superpowers verification-before-completion](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md)

## Basic Gate Structure

```markdown
## Verification Gate

BEFORE claiming completion:

1. Run the verification command
2. Read the COMPLETE output
3. Confirm results match expectations
4. Only then report success

If verification fails:
- Report the failure honestly
- Do NOT claim partial success
- Do NOT proceed to next step
```

## Gate Types

### Type 1: Command-Based

Verify by executing a command and reading output:

```markdown
## Verification Gate: Tests

BEFORE claiming implementation complete:

1. Run: `npm test`
2. Read FULL output (not just exit code)
3. Count: X passed, Y failed
4. If ANY failures: report them, do NOT claim success

Evidence required:
- Actual test output (copy relevant sections)
- Pass/fail counts
- Any warnings or errors
```

### Type 2: Checklist-Based

Verify by confirming each criterion:

```markdown
## Verification Gate: Code Quality

BEFORE claiming refactoring complete:

- [ ] All tests still pass
- [ ] No new linting errors
- [ ] No behavior changes (only structure)
- [ ] All TODO comments addressed

Evidence required:
- Test results
- Lint output
- Brief explanation of changes
```

### Type 3: Comparison-Based

Verify by comparing against specification:

```markdown
## Verification Gate: Spec Compliance

BEFORE claiming feature complete:

For EACH acceptance criterion in the spec:
1. Quote the criterion
2. Show evidence it's satisfied
3. Mark as ✅ or ❌

Example:
- Criterion: "WHEN user logs in, THE SYSTEM SHALL issue a JWT"
- Evidence: `auth.ts:42` - `return jwt.sign(payload, secret)`
- Status: ✅
```

### Type 4: Output-Based

Verify by checking produced artifacts:

```markdown
## Verification Gate: Build

BEFORE claiming build succeeds:

1. Run: `npm run build`
2. Confirm: No errors in output
3. Verify: Output files exist in `dist/`
4. Check: File sizes reasonable (not 0 bytes)

Evidence required:
- Build command output
- List of files in dist/
```

### Type 5: Red-Green-Refactor (TDD)

Verify using the test-driven development cycle. VS Code provides official TDD custom agents:

| Agent | Phase | Purpose |
|-------|-------|----------|
| `TDD-red.agent.md` | Red | Write failing tests that reproduce the issue |
| `TDD-green.agent.md` | Green | Implement minimal code to pass tests |
| `TDD-refactor.agent.md` | Refactor | Improve code quality while tests pass |

```markdown
## Verification Gate: TDD Bug Fix

BEFORE claiming bug is fixed:

1. **RED** — Write failing test
   - [ ] Test reproduces the bug
   - [ ] Test FAILS on current code (verified)

2. **GREEN** — Implement minimal fix
   - [ ] Test now PASSES
   - [ ] No other tests broken

3. **REFACTOR** — Clean up
   - [ ] All tests still pass
   - [ ] Code quality acceptable

Evidence required:
- Test file and test name
- "FAIL" output before fix
- "PASS" output after fix
```

This prevents "magic fixes" where a test passes immediately without ever failing.

Source: [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide), [Anthropic Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

## Five-Gate Validation (Spec-Driven)

For specification validation before implementation:

```markdown
## Gate 1: Metadata Completeness
- [ ] Name field is present and valid
- [ ] Status is set (draft/review/approved)
- [ ] Project type is specified (not "NEEDS CLARIFICATION")

## Gate 2: Requirement Quality
- [ ] All `[NEEDS CLARIFICATION]` markers resolved
- [ ] At least 3 user stories defined
- [ ] Each user story has acceptance criteria

## Gate 3: State Delta Clarity
- [ ] Current State section has ≥3 bullet points
- [ ] Proposed State section has ≥3 bullet points
- [ ] Actual delta exists (Current ≠ Proposed)

## Gate 4: Constraint Validation
- [ ] At least 1 MUST constraint defined
- [ ] Out of Scope section is not empty

## Gate 5: Resource Availability
- [ ] Required tools/APIs available
- [ ] Domain expertise level specified
```

Source: [GitHub Spec-Kit](https://github.com/github/spec-kit)

### Pre-Implementation Constitutional Gates

Before starting implementation, verify constitutional compliance:

```markdown
## Simplicity Gate
- [ ] Maximum 3 projects in scope for initial implementation
- [ ] No premature optimization planned

## Anti-Abstraction Gate
- [ ] Concrete implementations before abstraction
- [ ] No unnecessary indirection

## Integration-First Gate
- [ ] Real databases over mocks where feasible
- [ ] Integration tests alongside unit tests
```

Source: [GitHub Spec-Kit spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md)

## Phase Transition Gates

Verify before moving between workflow phases:

```markdown
## Phase Gate: Research → Plan

BEFORE transitioning to Planning:

1. **Findings documented**
   - [ ] Key discoveries listed
   - [ ] Sources cited

2. **Questions answered**
   - [ ] Original questions addressed
   - [ ] Remaining unknowns flagged

3. **Recommendation ready**
   - [ ] Clear recommendation exists
   - [ ] Tradeoffs documented

GATE VERDICT:
- [ ] PASS — Proceed to Planning
- [ ] FAIL — More research needed
```

```markdown
## Phase Gate: Plan → Implement

BEFORE transitioning to Implementation:

1. **Plan reviewed**
   - [ ] Tasks clearly defined
   - [ ] Dependencies mapped

2. **Scope confirmed**
   - [ ] Matches original spec
   - [ ] No scope creep

3. **Risks addressed**
   - [ ] Blockers identified
   - [ ] Mitigation planned

GATE VERDICT:
- [ ] PASS — Proceed to Implementation
- [ ] FAIL — Revise plan
```

## Handoff Protocol

After passing a verification gate, provide structured output for the next agent or phase:

```markdown
## Handoff Protocol

On successful verification, output:

```yaml
status: VERIFIED
timestamp: {ISO_8601}

completed:
  task: "{TASK_DESCRIPTION}"
  evidence:
    - "{EVIDENCE_1}"
    - "{EVIDENCE_2}"

artifacts:
  files_changed: ["{FILE_1}", "{FILE_2}"]
  test_results: "X passed, Y failed"
  coverage: "{PERCENTAGE}%"

next:
  task: "{NEXT_TASK}"
  prerequisites: ["{PREREQ_1}"]
  concerns: ["{ANY_ISSUES}"]
```
```

## Anti-Hallucination Gates

Specific gates to prevent fabricated claims:

### Quote-First Gate

```markdown
## Verification Gate: Claims

BEFORE making any claim about the codebase:

1. **Find the evidence first**
   - Search for relevant code
   - Read the actual file content

2. **Quote directly**
   - Include exact code snippets
   - Include file paths and line numbers

3. **Only then make claim**
   - Claim must match quoted evidence
   - If no evidence found, say "I don't know"

FORBIDDEN:
- Claiming code exists without showing it
- Describing behavior without reading implementation
- Stating test results without running tests
```

### Investigate-First Gate

```markdown
## Verification Gate: Debugging

BEFORE suggesting a fix:

1. **Read the error** — Quote exact error message
2. **Find the source** — Show file and line
3. **Understand the cause** — Explain based on code read
4. **Then suggest fix** — Grounded in actual code

NEVER:
- Guess at causes without reading code
- Suggest fixes based on assumptions
- Skip straight to "try this" without investigation
```

Source: [Anthropic Reduce Hallucinations](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations)

### Abstention Gate

When verification cannot produce confident results:

```markdown
## Verification Gate: Confidence

BEFORE making claims about uncertain topics:

1. **Assess confidence**
   - Can I cite specific evidence?
   - Is this in retrieved context?
   - Have I verified this recently?

2. **If uncertain, abstain**
   - Say "I don't know" or "I'm not sure"
   - Offer to investigate further
   - Do NOT fabricate confidence

3. **Route to clarification**
   - Ask user for more context
   - Suggest alternative approaches
   - Escalate to human review
```

Abstention is preferable to hallucination. Agents that can say "I don't know" produce more reliable output.

> **Official Support:** Microsoft's RAI validation uses classifiers to flag potentially harmful content, leading to "mitigations, such as not returning generated content" when confidence is low. This validates the abstention-over-hallucination principle.

Source: [Anthropic Reduce Hallucinations](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations), [Microsoft Transparency Note](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note#manage)

## Dual Review Pattern

<!-- NOT IN OFFICIAL DOCS: "Dual review pattern" with spec compliance before code quality - This is a community pattern from obra/superpowers. Official docs mention code review and separation of duties but don't prescribe this specific sequence. Flagged 2026-01-25 -->

Separate spec compliance from code quality — **always in this order**:

```markdown
## Gate A: Spec Compliance Review (FIRST)

Reviewer: spec-reviewer agent

Questions:
- Does implementation match requirements?
- Are all acceptance criteria satisfied?
- Is anything missing from spec?

Output: SPEC_COMPLIANCE_REPORT

## Gate B: Code Quality Review (SECOND)

Reviewer: quality-reviewer agent
Prerequisite: Gate A passed

Questions:
- Is code maintainable?
- Are there performance issues?
- Security vulnerabilities?
- Following project conventions?

Output: QUALITY_REPORT
```

> Spec compliance review FIRST, then code quality review. — [obra/superpowers](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md)

## Test Coverage Thresholds

<!-- NOT IN OFFICIAL DOCS: Specific coverage percentages (80%, 100%) - These are community guidelines, not VS Code requirements. Official docs mention runTests reports coverage to agent but don't mandate thresholds. Flagged 2026-01-25 -->

Define minimum coverage as a verification gate:

| Code Category | Minimum Coverage |
|---------------|------------------|
| General code | 80% |
| Financial calculations | 100% |
| Authentication logic | 100% |
| Security-critical code | 100% |

> **Note:** These thresholds are industry guidelines. VS Code's `runTests` tool reports coverage to the agent but doesn't enforce specific thresholds.

```markdown
## Verification Gate: Coverage

BEFORE claiming feature complete:

1. Run: `npm run test:coverage`
2. Check overall coverage ≥ 80%
3. Check security-critical paths = 100%
4. If thresholds not met, add tests FIRST
```

Source: [Claude Code ecosystem patterns](https://github.com/affaan-m/everything-claude-code), [VS Code Testing Updates](https://code.visualstudio.com/updates/v1_105#_testing)

## Agent Configuration

Add verification gates to any agent:

```yaml
---
name: feature-implementer
description: Implements features with verification
tools: ["read", "edit", "terminal"]
---

# Feature Implementer

## Verification Protocol

This agent MUST verify before any completion claim.

### After Each Change

1. Run relevant tests
2. Read full output
3. Report actual results

### Before Claiming Done

1. All tests pass
2. No linting errors
3. Matches spec requirements

### Evidence Format

Always include:
- Command run
- Actual output (relevant excerpt)
- Pass/fail determination

## Forbidden

- "Tests should pass" (without running them)
- "This looks correct" (without verification)
- "I believe this works" (belief ≠ evidence)
```

## Hook-Based Verification

Use lifecycle hooks for automated verification gates. Six hook types are available:

| Hook | Trigger | Use Case |
|------|---------|----------|
| `sessionStart` | Agent session begins | Initialize logging, load state |
| `sessionEnd` | Agent session ends | Final validation, cleanup |
| `userPromptSubmitted` | User sends prompt | Input validation, routing |
| `preToolUse` | Before tool execution | Block dangerous commands, enforce policies, require approval |
| `postToolUse` | After tool completes | Run linting, verify changes, log results |
| `errorOccurred` | Error during execution | Error handling, alerts |

The `preToolUse` hook is the most powerful—it can approve or deny tool executions by returning `permissionDecision: "allow"`, `"deny"`, or `"ask"`.

```json
{
  "hooks": {
    "preToolUse": [{
      "type": "command",
      "bash": "./scripts/security-check.sh",
      "timeoutSec": 15
    }],
    "postToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [
        { "type": "command", "command": "npm run lint --fix" }
      ]
    }]
  }
}
```

Hooks are stored in `.github/hooks/*.json` and are available for Copilot coding agent and GitHub Copilot CLI.

Source: [GitHub Hooks Configuration](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

## Backpressure Testing

<!-- NOT IN OFFICIAL DOCS: "Backpressure testing" terminology - This is a community pattern from Claude Code ecosystem. VS Code has test watch mode but doesn't use this specific terminology. Flagged 2026-01-25 -->

Tests as continuous feedback during development:

```markdown
## Verification Pattern: Backpressure

1. Run tests in watch mode: `npm test -- --watch`
2. Make changes
3. Tests provide immediate feedback
4. Agent iterates until tests pass
5. Never claim completion until green

Benefits:
- Immediate failure signal
- Prevents drift from working state
- Forces small, verifiable changes
```

This pattern treats tests as "backpressure" that resists incorrect changes.

Source: [Claude Code ecosystem patterns](https://github.com/hesreallyhim/awesome-claude-code)

## Gate Failure Handling

When verification fails:

```markdown
## On Verification Failure

1. **Report honestly**
   ```
   ❌ VERIFICATION FAILED

   Command: npm test
   Result: 3 tests failed

   Failures:
   - auth.test.ts: Invalid token format
   - user.test.ts: Missing field
   - api.test.ts: Timeout
   ```

2. **Do NOT claim partial success**
   - "Most tests pass" is not success
   - "Only minor failures" is not success

3. **Determine next action**
   - Fix the issue and re-verify
   - Escalate if unclear how to fix
   - Report blocker if external dependency

4. **Re-verify after fix**
   - Same gate, same criteria
   - Full output, not "it works now"
```

## Related

- [iron-law-discipline](iron-law-discipline.md) — Rules that gates enforce
- [hallucination-reduction](hallucination-reduction.md) — Evidence-grounding techniques
- [spec-driven](../WORKFLOWS/spec-driven.md) — Workflow with phase gates
- [riper-modes](../WORKFLOWS/riper-modes.md) — Mode transitions as checkpoints
- [approval-gates](../CHECKPOINTS/approval-gates.md) — Human review checkpoints
- [spec-templates](../WORKFLOWS/spec-templates.md) — Five-gate validation source
- [permission-levels](../CHECKPOINTS/permission-levels.md) — Tool execution verification

## Sources

### Official VS Code / GitHub Documentation
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Native checkpoint functionality
- [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) — TDD custom agents (Red/Green/Refactor)
- [VS Code Security Trust Boundaries](https://code.visualstudio.com/docs/copilot/security#_trust-boundaries) — Built-in verification gates
- [GitHub Hooks Configuration](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — Six hook types for automated verification
- [GitHub Spec-Kit](https://github.com/github/spec-kit) — Five-gate validation, constitutional gates
- [VS Code Testing Updates](https://code.visualstudio.com/updates/v1_105#_testing) — runTests tool reports coverage
- [Microsoft RAI Validation](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/rai-validation) — Manifest and runtime validation gates

### Community Patterns
- [obra/superpowers](https://github.com/obra/superpowers) — Verification-before-completion skill
- [obra/superpowers verification skill](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md) — Evidence-first patterns
- [Anthropic Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices) — TDD workflow
- [Anthropic Reduce Hallucinations](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations) — Abstention, quote-first patterns
- [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — Leverage model, phase gates
- [Claude Code ecosystem patterns](https://github.com/hesreallyhim/awesome-claude-code) — Backpressure testing
