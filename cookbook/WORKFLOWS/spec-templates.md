---
when:
  - creating project specifications
  - writing user stories with acceptance criteria
  - documenting requirements in standard format
  - using EARS or Gherkin notation
pairs-with:
  - spec-template
  - spec-driven
  - validation-checklist
  - telos-goals
requires:
  - none
complexity: medium
---

# Spec Templates

> **Platform Note:** These templates are from external community sources ([Spec-Kit](https://github.com/github/spec-kit), [TELOS](https://github.com/danielmiessler/Telos), [EARS](https://alistairmavin.com/ears/), [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents)). VS Code Copilot does not have native specification file formats—instead it uses `.prompt.md` files and custom agents. The built-in **Plan agent** (`@plan`) provides native planning capabilities. See [spec-driven](spec-driven.md) for how to use these templates with VS Code Copilot.

Copy-paste templates for specification-driven development. Use these templates to capture requirements before implementation—where human review has maximum leverage.

## Full .spec.md Template

Complete project specification with all 8 sections:

```yaml
---
name: "[PROJECT-NAME]"
version: "1.0.0"
created: "[YYYY-MM-DD]"
status: "draft"  # draft | review | approved | generating
type: "project-specification"

project_type: "[NEEDS CLARIFICATION: single|web|mobile|library|data-pipeline]"
domain: "[NEEDS CLARIFICATION: e.g., e-commerce, ML, DevOps, data-science]"
tech_stack:
  primary: "[NEEDS CLARIFICATION: e.g., Python, TypeScript, Rust]"
  frameworks: "[NEEDS CLARIFICATION: e.g., FastAPI, React, PyTorch]"
---

# Project Specification: [PROJECT-NAME]

## 1. Problem Statement (TELOS: Problems)

<!-- NOT IN OFFICIAL DOCS: TELOS framework is from danielmiessler/Telos, not native VS Code - flagged 2026-01-25 -->

### 1.1 What problem are you solving?
[Describe the core problem in 2-3 sentences]

### 1.2 Why does this problem matter?
[Business impact, user pain, opportunity cost]

### 1.3 Current Pain Points
- [Pain point 1]
- [Pain point 2]
- [Pain point 3]

## 2. Mission & Goals (TELOS: Mission/Goals)

<!-- NOT IN OFFICIAL DOCS: TELOS framework is external - flagged 2026-01-25 -->

### 2.1 Mission Statement
[One sentence: what this project will achieve]

### 2.2 Success Criteria (Measurable)
- [ ] [Metric 1: e.g., "Response time < 200ms"]
- [ ] [Metric 2: e.g., "99.9% uptime"]
- [ ] [Metric 3: e.g., "Support 10k concurrent users"]

## 3. Current State → Proposed State

### 3.1 Current State (What IS)
- [Current behavior/limitation 1]
- [Current behavior/limitation 2]
- [Current behavior/limitation 3]

### 3.2 Proposed State (What SHOULD BE)
- [Desired behavior 1]
- [Desired behavior 2]
- [Desired behavior 3]

## 4. User Stories & Requirements (EARS Format)

### US-001: [Title] (Priority: P1)
**As a** [user type]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria (EARS Notation):**
1. WHEN [condition/trigger], THE SYSTEM SHALL [expected behavior]
2. WHEN [condition/trigger], THE SYSTEM SHALL [expected behavior]

### US-002: [Title] (Priority: P2)
**As a** [user type]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria:**
1. WHEN [condition], THE SYSTEM SHALL [behavior]

### US-003: [Title] (Priority: P3)
[...]

## 5. Constraints & Boundaries

### 5.1 Hard Constraints (Non-Negotiable)
- MUST: [Absolute requirement]
- MUST NOT: [Prohibited action]

### 5.2 Preferences (Nice-to-Have)
- SHOULD: [Preferred approach]
- COULD: [Optional enhancement]

### 5.3 Out of Scope
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]

## 6. Challenges & Risks (TELOS: Challenges)

<!-- NOT IN OFFICIAL DOCS: TELOS framework is external - flagged 2026-01-25 -->

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Strategy] |
| [Risk 2] | High/Med/Low | High/Med/Low | [Strategy] |

## 7. Reference Resources

- [Link to existing docs]
- [Link to similar implementations]
- [Link to API documentation]

## 8. Clarification Log

<!-- Generator MUST NOT proceed until all [NEEDS CLARIFICATION] items resolved -->

| Item | Question | Answer | Resolved |
|------|----------|--------|----------|
| project_type | Single app, library, or service? | [PENDING] | [ ] |
| tech_stack | What language/framework? | [PENDING] | [ ] |
```

## TELOS-Lite Questionnaire

<!-- NOT IN OFFICIAL DOCS: "TELOS-Lite" is a cookbook adaptation of danielmiessler/Telos framework, not native VS Code - flagged 2026-01-25 -->

Quick intake form to gather spec inputs from stakeholders:

```markdown
# 🎯 Project Intake Questionnaire

*Questions marked with * are required*

## Section 1: Identity & Purpose
- Q1.1* What is your project called?
- Q1.2* In one sentence, what does this project do?
- Q1.3* What problem does this solve?

## Section 2: Goals & Success Metrics
- Q2.1* What does "success" look like? (measurable)
- Q2.2* What is your primary deadline?
- Q2.3 What are your stretch goals?

## Section 3: Current State
- Q3.1* Do you have an existing codebase? (yes/no, link if yes)
- Q3.2* Describe the current situation (what exists today)
- Q3.3 What works well that should be preserved?

## Section 4: Desired State
- Q4.1* Describe the ideal end state
- Q4.2* List 3 key capabilities the system must have
- Q4.3 What would "wow" look like?

## Section 5: Technical Context
- Q5.1* Primary programming language
- Q5.2* Key frameworks/libraries
- Q5.3* Target platform (web, mobile, desktop, cloud)
- Q5.4 External services/APIs to integrate

## Section 6: Constraints & Boundaries
- Q6.1* Absolute constraints (MUST/MUST NOT)
- Q6.2* What is explicitly OUT of scope?
- Q6.3 Budget/resource constraints

## Section 7: Preferences
- Q7.1 Preferred coding style or patterns
- Q7.2 Testing requirements (unit, integration, e2e)
- Q7.3 Documentation requirements
```

## EARS Quick Reference

<!-- NOT IN OFFICIAL DOCS: EARS (Easy Approach to Requirements Syntax) is from Alistair Mavin, not native VS Code. VS Code blogs mention "Gherkin specs" as an option. - flagged 2026-01-25 -->

EARS (Easy Approach to Requirements Syntax) provides unambiguous acceptance criteria:

| Pattern | Template | Example |
|---------|----------|---------|
| **Ubiquitous** | THE SYSTEM SHALL [behavior] | THE SYSTEM SHALL log all API requests |
| **Event-Driven** | WHEN [trigger], THE SYSTEM SHALL [behavior] | WHEN user clicks Submit, THE SYSTEM SHALL validate the form |
| **State-Driven** | WHILE [state], THE SYSTEM SHALL [behavior] | WHILE in maintenance mode, THE SYSTEM SHALL reject new connections |
| **Unwanted** | IF [condition], THEN THE SYSTEM SHALL [behavior] | IF authentication fails 3 times, THEN THE SYSTEM SHALL lock the account |
| **Optional** | WHERE [feature], THE SYSTEM SHALL [behavior] | WHERE premium tier, THE SYSTEM SHALL enable analytics dashboard || **Complex** | WHILE [state], WHEN [trigger], THE SYSTEM SHALL [behavior] | WHILE user is logged in, WHEN session expires, THE SYSTEM SHALL redirect to login |

> **Note:** GitHub Spec-Kit templates use BDD (Given/When/Then) format for acceptance scenarios. EARS notation is an alternative from Kiro and requirements engineering. Both are valid—choose based on team familiarity.
## Feature Spec Template (Lightweight)

For single features within an existing project:

```markdown
---
name: "[FEATURE-NAME]"
parent: "[PROJECT-NAME]"
status: "draft"
priority: "P1"  # P1 | P2 | P3
---

# Feature: [FEATURE-NAME]

## Problem
[1-2 sentences: what problem does this feature solve?]

## Current State
- [How it works today, or "Not implemented"]

## Proposed State
- [How it should work after implementation]

## Acceptance Criteria
1. WHEN [trigger], THE SYSTEM SHALL [behavior]
2. WHEN [trigger], THE SYSTEM SHALL [behavior]
3. WHEN [error condition], THE SYSTEM SHALL [error handling]

## Constraints
- MUST: [requirement]
- MUST NOT: [prohibition]
- Out of scope: [exclusion]

## Dependencies
- Requires: [prerequisite feature or service]
- Blocked by: [blocking issue, if any]
```

## Bug Fix Spec Template

For structured bug resolution:

```markdown
---
name: "BUG-[NUMBER]: [Title]"
status: "investigating"  # investigating | confirmed | fixing | verifying
severity: "high"  # critical | high | medium | low
---

# Bug: [Title]

## Observed Behavior
[What actually happens]

## Expected Behavior
[What should happen]

## Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Root Cause Analysis
[After investigation: why does this happen?]

## Proposed Fix

### Current State
- [Code/behavior causing the bug]

### Proposed State
- [Code/behavior after fix]

## Acceptance Criteria
1. WHEN [reproduction steps], THE SYSTEM SHALL [expected behavior]
2. WHEN [edge case], THE SYSTEM SHALL [handle correctly]

## Verification
- [ ] Original issue no longer reproduces
- [ ] No regression in related functionality
- [ ] Tests added for this case
```

## 5-Gate Validation Checklist

Verify spec completeness before implementation:

```markdown
## Gate 1: Metadata Completeness
- [ ] `name` field is present and valid
- [ ] `status` is set to valid enum value
- [ ] `project_type` is specified (not NEEDS CLARIFICATION)

## Gate 2: Requirement Quality
- [ ] All `[NEEDS CLARIFICATION]` markers resolved
- [ ] At least 3 user stories defined
- [ ] Each user story has EARS acceptance criteria

## Gate 3: State Delta Clarity
- [ ] Current State section has ≥3 bullet points
- [ ] Proposed State section has ≥3 bullet points
- [ ] Current ≠ Proposed (actual delta exists)

## Gate 4: Constraint Validation
- [ ] At least 1 MUST constraint defined
- [ ] Out of Scope section is not empty
- [ ] No conflicting constraints

## Gate 5: Resource Availability
- [ ] Domain expertise level specified
- [ ] Required dependencies identified
- [ ] Timeline/deadline noted
```

## Plan Template

Output from spec → plan phase:

```markdown
# Implementation Plan: [PROJECT-NAME]

**Spec:** [link to .spec.md]
**Status:** draft | approved
**Estimated effort:** [days/weeks]

## Architecture Decisions

### Decision 1: [Topic]
- **Options considered:** [A, B, C]
- **Chosen:** [Option]
- **Rationale:** [Why]

## File Changes

### Create
- `path/to/new/file.ts` — [Purpose]

### Modify
- `path/to/existing.ts` — [What changes]

### Delete
- `path/to/obsolete.ts` — [Why removing]

## Implementation Sequence

1. [Phase 1: Foundation]
   - Task 1.1
   - Task 1.2

2. [Phase 2: Core features]
   - Task 2.1
   - Task 2.2

3. [Phase 3: Integration]
   - Task 3.1

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| [Risk] | [Strategy] |

## Verification Strategy

- [ ] Unit tests for [components]
- [ ] Integration tests for [flows]
- [ ] Manual verification of [scenarios]
```

## Related

- [spec-driven](spec-driven.md) — The workflow that uses these templates
- [telos-goals](../CONTEXT-MEMORY/telos-goals.md) — TELOS hierarchy for problem/mission structure
- [verification-gates](../PATTERNS/verification-gates.md) — Evidence-before-claims validation
- [validation-checklist](../TEMPLATES/validation-checklist.md) — Standalone 5-gate checklist

## Why Specs Matter (Leverage Model)

<!-- NOT IN OFFICIAL DOCS: "Leverage model" concept is from HumanLayer ACE, not native VS Code - flagged 2026-01-25 -->

From HumanLayer's Advanced Context Engineering:

```
Bad research line → 1000s of bad lines of code
Bad plan line     → 100s of bad lines of code
Bad code line     → 1 bad line of code

∴ Review ~400 lines of specs > Review 2000 lines of code
```

Human review has maximum leverage at the specification stage—where one approved requirement shapes thousands of implementation lines.

## VS Code Native Alternatives

While these templates are from external sources, VS Code Copilot provides native planning capabilities:

| Feature | What It Does | How to Use |
|---------|--------------|------------|
| **Plan Agent** | Creates detailed implementation plans before coding | Use `@plan` in chat or select "Plan" mode |
| **Context Engineering** | Three-step workflow: Curate context → Generate plan → Generate code | See [Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) |
| **Prompt Files** | Reusable `.prompt.md` files for custom workflows | See [prompt-files](../CONFIGURATION/prompt-files.md) |
| **Custom Agents** | Define specification → planning → implementation agents with handoffs | See [agent-file-format](../CONFIGURATION/agent-file-format.md) |
| **Todo Lists** | Native task tracking during implementation | Built into Plan agent |

> **Tip:** The Plan agent's output includes a standardized plan format with task breakdowns and acceptance criteria. You can combine external templates (like EARS/BDD) with native `.prompt.md` files to create your own specification workflow.

Source: [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning), [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## Sources

- [GitHub Spec-Kit](https://github.com/github/spec-kit) — Templates, CLI, supports 18+ AI agents including Copilot, Claude Code, Cursor
- [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [TELOS Goal Framework](https://github.com/danielmiessler/Telos) — Mission → Goals → KPIs → Risk Register hierarchy
- [Kiro EARS Notation](https://kiro.dev/docs/specs/concepts/) — EARS-based requirements documentation
- [EARS Original (Alistair Mavin)](https://alistairmavin.com/ears/) — All 6 EARS patterns
- [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — Leverage model, FIC workflow
