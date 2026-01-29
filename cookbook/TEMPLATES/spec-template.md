---
when:
  - starting a new project or feature
  - documenting requirements before implementation
  - creating specification-driven development artifacts
  - capturing problem statements and success criteria
pairs-with:
  - spec-driven
  - spec-templates
  - validation-checklist
  - research-plan-implement
requires:
  - none
complexity: medium
---

# Spec Template

> **Platform Note:** This template synthesizes patterns from external sources ([Spec-Kit](https://github.com/github/spec-kit), [TELOS](https://github.com/danielmiessler/Telos), [Kiro EARS](https://kiro.dev/docs/specs/concepts/)). VS Code Copilot does not have native `.spec.md` support—use `.prompt.md` files or custom agents to implement this workflow. See [spec-templates](../WORKFLOWS/spec-templates.md) for more templates and context.
>
> **Official Alternatives:**
> - [Implementation Planner](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner) — GitHub's official custom agent template for creating implementation plans
> - Custom agents with `handoffs` for Plan→Implementation→Review workflows ([VS Code docs](https://code.visualstudio.com/docs/copilot/customization/custom-agents))
> - Save as `specifications.md` and attach as context ([VS Code blog](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode))

<!-- NOT IN OFFICIAL DOCS: .spec.md file extension, .github/specs/ folder, YAML frontmatter fields (version, status, type, project_type, domain, tech_stack), [NEEDS CLARIFICATION] markers, EARS acceptance criteria patterns (WHEN/SHALL), MUST/SHOULD/COULD constraint language - all are community/external patterns (Spec-Kit, Kiro, TELOS) - flagged 2026-01-26 -->

Copy-paste `.spec.md` file for specification-driven development. Save as `[project-name].spec.md` in your project root or `.github/specs/` folder (community convention).

## Complete .spec.md File

```markdown
---
name: "[PROJECT-NAME]"
version: "1.0.0"
created: "[YYYY-MM-DD]"
status: "draft"  # draft | review | approved | generating
type: "project-specification"

project_type: "[NEEDS CLARIFICATION]"  # single | web | mobile | library | data-pipeline
domain: "[NEEDS CLARIFICATION]"        # e.g., e-commerce, ML, DevOps
tech_stack:
  primary: "[NEEDS CLARIFICATION]"     # e.g., Python, TypeScript
  frameworks: "[NEEDS CLARIFICATION]"  # e.g., FastAPI, React
---

# Project Specification: [PROJECT-NAME]

## 1. Problem Statement

### 1.1 What problem are you solving?
[Describe the core problem in 2-3 sentences]

### 1.2 Why does this problem matter?
[Business impact, user pain, opportunity cost]

### 1.3 Current Pain Points
- [Pain point 1]
- [Pain point 2]
- [Pain point 3]

## 2. Mission & Goals

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

## 4. User Stories & Requirements

### US-001: [Title] (Priority: P1)
**As a** [user type]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria:**
1. WHEN [condition/trigger], THE SYSTEM SHALL [expected behavior]
2. WHEN [condition/trigger], THE SYSTEM SHALL [expected behavior]

### US-002: [Title] (Priority: P2)
**As a** [user type]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria:**
1. WHEN [condition], THE SYSTEM SHALL [behavior]

### US-003: [Title] (Priority: P3)
**As a** [user type]
**I want** [capability]
**So that** [benefit]

**Acceptance Criteria:**
1. WHEN [condition], THE SYSTEM SHALL [behavior]

## 5. Constraints & Boundaries

### 5.1 Hard Constraints (Non-Negotiable)
- MUST: [Absolute requirement]
- MUST: [Absolute requirement]
- MUST NOT: [Prohibited action]
- MUST NOT: [Prohibited action]

### 5.2 Preferences (Nice-to-Have)
- SHOULD: [Preferred approach]
- COULD: [Optional enhancement]

### 5.3 Out of Scope
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]
- [Explicitly excluded item 3]

## 6. Challenges & Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Strategy] |
| [Risk 2] | High/Med/Low | High/Med/Low | [Strategy] |
| [Risk 3] | High/Med/Low | High/Med/Low | [Strategy] |

## 7. Reference Resources

- [Link to existing docs]
- [Link to similar implementations]
- [Link to API documentation]
- [Link to design mockups]

## 8. Clarification Log

<!-- Agent MUST NOT proceed until all [NEEDS CLARIFICATION] items resolved -->

| Item | Question | Answer | Resolved |
|------|----------|--------|----------|
| project_type | Single app, library, or service? | [PENDING] | [ ] |
| tech_stack | What language/framework? | [PENDING] | [ ] |
| [item] | [question] | [PENDING] | [ ] |

---

## Validation Checklist

Before proceeding to planning:

- [ ] All `[NEEDS CLARIFICATION]` items have answers
- [ ] Problem statement is specific (not vague)
- [ ] Success criteria are measurable
- [ ] Current→Proposed state delta is clear
- [ ] Each user story has EARS acceptance criteria
- [ ] Constraints use MUST/MUST NOT language
- [ ] Out of scope is explicitly defined
```

## Feature Spec (Lightweight)

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
1. WHEN [condition], THE SYSTEM SHALL [behavior]
2. WHEN [condition], THE SYSTEM SHALL [behavior]
3. WHEN [condition], THE SYSTEM SHALL [behavior]

## Constraints
- MUST: [requirement]
- MUST NOT: [prohibition]

## Out of Scope
- [excluded item]
```

## EARS Quick Reference

> **Note:** EARS (Easy Approach to Requirements Syntax) is used by Kiro IDE. GitHub Spec-Kit uses **Given/When/Then (GWT)** BDD-style format instead: `"Given [initial state], When [action], Then [expected outcome]"`. Both are valid—choose based on team familiarity.

| Pattern | Template |
|---------|----------|
| **Ubiquitous** | THE SYSTEM SHALL [behavior] |
| **Event-Driven** | WHEN [trigger], THE SYSTEM SHALL [behavior] |
| **State-Driven** | WHILE [state], THE SYSTEM SHALL [behavior] |
| **Unwanted** | IF [condition], THEN THE SYSTEM SHALL [behavior] |
| **Optional** | WHERE [feature], THE SYSTEM SHALL [behavior] |

## Related

- [spec-templates](../WORKFLOWS/spec-templates.md) — Full questionnaire, bug fix template, plan template, 5-gate validation
- [spec-driven](../WORKFLOWS/spec-driven.md) — Full specification-driven workflow
- [telos-goals](../CONTEXT-MEMORY/telos-goals.md) — TELOS hierarchy mapping
- [validation-checklist](validation-checklist.md) — Detailed gate validation
- [prompt-files](../CONFIGURATION/prompt-files.md) — VS Code native alternative for custom workflows

## Sources

### Official Documentation
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) — Handoffs for Plan→Implementation workflows
- [GitHub Implementation Planner](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/implementation-planner) — Official custom agent template for implementation plans
- [VS Code Agent Mode Blog](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode) — specifications.md as context file

### External Sources (Not Native to VS Code)
- [GitHub Spec-Kit](https://github.com/github/spec-kit) — Open source toolkit (65k+ stars), supports 17+ AI agents including Copilot, Cursor, Claude Code
- [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [Kiro IDE Spec Concepts](https://kiro.dev/docs/specs/concepts/) — EARS-based requirements
- [EARS Original (Alistair Mavin)](https://alistairmavin.com/ears/) — Original EARS notation from Rolls-Royce (2009)
