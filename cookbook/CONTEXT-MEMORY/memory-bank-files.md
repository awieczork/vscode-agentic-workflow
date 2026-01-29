---
when:
  - setting up cross-session memory for agents
  - creating persistent project context
  - implementing file-based agent memory
  - structuring memory bank for new project
pairs-with:
  - session-handoff
  - tiered-memory
  - memory-bank-schema
  - conflict-resolution
requires:
  - file-write
complexity: medium
---

# Memory Bank Files

> File-based persistent memory for cross-session continuity. The 6-file pattern provides structured context that survives session boundaries.

> **Platform Note:** The Memory Bank pattern (`.github/memory-bank/` folder, 6-file structure) is a **community convention** originating from Cline/Roo Code, not a native VS Code or GitHub Copilot feature. VS Code has no built-in awareness of this folder — it works because agents read these files when instructed to. For official context persistence, see GitHub's [Agentic Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) (server-side, auto-expires after 28 days) or VS Code's [chat session history](https://code.visualstudio.com/docs/copilot/chat/chat-sessions).

Memory bank files solve the problem of agents losing context between sessions. By writing key information to structured files, agents can "remember" project context, decisions, and progress across invocations.

> **Note:** GitHub launched native [Agentic Memory for Copilot](https://github.blog/changelog/2026-01-15-agentic-memory-for-github-copilot-is-in-public-preview/) in Public Preview (January 2026). Key characteristics per [official docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory):
> - **Server-side storage** — not file-based
> - **Repository-scoped** — shared across users with access
> - **Auto-expires** after 28 days
> - **Works with** Copilot coding agent, code review, and CLI (not VS Code Chat yet)
> - **Cross-agent** — what one agent learns, others can use
>
> File-based Memory Bank remains valuable because it's:
> - **Portable** — Works with any AI tool, not just Copilot
> - **Explicit** — You control what's stored and when
> - **Visible** — Human-readable files in your repo
> - **Version-controlled** — Full git history of decisions
> - **Permanent** — Doesn't auto-expire

## The 6-File Core Pattern

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `projectbrief.md` | Project goals, scope, constraints | Rarely (reference) |
| `productContext.md` | Why this project exists, problems solved | Rarely |
| `techContext.md` | Tech stack, architecture decisions | When stack changes |
| `systemPatterns.md` | Code patterns, conventions discovered | When patterns emerge |
| `activeContext.md` | Current focus, recent changes, next steps | Every session |
| `progress.md` | What's done, what's pending | After significant work |

### Optional Extensions

| File | Purpose | When to Add |
|------|---------|-------------|
| `copilot-rules.md` | Team norms, security boundaries, testing frameworks | Teams with shared conventions |
| `tasks/_index.md` | Master task list with statuses, links to individual task files | Complex multi-task projects |

## File Templates

### projectbrief.md

```markdown
# Project Brief

## Overview
{1-2 sentence description of the project}

## Goals
1. {Primary goal}
2. {Secondary goal}

## Scope
### In Scope
- {Feature/capability}

### Out of Scope
- {Explicitly excluded}

## Constraints
- {Technical constraint}
- {Business constraint}
- {Timeline constraint}

## Success Criteria
- [ ] {Measurable outcome}
```

### productContext.md

```markdown
# Product Context

## Problem Statement
{What problem does this solve? Who has this problem?}

## User Personas
### {Persona Name}
- **Role**: {description}
- **Needs**: {what they need}
- **Pain Points**: {current frustrations}

## Business Context
{Why this project matters to the organization}

## Competitive Landscape
{How this compares to alternatives}
```

### techContext.md

```markdown
# Technical Context

## Stack
| Layer | Technology | Version |
|-------|------------|---------|
| Language | TypeScript | 5.x |
| Runtime | Node.js | 20.x |
| Framework | Express | 4.x |
| Database | PostgreSQL | 15 |

## Architecture
{Brief architecture description}

## Key Decisions
| Decision | Rationale | Date |
|----------|-----------|------|
| {Choice} | {Why} | {When} |

## Conventions
- {Naming convention}
- {File organization}
- {Testing approach}
```

### systemPatterns.md

```markdown
# System Patterns

## Code Patterns
### {Pattern Name}
**When to use**: {condition}
**Implementation**:
```typescript
// Example code
```
**Files using this**: {list}

## Architectural Patterns
### {Pattern Name}
{Description and rationale}

## Anti-Patterns to Avoid
- {What not to do}: {why}
```

### activeContext.md

```markdown
# Active Context

**Last Updated**: {ISO8601 timestamp}
**Current Agent**: {agent name or "user"}

## Current Focus
{What's being worked on right now}

## Recent Changes
- {Change 1} — {date}
- {Change 2} — {date}

## Active Decisions
| Decision | Status | Blocker |
|----------|--------|---------|
| {Decision} | pending | {blocker or none} |

## Next Steps
1. {Immediate action}
2. {Following action}

## Open Questions
- [ ] {Question needing answer}
```

### progress.md

```markdown
# Progress

## Completed
### {Milestone/Feature}
- [x] {Task} — {date}
- [x] {Task} — {date}

## In Progress
- [ ] {Task} — started {date}

## Pending
- [ ] {Task} — blocked by {reason} or ready

## Blockers
| Issue | Severity | Owner | Action |
|-------|----------|-------|--------|
| {Issue} | {high/med/low} | {who} | {what} |
```

### tasks/_index.md (Optional)

```markdown
# Tasks Index

## In Progress
- [TASK003] Implement user authentication — Working on OAuth
- [TASK005] Create dashboard UI — Building components

## Pending
- [TASK006] Add export functionality — Next sprint
- [TASK007] Optimize queries — After testing

## Completed
- [TASK001] Project setup — ✅ 2025-01-15
- [TASK002] Database schema — ✅ 2025-01-17

## Abandoned
- [TASK008] Legacy integration — Cancelled (API deprecated)
```

Each task can have its own file (`tasks/TASK003-auth.md`) with detailed implementation plans, subtasks, and progress logs.

## Directory Structure

```
.github/memory-bank/
├── manifest.yaml              # Index and metadata
├── global/                    # Project-wide context
│   ├── projectbrief.md
│   ├── productContext.md
│   ├── techContext.md
│   ├── systemPatterns.md
│   └── decisions.md           # Append-only decision log
├── sessions/
│   ├── _active.md             # Current session state
│   └── archive/               # Past sessions
└── features/{feature-id}/     # Feature-specific context
    ├── context.md
    ├── progress.yaml
    └── decisions.md
```

See [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) for full schema specification.

## Update Triggers

| Trigger | Action |
|---------|--------|
| **Session start** | Read all files, update `activeContext.md` with focus |
| **Pattern discovered** | Add to `systemPatterns.md` |
| **Significant progress** | Update `progress.md` and `activeContext.md` |
| **Decision made** | Append to `decisions.md` |
| **Context shift** | Update `activeContext.md` with new focus |
| **Session end** | Update `activeContext.md` with "Next Steps" |
| **User requests update** | Review and update ALL relevant files |

## File Dependencies

```
projectbrief.md ─────┐
                     ├──→ activeContext.md ──→ progress.md
productContext.md ───┤
                     │
techContext.md ──────┤
                     │
systemPatterns.md ───┘
```

**Read order at session start:**
1. `projectbrief.md` (establishes scope)
2. `techContext.md` (establishes constraints)
3. `activeContext.md` (establishes current focus)
4. `progress.md` (establishes what's done)

## What NOT to Store

❌ Sensitive credentials or secrets (use env vars)
❌ Large code snippets (use file paths instead)
❌ Raw chat transcripts (extract facts only)
❌ Redundant information (one source of truth)
❌ Temporary debugging notes (delete after use)

## Loading Memory in Agent Files

<!-- FILE REFERENCE SYNTAX: Official docs show Markdown links for instructions/agents, #file for chat -->

```markdown
<!-- In your .agent.md file -->
## Context Loading

At session start, read these files for project context:
- [Project Brief](.github/memory-bank/global/projectbrief.md)
- [Technical Context](.github/memory-bank/global/techContext.md)
- [Active Session](.github/memory-bank/sessions/_active.md)

Before context window fills:
1. Update `sessions/_active.md` with current state
2. Note any decisions in `decisions.md`
3. Update feature `progress.yaml` if applicable
```

> **Syntax Note:** Use Markdown links `[name](path)` in `.agent.md` and `.instructions.md` files. Use `#filename` (no colon) in interactive chat. See [VS Code prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files#_body) and [context references](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context).

## Native VS Code Session Management

VS Code provides official mechanisms for context persistence that complement the Memory Bank pattern:

| Feature | What It Does | Persistence | Source |
|---------|--------------|-------------|--------|
| **Session History** | Saves all chat sessions, accessible via History button | Local to VS Code | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) |
| **Checkpoints** | Snapshots of file state during chat, allows rollback | Within session only | [Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) |
| **Export Chat** | `Chat: Export Chat...` saves prompts/responses to JSON | Manual export | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_export-a-chat-session-as-a-json-file) |
| **Save as Prompt** | `/savePrompt` creates reusable `.prompt.md` from conversation | Persisted file | [Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_save-a-chat-session-as-a-reusable-prompt) |
| **Agentic Memory** | Server-side memory for coding agent, code review, CLI | 28 days, repository-scoped | [Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) |

> **Note:** VS Code session history is local — it doesn't sync across devices by default. Enable "Prompts and Instructions" in Settings Sync to share custom instructions.

## Related

- [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) — Full schema with manifest.yaml
- [tiered-memory.md](tiered-memory.md) — Hot/Warm/Cold/Frozen access patterns
- [conflict-resolution.md](conflict-resolution.md) — Handling concurrent updates
- [session-handoff.md](session-handoff.md) — Cross-session continuity template
- [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) — When to update memory

## Sources

### Community Pattern Sources
- [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank) — Primary source for 6-file pattern
- [Memory Bank Template — mrballistic](https://github.com/mrballistic/copilot-memory-bank-template) — GitHub Copilot adaptation
- [GitHub Copilot Memory — sethdford](https://github.com/sethdford/memory-bank/blob/main/GITHUB-COPILOT-INTEGRATION.md) — Integration guide
- [Agentic Coding Handbook — Tweag](https://tweag.github.io/agentic-coding-handbook/WORKFLOW_MEMORY_BANK/) — Comprehensive workflow guide
- [roo-framework Session Handoff](https://github.com/JackSmack1971/roo-autonomous-ai-development-framework/blob/main/memory-bank/session-handoff.md) — Session handoff template source

### Official Documentation
- [GitHub Agentic Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) — Native server-side memory
- [GitHub Agentic Memory Announcement](https://github.blog/changelog/2026-01-15-agentic-memory-for-github-copilot-is-in-public-preview/) — Public Preview January 2026
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Session history, export, save as prompt
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Within-session snapshots
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) — Auto-loaded context files
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — File reference syntax
