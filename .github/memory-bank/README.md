# Memory Bank

Session and global state management for AI agents.

<semantics>

**Ephemeral (session-scoped):**
- `_active.md` — Current session state, cleared between sessions
- Agents update via `<update_triggers>` events

**Persistent (cross-session):**
- `global/` — Project-level state (created separately)
- `global/generation-feedback.md` — Cross-session generation outcomes log

</semantics>

<usage>

Agents load `_active.md` as HOT tier context per `<context_loading>`.

Update triggers:
- session_start — Initialize or resume
- task_complete — Record progress
- session_end — Capture handoff notes

</usage>
