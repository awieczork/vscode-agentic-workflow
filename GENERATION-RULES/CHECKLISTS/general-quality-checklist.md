---
type: checklist
version: 1.0.0
purpose: Validate general quality standards across all components
checklist-for: quality
applies-to: [generator, build, inspect]
last-updated: 2026-01-28
---

# General Quality Checklist

> **Validate quality standards: context engineering, hallucination reduction, verification gates**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
Run this checklist after any significant output. Use Four Modes framework.

**For Build Agents:**
Validate outputs against quality standards before committing.

**For Inspect Agents:**
Use this checklist for comprehensive quality review. All four modes required.

---

## GATE 1: Context Engineering

```
CHECK_CE001: Progressive Disclosure
  VERIFY: Context loaded on-demand
  PASS_IF: Files loaded as needed, not pre-loaded
  FAIL_IF: All files loaded upfront
  SEVERITY: WARNING

CHECK_CE002: Lightweight Identifiers
  VERIFY: References instead of content
  PASS_IF: File paths, queries, URLs retained; content loaded JIT
  FAIL_IF: Full content stored when reference sufficient
  SEVERITY: WARNING

CHECK_CE003: Fresh Reads
  VERIFY: Actual file read before claims
  PASS_IF: File read immediately before describing content
  FAIL_IF: Describing code from memory/assumption
  SEVERITY: BLOCKING

CHECK_CE004: Context Isolation
  VERIFY: Separate sessions for different work
  PASS_IF: Planning, coding, testing in separate contexts
  FAIL_IF: Mixed work types in single session
  SEVERITY: WARNING

CHECK_CE005: Utilization Optimal (Proxy Signals)
  VERIFY: Context window at healthy utilization via proxy signals
  PASS_IF: No summarized history, no dropped context, responsive performance
  FAIL_IF: History summarized, context dropped, degraded performance
  SEVERITY: WARNING
  NOTE: VS Code does not expose token counts; use proxy signals
```

**Human-readable:**
- [ ] CHECK_CE001: Context loaded on-demand (not pre-loaded)
- [ ] CHECK_CE002: References kept, content loaded JIT
- [ ] CHECK_CE003: Files read before making claims about them
- [ ] CHECK_CE004: Different work types in separate sessions
- [ ] CHECK_CE005: Context utilization at 40-60%

**Gate 1 Result:** [ ] PASS  [ ] FAIL

---

## GATE 2: Hallucination Reduction

```
CHECK_HR001: Investigate First
  VERIFY: Read before answering
  PASS_IF: File read BEFORE answering codebase questions
  FAIL_IF: Speculating about unread code
  SEVERITY: BLOCKING

CHECK_HR002: Retract Unsupported
  VERIFY: Unverified claims retracted
  PASS_IF: Claims without evidence explicitly retracted
  FAIL_IF: Unverified claims in final output
  SEVERITY: BLOCKING

CHECK_HR003: Abstention Preferred
  VERIFY: Uncertainty acknowledged
  PASS_IF: "I don't know" when uncertain
  FAIL_IF: Fabricating confidence
  SEVERITY: BLOCKING

CHECK_HR004: Uncertainty Permission
  VERIFY: Agent allowed to express uncertainty
  PASS_IF: Instructions include uncertainty permission
  FAIL_IF: No "I don't know" permission documented
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_HR001: Read files BEFORE answering questions about them
- [ ] CHECK_HR002: Unsupported claims explicitly retracted
- [ ] CHECK_HR003: Says "I don't know" when uncertain
- [ ] CHECK_HR004: Agent instructions permit uncertainty

**Gate 2 Result:** [ ] PASS  [ ] FAIL

---

## GATE 3: Verification Gates

```
CHECK_VG001: Full Output Reading
  VERIFY: Complete command output read
  PASS_IF: Full output read and analyzed
  FAIL_IF: "Test returned 0" without reading output
  SEVERITY: BLOCKING

CHECK_VG002: All Tests Pass
  VERIFY: 100% relevant tests pass
  PASS_IF: All relevant tests pass
  FAIL_IF: "Most tests pass" accepted
  SEVERITY: BLOCKING

CHECK_VG003: Fresh Verification
  VERIFY: Evidence from current run
  PASS_IF: Evidence from current execution
  FAIL_IF: Citing stale evidence from previous runs
  SEVERITY: WARNING

CHECK_VG004: Red Before Green
  VERIFY: Test fails before fix
  PASS_IF: Test MUST fail before implementing fix
  FAIL_IF: Test passes immediately (no verification of fix)
  SEVERITY: WARNING

CHECK_VG005: Evidence First Format
  VERIFY: Quote before claim for high-stakes
  PASS_IF: Quote → Claim format for important decisions
  FAIL_IF: Claim-First without evidence
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_VG001: Full command output read (not just exit code)
- [ ] CHECK_VG002: 100% relevant tests pass (not "most")
- [ ] CHECK_VG003: Evidence from current run (not stale)
- [ ] CHECK_VG004: Test fails before fix (red-before-green)
- [ ] CHECK_VG005: Quote→Claim format for important decisions

**Gate 3 Result:** [ ] PASS  [ ] FAIL

---

## GATE 4: Four Modes Review

### 🔒 Security Mode

```
CHECK_SEC001: Data Exposure
  VERIFY: No PII or credentials in output
  PASS_IF: No sensitive data present
  FAIL_IF: PII, API keys, or credentials exposed
  SEVERITY: BLOCKING

CHECK_SEC002: Injection Risk
  VERIFY: User input validated
  PASS_IF: Inputs validated before execution
  FAIL_IF: Unvalidated user input in execution paths
  SEVERITY: BLOCKING

CHECK_SEC003: Architecture Leak
  VERIFY: No internal architecture exposed
  PASS_IF: Internal details not visible externally
  FAIL_IF: Architecture details exposed
  SEVERITY: WARNING
```

### 🧠 Logic Mode

```
CHECK_LOG001: Evidence Support
  VERIFY: Claims backed by citations
  PASS_IF: Each claim has cited evidence
  FAIL_IF: Claims without sources
  SEVERITY: WARNING

CHECK_LOG002: Assumption Explicit
  VERIFY: Assumptions stated
  PASS_IF: Assumptions explicitly documented
  FAIL_IF: Hidden prerequisites
  SEVERITY: WARNING

CHECK_LOG003: Request Alignment
  VERIFY: Output matches request
  PASS_IF: Deliverable matches what was asked
  FAIL_IF: Output misaligned with request
  SEVERITY: WARNING
```

### ⚖️ Bias Mode

```
CHECK_BIAS001: User Agnostic
  VERIFY: Same response regardless of user
  PASS_IF: Response wouldn't differ for different users
  FAIL_IF: Demographic-dependent advice
  SEVERITY: WARNING

CHECK_BIAS002: Principle Adherence
  VERIFY: Principles over preferences
  PASS_IF: Agent follows principles despite user pressure
  FAIL_IF: Agent agrees despite conflicting principles
  SEVERITY: BLOCKING

CHECK_BIAS003: Sycophancy Check
  VERIFY: Agent has pushed back when warranted
  PASS_IF: At least one disagreement this session if warranted
  FAIL_IF: Zero pushback patterns
  SEVERITY: WARNING
```

### 📋 Completeness Mode

```
CHECK_COMP001: Requirement Coverage
  VERIFY: All requirements addressed
  PASS_IF: Output addresses all stated requirements
  FAIL_IF: Missing spec items
  SEVERITY: WARNING

CHECK_COMP002: Edge Case Handling
  VERIFY: Edge cases covered
  PASS_IF: Boundary conditions handled
  FAIL_IF: Unhandled edge cases
  SEVERITY: WARNING

CHECK_COMP003: Error Coverage
  VERIFY: Error conditions covered
  PASS_IF: Error handling documented/implemented
  FAIL_IF: Silent failures possible
  SEVERITY: WARNING
```

**Human-readable Four Modes:**
- [ ] 🔒 Security: No data exposure, injection protected, architecture hidden
- [ ] 🧠 Logic: Evidence-backed, assumptions explicit, request-aligned
- [ ] ⚖️ Bias: User-agnostic, principle-adherent, not sycophantic
- [ ] 📋 Completeness: All requirements, edge cases, error handling

**Gate 4 Result:** [ ] PASS  [ ] FAIL

---

## GATE 5: Quality Hierarchy

```
CHECK_QH001: Priority Order
  VERIFY: Correct priority applied
  PASS_IF: Correctness > Completeness > Size > Trajectory
  FAIL_IF: Wrong priority (e.g., Size over Correctness)
  SEVERITY: WARNING

CHECK_QH002: Severity Action
  VERIFY: Actions match severity
  PASS_IF: Critical→Halt, High→Pause, Medium→Flag, Low→Log
  FAIL_IF: Wrong action for severity level
  SEVERITY: WARNING
```

**Human-readable:**
- [ ] CHECK_QH001: Correctness prioritized over other factors
- [ ] CHECK_QH002: Severity→Action mapping followed

**Gate 5 Result:** [ ] PASS  [ ] FAIL

---

## SUMMARY

| Gate | Status | Notes |
|------|--------|-------|
| 1. Context Engineering | | |
| 2. Hallucination Reduction | | |
| 3. Verification Gates | | |
| 4. Four Modes Review | | |
| 5. Quality Hierarchy | | |

**Overall:** [ ] PASS — Quality standards met  [ ] FAIL — Needs revision

**Blocking Issues:**
- 

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [quality-patterns.md](../PATTERNS/quality-patterns.md) | Rules being verified |
| [security-checklist.md](security-checklist.md) | Deeper security validation |
| [RULES.md](../RULES.md) | Priority hierarchy |

---

## SOURCES

- [quality-patterns.md](../PATTERNS/quality-patterns.md) — All RULE_NNN items
- [critique-template.md](../../cookbook/RED-TEAM/critique-template.md) — Four Modes framework
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Gate format
