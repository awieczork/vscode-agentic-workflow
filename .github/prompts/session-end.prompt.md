---
description: "Update memory-bank with session progress, decisions, and handoff notes for continuity"
name: "session-end"
argument-hint: "Optional: specific notes to include in handoff"

---

# Session End

<task>

Update memory-bank files to persist this session's state for future continuity.

Perform these steps:
1. Read current `.github/memory-bank/sessions/_active.md`
2. Update session state with progress from this conversation
3. If significant decisions were made, check if ADR needed in `global/decisions.md`
4. Write clear handoff notes for the next session

</task>

<context>

User input (if provided): ${input:notes:Any specific notes to include?}

Session context to capture:
- Tasks worked on
- Decisions made
- Progress completed
- Remaining work
- Blockers or open questions

</context>

<format>

After updating, confirm:
```
Session state updated:
- Progress: [items added]
- Decisions: [recorded or N/A]
- ADR: [created ADR-NNN or N/A]
- Handoff: [summary of notes]
```

</format>

<constraints>

- Follow rules in memory-bank.instructions.md (auto-loaded for memory-bank files)
- Preserve existing session structure — update sections, do not replace file
- Use ISO 8601 timestamps
- Keep handoff notes actionable and specific
- Do not store code or implementation details — only decisions and state

</constraints>
