---
type: patterns
version: 1.0.0
purpose: Define THE framework approach for persistent memory across sessions
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# Memory Patterns

> **File-based persistent memory enabling context continuity across session boundaries**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. When creating agents, include mandatory memory loading instructions
2. Reference tier-to-file mapping for context loading rules
3. Use session handoff template for `_active.md` content

**For Build Agents:**
1. Create memory bank directory structure on project initialization
2. Initialize core files using templates in STRUCTURE section
3. Implement update triggers as specified

**For Inspect Agents:**
1. Verify memory bank structure matches canonical layout
2. Check all files have `Last Updated` timestamps
3. Validate session handoff contains required fields

---

## PURPOSE

Agents lose ALL memory between sessions. Without explicit persistence:
- Prior work is unknown
- Decisions get contradicted
- Context must be re-established every time

Memory Bank solves this with structured files that persist context, decisions, and state across session boundaries.

**Origin:** Community pattern from [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank), adapted for VS Code Copilot. VS Code has NO native awareness of these files — they work because agents are instructed to read them.

---

## THE FRAMEWORK APPROACH

### Core Principles

```
PRINCIPLE_1: FILE-BASED PERSISTENCE
  Memory lives in structured Markdown/YAML files in .github/memory-bank/
  Files are version-controlled, portable, human-readable

PRINCIPLE_2: TIERED ACCESS
  Organize files by access frequency (HOT/WARM/COLD/FROZEN)
  Load only what's needed for current task

PRINCIPLE_3: MANDATORY LOADING
  Agents MUST load memory at session start (not optional)
  Agent instructions MUST include context loading section

PRINCIPLE_4: APPEND-ONLY DECISIONS
  decisions.md is NEVER modified, only appended
  Preserves full decision history

PRINCIPLE_5: EXPLICIT TIMESTAMPS
  Every file MUST have Last Updated timestamp
  Enables staleness detection
```

### Precedence Rule

When file-based memory conflicts with GitHub Copilot Memory:

```
FILE-BASED MEMORY > COPILOT MEMORY

RATIONALE:
- File-based = intentionally authored, human-controlled
- Copilot Memory = auto-learned conventions, LLM-managed
- Intentional state takes precedence over inferred patterns
```

---

## STRUCTURE

### Canonical Directory Layout

```
.github/memory-bank/
├── manifest.yaml              # Optional: index for large projects
│
├── global/                    # FROZEN tier — stable reference
│   ├── projectbrief.md        # Goals, scope, constraints
│   ├── productContext.md      # Why project exists, users
│   ├── techContext.md         # Stack, architecture, conventions
│   ├── systemPatterns.md      # Code patterns, anti-patterns
│   └── decisions.md           # ADRs (APPEND-ONLY)
│
├── sessions/
│   ├── _active.md             # HOT tier — current session state
│   └── archive/               # WARM → COLD tier
│       └── {YYYY-MM-DD}-{topic}.md
│
└── features/{feature-id}/     # Optional: feature-scoped
    ├── context.md
    └── progress.yaml
```

### Tier-to-File Mapping

| Tier | Files | Access Pattern | Size Target |
|------|-------|----------------|-------------|
| **HOT** | `sessions/_active.md` | Every turn | <1000 tokens |
| **WARM** | `sessions/archive/{recent}/`, `features/*/` | On-demand | <3000 tokens |
| **COLD** | `sessions/archive/{old}/` | Explicit search | Not loaded |
| **FROZEN** | `global/*.md` | Search-based excerpts | Excerpts only |

### Required Sections Per File

| File | Required Sections |
|------|-------------------|
| `projectbrief.md` | Overview, Goals, Scope (In/Out), Constraints, Success Criteria |
| `productContext.md` | Problem Statement, User Personas, Business Context |
| `techContext.md` | Stack (table), Architecture, Key Decisions (table), Conventions |
| `systemPatterns.md` | Code Patterns, Architectural Patterns, Anti-Patterns |
| `decisions.md` | ADR entries: Date, Status, Context, Decision, Consequences |
| `_active.md` | Last Updated, Active Focus, Completed, In Progress, Next Steps, Blockers |

---

## AUTHORING RULES

### File Rules

```
RULE_M001: TIMESTAMP REQUIRED
  REQUIRE: Every memory file has `Last Updated: {ISO8601}` or `**Last Updated**: {ISO8601}`
  REJECT_IF: No timestamp present
  RATIONALE: Enables staleness detection
  EXAMPLE_VALID: "**Last Updated**: 2026-01-28T14:30:00Z"
  EXAMPLE_INVALID: File with no timestamp header

RULE_M002: DECISIONS APPEND-ONLY
  REQUIRE: decisions.md entries are only added, never modified
  REJECT_IF: Existing ADR entry is edited or deleted
  RATIONALE: Full decision history must be preserved
  EXAMPLE_VALID: New ADR-003 added below ADR-002
  EXAMPLE_INVALID: ADR-001 text modified after creation

RULE_M003: SESSION STATE IN _ACTIVE.MD
  REQUIRE: Current session state lives in sessions/_active.md only
  REJECT_IF: Session state scattered across multiple files
  RATIONALE: Single source of truth for "what's happening now"
  EXAMPLE_VALID: Current focus, blockers, next steps all in _active.md
  EXAMPLE_INVALID: Some session state in activeContext.md, some in _active.md

RULE_M004: FROZEN FILES RARELY CHANGE
  REQUIRE: global/*.md files change only on significant project events
  REJECT_IF: Frequent edits to projectbrief.md or techContext.md
  RATIONALE: FROZEN tier is stable reference, not working memory
  EXAMPLE_VALID: techContext.md updated when stack changes
  EXAMPLE_INVALID: techContext.md updated every session
```

### Loading Rules

```
RULE_M005: MANDATORY SESSION START LOADING
  REQUIRE: Agent instructions include memory loading as MUST, not SHOULD
  REJECT_IF: Memory loading described as optional or "consider loading"
  RATIONALE: Without mandatory loading, memory exists but isn't used
  EXAMPLE_VALID: "At session start, MUST read: projectbrief.md, _active.md"
  EXAMPLE_INVALID: "You may optionally load memory bank files"

RULE_M006: TIER-APPROPRIATE LOADING
  REQUIRE: Load tier based on context utilization
  - <60% utilization: HOT + essential WARM
  - >60% utilization: HOT only
  - >80% utilization: Compact, preserve critical HOT only
  REJECT_IF: Loading all files regardless of utilization
  RATIONALE: Prevents context exhaustion

RULE_M007: FROZEN LOADS EXCERPTS ONLY
  REQUIRE: When loading FROZEN tier, load specific sections, not full files
  REJECT_IF: Full projectbrief.md (500+ lines) loaded into context
  RATIONALE: FROZEN files are reference, not working memory
  EXAMPLE_VALID: "From projectbrief.md, Goals section: ..."
  EXAMPLE_INVALID: Entire projectbrief.md in context every turn
```

### Update Rules

```
RULE_M008: UPDATE TRIGGERS
  REQUIRE: Update memory files at specified triggers:
  
  | File | Trigger |
  |------|---------|
  | _active.md | Session start, every 15-20 mins, on blocker, on decision, session end |
  | progress.md | After significant work completion |
  | decisions.md | After architectural/design decision (append) |
  | systemPatterns.md | When new pattern discovered |
  | techContext.md | When stack or architecture changes |
  | projectbrief.md | When scope or goals change |

RULE_M009: SESSION END HANDOFF
  REQUIRE: _active.md MUST be updated before session end with:
  - What was accomplished
  - What's pending
  - Blockers (if any)
  - Clear next steps
  REJECT_IF: Session ends without handoff update
  RATIONALE: Next session must know where to continue
```

---

## TEMPLATES

### Session Handoff Template (`_active.md`)

```markdown
# Session State

**Last Updated**: {ISO8601_timestamp}
**Agent**: {agent name or "user"}

## Active Focus
{1-2 sentences: what is being worked on RIGHT NOW}

## Completed This Session
- [x] {task completed} — {brief result}

## In Progress
- [ ] {current task} — {status or blocker}

## Pending (Prioritized)
- [ ] {task} — priority: **high**
- [ ] {task} — priority: medium

## Blockers
| Issue | Severity | Action Needed |
|-------|----------|---------------|
| {description} | {high/med/low} | {what must happen} |

## Decisions Made
| Decision | Rationale | Reversible? |
|----------|-----------|-------------|
| {choice} | {why} | {yes/no} |

## Next Steps (For Next Session)
1. {immediate action}
2. {follow-up action}

## Context for Resume
- Key files: {list}
- Tests: {status}
```

### Minimal Handoff (Emergency)

```markdown
# Quick Handoff: {timestamp}
**Working on:** {one line}
**Status:** {in-progress/blocked/near-complete}
**Next:** {single most important action}
**Blocker:** {if any, or "None"}
```

### Decisions Entry Template

```markdown
## ADR-{NNN}: {Title}
**Date:** {YYYY-MM-DD}
**Status:** {Proposed | Accepted | Deprecated | Superseded}

**Context:** {What situation prompted this decision?}

**Decision:** {What was decided?}

**Consequences:**
- (+) {Positive outcome}
- (-) {Negative tradeoff}
- Mitigation: {How negatives are addressed}
```

---

## VALIDATION CHECKLIST

```
VALIDATE_MEMORY_BANK:
  □ .github/memory-bank/ directory exists
  □ global/projectbrief.md exists with required sections
  □ sessions/_active.md exists with Last Updated timestamp
  □ All memory files have Last Updated timestamp
  □ decisions.md exists (even if empty initially)

VALIDATE_SESSION_HANDOFF:
  □ Has Last Updated timestamp
  □ Has Active Focus section
  □ Has Next Steps section
  □ Blockers documented (or explicitly "None")

VALIDATE_AGENT_INSTRUCTIONS:
  □ Memory loading is MUST, not SHOULD/MAY
  □ Specifies which files to load at session start
  □ Includes update triggers or references this pattern

VALIDATE_TIER_LOADING:
  □ HOT tier loaded at session start
  □ FROZEN tier loaded as excerpts, not full files
  □ WARM tier loaded only when utilization <60%
```

---

## RECONCILIATION CHECKPOINT

Memory can drift from codebase reality. Periodically verify:

```
RECONCILIATION_CHECKPOINT:
  FREQUENCY: Quarterly OR after major refactor
  
  VERIFY:
  - [ ] techContext.md matches actual stack
  - [ ] systemPatterns.md patterns are still used
  - [ ] projectbrief.md scope matches current work
  - [ ] decisions.md reflects current architecture
  
  ACTION_ON_DRIFT:
  - Update divergent files
  - Add ADR explaining the change
  - Update Last Updated timestamp
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Load all tiers at session start | Load HOT only, WARM on-demand | Context exhaustion |
| Make memory loading optional | Make it MUST in agent instructions | Memory exists but unused |
| Edit decisions.md entries | Append new ADRs only | Loses decision history |
| Store credentials in memory | Use environment variables | Security violation |
| Store large code snippets | Reference by file path | Token-expensive, stales quickly |
| Store raw chat transcripts | Extract facts only | 90%+ token waste |
| Update FROZEN files frequently | Update only on significant change | Wrong tier usage |
| Skip session handoff | Always write before session end | Context loss |
| Assume files are current | Check Last Updated timestamp | Staleness risk |
| Ignore utilization levels | Adjust loading by utilization | Quality degradation |

---

## SIMPLIFIED MODE (2-Tier)

For simple projects, use 2-tier approach:

| Tier | Files |
|------|-------|
| **ACTIVE** | `_active.md`, current feature context |
| **ARCHIVE** | Everything else |

**When to use 2-tier:**
- Projects <2 weeks
- Single developer
- Low context complexity

**When to upgrade to 4-tier:**
- Multiple active features
- Team collaboration
- Context regularly hitting limits

---

## GITHUB COPILOT MEMORY INTEGRATION

GitHub Copilot Memory (Public Preview, Jan 2026) is complementary:

| Aspect | File-Based Memory | Copilot Memory |
|--------|------------------|----------------|
| Content | Intentional state, decisions | Auto-learned conventions |
| Maintenance | Manual | Automatic |
| Retention | Permanent | 28-day TTL |
| Control | Full user control | Limited |
| Scope | Any AI tool | GitHub Copilot only |
| VS Code Chat | ✅ Works now | ⏳ Coming |

**Integration pattern:**
- Let Copilot Memory handle: coding conventions, repo patterns
- Use file-based for: work state, decisions, handoffs, cross-tool scenarios

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [agent-patterns.md](agent-patterns.md) | Agents include memory loading instructions |
| [instruction-patterns.md](instruction-patterns.md) | Instructions may reference memory files |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | Memory determines what's in context vs referenced |
| [CHECKLISTS/memory.md](../CHECKLISTS/memory.md) | Verification checklist for memory bank |

---

## SOURCES

| Source | Contribution |
|--------|--------------|
| [memory-bank-files.md](../../cookbook/CONTEXT-MEMORY/memory-bank-files.md) | 6-file pattern, update triggers, templates |
| [memory-bank-schema.md](../../cookbook/CONFIGURATION/memory-bank-schema.md) | Directory structure, manifest.yaml, conflict resolution |
| [tiered-memory.md](../../cookbook/CONTEXT-MEMORY/tiered-memory.md) | HOT/WARM/COLD/FROZEN tiers, utilization thresholds |
| [session-handoff.md](../../cookbook/CONTEXT-MEMORY/session-handoff.md) | _active.md template, handoff triggers, lifecycle |
| [telos-goals.md](../../cookbook/CONTEXT-MEMORY/telos-goals.md) | Goal tracking (noted as advanced extension) |
| [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank) | Original pattern origin |
| [HumanLayer ACE](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents) | Utilization threshold guidelines (40-60%) |
| [GitHub Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory) | Native memory feature reference |
