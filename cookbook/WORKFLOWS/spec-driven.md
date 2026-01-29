---
when:
  - starting new projects with clear requirements
  - front-loading human review at design phase
  - implementing complex features
  - reducing downstream code review burden
pairs-with:
  - spec-template
  - spec-templates
  - validation-checklist
  - task-tracking
requires:
  - file-write
complexity: high
---

# Spec-Driven Development

> **Platform Note:** Spec-driven development is implemented via [GitHub Spec-Kit](https://github.com/github/spec-kit), an open-source toolkit that works with VS Code Copilot and 17+ other AI agents. The methodology and commands below come from Spec-Kit — they are not native VS Code features. VS Code provides a built-in **Plan agent** (`@plan`) for implementation planning. Source: [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)

Define what you want before asking the agent to build it. Spec-driven development front-loads human review at the specification phase where one bad line of spec causes hundreds of bad lines of code—not at the code review phase where errors are expensive to fix.

## The Workflow

```
Specify → Plan → Tasks → Implement
   ↓        ↓       ↓         ↓
.spec.md  plan.md  tasks.md  code
   ↓        ↓       ↓         ↓
[REVIEW]  [REVIEW] [REVIEW]  [VERIFY]
```

Each phase produces a reviewable artifact. Human approval gates between phases catch problems early.

## Why Spec First

The human leverage principle:

| Error Location | Downstream Impact |
|----------------|-------------------|
| Bad research line | → 1000s of bad lines of code |
| Bad plan line | → 100s of bad lines of code |
| Bad code line | → 1 bad line of code |

**Insight:** Review ~400 lines of specs instead of 2000 lines of code. Front-load human attention where it has maximum leverage.

## The Four Phases

### Phase 1: Specify

Capture what the system should do using the Current State → Proposed State pattern.

**Outputs:** `.spec.md` file with:
- Problem statement (TELOS: Problems)
- Mission & goals (TELOS: Mission/Goals)
- Current state (what IS)
- Proposed state (what SHOULD BE)
- User stories with acceptance criteria (EARS format)
- Constraints and boundaries
- Out of scope

**Key format:**

```markdown
## Current State (What IS)
- Users must manually export data
- No API access available
- Reports take 2+ hours to generate

## Proposed State (What SHOULD BE)
- One-click data export
- REST API for programmatic access
- Reports generated in <5 minutes
```

### Phase 2: Plan

Convert the spec into an implementation approach.

**Outputs:** `plan.md` with:
- Architecture decisions
- File changes (create/modify/delete)
- Dependencies and sequencing
- Risk mitigation

**Review checkpoint:** Does this plan achieve the proposed state?

### Phase 3: Tasks

Break the plan into atomic, implementable units.

**Outputs:** `tasks.md` with:
- Discrete tasks (checkbox format)
- Estimated complexity per task
- Dependencies between tasks
- Verification criteria

```markdown
## Implementation Tasks

- [ ] Task 1: Create export API endpoint (M)
  - Depends on: none
  - Verify: `GET /api/export` returns 200

- [ ] Task 2: Build export service (L)
  - Depends on: Task 1
  - Verify: Unit tests pass
```

**Review checkpoint:** Are tasks atomic? Is anything missing?

### Phase 4: Implement

Execute tasks one by one with verification.

**Outputs:** Working code, tests, documentation

**Verification:** Each task verified against its criteria before proceeding.

## EARS Acceptance Criteria

<!-- NOT IN OFFICIAL DOCS: EARS notation - flagged 2026-01-25. EARS is an external requirements engineering standard from Alistair Mavin, not documented in VS Code/Copilot official docs. Included here as a recommended pattern from Spec-Kit. -->

Use [EARS (Easy Approach to Requirements Syntax)](https://alistairmavin.com/ears/) notation for unambiguous acceptance criteria. EARS is an external requirements engineering standard — not a VS Code feature — but integrates well with spec-driven workflows. EARS provides five patterns:

| Pattern | Template | Use When |
|---------|----------|----------|
| **Ubiquitous** | `THE SYSTEM SHALL [behavior]` | Always-active requirements |
| **State-Driven** | `WHILE [state], THE SYSTEM SHALL [behavior]` | Behavior depends on system state |
| **Event-Driven** | `WHEN [trigger], THE SYSTEM SHALL [behavior]` | Behavior triggered by event |
| **Optional Feature** | `WHERE [feature], THE SYSTEM SHALL [behavior]` | Configurable/optional features |
| **Unwanted Behavior** | `IF [condition], THEN THE SYSTEM SHALL [response]` | Error handling, edge cases |

**Examples:**

```markdown
## US-001: Export User Data
**Acceptance Criteria:**

### Event-Driven
1. WHEN user clicks "Export", THE SYSTEM SHALL generate a CSV file
2. WHEN export exceeds 1M rows, THE SYSTEM SHALL paginate into multiple files

### Unwanted Behavior
3. IF export fails, THEN THE SYSTEM SHALL display error message with retry option

### State-Driven
4. WHILE export is in progress, THE SYSTEM SHALL display progress indicator

### Optional Feature
5. WHERE scheduled exports are enabled, THE SYSTEM SHALL run daily at configured time
```

## Validation Gates

Before proceeding to implementation, validate the spec passes five gates:

```markdown
## Gate 1: Metadata Completeness
- [ ] Project name is present and valid
- [ ] Status is set (draft/review/approved)
- [ ] Project type is specified

## Gate 2: Requirement Quality
- [ ] All [NEEDS CLARIFICATION] markers resolved
- [ ] At least 3 user stories defined
- [ ] Each user story has EARS acceptance criteria

## Gate 3: State Delta Clarity
- [ ] Current State section has ≥3 bullet points
- [ ] Proposed State section has ≥3 bullet points
- [ ] Current ≠ Proposed (actual delta exists)

## Gate 4: Constraint Validation
- [ ] At least 1 MUST constraint defined
- [ ] Out of Scope section is not empty

## Gate 5: Resource Availability
- [ ] Domain expertise level specified
- [ ] Required dependencies identified
```

## Agent Configuration for Spec-Driven

Configure approval gates in your agent:

```yaml
---
name: implementer
description: Implements approved specifications
tools: ["*"]
---

# Implementation Agent

## Workflow
1. Read the approved `.spec.md` file
2. Verify all 5 validation gates pass
3. Generate implementation plan
4. 🚨 STOP - Request human review before coding
5. After approval, implement task-by-task
6. Verify each task against acceptance criteria

## Constraints
- NEVER proceed without approved spec
- NEVER skip validation gates
- ALWAYS verify task completion before next task
```

## Spec-Kit Commands

GitHub's [Spec-Kit](https://github.com/github/spec-kit) provides prompt templates for spec-driven development. Use these commands with any AI agent:

| Command | Purpose |
|---------|---------|
| `/speckit.constitution` | Create project governing principles |
| `/speckit.specify` | Define requirements and user stories |
| `/speckit.plan` | Create technical implementation plan |
| `/speckit.tasks` | Generate actionable task breakdown |
| `/speckit.implement` | Execute tasks to build the feature |
| `/speckit.clarify` | Resolve ambiguities in specifications |
| `/speckit.checklist` | Generate quality validation checklist |
| `/speckit.analyze` | Analyze existing code for spec alignment |

> **Tip:** Spec-Kit works with 17+ AI agents including Copilot, Claude Code, Cursor, Windsurf, Kiro, and more.

## Quick Start

### 1. Create Spec

```bash
# Create a new spec from template
cp templates/spec-template.md docs/feature-name.spec.md
# Fill in the template sections
```

Or use Spec-Kit directly:

```markdown
/speckit.specify

I need to build a data export feature for our dashboard...
```

### 2. Validate Spec

```markdown
/speckit.checklist #feature-name.spec.md

Generate validation checklist for this spec.
```

> **Syntax Note:** VS Code uses `#<filename>` (e.g., `#feature-name.spec.md`) not `#file:path`. Type `#` and select from the picker, or type `#` followed by the filename. Source: [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

### 3. Generate Plan

```markdown
/speckit.plan #feature-name.spec.md

Create implementation plan focusing on architecture decisions and file changes.
```

**VS Code Native Alternative:** Use the built-in Plan agent:
```markdown
@plan Create implementation plan for #feature-name.spec.md
```

### 4. Generate Tasks

```markdown
/speckit.tasks #feature-name.plan.md

Break into atomic tasks with checkbox format, dependencies, and verification criteria.
```

### 5. Implement

```markdown
/speckit.implement #feature-name.tasks.md

Implement one task at a time. Verify before proceeding.
```

## VS Code Native Planning

If not using Spec-Kit, VS Code provides native planning capabilities:

| Native Feature | Purpose | Invocation |
|----------------|---------|------------|
| **Plan Agent** | Create implementation plans | `@plan` in chat |
| **Todo Lists** | Track implementation progress | Auto-generated from plans |
| **Handoffs** | Transition from plan to implementation | Button in plan view |

The native workflow is: **Plan → Review → Implement** (via handoff).

Source: [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

## Integration with Context Engineering

Spec-driven development aligns with context engineering patterns:

| Spec Phase | Context Strategy |
|------------|------------------|
| Specify | Load domain context, user requirements |
| Plan | Load spec + codebase architecture |
| Tasks | Load spec + plan (compact research) |
| Implement | Load tasks only (fresh context per task) |

Each phase transition is an opportunity to compact context. The agent carries forward only what's needed for the next phase.

## Related

- [spec-templates](spec-templates.md) — Full `.spec.md` template with all sections
- [research-plan-implement](research-plan-implement.md) — FIC's R→P→I workflow (similar phases)
- [verification-gates](../PATTERNS/verification-gates.md) — Evidence-before-claims protocol
- [approval-gates](../CHECKPOINTS/approval-gates.md) — Permission levels and checkpoint config
- [telos-goals](../CONTEXT-MEMORY/telos-goals.md) — TELOS goal hierarchy for spec structure
- [prompt-files](../CONFIGURATION/prompt-files.md) — `.prompt.md` format for workflow prompts

## Sources

### Official VS Code Documentation
- [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) — Native Plan agent and todo lists
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Official workflow: Curate → Plan → Implement
- [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — `#<filename>` syntax reference

### Spec-Kit (External Toolkit)
- [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) — Official announcement (Sept 2025)
- [GitHub Spec-Kit](https://github.com/github/spec-kit) — Primary toolkit with commands and templates
- [Copilot Workspace User Manual](https://github.com/githubnext/copilot-workspace-user-manual) — ⚠️ *Archived Sept 2025*; source of Current→Proposed State pattern

### External Standards
- [EARS Notation (Alistair Mavin)](https://alistairmavin.com/ears/) — Original EARS inventor's documentation
- [Kiro Specs Concepts](https://kiro.dev/docs/specs/concepts/) — AWS Kiro's implementation of EARS
