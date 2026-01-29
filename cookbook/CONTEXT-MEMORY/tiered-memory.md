---
when:
  - optimizing context window usage
  - organizing memory by access frequency
  - deciding what context to load at session start
  - managing large memory banks efficiently
pairs-with:
  - memory-bank-files
  - session-handoff
  - utilization-targets
  - compaction-patterns
  - just-in-time-retrieval
requires:
  - file-write
complexity: medium
---

# Tiered Memory

> Organize memory files by access frequency and lifespan. Load only what's needed for the current task to maximize context efficiency.

Not all context is created equal. Some information is needed every turn (current task state), some occasionally (recent decisions), and some rarely (project architecture). Tiered memory organizes files by access pattern to optimize context window usage.

## The Four Tiers

| Tier | Scope | Lifespan | Access Pattern | File Location |
|------|-------|----------|----------------|---------------|
| **Hot** | Current task | Session | Every turn | `sessions/_active.md` |
| **Warm** | Recent work | Days | On-demand | `sessions/archive/{recent}/` |
| **Cold** | Historical | Weeks-months | Rare retrieval | `sessions/archive/{old}/` |
| **Frozen** | Reference | Permanent | Search-based | `global/*.md` |

> **Platform Note:** The Hot/Warm/Cold/Frozen terminology is a **synthesized design pattern** for this cookbook. Official platforms use different labels:
> - **Mem0:** Conversation → Session → User → Organization
> - **CrewAI:** Short-term → Long-term → Entity
> - **Azure Foundry:** Static (inject at start) → Contextual (per-turn retrieval)
> - **GitHub Copilot Memory:** Repository-scoped with 28-day expiration
>
> The underlying concept (organize by access frequency/lifespan) is consistent across platforms.

## Tier Characteristics

### Hot Tier — Always Loaded

```markdown
# Hot Tier Files
- sessions/_active.md         # Current session state
- Current spec file            # Active task specification
- Modified files list          # Files being changed this session
```

**Access:** Loaded at every session start. Updated frequently.
**Size target:** <1000 tokens total. Keep minimal.
**Content:** Current focus, immediate next steps, active blockers.

### Warm Tier — Load on Demand

```markdown
# Warm Tier Files
- sessions/archive/{recent}/   # Last 3-5 sessions
- features/{current}/context.md # Active feature context
- decisions.md (recent section) # Recent decisions
```

**Access:** Pull when referenced or when context allows.
**Size target:** <3000 tokens when loaded.
**Content:** Recent context that might be relevant but isn't essential every turn.

### Cold Tier — Rare Retrieval

```markdown
# Cold Tier Files
- sessions/archive/{old}/      # Older sessions
- features/{completed}/        # Completed feature context
- decisions.md (historical)    # Old decisions
```

**Access:** Only when explicitly searching history.
**Size target:** N/A (not loaded into context).
**Content:** Historical record for reference, not active use.

### Frozen Tier — Reference Only

```markdown
# Frozen Tier Files
- global/projectbrief.md       # Project fundamentals
- global/techContext.md        # Architecture, stack
- global/systemPatterns.md     # Code conventions
- global/productContext.md     # Business context
```

**Access:** Search-based, load specific sections.
**Size target:** Load excerpts, not full files.
**Content:** Stable reference information that rarely changes.

## Loading Strategy by Utilization

<!-- NOT IN OFFICIAL DOCS: Specific percentage thresholds are community guidelines from HumanLayer ACE, not official VS Code/Copilot features. Official docs describe qualitative behavior ("when context gets too large") without numeric thresholds. - flagged 2026-01-26 -->

| Utilization | Tier Loading Strategy |
|-------------|----------------------|
| **<40%** | Load HOT + WARM + selective COLD |
| **40-60%** | Load HOT + essential WARM only |
| **>60%** | HOT tier only, summarize everything else |
| **>80%** | Compact immediately, preserve only critical HOT |

> **Community Guideline:** These utilization thresholds are design recommendations from HumanLayer ACE, not official platform features. VS Code describes context management qualitatively ("most relevant parts kept", "when context gets too large") without specific percentages.

See [utilization-targets.md](../CONTEXT-ENGINEERING/utilization-targets.md) for detailed thresholds.

## Mode-to-Tier Alignment

| Workflow Mode | Primary Tiers | Rationale |
|--------------|---------------|-----------|
| Research | FROZEN + COLD | Reference docs, historical patterns |
| Innovate | WARM | Recent learnings, prior explorations |
| Plan | HOT + WARM | Current focus + recent decisions |
| Execute | HOT only | Minimal context, approved plan |
| Review | HOT + FROZEN | Current output + reference standards |

See [riper-modes.md](../WORKFLOWS/riper-modes.md) for mode definitions.

## Tier Transitions

Content moves between tiers based on lifecycle:

```
┌─────────┐     session end     ┌─────────┐     >7 days     ┌─────────┐
│   HOT   │ ─────────────────→  │  WARM   │ ─────────────→  │  COLD   │
└─────────┘                     └─────────┘                 └─────────┘
     ↑                                                            │
     │                    on explicit search                      │
     └────────────────────────────────────────────────────────────┘
```

**Promotion triggers (COLD/WARM → HOT):**
- User references historical context
- Resuming previous feature work
- Explicit `#file` reference (type `#` followed by filename)

**Demotion triggers (HOT → WARM → COLD):**
- Session ends → HOT moves to WARM
- >7 days inactive → WARM moves to COLD
- Feature completed → Feature context archived

## Implementation Patterns

### Session Start Loading

```markdown
## Context Loading Protocol

1. **Always load (HOT):**
   - #file .github/memory-bank/sessions/_active.md
   - Current task specification

2. **Check utilization, then load (WARM):**
   - IF <60% utilization: load recent session summaries
   - IF relevant: load feature context

3. **Search only (FROZEN):**
   - grep_search for specific patterns
   - Read specific sections, not full files
```

### Agent File Configuration

```markdown
<!-- In your .agent.md file -->
## Tier Loading Instructions

### Hot (Always)
At session start, read:
- #file .github/memory-bank/sessions/_active.md

### Warm (On Demand)
When context <60% full, consider:
- Recent session archives (last 3 sessions)
- Active feature context files

### Frozen (Reference Only)
Do NOT load full files. Instead:
- Search for specific terms
- Read only relevant sections
- Summarize before including
```

### Compaction by Tier

<!-- NOT IN OFFICIAL DOCS: 70% and 85% compaction thresholds are community guidelines. Official VS Code uses qualitative triggers ("when context gets too large") and automatic summarization via `github.copilot.chat.summarizeAgentConversationHistory.enabled`. - flagged 2026-01-26 -->

```markdown
## Compaction Strategy

When context exceeds 70%:
1. Summarize WARM tier content → compress to key facts
2. Move detailed WARM → COLD (archive)
3. Update HOT with summary references

When context exceeds 85%:
1. Archive current HOT → WARM
2. Create fresh HOT with essentials only
3. Reference archived content by path, don't include
```

> **VS Code Native:** Enable `github.copilot.chat.summarizeAgentConversationHistory.enabled` for automatic conversation summarization when context grows large. VS Code also reduces attached files to outlines (function signatures only) when full content exceeds context limits.

See [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) for detailed compaction triggers.

## Memory Scoping Levels

For multi-level projects, tiers can have additional scoping:

| Scope | Description | Example Location |
|-------|-------------|------------------|
| **User** | Individual preferences | `memory/user/preferences.md` |
| **Session** | Current task | `memory/sessions/_active.md` |
| **Feature** | Feature-specific | `memory/features/{id}/context.md` |
| **Agent** | Agent-specific state | `memory/agents/{name}/state.yaml` |
| **Shared** | Cross-agent | `memory/shared/decisions.md` |

## VS Code Native: Temporal Context

VS Code has experimental temporal context features that automatically include recently accessed files:

| Setting | Scope | Description |
|---------|-------|-------------|
| `github.copilot.chat.editor.temporalContext.enabled` | Inline Chat | Include recently viewed/edited files |
| `github.copilot.chat.edits.temporalContext.enabled` | Copilot Edits | Include recently viewed/edited files |

These settings provide a simpler alternative to manual tiered memory for tracking "what was I just working on."

Source: [VS Code 1.97 Release Notes](https://code.visualstudio.com/updates/v1_97)

## Retention and Expiration

Tiered memory also involves time-based retention policies:

| Tier | Retention Policy | Validation |
|------|------------------|------------|
| **Hot** | Session lifetime | Always current |
| **Warm** | 7-14 days (configurable) | Validate on load |
| **Cold** | Weeks-months | Search-based retrieval |
| **Frozen** | Permanent | Validate against current codebase |

**GitHub Copilot Memory model:**
- 28-day auto-expiration for unused memories
- Memories validated against current codebase before use
- Refreshed when actively used

**Token efficiency:** Mem0 research reports 90%+ token savings compared to full-context approaches by extracting facts rather than storing raw transcripts.

See [GitHub Copilot Memory docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) for platform-specific retention.

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Loading all tiers at start | Context exhaustion | Load HOT only, pull WARM on demand |
| No tier classification | Everything feels urgent | Classify files by access frequency |
| FROZEN content in HOT | Wastes tokens on stable info | Move to FROZEN, search when needed |
| No archival process | WARM grows unbounded | Auto-archive after 7 days |
| Loading full FROZEN files | Reference overwhelms context | Load excerpts, summarize |

## Related

- [memory-bank-files.md](memory-bank-files.md) — The 6-file templates stored in tiers
- [memory-bank-schema.md](../CONFIGURATION/memory-bank-schema.md) — Directory structure for tiers
- [utilization-targets.md](../CONTEXT-ENGINEERING/utilization-targets.md) — Thresholds for tier loading decisions
- [compaction-patterns.md](../CONTEXT-ENGINEERING/compaction-patterns.md) — Triggers for tier transitions
- [session-handoff.md](session-handoff.md) — HOT → WARM transition template

## Sources

**Official Documentation** (validated 2026-01-26):
- [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) — Repository-scoped, 28-day retention, citation validation
- [VS Code Context Management](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — #-mentions, file→outline→exclude fallback
- [VS Code 1.97 Release Notes](https://code.visualstudio.com/updates/v1_97) — Temporal context settings
- [VS Code 1.101 Release Notes](https://code.visualstudio.com/updates/v1_101) — Agent conversation summarization

**Community Patterns:**
- [mem0ai/mem0](https://github.com/mem0ai/mem0) — Multi-level memory scoping
- [Mem0 Memory Types](https://docs.mem0.ai/core-concepts/memory-types) — Conversation/Session/User/Org layers
- [mem0 Research Paper](https://arxiv.org/html/2504.19413v1) — Token efficiency through tiered compression (90%+ savings)
- [danielmiessler/PAI](https://github.com/danielmiessler/Personal_AI_Infrastructure) — Three-tier memory architecture
- [Anthropic Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — Compaction and tier transition strategies
- [LangMem Hot Path](https://langchain-ai.github.io/langmem/hot_path_quickstart/) — Active vs background memory creation
- [HumanLayer ACE](https://github.com/humanlayer/12-factor-agents) — Utilization threshold guidelines (40-60%)
