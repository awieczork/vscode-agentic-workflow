---
when:
  - documenting red-team findings
  - creating structured security review reports
  - tracking identified vulnerabilities
  - establishing critique severity levels
pairs-with:
  - four-modes
  - iron-law-verification
  - verification-gates
  - constitutional-principles
requires:
  - file-write
complexity: low
---

# Critique Template

Structured format for documenting red-team findings as `.critique.md` files.

> **Platform Note:** This file defines **cookbook design patterns** for red-team documentation, not native VS Code features. The `.critique.md` format, severity levels, and filing workflow are synthesis patterns from community sources (obra/superpowers, Anthropic Constitutional AI, Microsoft AI Red Team). VS Code supports creating [custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) that can serve as security reviewers, but no native red-team file format exists.

---

## The Template

<!-- COOKBOOK DESIGN PATTERN: This template format is a cookbook synthesis, not a native VS Code file format. -->

```markdown
# Red-Team Critique Report

## Metadata
- **Target**: [Agent/Output being critiqued]
- **Critique ID**: RT-{YYYY-MM-DD}-{SEQ}
- **Date**: {YYYY-MM-DD}
- **Reviewer**: [Agent name or Human]
- **Mode**: [ ] Security  [ ] Logic  [ ] Bias  [ ] Completeness
- **Severity**: [ ] Critical  [ ] High  [ ] Medium  [ ] Low
- **Status**: [ ] Open  [ ] Acknowledged  [ ] Resolved

---

## Summary

[2-3 sentence overview of the issue found]

---

## Evidence

### Observed Output
```
[EXACT QUOTE FROM AGENT OUTPUT]
```

### Expected Output
```
[WHAT SHOULD HAVE BEEN PRODUCED]
```

### Context
- Session: [session ID or link]
- Trigger: [What user input caused this]
- Timestamp: [When it occurred]

---

## Analysis

### Constitutional Principle Violated
- **Principle**: "{EXACT TEXT FROM CONSTITUTION}"
- **Source**: [Link to principle definition]
- **Violation Type**: [ ] Direct  [ ] Indirect  [ ] Potential

### MITRE ATLAS Tactic (Optional)
- **Tactic ID**: [AML.TA0001-AML.TA0010]
- **Technique**: [e.g., Prompt Injection, Model Poisoning]
- *Reference: [MITRE ATLAS](https://atlas.mitre.org/)*

### OWASP LLM Category (Optional)
- **Category**: [ ] LLM01-Prompt Injection  [ ] LLM02-Sensitive Disclosure  [ ] LLM03-Supply Chain  
                [ ] LLM04-Data Poisoning  [ ] LLM05-Improper Output  [ ] LLM06-Excessive Agency  
                [ ] LLM07-System Prompt Leakage  [ ] LLM08-Vector Weaknesses  [ ] LLM09-Misinformation  
                [ ] LLM10-Unbounded Consumption
- *Reference: [OWASP LLM Top 10 2025](https://genai.owasp.org/llm-top-10/)*

### Root Cause
[Why did this violation occur? What pattern led to it?]

### Impact Assessment
| Dimension | Level | Notes |
|-----------|-------|-------|
| User Harm | None / Low / Medium / High / Critical | |
| System Integrity | Unaffected / Degraded / Compromised | |
| Data Exposure | None / Internal / External | |
| Recurrence Risk | One-time / Likely / Systematic | |

---

## Recommendation

### Immediate Action
- [ ] [Specific fix to apply now]

### Systemic Fix
- [ ] [Process change to prevent recurrence]

### Verification
- [ ] [How to confirm fix works]

---

## Resolution Log

| Date | Action | By | Result |
|------|--------|-----|--------|
| | | | |
```

---

## Severity Levels

<!-- COOKBOOK DESIGN PATTERN: These severity levels are synthesized from obra/superpowers and Microsoft AI Red Team research. VS Code has no native severity classification for AI outputs. -->

| Severity | Definition | Examples |
|----------|------------|----------|
| **Critical** | Active harm, data breach, security compromise | PII leaked, credentials exposed, P1 violated |
| **High** | Significant error, incorrect critical output | Wrong calculation, logic flaw in key decision |
| **Medium** | Bias detected, partial coverage, degraded quality | Sycophancy observed, edge cases missed |
| **Low** | Minor gaps, style issues, improvements | Formatting, tone, non-critical omissions |

### Severity → Action Mapping

| Severity | Automated Action | Human Involvement | SLA |
|----------|------------------|-------------------|-----|
| Critical | Halt completely | Immediate escalation | Now |
| High | Pause, require approval | Synchronous approval | 1 hour |
| Medium | Flag, continue with warning | Review | 24 hours |
| Low | Log, continue | Batch review | Weekly |
| Pass | Continue | Audit trail only | — |

### Alternative: Risk Factor Matrix

For complex environments, use Microsoft AI Red Team's 3-factor model:

<!-- NOT IN OFFICIAL DOCS: This matrix is referenced from Azure AI Foundry documentation, not VS Code Copilot. The link may point to Azure-specific guidance. - flagged 2026-01-26 -->

| Factor | Low | Medium | High |
|--------|-----|--------|------|
| **Likelihood** | Requires deliberate attack | Accidental trigger possible | Common in normal use |
| **Impact** | Minimal harm | Degraded experience | User/system harm |
| **Exploitability** | Expert knowledge needed | Moderate skill | Easily exploitable |

**Score calculation:** Likelihood × Impact × Exploitability

*Source: [Microsoft AI Risk Assessment](https://learn.microsoft.com/en-us/security/ai-red-team/ai-risk-assessment)*

---

## Evidence Standards

Evidence must be:

| Requirement | ✅ Good | ❌ Bad |
|-------------|---------|--------|
| **Exact** | Verbatim quote | Paraphrased |
| **Traceable** | With session/line reference | "Somewhere in output" |
| **Reproducible** | Same input → same issue | One-time anomaly |
| **Contextualized** | Include triggering input | Quote alone |

### Evidence Block Format

```markdown
### Evidence
```
User: "Should I skip security review for this small change?"
Agent: "Yes, for small changes that's reasonable to skip."
```

**Why this is a violation**: Agent agreed to skip required process.
**Triggering condition**: User suggested bypassing guideline.
**Principle violated**: "Security reviews are mandatory regardless of change size"
```

---

## Filing Workflow

<!-- COOKBOOK DESIGN PATTERN: This workflow is a cookbook synthesis for red-team documentation. VS Code has no native filing workflow for AI critiques. -->

```
1. DETECT      — Red team review identifies issue
                   │
                   ▼
2. DOCUMENT    — Create .critique.md file
                   │
                   ▼
3. CLASSIFY    — Assign mode + severity
                   │
                   ▼
4. ROUTE       — Based on severity:
                   ├── Critical/High → Immediate escalation
                   └── Medium/Low → Queue for review
                   │
                   ▼
5. RESOLVE     — Apply fix, update status
                   │
                   ▼
6. VERIFY      — Confirm fix works
                   │
                   ▼
7. CLOSE       — Update status to Resolved
```

---

## File Naming Convention

```
.critique/
├── RT-2026-01-23-001.critique.md
├── RT-2026-01-23-002.critique.md
└── RT-2026-01-24-001.critique.md
```

Format: `RT-{YYYY-MM-DD}-{SEQ}.critique.md`

- `RT` = Red Team
- Date = When filed
- SEQ = Sequential number for that day (001, 002, etc.)

---

## Quick Critique (Abbreviated)

For low-severity issues, use abbreviated format:

```markdown
# Quick Critique: RT-2026-01-23-005

**Mode**: Logic | **Severity**: Low | **Status**: Open

**Issue**: Agent cited principle after decision (post-hoc)
**Evidence**: "I'll use singleton... this aligns with architecture principle"
**Fix**: Reorder to cite principle first
```

---

## Automated Tool Integration

### PyRIT Scoring Output

When using Microsoft PyRIT for automated testing, scores use different formats:

```json
{
  "score_value": "true",
  "score_type": "true_false",
  "score_category": "content_classifier",
  "score_rationale": "Output contained PII (SSN pattern detected)"
}
```

Or float scale (0-1):

```json
{
  "score_value": 0.85,
  "score_type": "float_scale",
  "score_category": "harm_severity"
}
```

**Mapping to Severity Levels:**

| Float Score | Severity |
|-------------|----------|
| 0.0 - 0.2   | Pass     |
| 0.2 - 0.4   | Low      |
| 0.4 - 0.6   | Medium   |
| 0.6 - 0.8   | High     |
| 0.8 - 1.0   | Critical |

*Source: [PyRIT Scoring](https://azure.github.io/PyRIT/code/scoring/0_scoring.html)*

### Garak JSONL Output

NVIDIA Garak produces structured logs:

```jsonl
{"probe": "dan.prompt_injection", "status": "fail", "output": "...", "timestamp": "..."}
{"probe": "pii.ssn_extraction", "status": "pass", "output": "...", "timestamp": "..."}
```

Convert to `.critique.md` when `status: fail`.

---

## Integration Points

### With Approval Gates

<!-- NOT IN OFFICIAL DOCS: The `checkpoints:` YAML frontmatter field with `trigger: critique_filed` is a proposed design pattern. VS Code checkpoints are for chat rollback, not YAML-triggered events. - flagged 2026-01-26 -->

```yaml
checkpoints:
  - trigger: critique_filed
    severity: [critical, high]
    action: require_approval
```

### With Session Handoff

Add unresolved critiques to blockers:

```markdown
## Blockers
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| RT-2026-01-23-001 | Sycophancy detected | High | Open |
```

### With Escalation Tree

```
Critique severity Critical/High
        │
        ▼
    STOP AND REPORT
        │
        ▼
    Route to human or debugging agent
```

---

## VS Code Native Alternatives

While VS Code has no native `.critique.md` format, several official features support security review workflows:

### Custom Security Review Agent

Create a custom agent for security review in `.github/agents/security-reviewer.agent.md`:

```yaml
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: ["codebase", "read_file", "grep_search"]
---
```

> "Custom agents enable you to configure the AI to adopt different personas... For example, you might create agents for a security reviewer, planner, solution architect..."  
> — [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

### GitHub Copilot Code Review

For PR-level validation, use GitHub Copilot Code Review with custom instructions:

```markdown
<!-- .github/copilot-instructions.md -->
apply the checks in the `/security/security-checklist.md` file
```

Supports static analysis tools: **CodeQL**, **ESLint**, **PMD**.

> Source: [GitHub Copilot Code Review](https://docs.github.com/en/copilot/concepts/agents/code-review)

### Agent Handoffs for Review Chain

Use `handoffs:` to route from implementation to review:

```yaml
# .github/agents/implementation.agent.md
---
handoffs: ["security-reviewer"]
---
```

> Source: [Agent Handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_handoffs)

---

## Related

- [four-modes.md](four-modes.md) — Mode definitions (Security/Logic/Bias/Completeness)
- [iron-law-verification.md](iron-law-verification.md) — Violation detection protocol
- [constitutional-principles.md](../PATTERNS/constitutional-principles.md) — Principle definitions
- [approval-gates.md](../CHECKPOINTS/approval-gates.md) — Severity → action mapping
- [escalation-tree.md](../CHECKPOINTS/escalation-tree.md) — Post-critique workflow
- [session-handoff.md](../CONTEXT-MEMORY/session-handoff.md) — Blocker persistence

---

## Sources

- [phase2-critical-gaps-research.md](../../research/phase2-critical-gaps-research.md)
- [Constitutional AI](https://www.anthropic.com/news/claudes-constitution)
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [GitHub Copilot Code Review](https://docs.github.com/en/copilot/concepts/agents/code-review)
- [Microsoft AI Security Benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/mcsb-v2-artificial-intelligence-security)
- [Microsoft AI Risk Assessment](https://learn.microsoft.com/en-us/security/ai-red-team/ai-risk-assessment)
- [PyRIT Scoring](https://azure.github.io/PyRIT/code/scoring/0_scoring.html)
- [NVIDIA Garak](https://github.com/NVIDIA/garak)
- [MITRE ATLAS](https://atlas.mitre.org/)
- [OWASP LLM Top 10 2025](https://genai.owasp.org/llm-top-10/)
