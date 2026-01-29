---
when:
  - managing task dependencies
  - tracking multi-step implementation progress
  - organizing complex feature work
  - querying what tasks are ready to execute
pairs-with:
  - spec-driven
  - research-plan-implement
  - workflow-orchestration
  - wrap-task-decomposition
requires:
  - file-write
complexity: medium
---

# Task Tracking

Manage task dependencies, track progress, and determine what's ready to execute. This covers issue-based orchestration patterns from Beads—structured tasks that beat prose plans.

> **Platform Note:** VS Code has a native **Todo List** feature (see [VS Code Native Todo Lists](#vs-code-native-todo-lists) section below). The Beads patterns in this document are **community/external patterns** for complex multi-feature work requiring explicit dependency tracking. Choose the approach that fits your needs:
> - **Native Todo List**: Best for single/multi-session tasks with automatic progress tracking
> - **Beads/YAML patterns**: Best for complex dependencies, team collaboration, and explicit task graphs

> **Source:** Patterns derived from [steveyegge/beads](https://github.com/steveyegge/beads) (12.5k+ stars, v0.49.0) — a distributed, git-backed graph issue tracker designed for AI agents.

## Why Structured Tasks

| Problem with Prose Plans | Structured Task Solution |
|-------------------------|-------------------------|
| Agents create recursive 6-phase plans | Hash/hierarchical IDs prevent confusion |
| No dependency tracking | First-class `blocks`, `blocked-by` links |
| Can't query "what's ready?" | Filter incomplete blockers |
| Lost work discoveries | Agents file tasks for problems found |
| Context-heavy | Query only what's needed |

> **Source:** [Introducing Beads (Medium)](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a)

## Task State Markers

Use consistent markers across all task files. These are **Markdown conventions** for pure-text tracking (Beads CLI uses JSON status fields internally):

| Marker | State | Meaning | Beads Equivalent |
|--------|-------|---------|------------------|
| `[ ]` | Open | Not started | `"status": "open"` |
| `[~]` | In Progress | Being worked on | `"status": "in_progress"` |
| `[x]` | Done | Completed | `"status": "done"` |
| `[!]` | Blocked | Waiting on dependency | `"status": "blocked"` |
| `[-]` | Skipped | Won't do (with reason) | Closed with reason |

> **Note:** If using Beads CLI, status is tracked in JSONL files (`.beads/issues.jsonl`). The Markdown markers above are for teams using pure-Markdown workflows without Beads tooling.

### Example Task List

```markdown
## Tasks

- [x] AUTH.1: Set up authentication middleware
- [x] AUTH.2: Create login endpoint
- [~] AUTH.3: Add JWT token generation
  - [x] AUTH.3.1: Install jsonwebtoken
  - [~] AUTH.3.2: Implement token signing
  - [ ] AUTH.3.3: Add refresh token logic
- [!] AUTH.4: Integration tests [blocked-by: AUTH.3]
- [ ] AUTH.5: Documentation
```

## Hierarchical Task IDs

Use hierarchical naming for epics, tasks, and subtasks:

**Feature-prefix format (Markdown workflows):**
```
AUTH           # Epic
AUTH.1         # Task under epic
AUTH.1.1       # Sub-task under task
AUTH.1.2       # Another sub-task
AUTH.2         # Another task under epic
```

**Beads hash-prefix format (Beads CLI):**
```
bd-a3f8        # Epic (hash-based ID)
bd-a3f8.1      # Task under epic
bd-a3f8.1.1    # Sub-task
```

**Benefits:**
- Clear parent-child relationships
- Sortable and filterable
- Collision-free across features

> **Note:** Beads uses hash-based prefixes (`bd-xxxx`) generated automatically. The feature-prefix format (`AUTH.1`) is a human-friendly adaptation for Markdown-only workflows.

### Naming Convention

```
{FEATURE}.{task_number}.{subtask_number}

Examples:
- AUTH.1 — First task in Auth feature
- API.3.2 — Second subtask of third task in API feature
- DB.MIGRATION.1 — Nested feature prefix
```

## Dependency Notation

Track task relationships explicitly. These four dependency types are from Beads:

| Type | Notation | Meaning |
|------|----------|---------|
| `blocks:` | Task A blocks B | B can't start until A done |
| `blocked-by:` | Task B blocked by A | Same, reverse direction |
| `discovered-from:` | Found during A | Bug found while working |
| `related:` | Cross-reference | Documentation link |

> **Source:** [Beads Dependency Types](https://github.com/steveyegge/beads) — these are the four first-class relationship types in the Beads issue graph.

### In Markdown Tasks

```markdown
- [ ] AUTH.4: Write integration tests
  - blocked-by: AUTH.3
  - related: API.2

- [ ] AUTH.5: Fix session timeout [discovered-from: AUTH.3]
  - Priority: P1
```

### In YAML Task Files

```yaml
# tasks/AUTH.4.yaml
id: AUTH.4
title: Write integration tests
status: blocked
blocked-by:
  - AUTH.3
related:
  - API.2
priority: 2
```

## Ready Task Determination

A task is "ready" when:
1. Status is `open` (not done, not in-progress)
2. All `blocked-by` items are `done`
3. Not explicitly blocked

> **Beads equivalent:** `bd ready --json` returns tasks with no incomplete blockers, sorted by priority.

### Algorithm

```markdown
## Ready Task Protocol

To find the next task:

1. **List all open tasks** (status = `[ ]`)
2. **Filter out blocked** — Remove tasks where ANY `blocked-by` item is incomplete
3. **Sort by priority** — P0 > P1 > P2 > P3
4. **Pick first** — Highest priority unblocked task

### Example Query
Given:
- AUTH.3: [~] in progress
- AUTH.4: [ ] blocked-by AUTH.3
- AUTH.5: [ ] no blockers, P2
- API.1: [ ] no blockers, P1

Ready tasks: AUTH.5, API.1
Next task: API.1 (higher priority)
```

### VS Code Implementation

Without external tools, implement in agent instructions:

```markdown
## Finding Ready Work

Before starting new work:

1. Read `tasks.md` in current feature folder
2. For each `[ ]` task:
   - Check if any `blocked-by` items exist
   - For each blocker, check if it's `[x]` done
   - If ALL blockers are done → task is READY
3. From ready tasks, pick highest priority (P0 > P1 > P2)
4. Mark selected task `[~]` before starting

Report: "Starting {TASK_ID}: {title}"
```

## Discovery Protocol

When you find new work during execution, file it immediately:

### Priority Levels

| Priority | Impact | Action |
|----------|--------|--------|
| **P0** | Blocks ALL work | Stop, file, escalate |
| **P1** | Blocks this track | File, may need to switch |
| **P2** | Should address soon | File, continue current |
| **P3** | Nice to have | File, backlog |
| **P4** | Future consideration | File, icebox |

### Discovery Format

```markdown
## Discovery Protocol

When encountering issues during work:

1. **Log immediately** with prefix:
   `[DISCOVERED:P#] {description}`

2. **Add relationship**:
   `discovered-from: {current_task_id}`

3. **Continue or stop** based on priority:
   - P0/P1: Stop, address or escalate
   - P2-P4: Log, continue current work

### Example Discovery
Working on AUTH.3, find that rate limiting is missing:

```markdown
- [ ] AUTH.6: Add rate limiting to login endpoint [discovered-from: AUTH.3]
  - Priority: P1
  - blocks: AUTH.4 (integration tests need this)
```
```

### Discovery Agent Instructions

```markdown
## During Work

When you encounter an issue, bug, or missing requirement:

1. Do NOT silently ignore it
2. Create a new task entry:
   ```
   - [ ] {FEATURE}.{next_id}: {description} [discovered-from: {current_id}]
     - Priority: P{0-4}
     - {optional: blocks/blocked-by}
   ```
3. Announce: "[DISCOVERED:P{n}] {brief description}"
4. If P0/P1: Ask whether to switch focus
5. If P2-P4: Continue current task
```

## Session Completion Protocol

**MANDATORY** before ending any work session:

```markdown
## Session End Checklist

1. **File remaining work**
   - Create entries for incomplete items
   - Mark in-progress tasks with `[~]`

2. **Run quality gates**
   ```bash
   npm test
   npm run lint
   ```

3. **Update task states**
   - Mark completed tasks `[x]`
   - Update `blocked-by` resolutions

4. **Commit and push**
   ```bash
   git add -A
   git commit -m "WIP: {summary of progress}"
   git push
   ```

5. **Generate handoff**
   - Write progress summary
   - List ready tasks for next session

**CRITICAL:** Session is NOT complete until push succeeds.
```

## Task File Format

### Simple Markdown (tasks.md)

```markdown
# Feature: User Authentication

## Epic: AUTH

### Tasks

- [x] AUTH.1: Set up middleware
- [x] AUTH.2: Create login endpoint
- [~] AUTH.3: JWT token generation
  - blocked-by: (none)
  - [x] AUTH.3.1: Install dependencies
  - [~] AUTH.3.2: Implement signing
  - [ ] AUTH.3.3: Refresh tokens
- [!] AUTH.4: Integration tests
  - blocked-by: AUTH.3
- [ ] AUTH.5: Documentation
  - Priority: P3

### Discovered

- [ ] AUTH.6: Rate limiting [discovered-from: AUTH.3]
  - Priority: P1
  - blocks: AUTH.4

## Progress

- Started: 2026-01-20
- Last updated: 2026-01-23
- Completed: 2/5 tasks
```

### YAML Task Registry

For more structured tracking:

<!-- COMMUNITY PATTERN: .github/memory-bank/ folder is NOT official VS Code - it's from Cline/Roo Code community. Flagged 2026-01-25 -->

```yaml
# .github/memory-bank/features/auth/tasks.yaml
feature: auth
epic_id: AUTH
created: 2026-01-20
updated: 2026-01-23

tasks:
  - id: AUTH.1
    title: Set up authentication middleware
    status: done
    completed: 2026-01-20

  - id: AUTH.2
    title: Create login endpoint
    status: done
    completed: 2026-01-21

  - id: AUTH.3
    title: JWT token generation
    status: in_progress
    subtasks:
      - id: AUTH.3.1
        title: Install dependencies
        status: done
      - id: AUTH.3.2
        title: Implement signing
        status: in_progress
      - id: AUTH.3.3
        title: Refresh tokens
        status: open

  - id: AUTH.4
    title: Integration tests
    status: blocked
    blocked_by: [AUTH.3]

  - id: AUTH.5
    title: Documentation
    status: open
    priority: 3

discoveries:
  - id: AUTH.6
    title: Rate limiting needed
    discovered_from: AUTH.3
    priority: 1
    blocks: [AUTH.4]
    status: open
```

## Agent Workflow Loop

```
┌─────────────────────────────────────────────────────┐
│                  Task Execution Loop                 │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────┐                                        │
│  │  Start   │                                        │
│  └────┬─────┘                                        │
│       ↓                                              │
│  ┌──────────┐    No tasks    ┌──────────┐           │
│  │  Query   │───────────────→│   Done   │           │
│  │  Ready   │                └──────────┘           │
│  └────┬─────┘                                        │
│       ↓ Has tasks                                    │
│  ┌──────────┐                                        │
│  │   Pick   │  (highest priority)                   │
│  │  First   │                                        │
│  └────┬─────┘                                        │
│       ↓                                              │
│  ┌──────────┐                                        │
│  │  Claim   │  mark [~]                             │
│  │   Task   │                                        │
│  └────┬─────┘                                        │
│       ↓                                              │
│  ┌──────────┐     Yes    ┌──────────┐               │
│  │   Work   │───────────→│   File   │               │
│  │          │  discover? │ Discovery│               │
│  └────┬─────┘            └────┬─────┘               │
│       ↓                       │                      │
│  ┌──────────┐                 │                      │
│  │   Test   │←────────────────┘                      │
│  └────┬─────┘                                        │
│       ↓                                              │
│  ┌──────────┐    Fail    ┌──────────┐               │
│  │   Pass?  │───────────→│  Debug   │───┐           │
│  └────┬─────┘            └──────────┘   │           │
│       ↓ Pass                            │           │
│  ┌──────────┐                           │           │
│  │  Close   │  mark [x]                 │           │
│  │   Task   │                           │           │
│  └────┬─────┘                           │           │
│       │                                 │           │
│       └────────────→ Query Ready ←──────┘           │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## VS Code Native Todo Lists

VS Code's agent mode automatically creates todo lists to track multi-step task progress. This is a lightweight alternative for simple workflows:

- Agent mode generates task lists in chat for complex requests
- The todo list appears in a **Todo control at the top of the Chat view**
- Tasks update automatically as the agent completes each step
- Todo list automatically collapses, showing only the current task in progress
- You can update the list using natural language (e.g., "revise step 1 to do x" or "add another task")
- **Session history is preserved** — all chat sessions are saved and can be resumed later
- Enable **Checkpoints** (`chat.checkpoints.enabled`) to restore workspace state to any point

> **Note:** The Todo List tool was introduced in VS Code 1.103 (experimental) and enabled by default in v1.104+.

> **Use when:** Single-session or multi-session tasks with automatic progress tracking.
>
> **Use structured tracking (Beads, YAML):** Multi-feature work, complex dependencies, or team collaboration requiring explicit task relationships.

### Related Native Features

| Feature | Purpose | Setting/Command |
|---------|---------|-----------------|
| **Todo List** | Automatic task breakdown and progress | Enabled by default (v1.104+) |
| **Checkpoints** | Restore workspace to previous state | `chat.checkpoints.enabled` |
| **Session History** | Review/resume past conversations | Chat view → Session list |
| **Export Session** | Save session as JSON or `.prompt.md` | Session menu → Export |
| **Plan Agent** | Research-first planning before coding | `@plan` or Plan mode |

> **Source:** [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning), [Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints), [Manage Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)

## Anti-Patterns

| Anti-Pattern | Problem | Instead |
|--------------|---------|---------|
| Prose plans | Hard to track, recursive | Structured task lists |
| No IDs | Can't reference tasks | Hierarchical IDs |
| Ignoring discoveries | Lost work, regressions | File immediately |
| Skipping blockers | Work on blocked tasks | Check dependencies first |
| No session close | Lost progress | Mandatory commit+push |

## Related

- [wrap-task-decomposition](wrap-task-decomposition.md) — Creating atomic tasks (input to tracking)
- [spec-driven](spec-driven.md) — Phase 3 produces the tasks to track
- [workflow-orchestration](workflow-orchestration.md) — DAG patterns for dependencies
- [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) — Where to persist task state
- [session-handoff](../CONTEXT-MEMORY/session-handoff.md) — Cross-session continuity

## Sources

### VS Code Native
- [VS Code Chat Planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning) — Native todo list tracking and Plan agent
- [VS Code Chat Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Workspace state restoration
- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Session persistence and export
- [VS Code 1.104 Release Notes](https://code.visualstudio.com/updates/v1_104#_todo-list-tool) — Todo List tool now enabled by default
- [VS Code 1.103 Release Notes](https://code.visualstudio.com/updates/v1_103#_chat-checkpoints) — Checkpoints feature introduced

### Community Patterns (External)
- [steveyegge/beads](https://github.com/steveyegge/beads) — Distributed, git-backed graph issue tracker for AI agents (v0.49.0, 12.5k+ stars)
- [Introducing Beads (Medium)](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) — Steve Yegge's introduction to the Beads system
- [obra/superpowers](https://github.com/obra/superpowers) — Complete software development workflow with session patterns (35k+ stars)
