---
when:
  - multiple agents updating same memory file
  - session handoffs causing conflicting state
  - deciding between append vs overwrite for updates
  - implementing memory bank file locking
pairs-with:
  - memory-bank-files
  - session-handoff
  - tiered-memory
requires:
  - file-write
complexity: medium
---

# Conflict Resolution

> When multiple agents or sessions update the same memory file, how do you decide which changes win? Strategies for handling concurrent memory updates.

> **Platform Note:** VS Code/GitHub Copilot does not provide native conflict resolution for custom memory files. This cookbook documents community patterns from mem0, Beads, and Cline Memory Bank. GitHub Copilot Memory uses a different approach: [citation-based just-in-time verification](#github-copilots-citation-based-verification). The strategies here are design patterns for custom memory implementations.

Memory bank files can be updated by different agents, different sessions, or by user edits. Without explicit conflict resolution strategies, you get undefined behavior — overwrites, lost information, or corrupted state.

## The ADD/UPDATE/DELETE/NOOP Model

<!-- NOT IN OFFICIAL DOCS: ADD/UPDATE/DELETE/NOOP model is from mem0 research paper, not VS Code/Copilot - flagged 2026-01-26 -->

From the [mem0 research paper](https://arxiv.org/html/2504.19413v1), every memory update falls into one of four categories:

| Operation | When to Apply | Example |
|-----------|---------------|---------|
| **ADD** | New information not in memory | "Prefers TypeScript" (not previously recorded) |
| **UPDATE** | Enriches existing fact | "likes pizza" → "loves cheese pizza" |
| **DELETE** | Contradicts existing fact | "dislikes pizza" removes "likes pizza" |
| **NOOP** | Already captured accurately | No change needed |

**Decision Flow:**
```
New information arrives
        │
        ▼
┌───────────────────┐
│ Search existing   │
│ memory for match  │
└───────────────────┘
        │
        ▼
    ┌───────┐
    │ Found │
    │ match?│
    └───────┘
     │     │
   Yes     No
     │      │
     ▼      ▼
┌─────────┐ ┌─────────┐
│Compare  │ │   ADD   │
│semantics│ │         │
└─────────┘ └─────────┘
     │
     ▼
┌──────────────────┐
│Enriches? →UPDATE │
│Contradicts?→DELETE│
│Same? → NOOP      │
└──────────────────┘
```

## Strategies by File Type

<!-- NOT IN OFFICIAL DOCS: These conflict strategies are community design patterns, not VS Code features - flagged 2026-01-26 -->

Different memory files need different conflict strategies:

```yaml
conflict_resolution:
  # Append-only: Never lose information
  global_files:
    strategy: "append_only"
    applies_to: ["decisions.md", "patterns.md"]

  # Last-write-wins: Current state matters most
  session_files:
    strategy: "last_write_wins"
    applies_to: ["sessions/**"]

  # Semantic merge: Merge by unique key
  progress_files:
    strategy: "semantic_merge"
    applies_to: ["**/progress.yaml"]
    merge_keys: ["task_id"]

  # Frozen: Reference only, no edits
  reference_files:
    strategy: "frozen"
    applies_to: ["global/projectbrief.md", "global/techContext.md"]
```

### Strategy Definitions

| Strategy | Behavior | Use For |
|----------|----------|---------|
| **append_only** | New entries added, existing never modified | Decision logs, pattern discoveries |
| **last_write_wins** | Most recent write overwrites | Session state, active context |
| **semantic_merge** | Merge by unique key field | Progress tracking, task lists |
| **frozen** | No modifications allowed | Reference documentation |

## Implementation Patterns

### Append-Only for Decisions

Decisions should never be deleted or modified — only new decisions added.

```markdown
<!-- decisions.md -->
# Decisions

## 2026-01-23
### Decision: Use PostgreSQL for persistence
**Context**: Need relational data with complex queries
**Options**: PostgreSQL, MongoDB, SQLite
**Choice**: PostgreSQL
**Rationale**: Team expertise, query requirements
**Status**: Approved

## 2026-01-22
### Decision: TypeScript strict mode
...
```

**Conflict handling:** If two agents record decisions simultaneously, append both with timestamps. Let humans reconcile if contradictory.

### Last-Write-Wins for Session State

Current session state replaces previous state entirely.

```markdown
<!-- sessions/_active.md -->
# Active Context

**Last Updated**: 2026-01-23T14:30:00Z
**Updated By**: implementer-agent

## Current Focus
Implementing user authentication

## Next Steps
1. Add JWT validation middleware
2. Create protected routes
```

**Conflict handling:** Most recent timestamp wins. Include `Updated By` for audit trail.

### Semantic Merge for Progress

Merge by unique identifier, don't overwrite entire file.

```yaml
# features/auth/progress.yaml
tasks:
  - id: auth-001
    name: Create login endpoint
    status: complete
    updated: 2026-01-23T10:00:00Z

  - id: auth-002
    name: Add JWT validation
    status: in-progress
    updated: 2026-01-23T14:00:00Z
```

**Conflict handling:** If Agent A updates `auth-001` and Agent B updates `auth-002`, merge both changes. If both update same `id`, use most recent `updated` timestamp.

## Conflict Markers

<!-- NOT IN OFFICIAL DOCS: Conflict marker format is a cookbook design pattern - flagged 2026-01-26 -->

When automatic resolution isn't possible, mark the conflict for human review:

```markdown
<!-- CONFLICT: 2026-01-23T14:30:00Z -->
**Agent A wrote (14:25:00Z):**
> Authentication should use session cookies

**Agent B wrote (14:30:00Z):**
> Authentication should use JWT tokens

**Resolution needed**: Choose approach before proceeding
<!-- END CONFLICT -->
```

### Conflict Marker Protocol

1. **Detection**: Two writes to same content within threshold (e.g., 5 minutes)
2. **Marking**: Insert conflict block with both versions + timestamps
3. **Notification**: Include in session handoff as blocker
4. **Resolution**: Human chooses, removes marker

## Agent Instructions for Conflict Handling

Add to your agent file:

```markdown
## Memory Update Protocol

When updating memory files:

1. **Check file type → strategy**
   - `decisions.md` → Append new entry, never modify existing
   - `_active.md` → Overwrite with current state
   - `progress.yaml` → Merge by task_id

2. **Before writing**
   - Read current content
   - Check for conflict markers
   - If markers exist, resolve or escalate before proceeding

3. **When writing**
   - Include timestamp in ISO8601 format
   - Include agent name in metadata
   - For append-only: add new section, don't modify old

4. **After writing**
   - Verify write completed
   - Update session handoff if significant change
```

## Cross-Agent Scenarios

### Scenario: Two Agents Update Progress

```
Agent A: Completes task-001
Agent B: Starts task-002

Both update progress.yaml
```

**Resolution**: Semantic merge by `task_id`
- Agent A's change to task-001 preserved
- Agent B's change to task-002 preserved
- No conflict

### Scenario: Contradictory Decisions

```
Agent A: Records "Use REST API"
Agent B: Records "Use GraphQL"
```

**Resolution**: Both appended to decisions.md
- Add conflict marker noting contradiction
- Flag in session handoff for human resolution

### Scenario: Session State Race

```
Agent A: Updates _active.md at 14:25:00
Agent B: Updates _active.md at 14:25:05
```

**Resolution**: Last-write-wins
- Agent B's version persists
- Agent A's changes lost (acceptable for transient state)

## Configuration in Memory Bank Schema

<!-- NOT IN OFFICIAL DOCS: manifest.yaml conflict_resolution config is a cookbook extension, not VS Code native - flagged 2026-01-26 -->

```yaml
# In manifest.yaml
memory_bank:
  version: "1.0"

  conflict_resolution:
    default_strategy: "last_write_wins"

    overrides:
      - pattern: "**/decisions.md"
        strategy: "append_only"

      - pattern: "**/progress.yaml"
        strategy: "semantic_merge"
        merge_key: "id"

      - pattern: "global/**"
        strategy: "frozen"

    conflict_markers:
      enabled: true
      format: "<!-- CONFLICT: {timestamp} -->"
      threshold_seconds: 300  # 5 minutes
```

See [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) for full schema.

## GitHub Copilot's Citation-Based Verification

GitHub Copilot Memory takes a different approach: **citation-based just-in-time verification**.

> **Official Documentation:** "Each memory that Copilot generates is stored with citations. These are references to specific code locations that support the memory. When Copilot finds a memory that relates to the work it is doing, it checks the citations against the current codebase to validate that the information is still accurate." — [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

**How it works:**
1. Memories are stored with **citations** (code locations that support the memory)
2. Before using a memory, agents verify citations against current codebase
3. If code contradicts memory, agents store corrected versions
4. Memories auto-expire after 28 days if not validated and reused

> **28-Day Expiry:** "To avoid stale memories being retained, resulting in outdated information adversely affecting Copilot's decision making, memories are automatically deleted after 28 days. If a memory is validated and used by Copilot, then a new memory with the same details may be stored, which increases the longevity of that memory." — [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-memories-are-stored-retained-and-used)

**Memory Scope:**
- **Repository-specific**: Memories are scoped to a repository, not user
- **Cross-feature sharing**: Memories created by one agent (e.g., Coding Agent) can be used by another (e.g., Code Review)
- **Opt-in required**: Enable via GitHub account settings at github.com/settings/copilot

```yaml
memory_example:
  content: "This codebase uses TypeScript strict mode"
  citation:
    file: "tsconfig.json"
    line_range: [1, 5]
  last_validated: "2026-01-23T10:00:00Z"
  expires: "2026-02-20T10:00:00Z"  # 28 days
```

**Self-Healing Pattern:**

> **Verified:** "Across 100 diverse sessions, agents consistently verified citations, discovered contradictions, and updated incorrect memories. The memory pool self-healed as agents stored corrected versions of outdated memories." — [GitHub Engineering Blog](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/)

- Multiple agents share the same memory pool
- Each agent independently verifies memories before use
- When an agent finds outdated memory, it corrects it
- No central conflict resolution—distributed self-correction

This pattern is particularly effective for code-centric repositories where citations can be programmatically verified.

## Conflict Log Template

From the Mem0 pattern, track all conflict resolutions in a structured log:

```markdown
## Conflict Log

| Timestamp | Old Fact | New Fact | Action | Agent |
|-----------|----------|----------|--------|-------|
| 2026-01-23T10:30 | Uses localStorage | Prefers httpOnly cookies | UPDATE | security-agent |
| 2026-01-22T14:00 | Prefers REST | Prefers GraphQL | DELETE+ADD | architect-agent |
| 2026-01-21T09:15 | — | Uses PostgreSQL | ADD | setup-agent |
```

**Usage:**
- Append to global log (never delete entries)
- Include agent name for audit trail
- Log `DELETE+ADD` when UPDATE isn't supported (mem0 Platform pattern)

## Hash-Based IDs for Merge Safety

<!-- NOT IN OFFICIAL DOCS: Hash-based IDs are from steveyegge/beads, not VS Code - flagged 2026-01-26 -->

From the [Beads system](https://github.com/steveyegge/beads), use hash-based IDs to prevent merge collisions:

```markdown
## Tasks

- [bd-a1b2c3] Implement authentication — Status: complete
- [bd-d4e5f6] Add JWT validation — Status: in-progress
- [bd-g7h8i9] Create protected routes — Status: pending
```

**Benefits:**
- **Unique identifiers** prevent confusion when multiple agents work on similar tasks
- **JSONL format** enables intelligent merging (line-based, each ID is unique)
- **Hash prefixes** (`bd-`) make IDs recognizable and searchable

**Conflict handling:** When two agents update different IDs, merge both. When both update same ID, use most recent timestamp.

## VS Code Checkpoints for State Recovery

> **Official Feature:** VS Code provides checkpoints as a mechanism for reverting workspace state during chat sessions. While not specifically designed for conflict resolution, checkpoints can help recover from unwanted changes.

**How Checkpoints Work:**
- Automatic snapshots of workspace files during chat interactions
- Restore workspace to any previous checkpoint state
- Created after each accepted chat request when enabled

> "Use chat checkpoints to restore all files to a previous state, or redo edits after they have been reverted. A checkpoint is created after each accepted chat request." — [VS Code Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

**Important Limitation:**
> "Checkpoints are designed for quick iteration within a chat session and are temporary. They complement Git but don't replace it." — [VS Code Docs](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

**Enable Checkpoints:**
```json
{
  "chat.checkpoints.enabled": true
}
```

## Session Completion Protocol

<!-- NOT IN OFFICIAL DOCS: Git push completion protocol is a community pattern - flagged 2026-01-26 -->

**Prevent conflicts before they happen** by completing sessions cleanly:

```markdown
## Before Ending Session

1. **Commit all changes**
   ```bash
   git add -A
   git commit -m "Session complete: [summary]"
   ```

2. **Push to remote**
   ```bash
   git push origin [branch]
   ```

3. **Verify push succeeded**
   ```bash
   git status  # Should show "up to date with origin"
   ```

**CRITICAL**: Session is NOT complete until push succeeds.
```

This prevents concurrent edit conflicts by ensuring all changes are synchronized before another agent or session begins.

## Sources

### Official Documentation ✓
- [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) — Citation-based verification, 28-day expiry (verified)
- [GitHub Engineering Blog](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) — Self-healing memory pools (verified)
- [VS Code Checkpoints](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Workspace state recovery (verified)

### Community Patterns
- [mem0 Research Paper](https://arxiv.org/html/2504.19413v1) — ADD/UPDATE/DELETE/NOOP model
- [mem0ai/mem0](https://github.com/mem0ai/mem0) — Memory conflict resolution implementation
- [steveyegge/beads](https://github.com/steveyegge/beads) — Hash-based IDs, JSONL merge strategy
- [CRDT Patterns](https://crdt.tech/) — Conflict-free replicated data types (reference)

## Related

- [memory-bank-files.md](memory-bank-files.md) — The 6-file pattern that needs conflict resolution
- [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) — YAML configuration for strategies
- [tiered-memory.md](tiered-memory.md) — Tier transitions as merge points
- [session-handoff.md](session-handoff.md) — Handling conflicts in handoffs
- [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) — Agent-to-agent state transfer
- [task-tracking.md](../WORKFLOWS/task-tracking.md) — Hash-based issue IDs from Beads
