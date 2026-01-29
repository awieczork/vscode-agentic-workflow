---
when:
  - ending a session with incomplete work
  - handing off work between sessions
  - context window approaching limit
  - preserving decisions for next session
pairs-with:
  - memory-bank-files
  - tiered-memory
  - handoffs-and-chains
  - compaction-patterns
requires:
  - file-write
complexity: low
---

# Session Handoff

> Preserve context across session boundaries. When a session ends (or context fills), write a handoff file so the next session can resume without loss.

Copilot agents lose memory between sessions. Without explicit handoff, the next session starts cold — no knowledge of what was done, what's pending, or what was decided. Session handoff files bridge this gap.

> **Platform Note:** VS Code 1.108+ provides native chat session history (workspace-scoped), but it is NOT portable across machines or shareable with teams. Project-portable chat history was [requested but closed as out-of-scope](https://github.com/microsoft/vscode/issues/257143) (December 2025). The `_active.md` pattern remains necessary for intentional context control and team-shareable state.

## The Problem

```
Session 1: Works on feature, makes progress, decides on approach
           [Session ends / Context fills]
Session 2: Starts fresh. "What was I working on?"
           Has to re-read everything, may make contradictory decisions
```

## Native Session Features (VS Code 1.108+)

VS Code provides built-in session management:

| Feature | Description | Limitation |
|---------|-------------|------------|
| **Agent Sessions View** | Centralized view for local, background, cloud, and third-party sessions | Workspace-scoped only |
| **Session Types** | Local, Background Agent, Cloud Agent, Third-Party (e.g., OpenAI Codex) | Not portable across machines |
| **Session History** | Return to previous conversations | Not shareable with teams |
| **Export to JSON** | `Chat: Export Chat...` command | Manual, one-time export |
| **Export to Prompt** | `/savePrompt` command | Saves as reusable prompt file |
| **Context Summarization** | Auto-summarizes when context window fills | Setting: `github.copilot.chat.summarizeAgentConversationHistory.enabled` |

<!-- NOT IN OFFICIAL DOCS: Storage location workspaceStorage/[workspace-id]/chatSessions/ - flagged 2026-01-26 -->
**Storage:** Sessions stored locally in workspace storage (exact path not documented)

**When to use native vs handoff files:**
- **Native history**: Quick recall within same workspace on same machine
- **Handoff files**: Team collaboration, cross-machine work, intentional checkpoints

## Copilot Memory (Public Preview)

[Copilot Memory](https://docs.github.com/copilot/concepts/agents/copilot-memory) provides cross-session, repository-level knowledge persistence:

| Aspect | Details |
|--------|---------|
| **Scope** | Repository-level (not session-specific) |
| **Retention** | 28-day cycle; used memories get refreshed |
| **Cross-Agent** | Shared between coding agent, CLI, code review |
| **Validation** | LLM validates with source citations |
| **Opt-In** | Enable in user/organization/enterprise settings (user-based, not repository) |

**Copilot Memory vs `_active.md` Handoffs:**

| Copilot Memory | `_active.md` Handoffs |
|----------------|----------------------|
| Auto-learned conventions | Intentionally authored |
| Repository patterns | Task state and decisions |
| 28-day TTL | Explicit archiving |
| LLM-managed | Human-controlled |

**Key Insight:** Copilot Memory handles repository conventions (coding patterns, preferences) while handoff files capture work-in-progress state. They complement each other.

> **Platform Note:** Copilot Memory currently works with Copilot coding agent, Copilot code review (on GitHub.com pull requests), and Copilot CLI. VS Code Chat integration is not yet available (as of January 2026). Memory will be extended to other parts of Copilot in future releases.

## The Solution: `_active.md`

<!-- NOT IN OFFICIAL DOCS: _active.md pattern and .github/memory-bank/ structure - flagged 2026-01-26 -->
<!-- This is a community pattern originating from Cline Memory Bank, adapted for VS Code Copilot workflows -->

Maintain a "hot" session state file that's updated throughout the session and serves as the handoff document.

> **Community Pattern:** The `.github/memory-bank/` structure and `_active.md` pattern are not native VS Code features. This is a community convention from [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank), adapted for VS Code Copilot workflows to provide intentional, portable session state.

**Location:** `.github/memory-bank/sessions/_active.md`

## Session Handoff Template

```markdown
# Session State

**Last Updated**: {ISO8601_timestamp}
**Session ID**: {optional unique identifier}
**Agent**: {agent name or "user"}

## Active Focus
{1-2 sentences: what is being worked on RIGHT NOW}

## Completed This Session
- [x] {task/action completed} — {brief result}
- [x] {task/action completed} — {brief result}

## In Progress
- [ ] {current task} — {current status/blocker}

## Pending (Prioritized)
- [ ] {task} — priority: **high**
- [ ] {task} — priority: medium
- [ ] {task} — priority: low

## Blockers
| Issue | Severity | Action Needed |
|-------|----------|---------------|
| {blocker description} | {high/med/low} | {what needs to happen} |

## Decisions Made
| Decision | Rationale | Reversible? |
|----------|-----------|-------------|
| {choice made} | {why} | {yes/no} |

## Next Steps (For Next Session)
1. {immediate action to take}
2. {follow-up action}
3. {if time permits}

## Context for Resume
{Any context the next session needs to understand the current state}
- Key files modified: {list}
- Tests status: {passing/failing/pending}
- Dependencies discovered: {any new requirements}

## Memory Files Updated This Session
- {file path} — {what changed}
```

## Session Hooks

Configure session lifecycle events in `.github/hooks/*.json`:

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      { "type": "command", "bash": "echo 'Session started' >> .github/memory-bank/sessions.log", "powershell": "Add-Content -Path '.github/memory-bank/sessions.log' -Value 'Session started'" }
    ],
    "sessionEnd": [
      { "type": "command", "bash": "git add .github/memory-bank/ && git commit -m 'Session handoff'", "powershell": "git add .github/memory-bank/; git commit -m 'Session handoff'" }
    ]
  }
}
```

| Hook | Trigger | Use Case |
|------|---------|----------|
| `sessionStart` | Agent session begins | Initialize environment, log start |
| `sessionEnd` | Agent session completes | Cleanup, commit handoff files |
| `userPromptSubmitted` | User submits a prompt | Logging, validation |
| `preToolUse` | Before tool execution | Approve/deny tool calls |
| `postToolUse` | After tool execution | Logging, state updates |
| `errorOccurred` | Error during execution | Error handling, notifications |

> **Source:** [GitHub Hooks Configuration](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)

## When to Write Handoffs

| Trigger | Action |
|---------|--------|
| **Context >60% full** | Write handoff, continue working |
| **Context >80% full** | Write handoff, consider fresh session |
| **Significant milestone** | Write handoff (checkpoint) |
| **Before any break** | Write handoff |
| **Session ending** | Write handoff (mandatory) |
| **Blocker encountered** | Write handoff with blocker details |

### Signs of Stale Context

Write a handoff immediately if you observe:

- **Context auto-summarization triggers** — VS Code "automatically summarizes and condenses the information to fit the window"
- Response quality degradation (less specific, more generic)
- Repeated suggestions for already-rejected approaches
- Agent "forgets" earlier decisions in the same session
- Longer response times without obvious cause

These indicate the context window is near capacity or has been auto-compacted.

> **Official Guidance:** "Keep context fresh: Regularly audit and update your project documentation (using the agent) as the codebase evolves. Stale context leads to outdated or incorrect suggestions." — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## Handoff Lifecycle

```
Session Start
    │
    ▼
┌─────────────────────────┐
│ Read _active.md         │  ← Resume from previous
│ Load relevant context   │
└─────────────────────────┘
    │
    ▼
    Work (update _active.md periodically)
    │
    ▼
┌─────────────────────────┐
│ Session End Approaching │
└─────────────────────────┘
    │
    ▼
┌─────────────────────────┐
│ Final _active.md update │
│ Archive if milestone    │
└─────────────────────────┘
    │
    ▼
┌─────────────────────────┐
│ Move _active.md → WARM  │  ← Tier transition
│ Create fresh _active.md │     (if archiving)
└─────────────────────────┘
```

## Session Start Protocol

When beginning a new session:

```markdown
## Context Loading

1. **Read hot tier:**
   - #file:.github/memory-bank/sessions/_active.md

2. **Check for blockers:**
   - If blockers exist, address or escalate before proceeding

3. **Verify pending items:**
   - Are "Next Steps" still valid?
   - Any external changes that affect the plan?

4. **Update timestamp:**
   - Mark session start in _active.md

5. **Continue from "Next Steps":**
   - Execute first item from previous session's Next Steps
```

## Session End Protocol

Before ending a session:

```markdown
## Session Completion Checklist

- [ ] All modified files saved
- [ ] Tests run (note status in handoff)
- [ ] _active.md updated with:
  - [ ] Completed items checked off
  - [ ] Current progress noted
  - [ ] Blockers documented
  - [ ] Next steps listed
- [ ] Decisions recorded in decisions.md (if any)
- [ ] Changes committed (if applicable)
```

## Agent Instructions for Handoff

Add to your agent file:

```markdown
## Session Management

### During Session
Update _active.md when:
- Completing a significant task
- Encountering a blocker
- Making a decision
- Every 15-20 minutes of active work

### Before Session End
1. Stop work at a clean boundary
2. Update _active.md with:
   - What was accomplished
   - What's pending
   - Any blockers
   - Clear next steps
3. Commit/save all files
4. Verify _active.md is current

### When Context Fills (>80%)
1. Write comprehensive handoff to _active.md
2. Notify user: "Context nearly full. Handoff written."
3. Suggest: "Start fresh session to continue"
```

## Archiving Sessions

When a milestone completes, archive the session:

```bash
# Archive pattern
.github/memory-bank/sessions/
├── _active.md                      # Current (HOT)
└── archive/
    ├── 2026-01-23-auth-feature.md  # Archived (WARM)
    └── 2026-01-20-setup.md         # Older (COLD)
```

**Archive when:**
- Feature/milestone completes
- Shifting to unrelated work
- Weekly cleanup

**Archive format:** `{YYYY-MM-DD}-{brief-topic}.md`

## Session Handoff vs Agent Handoff

| Aspect | Session Handoff | Agent Handoff |
|--------|-----------------|---------------|
| **Purpose** | Temporal continuity | Task delegation |
| **Scope** | Same agent, different time | Different agents, same time |
| **File** | `_active.md` | `handoffs/{task}.md` |
| **Content** | Full session state | Task-specific context |

See [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) for agent-to-agent handoffs.

## Minimal Handoff (Emergency)

If context is filling fast and time is short:

```markdown
# Quick Handoff: {timestamp}

**Working on:** {one line}
**Status:** {in-progress/blocked/near-complete}
**Next:** {single most important action}
**Blocker:** {if any, or "None"}
```

Even a minimal handoff is better than none.

## Related

- [memory-bank-files.md](memory-bank-files.md) — The `activeContext.md` template
- [tiered-memory.md](tiered-memory.md) — HOT → WARM tier transitions at session end
- [conflict-resolution.md](conflict-resolution.md) — `_active.md` uses last-write-wins
- [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) — When to trigger handoff
- [handoffs-and-chains.md](../WORKFLOWS/handoffs-and-chains.md) — Agent-to-agent handoffs (different pattern)
- [task-tracking.md](../WORKFLOWS/task-tracking.md) — Session completion protocol

## Native Session Handoffs (Agent Delegation)

VS Code provides built-in session handoff capabilities for delegating between agent types:

| Method | Description |
|--------|-------------|
| **Continue In control** | In Chat view, use "Continue In" to delegate to a different agent type |
| **`@cli` mention** | Type `@cli` in prompt to delegate to background agent |
| **`@cloud` mention** | Type `@cloud` in prompt to delegate to cloud agent |
| **Custom agent handoffs** | Configure `handoffs` property in `.agent.md` frontmatter |

When delegating:
- Full conversation context (including file references) is forwarded
- If context exceeds target's window, VS Code auto-summarizes to fit
- Creates new agent session with context carried over

> **Source:** [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview#_hand-off-a-session-to-another-agent)

## Context Isolation Recommendation

> **Official Guidance:** "Maintain context isolation: Keep different types of work (planning, coding, testing, debugging) in separate chat sessions to prevent context mixing and confusion." — [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide)

## Subagents for Isolated Tasks

For tasks that need context isolation within a session (rather than full session handoff):

```
#runSubagent [task description]
```

Subagents run in isolated context windows and return results to the parent session. Use when you need:
- Parallel task execution
- Context isolation without full session switch
- Task delegation within same agent

> **Source:** [VS Code Chat Sessions - Subagents](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_context-isolated-subagents)

## Sources

- [VS Code Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Native session management
- [VS Code Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview) — Agent types, sessions list, handoffs
- [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Official context management principles
- [VS Code Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — Session-related settings
- [Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) — Cross-session repository knowledge
- [GitHub Hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks) — Session lifecycle hooks (6 hook types)
- [Copilot Memory Engineering](https://github.blog/ai-and-ml/github-copilot/building-an-agentic-memory-system-for-github-copilot/) — Technical implementation
- [roo-framework session-handoff.md](https://github.com/JackSmack1971/roo-autonomous-ai-development-framework/blob/main/memory-bank/session-handoff.md) — Structured handoff pattern
- [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank) — `activeContext.md` pattern origin
- [Advanced Context Engineering](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — FIC workflow for session continuity
