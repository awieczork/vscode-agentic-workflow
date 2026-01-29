---
type: patterns
version: 1.0.0
purpose: Defines THE framework approach to context engineering, verification, hallucination prevention, and red-team review
applies-to: [generator, build, inspect, architect, brain]
last-updated: 2026-01-28
---

# Quality Patterns

> **Ensure agent outputs are correct, verifiable, and free from hallucination through systematic quality engineering.**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Apply quality hierarchy to all context decisions
2. Include hallucination prevention rules in generated agent instructions
3. Embed verification gates appropriate to agent purpose

**For Build Agents:**
1. Follow Evidence-First format for all claims
2. Verify before claiming completion
3. Request compaction when approaching utilization limits

**For Inspect Agents:**
1. Run Four Modes review (Security, Logic, Bias, Completeness)
2. Check for sycophancy indicators
3. Verify evidence supports all claims

---

## PURPOSE

Quality patterns solve three critical problems:

1. **Context Rot** — Agent performance degrades as context window fills with noise
2. **Hallucination** — Agents confidently state false information without evidence
3. **Verification Gaps** — Agents claim completion without proof

The "leverage model" explains why quality matters:

```
Bad research line    → 1000s of bad code lines
Bad plan line        → 100s of bad code lines
Bad code line        → 1 bad code line

∴ Quality at high-leverage phases prevents multiplicative downstream errors
```

---

## THE FRAMEWORK APPROACH

Quality is achieved through four complementary systems:

| System | Purpose | Primary Technique |
|--------|---------|-------------------|
| **Context Engineering** | Maintain useful context window | Quality hierarchy + utilization targets |
| **Hallucination Prevention** | Prevent false claims | Evidence-First + uncertainty permission |
| **Verification Gates** | Prove work is complete | Evidence before claims |
| **Red-Team Review** | Catch systematic errors | Four Modes framework |

---

## CONTEXT ENGINEERING

### Quality Hierarchy (Non-Negotiable)

All context decisions MUST follow this priority order:

```
PRIORITY_ORDER:
  1. ⭐⭐⭐⭐ CORRECTNESS — No false information
  2. ⭐⭐⭐   COMPLETENESS — All relevant info for THIS decision
  3. ⭐⭐     SIZE — Minimal noise
  4. ⭐       TRAJECTORY — Heading toward goal

CONFLICT_RESOLUTION:
  IF correctness conflicts with size
    THEN → sacrifice size (include the context)
  IF completeness conflicts with size
    THEN → sacrifice size (include the context)
  IF size conflicts with trajectory
    THEN → sacrifice trajectory (manage via compaction)
```

**Key insight:** Too much noise is the *least bad* problem. Agents can filter noise but cannot recover from missing data or false beliefs.

### Utilization Targets

| Range | Status | Action |
|-------|--------|--------|
| <40% | Underutilized | Add relevant context |
| **40-60%** | **Optimal** | Ideal zone for complex tasks |
| 60-80% | Heavy | Monitor for quality degradation |
| >80% | Overloaded | Split into phases immediately |
| >90% | Critical | Emergency compaction |
| 100% | Auto-compaction | Save state to file, fresh session |

> **Platform Note:** VS Code does not expose token counts. Use proxy signals: response slowdown, repeated suggestions, "Summarized conversation history" message. 40-60% target is community guideline from HumanLayer ACE.

### Compaction Triggers

```
COMPACT_WHEN:
  trigger: phase_completion
    action: Write summary (~200 lines), fresh session

  trigger: utilization_above_60%
    action: Proactive compaction to file, reload essentials

  trigger: summarized_history_message
    action: Already at 100%, save state, fresh session

  trigger: quality_degradation
    signals: [repeated_suggestions, response_slowdown, context_amnesia]
    action: Save state, fresh session, reload minimal context

  trigger: topic_switch
    action: New session with relevant context only
```

### Compaction Strategies

| Strategy | When to Use | Output Target |
|----------|-------------|---------------|
| **Phase-Based (FIC)** | Between Research → Plan → Implement | ~200 lines summary |
| **Subagent Offloading** | Exploration-heavy tasks | Subagent returns <100 line summary |
| **Manual Clear + Reload** | Mid-session quality drop | Save state → Ctrl+N → reload essentials |
| **Tool Result Clearing** | After processing tool output | Extract findings, discard raw output |

### Context Loading Rules

```
RULE_CE001: Progressive Disclosure
  REQUIRE: Load context on-demand, not upfront
  PATTERN: #selection → #file → #codebase (escalate only when needed)
  RATIONALE: Pay-as-you-go keeps utilization in optimal range

RULE_CE002: Lightweight Identifiers
  REQUIRE: Keep file paths, queries, URLs in context
  REQUIRE: Retrieve full content just-in-time
  RATIONALE: Pointers cost near-zero tokens

RULE_CE003: Fresh Reads Before Decisions
  REQUIRE: Read actual file content before claiming anything about code
  REJECT_IF: Describing code from memory or assumption
  RATIONALE: Stale context causes CORRECTNESS failures

RULE_CE004: Context Isolation
  REQUIRE: Separate sessions for different work types (planning, coding, testing)
  RATIONALE: Prevents context mixing and trajectory confusion
```

### Graceful Degradation Protocol

```
AT_90_PERCENT:
  1. Alert: "Context approaching limit"
  2. Action: Emergency compaction — summarize to essentials
  3. Continue with minimal context

AT_100_PERCENT:
  1. Alert: "Context limit reached"
  2. Action: Write full state to memory-bank file
  3. Start fresh session
  4. Reload: Instructions + state file + current focus only
```

---

## HALLUCINATION PREVENTION

### Core Principle

```
NEVER claim without evidence. When uncertain, say so.
```

### Evidence-First Format

All factual claims MUST use Quote → Claim format:

```markdown
✅ CORRECT (Evidence-First):
**Evidence:**
> "UserService.authenticate() returns null on invalid credentials"
> — src/services/user.ts#L45

**Claim:** The authentication returns null rather than throwing an exception.

❌ INCORRECT (Claim-First):
The auth module validates tokens using JWT verification.
(No evidence provided)
```

### Tiered Evidence Requirements

| Claim Type | Evidence Requirement | Rationale |
|------------|---------------------|-----------|
| **High-stakes** (security, data loss, >3 files) | MUST provide evidence | Errors cascade multiplicatively |
| **Implementation claims** | SHOULD provide evidence | Verifiable reduces debugging |
| **Routine/conversational** | MAY omit evidence | Friction outweighs benefit |

### Uncertainty Permission

Every agent MUST include explicit uncertainty permission:

```xml
<uncertainty_handling>
When you don't have enough information to answer confidently:
- Say "I don't know" or "I'm not certain"
- Explain what information would help
- Never fabricate plausible-sounding answers

This applies even when the user expects an answer.
Abstention is preferable to hallucination.
</uncertainty_handling>
```

### Investigate-First Rule

```
RULE_HR001: Investigate Before Answering
  REQUIRE: Read relevant files BEFORE answering codebase questions
  REQUIRE: Find implementation BEFORE describing behavior
  REQUIRE: Run tests BEFORE claiming results
  REJECT_IF: Speculating about unread code
  REJECT_IF: Claiming code exists without showing it

FORBIDDEN_ACTIONS:
  - Claiming code exists without showing it
  - Describing behavior without reading implementation
  - Stating test results without running tests
  - Explaining patterns based on "typical" implementations
```

### Anti-Sycophancy Protocol

Sycophancy (agreeing with user to please them) is a hallucination vector.

**Warning Signs:**
- About to agree with user's assertion without checking
- User's framing conflicts with what you observed
- Softening a finding to avoid disappointing user
- User expresses strong preference and you're inclined to agree

**Sycophancy Checklist (run when triggered):**

```
TRIGGER_CONDITIONS:
  - User pushes back on agent's finding
  - Claim affects >3 files
  - Involves security or data handling
  - User expresses strong preference

CHECKLIST:
  □ Would this decision change if user wanted the opposite?
  □ Have I disagreed with user at least once this session (when warranted)?
  □ Am I citing principles BEFORE decisions, not AFTER as justification?
  □ Am I considering ALL relevant guidelines, not just supporting ones?
  □ If a different user made this request, would the output be identical?

VERDICT:
  All YES → Proceed
  Any NO → Re-evaluate decision independent of user preference
```

### Retraction Protocol

```
RULE_HR002: Retract Unsupported Claims
  WHEN: Claim made without evidence found
  THEN: Explicitly retract: "I stated X, but I cannot find supporting evidence for this"
  RATIONALE: No unverified claims in final output
```

---

## VERIFICATION GATES

### Core Principle

```
NEVER claim completion without verifiable evidence.
Evidence before claims, always.
```

### Gate Types

| Type | Verification Method | Evidence Required |
|------|---------------------|-------------------|
| **Command-Based** | Execute command, read FULL output | Command + output + pass/fail |
| **Checklist-Based** | Confirm each criterion | Boolean checks with evidence per item |
| **Comparison-Based** | Match against specification | Criterion → Evidence → ✅/❌ |
| **Output-Based** | Check produced artifacts | File existence, sizes, contents |
| **TDD (Red-Green)** | Test fails THEN passes | FAIL output before, PASS output after |

### Verification Rules

```
RULE_VG001: Full Output Reading
  REQUIRE: Read complete command output, not just exit code
  REJECT_IF: "Test returned 0" without reading actual output
  RATIONALE: Exit codes hide failures in output

RULE_VG002: All Tests Must Pass
  REQUIRE: 100% of relevant tests pass for completion claim
  REJECT_IF: "Most tests pass" or "Only minor failures"
  RATIONALE: One failure invalidates completion

RULE_VG003: Fresh Verification
  REQUIRE: Evidence from current run, not previous
  REJECT_IF: Citing stale evidence from earlier execution
  RATIONALE: State may have changed

RULE_VG004: Red-Before-Green (TDD)
  REQUIRE: Test MUST fail before fix is implemented
  REQUIRE: Capture FAIL output as evidence
  REJECT_IF: Test passes immediately without ever failing
  RATIONALE: Immediate pass proves nothing about the fix
```

### Verification Failure Protocol

```
ON_VERIFICATION_FAILURE:
  1. Report honestly with actual output
  2. Do NOT claim partial success
  3. Do NOT proceed to next step
  4. Determine: fix issue OR escalate OR report blocker
  5. Re-verify after fix (same gate, same criteria)
```

### Dual Review Order

For implementation review, apply in this sequence:

```
REVIEW_ORDER:
  1. SPEC_COMPLIANCE (First)
     Question: Does implementation match requirements?
     Prerequisite: None

  2. CODE_QUALITY (Second)
     Question: Is code maintainable, secure, performant?
     Prerequisite: Spec compliance passed

RATIONALE: Reviewing quality of wrong implementation wastes effort
```

### Abstention Over Fabrication

```
RULE_VG005: Abstention Preferred
  WHEN: Verification cannot produce confident results
  THEN:
    - Say "I don't know" or "I'm not sure"
    - Offer to investigate further
    - Route to clarification or escalate
  REJECT_IF: Fabricating confidence when uncertain
  RATIONALE: Abstention > hallucination
```

---

## RED-TEAM REVIEW

### Four Modes Framework

Every significant output SHOULD be challenged across four dimensions:

| Mode | Focus | Primary Questions |
|------|-------|-------------------|
| 🔒 **Security** | Vulnerabilities, data leakage | "Can this leak sensitive data?" "How could an attacker misuse this?" |
| 🧠 **Logic** | Accuracy, hallucination | "Is this conclusion supported by evidence?" |
| ⚖️ **Bias** | Fairness, sycophancy | "Would this advice change based on who's asking?" |
| 📋 **Completeness** | Coverage, edge cases | "What scenarios aren't covered?" |

### Severity Levels

| Severity | Definition | Action | SLA |
|----------|-----------|--------|-----|
| 🔴 **Critical** | Security breach, data leak, P1 violation | Halt immediately | Now |
| 🟠 **High** | Logic error, incorrect critical output | Pause, require approval | 1 hour |
| 🟡 **Medium** | Bias detected, partial coverage | Flag, continue with warning | 24 hours |
| 🟢 **Low** | Minor gaps, style issues | Log, batch review | Weekly |
| ✅ **Pass** | No issues found | Continue workflow | — |

### Iron Law Violation Detection

| Signal | Indicates | Action |
|--------|-----------|--------|
| Principle cited AFTER decision | Post-hoc rationalization | Re-evaluate decision |
| Only supporting principles cited | Selective citation | List ALL principles (for and against) |
| Agent never disagrees with user | Active sycophancy | Run anti-sycophancy checklist |
| "This is a special case" reasoning | Rationalization attempt | Apply guidelines first, discuss exceptions after |

### Red-Team Agent Configuration

```yaml
# Red-team agents MUST be restricted to read-only tools
tools:
  - readFile
  - textSearch
  - codebase
  - fileSearch
  - usages
  - problems

# If write access needed, request sandboxed build via @build with explicit scope
```

### Verification Verdict

| Verdict | Criteria | Action |
|---------|----------|--------|
| **PASS** | Principles clearly guided decision | Continue workflow |
| **WARN** | Potential rationalization detected | Human review required |
| **FAIL** | Clear violation detected | Decision MUST be revised |

---

## VALIDATION CHECKLIST

```
VALIDATE_quality_patterns:
  ## Context Engineering
  □ Quality hierarchy applied (Correctness > Completeness > Size > Trajectory)
  □ Utilization estimated and within 40-60% (or compaction planned)
  □ Files read fresh before major decisions
  □ Different work types in separate sessions

  ## Hallucination Prevention
  □ Uncertainty permission included in agent instructions
  □ High-stakes claims have Evidence-First format
  □ No speculation about unread code
  □ Anti-sycophancy checklist available for triggers

  ## Verification
  □ Completion claims have verifiable evidence
  □ Full output read (not just exit codes)
  □ TDD tests fail before fix, pass after
  □ Spec compliance checked before code quality

  ## Red-Team
  □ Four Modes considered (Security, Logic, Bias, Completeness)
  □ Severity → Action mapping followed
  □ Red-team agent uses read-only tools
  □ Principles cited BEFORE decisions
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Pre-load all files upfront | Progressive disclosure | Wastes context budget before work begins |
| "Test returned 0" as verification | Read FULL test output | Exit codes hide failures |
| Describe code without reading it | Investigate-First | Speculation compounds errors |
| Agree to please user | Verify against evidence | Sycophancy is hallucination vector |
| Cite principle AFTER decision | Cite BEFORE deciding | Post-hoc = rationalization |
| "Most tests pass" = success | ALL tests must pass | Partial = failure |
| Keep verbose history | Summarize decisions | History crowds out useful context |
| Same session for all work types | Separate by type | Prevents context mixing |
| Wait for auto-compaction | Proactive at 60% | Reactive loses control |
| Fabricate when uncertain | Say "I don't know" | Abstention > hallucination |

---

## KNOWN LIMITATIONS

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| No native token visibility | Cannot precisely measure utilization | Use proxy signals (slowdown, summarization message) |
| 40-60% is community guideline | Not officially validated by VS Code | Conservative threshold; official auto-compaction is backstop |
| No enforcement mechanism | Gates are instructions, not runtime checks | Design for agent compliance; human review for critical |
| Confidence thresholds subjective | Cannot objectively measure 80%/50% | Use examples: "High = would bet reputation" |
| Subagent context size unspecified | Cannot precisely plan offloading | Assume independent; return summaries <100 lines |

---

## RECOVERY PROTOCOLS

### Compaction Failure Recovery

```
IF compaction_lost_critical_context:
  1. Identify: What decision/state was lost?
  2. Re-read: Original source files
  3. Re-derive: Decision from fresh evidence
  4. Document: "Re-derived D{n} due to compaction loss"
  5. Continue: With fresh context
```

### Invalid Decision Recovery

```
IF decision_found_invalid:
  1. Strike: Mark decision as invalid with reason
  2. Document: What evidence disproved it
  3. Re-derive: From corrected understanding
  4. Propagate: Check downstream decisions for impact
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | Component selection affects quality requirements |
| [agent-patterns.md](agent-patterns.md) | Agent structure includes quality sections |
| [RULES.md](../RULES.md) | Cross-cutting rules reference quality hierarchy |
| [CHECKLISTS/quality-checklist.md](../CHECKLISTS/quality-checklist.md) | Executable verification of these patterns |

---

## SOURCES

| Source | What Was Extracted |
|--------|-------------------|
| [context-quality.md](../../cookbook/CONTEXT-ENGINEERING/context-quality.md) | Quality hierarchy, leverage model, degradation signals |
| [utilization-targets.md](../../cookbook/CONTEXT-ENGINEERING/utilization-targets.md) | 40-60% target, compaction triggers, hard limits |
| [compaction-patterns.md](../../cookbook/CONTEXT-ENGINEERING/compaction-patterns.md) | FIC methodology, compaction strategies, ~200 line target |
| [hallucination-reduction.md](../../cookbook/PATTERNS/hallucination-reduction.md) | Evidence-First, uncertainty permission, anti-sycophancy |
| [verification-gates.md](../../cookbook/PATTERNS/verification-gates.md) | Gate types, TDD protocol, abstention principle |
| [four-modes.md](../../cookbook/RED-TEAM/four-modes.md) | Four Modes framework, severity levels, iron law detection |
| [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) | 40-60% utilization target (community) |
| [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) | Context isolation, anti-patterns (official) |
| [obra/superpowers](https://github.com/obra/superpowers) | Dual review order (community) |
