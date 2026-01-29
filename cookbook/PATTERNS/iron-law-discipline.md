---
when:
  - enforcing strict process rules on agents
  - implementing TDD or similar disciplines
  - preventing agent rationalization of shortcuts
  - creating hard boundaries that cannot be bypassed
pairs-with:
  - iron-law-verification
  - constitutional-principles
  - verification-gates
  - approval-gates
requires:
  - none
complexity: medium
---

# Iron Law Discipline

> **Platform Note:** "Iron Law", "Red Flags", and "Rationalization Prevention" are **design patterns** from the [obra/superpowers](https://github.com/obra/superpowers) repository, not native VS Code/Copilot features. These patterns are implemented via agent instructions and custom instructions files. The underlying concepts align with VS Code's [TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) which documents similar workflow enforcement through agent handoffs.

Define inviolable rules with no exceptions. The Iron Law pattern creates a hard boundary that the agent cannot rationalize around—paired with Red Flags that trigger immediate stops, and Rationalization Tables that pre-empt common excuses.

## The Three Components

Every discipline-enforcing agent needs:

| Component | Purpose | Format |
|-----------|---------|--------|
| **Iron Law** | The inviolable rule | Single imperative statement |
| **Red Flags** | Stop triggers | Bulleted conditions |
| **Rationalization Table** | Pre-empt excuses | Excuse → Reality pairs |

## Iron Law Statement

A single, unambiguous rule that cannot be violated:

```markdown
## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```
```

### Characteristics of Good Iron Laws

| ✅ Good | ❌ Bad |
|---------|--------|
| Single clear rule | Multiple rules |
| Binary (violated/not) | Subjective judgment |
| No escape clauses | "Unless...", "Except when..." |
| Actionable | Abstract principle |

### Example Iron Laws

```markdown
## Security Agent Iron Law
```
NEVER COMMIT SECRETS, CREDENTIALS, OR API KEYS
```

## Documentation Agent Iron Law
```
NO PUBLIC API WITHOUT DOCUMENTED EXAMPLES
```

## Review Agent Iron Law
```
NO APPROVAL WITHOUT RUNNING THE TEST SUITE
```

## Refactoring Agent Iron Law
```
NO BEHAVIOR CHANGES—ONLY STRUCTURE
```
```

## Red Flags — Stop Conditions

Specific signals that indicate potential Iron Law violation:

```markdown
## Red Flags — STOP

If you observe ANY of these, STOP immediately:

- Writing production code before a failing test exists
- Test passes on first run (wasn't testing anything)
- Saying "I'll test later" or "this is too simple to test"
- Modifying test to make it pass instead of fixing code
- Skipping tests for "urgent" fixes
```

### Red Flag Template

```markdown
## Red Flags — STOP

If you observe ANY of these, STOP immediately:

- {Specific observable behavior 1}
- {Specific observable behavior 2}
- {Phrase that signals violation}
- {Shortcut that bypasses the rule}
- {Excuse that precedes violation}
```

## Rationalization Prevention Table

Pre-emptively counter the excuses agents use to bypass rules:

```markdown
## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "Tests slow me down" | Bugs slow you down more. Untested code = tech debt. |
| "I'll add tests later" | Later never comes. Write test NOW. |
| "This is just a quick fix" | Quick fixes become permanent. Test it. |
| "The user said it's urgent" | Broken code is never acceptable, urgent or not. |
| "It's only internal code" | Internal code breaks too. Test it. |
```

### Additional TDD Pitfalls (from VS Code TDD Guide)

<!-- Source: https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide#_troubleshooting-and-best-practices -->

| Excuse | Reality |
|--------|---------|
| "Let me implement first" | Skipping the red phase defeats TDD. Test first. |
| "I'll add comprehensive tests" | Over-implementation risk. One failing test at a time. |
| "Testing implementation details" | Test behavior, not implementation. Tests break on refactor otherwise. |
| "Running TDD without handoffs" | Removes human from the loop. Use handoffs for control points. |

### Why This Works

Agents (like humans) rationalize to achieve goals faster. The table:
1. **Anticipates** common rationalizations
2. **Provides counter-argument** agent can't dismiss
3. **Removes decision burden** — the excuse is already addressed

### Building Your Rationalization Table

1. List excuses you've heard (or the agent has used)
2. Write the reality that counters each
3. Keep adding as new rationalizations appear

## Complete Agent Example

```yaml
---
name: tdd-implementer
description: Implements features using test-driven development
tools: ["read", "edit", "execute", "search"]
# Note: Use 'execute' for terminal/shell commands (aliases: shell, Bash, powershell)
# See: https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases
---

# TDD Implementer Agent

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

## Red Flags — STOP

If you observe ANY of these, STOP immediately:

- Writing production code before test exists
- Test passes on first run
- "I'll test later"
- "Too simple to test"
- Modifying test expectations to pass

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. 30 seconds to write test. |
| "Tests slow me down" | Bugs slow you down more. |
| "Just a quick fix" | Quick fixes need tests too. |
| "User said urgent" | Broken code is never acceptable. |

## Workflow

1. **Write failing test** that describes desired behavior
2. **Run test** — confirm it fails for the right reason
3. **Write minimal code** to make test pass
4. **Run test** — confirm it passes
5. **Refactor** if needed (tests still pass)
6. **Repeat** for next behavior

## Verification Gate

BEFORE claiming completion:
1. Run full test suite: `npm test`
2. Read COMPLETE output
3. Verify ALL tests pass
4. Report results honestly
```

## Violation Detection

Watch for these signals that indicate rationalization:

| Signal | Detection | Example |
|--------|-----------|---------|
| **Post-hoc justification** | Principle cited AFTER decision | "I wrote the code... this aligns with TDD" |
| **Selective citation** | Only citing supporting principles | Ignoring "test first" while citing "clean code" |
| **Sycophancy** | Agreeing despite guideline conflict | User asks to skip tests, agent complies |
| **Inverse scaling** | More capable = more convincing excuses | Elaborate justifications for violations |

## Self-Verification Checklist

Include in agents that enforce critical rules:

```markdown
## Iron Law Self-Check

Before proceeding, verify:

### 1. Principle-First
- [ ] Did I cite the relevant principle BEFORE making my decision?

### 2. Conflict Detection
- [ ] Have I listed ALL relevant principles, including ones that might oppose this action?

### 3. Sycophancy Check
- [ ] Would my decision change if the user wanted the opposite?
- [ ] Have I disagreed with the user at least once when warranted?

### 4. Counterfactual Test
- [ ] Would a different user get the same output for this request?

### VERDICT
- **PASS**: Principles guided the decision
- **WARN**: Potential rationalization — request human review
- **FAIL**: Clear violation — revise before proceeding
```

## Domain-Specific Examples

### Security Iron Law

```markdown
## The Iron Law
```
NEVER LOG, COMMIT, OR TRANSMIT CREDENTIALS
```

## Red Flags — STOP
- Variable named `password`, `secret`, `key`, `token` in logs
- Hardcoded credentials in source files
- API keys in commit history
- Environment variables printed to output

## Rationalization Prevention
| Excuse | Reality |
|--------|---------|
| "It's just for debugging" | Debug logs get shipped to production. |
| "This is a private repo" | Private repos get leaked. Treat all as public. |
| "I'll remove it before commit" | You'll forget. Never add it. |
| "It's encrypted" | Encrypted secrets are still secrets. Don't log. |
```

### Documentation Iron Law

```markdown
## The Iron Law
```
NO PUBLIC FUNCTION WITHOUT JSDoc/DOCSTRING
```

## Red Flags — STOP
- Exported function without documentation
- Parameters without type annotations
- Missing @returns description
- "Documentation TODO" comments

## Rationalization Prevention
| Excuse | Reality |
|--------|---------|
| "Code is self-documenting" | Future you disagrees. Document it. |
| "I'll document later" | Later = never. Document as you write. |
| "It's obvious what it does" | Obvious to you now. Not to others. |
| "Types are enough" | Types describe what, not why. Add context. |
```

## Enforcement Escalation

<!-- NOT IN OFFICIAL DOCS: Severity levels (None/Low/Medium/High/Critical) are a cookbook design pattern, not native VS Code classification - flagged 2026-01-25 -->

When Iron Law violation is detected, severity determines response:

### Severity-to-Action Mapping

| Severity | Automated Action | Human Involvement | Example |
|----------|------------------|-------------------|---------|
| **None/Pass** | Continue workflow | None (logged for audit) | All checks pass |
| **Low** | Log, continue | Batch review weekly | Minor style deviation |
| **Medium** | Flag, continue with warning | Review within 24h | Missing documentation |
| **High** | Pause, require approval | Synchronous approval required | Tests skipped |
| **Critical** | Halt completely | Immediate escalation | Production code without test |

### Action Levels

| Severity | Action | Example |
| **Prevented** | Agent stops itself | Red Flag triggered, work halted |
| **Detected** | Request human review | Self-check fails, user notified |
| **Violated** | Mandatory correction | Work reverted, violation logged |

```markdown
## On Violation Detection

If Iron Law violation is detected:

1. **STOP** current work immediately
2. **REPORT** the violation:
   ```
   ⚠️ IRON LAW VIOLATION DETECTED

   Rule: {THE_IRON_LAW}
   Violation: {WHAT_HAPPENED}
   Evidence: {SPECIFIC_OBSERVATION}
   ```
3. **WAIT** for human guidance
4. **DO NOT** proceed until resolved
```

## Documenting Violations

<!-- NOT IN OFFICIAL DOCS: .critique.md is a cookbook-defined file format, not a VS Code/Copilot recognized extension - flagged 2026-01-25 -->

Use a `.critique.md` file to formally document Iron Law violations:

```markdown
---
type: critique
date: {DATE}
severity: [low|medium|high|critical]
---

# Critique: {BRIEF_DESCRIPTION}

## Violation
- **Iron Law Violated:** {THE_IRON_LAW}
- **Evidence:** {WHAT_WAS_OBSERVED}
- **Violation Type:** [Direct | Indirect | Potential]

## Impact Assessment
- **Scope:** [File | Module | System]
- **Reversibility:** [Easy | Moderate | Difficult]
- **Urgency:** [Immediate | Soon | Scheduled]

## Recommendation
- **Immediate Action:** {WHAT_TO_DO_NOW}
- **Systemic Fix:** {PROCESS_CHANGE_TO_PREVENT_RECURRENCE}
```

## Connection to 12-Factor Agents

<!-- NOT IN OFFICIAL DOCS: 12-Factor Agents is a community framework from HumanLayer, not referenced in VS Code/GitHub documentation - flagged 2026-01-25 -->

Iron Law discipline aligns with key 12-Factor Agents principles:

| Factor | Principle | Iron Law Application |
|--------|-----------|----------------------|
| **6** | Launch/Pause/Resume | Design for asynchronous workflows, human checkpoints on violation |
| **7** | Contact Humans with Tool Calls | Make human escalation a first-class action when Iron Law at risk |
| **8** | Own Your Control Flow | Don't surrender loop control to AI; instrument it with Iron Law checks |

## Official VS Code TDD Integration

VS Code's [Test-Driven Development Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) provides official support for Iron Law-style workflows:

| VS Code TDD Feature | Iron Law Application |
|---------------------|---------------------|
| **Red-Green-Refactor cycle** | Maps to "NO CODE WITHOUT FAILING TEST" law |
| **Agent handoffs** | Control points between TDD phases |
| **Pitfalls documentation** | Officially documents rationalization patterns |
| **Tool approval** | Native verification gates via `chat.tools.autoApprove` |

### Creating TDD Agents with Handoffs

```yaml
---
name: tdd-red
description: Write failing test for new functionality
tools: ['read', 'edit', 'search']
handoffs:
  - agent: tdd-green
    description: Implementation ready after test written
---

# Red Phase Agent

## Iron Law
\`\`\`
WRITE FAILING TEST BEFORE ANY IMPLEMENTATION
\`\`\`

## Workflow
1. Write test describing desired behavior
2. Run test — confirm it fails
3. Hand off to Green phase
```

## Related

- [verification-gates](verification-gates.md) — Evidence-before-claims protocol
- [hallucination-reduction](hallucination-reduction.md) — "I don't know" permission, grounding techniques
- [constraint-hierarchy](constraint-hierarchy.md) — Where Iron Law fits in priority stack
- [constitutional-principles](constitutional-principles.md) — Defining immutable rules
- [iron-law-verification](../RED-TEAM/iron-law-verification.md) — Anti-sycophancy checks
- [critique-template](../RED-TEAM/critique-template.md) — `.critique.md` format for violations
- [approval-gates](../CHECKPOINTS/approval-gates.md) — Escalation on violation
- [riper-modes](../WORKFLOWS/riper-modes.md) — Permission boundaries per mode

## Sources

### Official Documentation
- [VS Code TDD Guide](https://code.visualstudio.com/docs/copilot/guides/test-driven-development-guide) — Official red-green-refactor workflow with agent handoffs and pitfalls
- [GitHub Tool Aliases](https://docs.github.com/en/copilot/reference/custom-agents-configuration#tool-aliases) — Official tool names (`execute`, `read`, `edit`, `search`)
- [VS Code Security](https://code.visualstudio.com/docs/copilot/security) — Tool approval and trust boundaries
- [GitHub Best Practices](https://docs.github.com/en/copilot/get-started/best-practices#check-copilots-work) — "Check Copilot's work" verification guidance

### Community Patterns
- [obra/superpowers](https://github.com/obra/superpowers) — Primary source for Iron Law, Red Flags, and Rationalization Tables patterns
- [Anthropic Claude Constitution (Jan 2026)](https://www.anthropic.com/constitution) — "Hard constraints" concept parallels Iron Law; honesty principles address sycophancy
- [Sycophancy in LLMs (arxiv 2411.15287)](https://arxiv.org/abs/2411.15287) — Comprehensive survey of sycophancy causes, measurement, and mitigations
- [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) — Factor 7/8 for human escalation and control flow ownership
