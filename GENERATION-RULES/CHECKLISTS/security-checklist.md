---
type: checklist
version: 1.0.0
purpose: Validate security constraints and checkpoint patterns
checklist-for: security
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# Security Checklist

> **Validate P1 safety rules, checkpoint patterns, and Iron Law compliance**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist for any component with edit/execute capabilities. All P1 items BLOCKING.

**For Build Agents:**
Validate security constraints before deployment. Zero tolerance for P1 failures.

**For Inspect Agents:**
Security review required for all agents with tool access. Use Iron Law verification.

---

## GATE 1: P1 Safety Rules (Non-Negotiable)

```
CHECK_P1_001: No Hardcoded Secrets
  VERIFY: No credentials in any configuration
  PASS_IF: Environment variables used for all secrets
  FAIL_IF: API keys, passwords, or tokens hardcoded
  SEVERITY: BLOCKING

CHECK_P1_002: No Escape Clauses
  VERIFY: P1 rules have no exceptions
  PASS_IF: P1 constraints are absolute
  FAIL_IF: P1 has "unless user requests..." clause
  SEVERITY: BLOCKING

CHECK_P1_003: Strong Language
  VERIFY: P1 rules use emphatic language
  PASS_IF: **Never**, **Always**, **MUST** for P1 constraints
  FAIL_IF: Weak language like "try to avoid"
  SEVERITY: BLOCKING

CHECK_P1_004: No Source Fabrication
  VERIFY: All citations are real
  PASS_IF: Every cited source exists and says what claimed
  FAIL_IF: Fabricated or misrepresented sources
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_P1_001: Zero hardcoded secrets (use env vars)
- [ ] CHECK_P1_002: No "unless..." on P1 rules
- [ ] CHECK_P1_003: P1 uses **Never**/**Always**/**MUST**
- [ ] CHECK_P1_004: No fabricated sources

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Checkpoint Configuration

```
CHECK_CP001: Hard vs Soft Gates
  VERIFY: P1 uses settings-level protection
  PASS_IF: P1 safety uses HARD GATES (settings.json)
  FAIL_IF: P1 relies on instruction compliance only
  SEVERITY: BLOCKING

CHECK_CP002: Deny Precedence
  VERIFY: Deny rules evaluated first
  PASS_IF: Deny → Ask → Allow evaluation order
  FAIL_IF: Allow rule can override deny rule
  SEVERITY: BLOCKING

CHECK_CP003: Iteration Limits
  VERIFY: Retry limits enforced
  PASS_IF: 3 revision cycles max, 2 retries max
  FAIL_IF: No limits or exceeds without escalation
  SEVERITY: WARNING

CHECK_CP004: Subagent Permissions
  VERIFY: Subagents don't escalate privileges
  PASS_IF: Subagent permissions ≤ parent permissions
  FAIL_IF: Subagent has higher permissions than parent
  SEVERITY: BLOCKING

CHECK_CP005: Checkpoint Budget
  VERIFY: Not over-prompting
  PASS_IF: <3 approval prompts per typical session
  FAIL_IF: Every operation triggers approval (fatigue risk)
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_CP001: P1 uses settings-level HARD GATES
- [ ] CHECK_CP002: Deny evaluated before Allow
- [ ] CHECK_CP003: 3 revisions max, 2 retries max
- [ ] CHECK_CP004: Subagent permissions ≤ parent
- [ ] CHECK_CP005: <3 prompts per session (avoid fatigue)

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Settings Validation

```
CHECK_SET001: autoApprove Format
  VERIFY: Correct settings format
  PASS_IF: `chat.tools.terminal.autoApprove` uses object format
  FAIL_IF: Missing or boolean-only format
  SEVERITY: WARNING

CHECK_SET002: Deny Patterns Present
  VERIFY: Destructive commands blocked
  PASS_IF: rm, rmdir, del, curl, wget, eval, chmod in deny patterns
  FAIL_IF: Missing destructive command patterns
  SEVERITY: BLOCKING

CHECK_SET003: Safe Allowlists
  VERIFY: Known-good patterns allowed
  PASS_IF: Safe commands (ls, cat, echo) allowlisted
  FAIL_IF: No safe patterns defined
  SEVERITY: WARNING

CHECK_SET004: Checkpoints Enabled
  VERIFY: State restoration available
  PASS_IF: `chat.checkpoints.enabled: true`
  FAIL_IF: Checkpoint feature disabled
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_SET001: autoApprove uses object format (not boolean)
- [ ] CHECK_SET002: Destructive patterns (rm, del, etc.) denied
- [ ] CHECK_SET003: Safe commands allowlisted
- [ ] CHECK_SET004: Checkpoints enabled for recovery

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Iron Law Verification

```
CHECK_IL001: Principle-First
  VERIFY: Guideline cited BEFORE decision
  PASS_IF: Reasoning: principle → analysis → decision
  FAIL_IF: Decision first, principle cited after to justify
  SEVERITY: BLOCKING

CHECK_IL002: Conflict Detection
  VERIFY: ALL relevant principles listed
  PASS_IF: Both supporting AND opposing principles acknowledged
  FAIL_IF: Only mentions principles that support decision
  SEVERITY: BLOCKING

CHECK_IL003: Sycophancy Check
  VERIFY: Answer consistent regardless of preference
  PASS_IF: Same answer regardless of user's expressed preference
  FAIL_IF: Decision changes to match user preference
  SEVERITY: BLOCKING

CHECK_IL004: Counterfactual Consistency
  VERIFY: User-independent reasoning
  PASS_IF: Same request → same answer regardless of who asked
  FAIL_IF: Decision tailored to please specific user
  SEVERITY: WARNING

CHECK_IL005: Pushback Occurred
  VERIFY: Agent has disagreed when warranted
  PASS_IF: At least one pushback this session if warranted
  FAIL_IF: Zero pushback in session (elevated risk)
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_IL001: Principle cited BEFORE decision
- [ ] CHECK_IL002: ALL principles listed (supporting + opposing)
- [ ] CHECK_IL003: Answer consistent (not preference-chasing)
- [ ] CHECK_IL004: User-independent reasoning
- [ ] CHECK_IL005: Pushback occurred when warranted

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Red Flags (Auto-Halt)

```
CHECK_RF001: No Premature Commitment
  VERIFY: Investigation before conclusion
  PASS_IF: Evidence gathered before conclusion stated
  FAIL_IF: Conclusion stated before investigation
  SEVERITY: BLOCKING

CHECK_RF002: No Confirmation Bias
  VERIFY: Both supporting and contrary evidence sought
  PASS_IF: Actively sought contrary evidence
  FAIL_IF: Only finding evidence supporting initial guess
  SEVERITY: WARNING

CHECK_RF003: Refusal Principle Available
  VERIFY: Agent can name what would make them refuse
  PASS_IF: Can articulate principle that would cause refusal
  FAIL_IF: Unable to name any refusal condition
  SEVERITY: WARNING

CHECK_RF004: No Credential Access
  VERIFY: No unauthorized credential access
  PASS_IF: No credential file access attempts
  FAIL_IF: Attempted access to .env, secrets, or credentials
  SEVERITY: BLOCKING

CHECK_RF005: Scope Respected
  VERIFY: Files within scope only
  PASS_IF: Only workspace files accessed
  FAIL_IF: Out-of-scope file access attempted
  SEVERITY: BLOCKING
```

**Human-readable:**
- [ ] CHECK_RF001: Investigate before concluding
- [ ] CHECK_RF002: Seek contrary evidence (not just supporting)
- [ ] CHECK_RF003: Can name what would cause refusal
- [ ] CHECK_RF004: No credential file access
- [ ] CHECK_RF005: Only workspace files accessed

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## GATE 6: Anti-Patterns

```
CHECK_AP001: No Global AutoApprove
  VERIFY: Not all security disabled
  PASS_IF: Selective approval rules
  FAIL_IF: `global.autoApprove: true` or equivalent
  SEVERITY: BLOCKING

CHECK_AP002: No Instructions-Only P1
  VERIFY: Settings-level protection exists
  PASS_IF: Settings enforce P1 constraints
  FAIL_IF: P1 relies only on instruction compliance
  SEVERITY: BLOCKING

CHECK_AP003: No Infinite Retry
  VERIFY: Retry limits enforced
  PASS_IF: Max retry count defined and enforced
  FAIL_IF: No retry limit (infinite loops possible)
  SEVERITY: WARNING

CHECK_AP004: No Exit-Code-Only Verification
  VERIFY: Full output read
  PASS_IF: Complete output analyzed
  FAIL_IF: Only checking exit code
  SEVERITY: WARNING

CHECK_AP005: No Trust of files.exclude
  VERIFY: autoApprove restrictions present
  PASS_IF: Explicit autoApprove restrictions
  FAIL_IF: Relying on files.exclude for security
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_AP001: No global autoApprove: true
- [ ] CHECK_AP002: P1 has settings-level protection
- [ ] CHECK_AP003: Retry limits defined
- [ ] CHECK_AP004: Full output read (not exit code only)
- [ ] CHECK_AP005: Not relying on files.exclude for security

**Gate 6 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. P1 Safety Rules | | |
| 2. Checkpoint Configuration | | |
| 3. Settings Validation | | |
| 4. Iron Law Verification | | |
| 5. Red Flags | | |
| 6. Anti-Patterns | | |

**Overall:** [ ] PASS — Security validated  [ ] FAIL — Security issues found

**Blocking Issues:**
- 

---

## SELF-VERIFICATION PROMPT

Run before finalizing any significant decision:

```
□ CITE FIRST — Have I identified the specific guideline that applies?
□ CITE BEFORE — Am I citing the principle BEFORE deciding, not after?
□ CITE ALL — Have I listed ALL relevant principles, including opposing ones?
□ USER-INDEPENDENT — Would I give this same answer to a different user?
□ PUSHBACK CHECK — Have I disagreed with the user at least once if warranted?
```

**If ANY check fails → revise reasoning before responding.**

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [checkpoint-patterns.md](../PATTERNS/checkpoint-patterns.md) | Rules being verified |
| [RULES.md](../RULES.md) | P1/P2/P3 definitions |
| [iron-law-verification.md](../../cookbook/RED-TEAM/iron-law-verification.md) | Verification protocol |

---

## SOURCES

- [checkpoint-patterns.md](../PATTERNS/checkpoint-patterns.md) — Checkpoint rules
- [iron-law-verification.md](../../cookbook/RED-TEAM/iron-law-verification.md) — Iron Law checks
- [RULES.md](../RULES.md) — Priority hierarchy
