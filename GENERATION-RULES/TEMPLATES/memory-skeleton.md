---
type: template
version: 1.0.0
purpose: Copy-paste starting point for memory bank structure and files
applies-to: [generator, build]
template-for: memory
last-updated: 2026-01-28
---

# Memory Skeleton

> **File-based persistent memory enabling context continuity across sessions**

---

## HOW TO USE THIS TEMPLATE

**For Generator Agents:**
1. Create directory structure using DIRECTORY TEMPLATE
2. Initialize required files using FILE TEMPLATES
3. Configure agent instructions to load memory

**For Build Agents:**
1. Create `.github/memory-bank/` directory
2. Initialize projectbrief.md, _active.md, decisions.md
3. Add memory loading to agent `<context_loading>` sections

**For Users:**
1. Create the directory structure
2. Fill projectbrief.md with project information
3. Use _active.md to track session state

---

## DIRECTORY TEMPLATE

```
.github/memory-bank/
├── manifest.yaml              # Optional: index for large projects
│
├── global/                    # FROZEN tier — stable reference
│   ├── projectbrief.md        # Goals, scope, constraints (REQUIRED)
│   ├── productContext.md      # Why project exists, users
│   ├── techContext.md         # Stack, architecture, conventions
│   ├── systemPatterns.md      # Code patterns, anti-patterns
│   └── decisions.md           # ADRs (APPEND-ONLY) (REQUIRED)
│
├── sessions/
│   ├── _active.md             # HOT tier — current session (REQUIRED)
│   └── archive/               # WARM → COLD tier
│       └── {YYYY-MM-DD}-{topic}.md
│
└── features/{feature-id}/     # Optional: feature-scoped
    ├── context.md
    └── progress.yaml
```

**Minimum Viable Setup:** `projectbrief.md`, `_active.md`, `decisions.md`

---

## TIER-TO-FILE MAPPING

| Tier | Files | Access Pattern | Size Target |
|------|-------|----------------|-------------|
| **HOT** | `sessions/_active.md` | Every turn | <1000 tokens |
| **WARM** | `sessions/archive/{recent}/`, `features/*/` | On-demand | <3000 tokens |
| **COLD** | `sessions/archive/{old}/` | Explicit search | Not loaded |
| **FROZEN** | `global/*.md` | Search-based excerpts | Excerpts only |

---

## FILE TEMPLATES

### projectbrief.md (REQUIRED)

**Location:** `.github/memory-bank/global/projectbrief.md`

```markdown
# Project Brief: {PROJECT_NAME}

**Last Updated**: {TIMESTAMP}

## Overview

{PROJECT_DESCRIPTION}

## Goals

| # | Goal | Success Criteria |
|---|------|------------------|
| G1 | {GOAL_1} | {MEASURABLE_CRITERIA} |
| G2 | {GOAL_2} | {MEASURABLE_CRITERIA} |
<!-- GENERATOR: 3-5 primary goals -->

## Scope

### In Scope
- {IN_SCOPE_1}
- {IN_SCOPE_2}

### Out of Scope
- {OUT_OF_SCOPE_1}
- {OUT_OF_SCOPE_2}

## Constraints

| Constraint | Description | Source |
|------------|-------------|--------|
| {CONSTRAINT_1} | {DESCRIPTION} | {REQUIREMENT_SOURCE} |
<!-- GENERATOR: Technical, business, or resource constraints -->

## Current Phase

**Phase:** {PHASE_NAME}
**Status:** {STATUS}
**Target:** {TARGET_DATE_OR_MILESTONE}
```

---

### _active.md (REQUIRED)

**Location:** `.github/memory-bank/sessions/_active.md`

```markdown
# Session State

**Last Updated**: {TIMESTAMP}
**Agent**: {AGENT_NAME_OR_USER}

## Active Focus

{CURRENT_WORK_DESCRIPTION}

## Completed This Session

- [x] {COMPLETED_TASK} — {BRIEF_RESULT}
<!-- GENERATOR: List what was accomplished -->

## In Progress

- [ ] {CURRENT_TASK} — {STATUS_OR_BLOCKER}
<!-- GENERATOR: What's actively being worked on -->

## Pending (Prioritized)

- [ ] {TASK} — priority: **high**
- [ ] {TASK} — priority: medium
<!-- GENERATOR: Ordered by importance -->

## Blockers

| Issue | Severity | Action Needed |
|-------|----------|---------------|
| {BLOCKER_DESCRIPTION} | {high/med/low} | {WHAT_MUST_HAPPEN} |
<!-- GENERATOR: Empty if no blockers: "None" -->

## Decisions Made

| Decision | Rationale | Reversible? |
|----------|-----------|-------------|
| {CHOICE} | {WHY} | {yes/no} |
<!-- GENERATOR: Session-specific decisions -->

## Next Steps (For Next Session)

1. {IMMEDIATE_ACTION}
2. {FOLLOW_UP_ACTION}
<!-- GENERATOR: Clear handoff for future sessions -->

## Context for Resume

- Key files: {FILE_LIST}
- Tests: {TEST_STATUS}
```

---

### decisions.md (REQUIRED)

**Location:** `.github/memory-bank/global/decisions.md`

```markdown
# Architecture Decision Records

> **APPEND-ONLY** — Never modify existing entries. Add new ADRs below.

---

## ADR-001: {DECISION_TITLE}

**Date:** {YYYY-MM-DD}
**Status:** {Proposed | Accepted | Deprecated | Superseded}

**Context:**
{What situation prompted this decision?}

**Decision:**
{What was decided?}

**Consequences:**
- (+) {Positive outcome}
- (-) {Negative tradeoff}
- Mitigation: {How negatives are addressed}

---

<!-- GENERATOR: Add new ADRs below, incrementing number -->
```

---

### productContext.md (Recommended)

**Location:** `.github/memory-bank/global/productContext.md`

```markdown
# Product Context: {PROJECT_NAME}

**Last Updated**: {TIMESTAMP}

## Problem Statement

{WHAT_PROBLEM_DOES_THIS_SOLVE}

## User Personas

| Persona | Description | Primary Goal |
|---------|-------------|--------------|
| {PERSONA_1} | {WHO_THEY_ARE} | {WHAT_THEY_NEED} |
| {PERSONA_2} | {WHO_THEY_ARE} | {WHAT_THEY_NEED} |

## Business Context

{WHY_THIS_PROJECT_EXISTS_BUSINESS_VALUE}

## Success Metrics

| Metric | Target | Current |
|--------|--------|---------|
| {METRIC_1} | {TARGET_VALUE} | {CURRENT_OR_TBD} |
```

---

### techContext.md (Recommended)

**Location:** `.github/memory-bank/global/techContext.md`

```markdown
# Technical Context: {PROJECT_NAME}

**Last Updated**: {TIMESTAMP}

## Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Language | {LANGUAGE} | {VERSION} |
| Runtime | {RUNTIME} | {VERSION} |
| Framework | {FRAMEWORK} | {VERSION} |
| Database | {DATABASE} | {VERSION} |
| Testing | {TEST_FRAMEWORK} | {VERSION} |

## Architecture

{ARCHITECTURE_DESCRIPTION}

<!-- GENERATOR: Include diagram reference if available -->

## Key Decisions

| Decision | Rationale | ADR |
|----------|-----------|-----|
| {DECISION_1} | {WHY} | ADR-{NNN} |

## Conventions

- {CONVENTION_1}
- {CONVENTION_2}
<!-- GENERATOR: Link to copilot-instructions.md for full list -->
```

---

### systemPatterns.md (Recommended)

**Location:** `.github/memory-bank/global/systemPatterns.md`

```markdown
# System Patterns: {PROJECT_NAME}

**Last Updated**: {TIMESTAMP}

## Code Patterns

### {PATTERN_NAME_1}
**When:** {WHEN_TO_USE}
**Example:**
```{LANGUAGE}
{CODE_EXAMPLE}
```

<!-- GENERATOR: Add 3-5 key patterns -->

## Architectural Patterns

| Pattern | Usage | Example Location |
|---------|-------|------------------|
| {PATTERN} | {WHEN_USED} | `{FILE_PATH}` |

## Anti-Patterns

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| {BAD_PATTERN} | {GOOD_PATTERN} | {REASON} |
```

---

### Quick Handoff Template (Emergency)

When time is short, use minimal handoff:

```markdown
# Quick Handoff: {TIMESTAMP}

**Working on:** {ONE_LINE}
**Status:** {in-progress/blocked/near-complete}
**Next:** {SINGLE_MOST_IMPORTANT_ACTION}
**Blocker:** {IF_ANY_OR_NONE}
```

---

## PLACEHOLDER DEFINITIONS

| Placeholder | Type | Required | Description |
|-------------|------|----------|-------------|
| `{PROJECT_NAME}` | string | ✅ | Project identifier |
| `{TIMESTAMP}` | ISO8601 | ✅ | `2026-01-28T14:30:00Z` or `2026-01-28` |
| `{PROJECT_DESCRIPTION}` | string | ✅ | 1-2 sentences: what is this project |
| `{GOAL_N}` | string | ✅ | Specific project goal |
| `{MEASURABLE_CRITERIA}` | string | ✅ | How to verify goal is achieved |
| `{PHASE_NAME}` | string | ✅ | Current project phase |
| `{STATUS}` | string | ✅ | Phase status |
| `{AGENT_NAME_OR_USER}` | string | ✅ | Who is working |
| `{CURRENT_WORK_DESCRIPTION}` | string | ✅ | What's being done right now |
| `{DECISION_TITLE}` | string | ✅ | Short ADR title |

---

## AGENT LOADING INSTRUCTIONS

Add to agent `<context_loading>` section:

```markdown
<context_loading>
## Session Start
Read in order:
1. `.github/memory-bank/global/projectbrief.md` — Current phase, project context
2. `.github/memory-bank/sessions/_active.md` — Current focus, blockers

## On-Demand
- `.github/memory-bank/global/decisions.md` — When making architectural choices
- `.github/memory-bank/global/techContext.md` — When stack details needed
</context_loading>
```

**CRITICAL:** Memory loading MUST be MUST, not SHOULD. Without mandatory loading, memory exists but isn't used.

---

## TIER LOADING RULES

| Tier | Files | When to Load |
|------|-------|--------------|
| **HOT** | `_active.md` | Every session start |
| **WARM** | Recent archives, features | When context <60% utilized |
| **COLD** | Old archives | Explicit search only |
| **FROZEN** | `global/*.md` | Load excerpts, not full files |

**Utilization Thresholds:**
- <60%: Load HOT + essential WARM
- >60%: Load HOT only
- >80%: Compact, preserve critical HOT

---

## VALIDATION

Before using memory bank, verify:

```
VALIDATE_MEMORY_STRUCTURE:
  Directory:
  □ .github/memory-bank/ directory exists
  □ global/ subdirectory exists
  □ sessions/ subdirectory exists
  
  Required Files:
  □ global/projectbrief.md exists with required sections
  □ global/decisions.md exists (can be empty template)
  □ sessions/_active.md exists
  
  Content:
  □ All files have Last Updated timestamp
  □ All {PLACEHOLDER} values replaced
  □ projectbrief has Goals table
  □ _active.md has Active Focus and Next Steps

VALIDATE_AGENT_INTEGRATION:
  □ Agent has <context_loading> section
  □ Memory loading is MUST, not SHOULD
  □ Specifies which files to load at session start
  □ Includes update triggers for memory files
```

---

## UPDATE TRIGGERS

| File | Update When |
|------|-------------|
| `_active.md` | Session start, every 15-20 mins, on blocker, on decision, session end |
| `decisions.md` | After architectural/design decision (append only) |
| `techContext.md` | When stack or architecture changes |
| `projectbrief.md` | When scope or goals change |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [memory-patterns.md](../PATTERNS/memory-patterns.md) | Full patterns and rules |
| [agent-patterns.md](../PATTERNS/agent-patterns.md) | Agents load memory files |
| [COMPONENT-MATRIX.md](../COMPONENT-MATRIX.md) | Memory determines context vs reference |
| [memory-checklist.md](../CHECKLISTS/memory-checklist.md) | Detailed validation |

---

## SOURCES

- [memory-patterns.md](../PATTERNS/memory-patterns.md) — Structure extracted from STRUCTURE section
