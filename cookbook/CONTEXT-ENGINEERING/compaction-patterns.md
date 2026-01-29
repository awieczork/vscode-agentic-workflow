---
when:
  - context window filling up during long sessions
  - quality degradation from accumulated noise
  - transitioning between workflow phases
  - preparing for fresh sessions with preserved context
pairs-with:
  - utilization-targets
  - context-quality
  - subagent-isolation
  - session-handoff
requires:
  - file-write
complexity: medium
---

# Compaction Patterns

Techniques for reducing context window usage without losing essential information. Compaction prevents quality degradation when context fills up.

## When to Compact

<!-- NOT IN OFFICIAL DOCS: >60% threshold is community guideline from HumanLayer ACE, not official VS Code guidance - flagged 2026-01-25 -->

| Trigger | Signal | Action |
|---------|--------|--------|
| Phase completion | Finished research/planning | Write summary, fresh session |
| Utilization >60%* | Response slowdown | Compact to file, reload essentials |
| "Summarized history" | Auto-compaction message | Already at limit, `/clear` recommended |
| Quality degradation | Repeated/wrong suggestions | Reset and reload |
| Topic switch | Major context shift | New session with relevant files |

*\\*Community guideline from HumanLayer ACE. Official docs say auto-summarization occurs "when context window is full" but don't specify a percentage threshold.*

## What Gets Compacted

These consume context and should be cleared:

| Source | Impact | Compaction Target |
|--------|--------|-------------------|
| File searches | 100-5000+ tokens | Keep paths, discard contents |
| Tool outputs | 500-2000+ per call | Discard after processing |
| Edit histories | Growing | Keep summary, discard diffs |
| Test/build logs | 1000+ | Extract errors only |
| Conversation | Growing | Summarize decisions |
| JSON blobs | Variable | Extract relevant fields |

## Compaction Techniques

### 1. Phase-Based Compaction (FIC)

Split work into phases, compact between each:

```
┌────────────────────────────────────────┐
│ RESEARCH PHASE                         │
│ → Use subagents for exploration        │
│ → Output: research_doc.md (~200 lines) │
│ → Then: /clear                         │
├────────────────────────────────────────┤
│ PLAN PHASE                             │
│ → Input: research_doc.md only          │
│ → Output: implementation_plan.md       │
│ → Then: /clear                         │
├────────────────────────────────────────┤
│ IMPLEMENT PHASE                        │
│ → Input: implementation_plan.md only   │
│ → Compact to plan when >60%            │
│ → Output: Code + updated plan          │
└────────────────────────────────────────┘
```

### 2. Tool Result Clearing

Safe to discard old tool outputs once processed:

```markdown
## Before (cluttered)
- grep_search results: 2000 tokens
- read_file x3: 6000 tokens
- Previous tool history: 5000 tokens
- Current conversation: 3000 tokens

## After (compacted)
- Tool calls preserved (for reference)
- Results cleared (already processed)
- Summary of findings: 500 tokens
- Current conversation: 3000 tokens
```

**Guideline:** Once a tool was called deep in history, raw results aren't needed again.

### 3. Subagent Summarization

Offload exploration to subagents that return summaries:

```markdown
## Parent Agent Request
Use #runSubagent to research authentication patterns in the codebase.
Return a 50-line summary with:
- Relevant file paths
- Key functions
- Current approach

Do NOT return raw file contents.
```

**Impact:** Subagent uses 10k+ tokens internally, returns ~1k token summary. Parent stays clean.

### 4. Manual Clear + Reload

When quality degrades mid-session:

```markdown
## Step 1: Save state
Write current progress to:
.github/memory-bank/sessions/_active.md

## Step 2: Clear
Use /clear to reset context

## Step 3: Reload essentials
#.github/copilot-instructions.md
#.github/memory-bank/sessions/_active.md
#src/current-focus.ts

## Step 4: Continue
Resume from saved state
```

### 5. Structured Note-Taking

Write progress externally to reduce in-context repetition:

```markdown
# Progress Notes

## Current Objective
Implement refresh token rotation

## Completed
- [x] Database migration
- [x] Token generation

## In Progress
- [ ] Rotation endpoint (70%)

## Decisions Made
- Using RS256 for signing (ADR-001)
- 15-minute token expiry

## Context for Resume
Next: Add token invalidation in src/auth/refresh.ts:45
```

## Compaction Templates

### Research Output Template

<!-- NOT IN OFFICIAL DOCS: ~200 lines is community guideline from FIC patterns, not official VS Code guidance - flagged 2026-01-25 -->

Compact research findings to ~200 lines:

```markdown
# Research: [Topic]

## Summary
[2-3 sentences on findings]

## Relevant Files
| File | Purpose |
|------|---------|
| path/to/file.ts | Description |

## Key Findings
1. Finding one
2. Finding two

## Recommended Approach
[High-level strategy]

## Open Questions
- Question needing clarification
```

### Plan Output Template

Compact plan to ~200 lines:

```markdown
# Plan: [Feature]

## Goal
[One sentence]

## Steps

### 1. [Step Title]
**File:** path/to/file.ts
**Change:** Add function X
**Test:** npm test path/to/file.test.ts

### 2. [Step Title]
[Same structure]

## Progress
- [x] Step 1: Done
- [ ] Step 2: Pending
```

### Session Handoff Template

Compact session state for continuation:

```markdown
# Session State: [timestamp]

## Active Focus
[Current work description]

## Completed This Session
- [x] Item 1
- [x] Item 2

## Pending
- [ ] Item 3 (priority: high)

## Blockers
[Any blocking issues]

## Resume Instructions
Start with [specific file/function]
```

## Compaction Decision Tree

```
Is context >60%?
├── YES → Is task complete?
│         ├── YES → Save output, /clear, start next phase
│         └── NO  → Save progress, /clear, reload essentials
│
└── NO  → Continue working
          │
          └── Quality degrading?
              ├── YES → Save state, /clear anyway
              └── NO  → Continue
```

## Commands Reference

| Command | Purpose |
|---------|---------|
| `/clear` | Reset context, start fresh |
| `#<filename>` | Load specific file (type `#` then filename) |
| `#runSubagent` | Offload to isolated context |
| `bd compact` | Beads: Summarize old closed tasks |

> **Note:** File syntax is `#filename.ts` or `#path/to/file.ts`, not `#file:path`. Type `#` followed by the file name.
>
> Source: [VS Code Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features#add-context-to-your-prompt)

## Workspace Indexing

Configure exclusions to reduce noise before it enters context:

```jsonc
{
  // Affects Copilot workspace indexing (confirmed)
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/.git": true,
    "**/coverage": true,
    "**/*.min.js": true,
    "**/vendor": true
  }
  // .gitignore is also respected by workspace index
}
```

**Impact:** Prevents irrelevant files from being indexed and suggested. Ranked #2 strategy for context optimization.

Source: [VS Code Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context)

## Token-Efficient Formats

Use compact data formats when passing structured data:

| Format | Tokens (benchmark) | Efficiency |
|--------|-------------------|------------|
| **TOON** | 2,744 | Best (40% fewer than JSON) |
| JSON (compact) | 3,081 | Good |
| YAML | 3,719 | Moderate |
| JSON (formatted) | 4,545 | Poor |
| XML | 5,167 | Worst |

**When to use TOON:** LLM context window optimization, tabular/mixed data. Not for external APIs.

Source: [TOON Format](https://toonformat.dev/guide/benchmarks.html)

## Progressive Disclosure

Load context on-demand, not upfront:

```
SKILL.md (overview)
├── Points to detailed files
├── Claude loads on-demand
└── Keep references one level deep

Instead of: Load all potentially relevant data
Do: Maintain lightweight identifiers (paths, queries)
    Load dynamically when needed
```

**Pattern:** Metadata → Instructions → Resources (token-efficient skill loading)

Source: [Anthropic Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)

## Context Quality Priority

<!-- NOT IN OFFICIAL DOCS: This priority hierarchy is from HumanLayer ACE community patterns, not official VS Code/Copilot guidance - flagged 2026-01-25 -->

When compacting, preserve in this order:

| Priority | Aspect | Description |
|----------|--------|-------------|
| 1 | ⭐⭐⭐⭐ Correctness | No false information |
| 2 | ⭐⭐⭐ Completeness | All relevant info included |
| 3 | ⭐⭐ Size | Minimal noise |
| 4 | ⭐ Trajectory | Heading in right direction |

**Worst outcomes (in order):** Incorrect info → Missing info → Too much noise

> **Platform Note:** This is a community-developed prioritization from HumanLayer ACE, not official VS Code/Copilot guidance. Official docs recommend "progressive context building" and "start small and iterate" but don't prescribe a specific priority order.

Source: [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents)

## Automatic Compaction by VS Code

VS Code performs automatic context compaction:

| Scenario | Automatic Behavior |
|----------|-------------------|
| Large file attached | Full contents → outline (functions/descriptions) → excluded if still too large |
| Context window full | Only most relevant parts kept |
| Agent conversation long | Auto-summarizes history (when `summarizeAgentConversationHistory` enabled) |
| Subagent completes | Returns only final result, internal context discarded |

> "If possible, the full contents of the file will be included when you attach a file. If that is too large to fit into the context window, an outline of the file will be included that includes functions and their descriptions without implementations."
>
> Source: [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_add-files-as-context)

## Anti-Patterns

### ❌ Avoid

```markdown
# Loading everything upfront
Read all files in src/ before planning

# Keeping verbose history
[Full conversation with debugging back-and-forth]

# Reprocessing tool outputs
Read the same file multiple times
```

### ✅ Do

```markdown
# Progressive loading
Read files only when needed

# Summarize decisions
"Decided to use X because Y"

# Process once, discard results
Extract what's needed, clear raw output
```

## Related

- [utilization-targets](./utilization-targets.md) — When to trigger compaction
- [subagent-isolation](./subagent-isolation.md) — Offload via subagents
- [memory-bank-schema](../CONFIGURATION/memory-bank-schema.md) — Where to store compacted output
- [research-plan-implement](../WORKFLOWS/research-plan-implement.md) — FIC workflow
- [session-handoff](../CONTEXT-MEMORY/session-handoff.md) — Cross-session continuity

## Sources

### Official VS Code / GitHub Copilot Documentation
- [VS Code - Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — File attachment, context management
- [VS Code - Chat Sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) — Sessions, subagents, `/clear` command
- [VS Code - Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Progressive disclosure, phase workflows
- [VS Code - Workspace Context](https://code.visualstudio.com/docs/copilot/reference/workspace-context) — Indexing, `files.exclude`
- [VS Code - Features Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) — Commands, tools
- [VS Code - Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings) — `summarizeAgentConversationHistory`
- [GitHub - Copilot Cheat Sheet](https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode) — Slash commands, chat variables

### Community / Research Sources
- [Anthropic - Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [HumanLayer - Advanced Context Engineering](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) — Context quality hierarchy
- [TOON Format Benchmarks](https://toonformat.dev/guide/benchmarks.html)
- [Anthropic - Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Beads System](https://github.com/steveyegge/beads)
